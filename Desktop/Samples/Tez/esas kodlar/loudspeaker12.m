SOFAstart;
hrtf = SOFAload('HRIR_FULL2DEG.sofa');
%SOFAinfo(hrtf);
%SOFAplotGeometry(hrtf);
%size(hrtf.Data.IR)
%% Calculate the source position from a listener point of view
apparentSourceVector = SOFAcalculateAPV(hrtf);
%% Define a 12-speaker uniform setup
[~, ls_dirs_rad] = platonicSolid('icosahedron');
ls_dirs = ls_dirs_rad*180/pi;
ls_num = size(ls_dirs,1);

%% for the cross fade
blocksize = 128;
fade_in = single([linspace(0,1,blocksize)' linspace(0,1,blocksize)']); 
fade_out = single([linspace(1,0,blocksize)' linspace(1,0,blocksize)']);

%% get ALLRAD decoder
MAXRE_ON = 1;
D_allrad = ambiDecoder(ls_dirs, 'allrad', MAXRE_ON);
%%
%encodingBFormat

EncodedSignal = encodeBformat(source_signals, source_directions);
EncodedSignal_cells = mat2cell(EncodedSignal, [repelem(128,size(EncodedSignal,1)/128)], [4]);  %128samples 11250 blocks
sample_count = 1;
memory = zeros(128,2);
yaw_old = 0;
pitch_old = 0;
roll_old = 0;

%%
%Head-tracking Rotation
art_udp = dsp.UDPReceiver('LocalIPPort',6666);

pause(1);

while sample_count <= 11250


udp_str = char(step(art_udp))';

if length(udp_str)>200
    U = strsplit(udp_str,{' ','[',']'});

speaker = audioDeviceWriter('Driver','CoreAudio','Device','Default','SampleRate',samplerate);

    rot(1) = single(str2double(U(16)));
    rot(2) = single(str2double(U(17)));
    rot(3) = single(str2double(U(18)));
    rot(4) = single(str2double(U(21)));
    rot(5) = single(str2double(U(24)));
    rot(6) = single(str2double(U(19)));
    rot(7) = single(str2double(U(20)));

    yaw=atan2d(rot(2),rot(1));
    pitch=atan2d(-rot(3),norm([rot(1) rot(2)]));
    roll=atan2d(rot(4),rot(5));
    
    %i added this
    if sample_count == 1
        yaw_old = yaw;
        pitch_old = pitch;
        roll_old = roll;
    end    

    if pitch==90
        yaw=0;
        roll=atan2d(rot(6),rot(7));
    elseif pitch==-90
        yaw=0;
        roll=-atan2(rot(6),rot(7));
    end

    if yaw<single(-179)
        yaw = single(1);
    else
        yaw = (round(yaw/single(2)))+single(90);
    end

    if pitch<single(-50)
        pitch = single(1);
    elseif pitch>single(80)
        pitch = single(27);
    else
        pitch = (round(pitch/single(5)))+single(11);
    end

    if roll<single(-35)
        roll = single(1);
    elseif roll>single(35)
        roll = single(15);
    else
        roll = (round(roll/single(5)))+single(8);
    end

end

%%
%if sample_count <= 11250
if sample_count == 1
        result = rotateBformat(EncodedSignal_cells{sample_count,1}, yaw, pitch, roll);
end
if sample_count <= 11250 && sample_count > 1 
    rotated_EncodedSignal = rotateBformat(EncodedSignal_cells{sample_count,1}, yaw, pitch, roll);
    rotated_EncodedSignal_old = rotateBformat(EncodedSignal_cells{sample_count,1}, yaw_old, pitch_old, roll_old);
   % new_parameter = rotated_EncodedSignal .*fade_in; 
    %old_parameter = rotated_EncodedSignal_old .*fade_in;
    yaw_old = yaw;
    pitch_old = pitch;
    roll_old = roll;
    %result = (old_parameter + new_parameter)/2;
end    

    %sample_count = sample_count + 1;


    %% 
    %%decodingto4load & creating loudspeaker signals
    
    result = (decodeBformat(rotated_EncodedSignal, D_allrad).*fade_in + decodeBformat(rotated_EncodedSignal_old, D_allrad).*fade_in)/2;
    
    %lssig = decodeBformat(result, D_allrad);

    [~,indices] = min(sum(abs(repmat(apparentSourceVector(:,1:2),1,1,ls_num) - permute(repmat(ls_dirs,1,1,size(apparentSourceVector,1)),[3,2,1])) , 2));

    indices = squeeze(indices);
    %%
    %binaural rendering


    soundOutput = [conv(squeeze(hrtf.Data.IR(indices(1), 1, :)), result(:,1)) ...
                   conv(squeeze(hrtf.Data.IR(indices(1), 2, :)), result(:,1))];
               

%%

    for i=2:size(indices,2)

        soundOutput = soundOutput + [conv(squeeze(hrtf.Data.IR(indices(i), 1, :)), result(:,i)) ...
                   conv(squeeze(hrtf.Data.IR(indices(i), 2, :)), result(:,i))];
    end

   soundOutput_Zero = [soundOutput;zeros(1,2)];
   soundOutput_Zero1 = soundOutput_Zero(1:size(soundOutput_Zero)/2);
   soundOutput_Zero2 = soundOutput_Zero(size(soundOutput_Zero)/2+1:size(soundOutput_Zero));
   if sample_count == 1
       memory = soundOutput_Zero2;
   end     
   
   
   

    %%
    %Listening all the binaural recordin
    if sample_count > 1
        sound(soundOutput_Zero1 + memory,480000);
        memory = soundOutput_Zero2;
    end 
    
     speaker(soundOutput_Zero1,48000); 
    
    %dispaudio() 
    %audioDeviceWriter()
    %audiotodevice....
 
    sample_count = sample_count+1;
end




