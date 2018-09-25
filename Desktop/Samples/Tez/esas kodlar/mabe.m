clear all

load('setup\bigsave.mat');

for n=single(1):1:size(position,2)
    eval(sprintf('position(n).data = complex(irdata%i_real, irdata%i_imag);',n,n));
    eval(sprintf('clear irdata%i_real irdata%i_imag;',n,n));
end

for n=single(1):1:size(file,2)
    eval(sprintf('file(n).data = complex(filedata%i_real, filedata%i_imag);',n,n));
    eval(sprintf('clear filedata%i_real filedata%i_imag;',n,n));
end

art_udp = dsp.UDPReceiver('LocalIPPort',6666,'ReceiveBufferSize',1);
setup(art_udp);
un_udp = dsp.UDPReceiver('LocalIPPort',6667);
setup(un_udp);

speaker = audioDeviceWriter('Driver','ASIO','Device','UA-25EX','SampleRate',samplerate);

while 1
    
    art_str = char(art_udp())';
    
    if length(art_str)>200
        U = strsplit(art_str,{' ','[',']'});
        
        udprot(1,1) = single(str2double(U(16)));
        udprot(2,1) = single(str2double(U(17)));
        udprot(3,1) = single(str2double(U(18)));
        udprot(1,2) = single(str2double(U(19)));
        udprot(2,2) = single(str2double(U(20)));
        udprot(3,2) = single(str2double(U(21)));
        udprot(1,3) = single(str2double(U(22)));
        udprot(2,3) = single(str2double(U(23)));
        udprot(3,3) = single(str2double(U(24)));
        
        rot=udprot*rsrot;
               
        yaw=atan2d(rot(2,1),rot(1,1));
        pitch=atan2d(-rot(3,1),norm([rot(1,1) rot(2,1)]));
        roll=atan2d(rot(3,2),rot(3,3));
                
        if pitch>-50 && pitch<54 && roll>-40 && roll<40
            
            if yaw<-179
                yaw_id = single(1);
            else
                yaw_id = (round(yaw/single(2)))+single(90);
            end
            
            if pitch<-46
                pitch_id = single(1);
            elseif pitch>50
                pitch_id = single(25);
            else
                pitch_id = (round(pitch/single(4)))+single(12);
            end
            
            if roll<-30
                roll_id = single(1);
            elseif roll>30
                roll_id = single(7);
            else
                roll_id = (round(roll/single(10)))+single(4);
            end
        end
    end
    
    un_str = char(un_udp())';
    
    if ~isempty(un_str)
        if un_str=='r'
            rsrot = udprot.';
        elseif length(un_str)>1
            scenr = single(0);
            A = strsplit(un_str,{' '});
            fnr = single(str2double(A(1)));
            pnr = single(str2double(A(2)));
            if fnr == 1 || fnr == 2
                filenr2 = fnr;
                posnr2 = pnr;
                databuffer2 = single(zeros(blocksize+1,2,position(posnr2).buffersize));
                countermax2 = size(file(filenr2).data,2);
                counter2 = single(1);
            else
                filenr = fnr;
                posnr = pnr;
                databuffer = single(zeros(blocksize+1,2,position(posnr).buffersize));
                countermax = size(file(filenr).data,2);
                counter = single(1);
            end
        else
            snr = single(str2double(un_str));
            filenr = single(0);
            posnr = single(0);
            if snr==0
                fade = single(1);
            else
                scenr = snr;
                fade = single(0);
                databuffer = single(zeros(blocksize+1,2,position(1).buffersize,size(scenario(scenr).file,2)));
                countermax = size(file(scenario(scenr).file(1)).data,2);
            end            
            counter = single(1);
        end       
    end
    
    if scenr || (filenr && posnr)
        
        new=single(zeros(blocksize*2,2));
        old=single(zeros(blocksize*2,2));
        
        hrtfcurrent = position(1).pos(yaw_id,pitch_id,roll_id);
        
        if hrtfold<=0
            hrtfold = hrtfcurrent;
        end
        
        if scenr
            
            for n=single(1):1:size(scenario(scenr).file,2)
                
                
                if fade
                    databuffer(:,:,:,n)=cat(3,single(zeros(blocksize+1,2,1)),databuffer(:,:,1:end-1,n));
                else
                    databuffer(:,:,:,n)=cat(3,[file(scenario(scenr).file(n)).data(:,counter) file(scenario(scenr).file(n)).data(:,counter)],databuffer(:,:,1:end-1,n));
                end
                newtmp=sum(databuffer(:,:,:,n).*position(scenario(scenr).position(n)).data(:,:,:,hrtfcurrent),3);
                oldtmp=sum(databuffer(:,:,:,n).*position(scenario(scenr).position(n)).data(:,:,:,hrtfold),3);
                new=new+[newtmp;conj(newtmp(end-1:-1:2,:))];
                old=old+[oldtmp;conj(oldtmp(end-1:-1:2,:))];
                
            end
            
        else
            
            if filenr2 && posnr2
                databuffer2=cat(3,[file(filenr2).data(:,counter2) file(filenr2).data(:,counter2)],databuffer2(:,:,1:end-1));
                newtmp=sum(databuffer2.*position(posnr2).data(:,:,:,hrtfcurrent),3);
                oldtmp=sum(databuffer2.*position(posnr2).data(:,:,:,hrtfold),3);
                new=new+[newtmp;conj(newtmp(end-1:-1:2,:))];
                old=old+[oldtmp;conj(oldtmp(end-1:-1:2,:))];
                
                counter2 = counter2+single(1);
            end
            
            databuffer=cat(3,[file(filenr).data(:,counter) file(filenr).data(:,counter)],databuffer(:,:,1:end-1));
            newtmp=sum(databuffer.*position(posnr).data(:,:,:,hrtfcurrent),3);
            oldtmp=sum(databuffer.*position(posnr).data(:,:,:,hrtfold),3);
            new=new+[newtmp;conj(newtmp(end-1:-1:2,:))];
            old=old+[oldtmp;conj(oldtmp(end-1:-1:2,:))];
            
        end
        
        hrtfold = hrtfcurrent;
        counter = counter+single(1);
        
        new=ifft(new);
        old=ifft(old);
        
        speaker((new(blocksize+1:end,:).*fade_in + old(blocksize+1:end,:).*fade_out));
        
        if counter>=countermax || (fade && scenr)
            if filenr && posnr
                counter = single(1);        
                databuffer=single(zeros(blocksize+1,2,position(posnr).buffersize));
            else
                counter = single(1);
                countermax = single(0);
                fade = single(0);
                scenr = single(0);
                filenr = single(0);
                posnr = single(0);
            end
        end
        
        if counter2>=countermax2
            counter2=single(1);
            coutermax2=single(0);
            filenr2=single(0);
            posnr2=single(0);
        end
        
    else
        pause(0.01);
    end
    
end