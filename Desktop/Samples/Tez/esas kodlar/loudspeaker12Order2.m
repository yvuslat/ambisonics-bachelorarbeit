
%%
SOFAstart;
hrtf = SOFAload('HRIR_FULL2DEG.sofa');
%SOFAinfo(hrtf);
%SOFAplotGeometry(hrtf);
%size(hrtf.Data.IR)
%%
% Calculate the source position from a listener point of view
apparentSourceVector = SOFAcalculateAPV(hrtf);


%%
%encodingBFormat
EncodedSignal = encodeHOA_N3D(2 ,source_signals, source_directions);
EncodedSignal_cells = mat2cell(EncodedSignal, [repelem(size(EncodedSignal,1)/128,128)], [9]) ;
sample_count = 1;
%%
% %% define a 12-speaker uniform setup
% %A regular icosahedron is a convex polyhedron with 20 faces, 30 edges and 12 vertices
% [u12, ls_dirs12_rad, mesh12] = platonicSolid('icosahedron');
% ls_dirs12 = ls_dirs12_rad*180/pi;
% %ls_dirs12 
% %90.0000   31.7175
% %  -90.0000   31.7175
% %   90.0000  -31.7175
% %  -90.0000  -31.7175
% %        0   58.2825
% %        0  -58.2825
% % 180.0000   58.2825
% % 180.0000  -58.2825
% %  31.7175         0
% % -31.7175         0
% % 148.2825         0
% % -148.2825         0
% 
% %%
% % get ALLRAD decoder
% % Max-rE weighting for the decoder
% MAXRE_ON = 1;
% D_allrad12 = ambiDecoder(ls_dirs12, 'allrad', MAXRE_ON);
% %
% %decodingto12load & creating loudspeaker signals
% lssig = decodeHOA_N3D(EncodedSignal, D_allrad12);
% signal1 = lssig(:,1);
% signal2 = lssig(:,2);
% signal3 = lssig(:,3);
% signal4 = lssig(:,4);
% signal5 = lssig(:,5);
% signal6 = lssig(:,6);
% signal7 = lssig(:,7);
% signal8 = lssig(:,8);
% signal9 = lssig(:,9);
% signal10 = lssig(:,10);
% signal11 = lssig(:,11);
% signal12 = lssig(:,12);
% 
% %%
% %binaural rendering
% soundOutput1 = [conv(squeeze(hrtf.Data.IR(4034, 1, :)), signal1) ...
%                conv(squeeze(hrtf.Data.IR(4034, 2, :)), signal1)];
%            
% soundOutput2 = [conv(squeeze(hrtf.Data.IR(12044, 1, :)), signal2) ...
%                conv(squeeze(hrtf.Data.IR(12044, 2, :)), signal2)];
% 
% soundOutput3 = [conv(squeeze(hrtf.Data.IR(4066, 1, :)), signal3) ...
%                conv(squeeze(hrtf.Data.IR(4066, 2, :)), signal3)];           
% 
% soundOutput4 = [conv(squeeze(hrtf.Data.IR(12076, 1, :)), signal4) ...
%                conv(squeeze(hrtf.Data.IR(12076, 2, :)), signal4)];
% 
% soundOutput5 = [conv(squeeze(hrtf.Data.IR(16, 1, :)), signal5) ...
%                conv(squeeze(hrtf.Data.IR(16, 2, :)), signal5)];
% 
% soundOutput6 = [conv(squeeze(hrtf.Data.IR(74, 1, :)), signal6) ...
%                conv(squeeze(hrtf.Data.IR(74, 2, :)), signal6)];
% 
% soundOutput7 = [conv(squeeze(hrtf.Data.IR(8026, 1, :)), signal7) ...
%                conv(squeeze(hrtf.Data.IR(8026, 2, :)), signal7)];  
%            
% soundOutput8 = [conv(squeeze(hrtf.Data.IR(8084, 1, :)), signal8) ...
%                conv(squeeze(hrtf.Data.IR(8084, 2, :)), signal8)];  
% 
% soundOutput9 = [conv(squeeze(hrtf.Data.IR(1469, 1, :)), signal9) ...
%                conv(squeeze(hrtf.Data.IR(1469, 2, :)), signal9)];  
% 
% soundOutput10 = [conv(squeeze(hrtf.Data.IR(14641, 1, :)), signal10) ...
%                conv(squeeze(hrtf.Data.IR(14641, 2, :)), signal10)]; 
% 
% soundOutput11 = [conv(squeeze(hrtf.Data.IR(6631, 1, :)), signal11) ...
%                conv(squeeze(hrtf.Data.IR(6631, 2, :)), signal11)];  
%  
% soundOutput12 = [conv(squeeze(hrtf.Data.IR(9479, 1, :)), signal12) ...
%                conv(squeeze(hrtf.Data.IR(9479, 2, :)), signal12)];            
% 
% %%
% %Listening all the binaural recording
% 
% soundOutputogether12 = soundOutput1+soundOutput2+soundOutput3 +soundOutput4 + soundOutput5 + soundOutput6 + soundOutput7 + soundOutput8 + soundOutput9 + soundOutput10 + soundOutput11 + soundOutput12;
%           
% %%
% 
% 
% soundsc(soundOutputogether12,48000); 

%%
%Head-tracking Rotation
art_udp = dsp.UDPReceiver('LocalIPPort',6666);

pause(1);


    
udp_str = char(step(art_udp))';

if length(udp_str)>200
    U = strsplit(udp_str,{' ','[',']'});


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

if sample_count <= 128
    rotated_EncodedSignal = rotateBformat(EncodedSignal_cell{sample_count,1}, yaw, pitch, roll);
    rotated_EncodedSignal_old = rotateBformat(EncodedSignal_cells{sample_count,1}, yaw_old, pitch_old, roll_old);
    new_parameter = rotated_EncodedSignal * Beta; 
    old_parameter = rotated_EncodedSignal_old * Alfa;
    yaw_old = yaw;
    pitch_old = pitch;
    roll_old = roll;
    result = (old_parameter + new_parameter)/2;

    sample_count = sample_count + 1;



%% define a 12-speaker uniform setup
    %A regular icosahedron is a convex polyhedron with 20 faces, 30 edges and 12 vertices

    [~, ls_dirs_rad] = platonicSolid('icosahedron');
    ls_dirs = ls_dirs_rad*180/pi;
    ls_num = size(ls_dirs,1);

    %%
    % get ALLRAD decoder
    % Max-rE weighting for the decoder
    MAXRE_ON = 1;
    D_allrad12 = ambiDecoder(ls_dirs, 'allrad', MAXRE_ON, 2);

    %% 
    %%decodingto4load & creating loudspeaker signals
    lssig = decodeHOA_N3D(EncodedSignal, D_allrad12);

    [~,indices] = min(sum(abs(repmat(apparentSourceVector(:,1:2),1,1,ls_num) - permute(repmat(ls_dirs,1,1,size(apparentSourceVector,1)),[3,2,1])) , 2));

    indices = squeeze(indices);
    %%
    %binaural rendering


    soundOutput = [conv(squeeze(hrtf.Data.IR(indices(1), 1, :)), lssig(:,1)) ...
                   conv(squeeze(hrtf.Data.IR(indices(1), 2, :)), lssig(:,1))];



    for i=2:size(indices,2)

        soundOutput = soundOutput + [conv(squeeze(hrtf.Data.IR(indices(i), 1, :)), lssig(:,i)) ...
                   conv(squeeze(hrtf.Data.IR(indices(i), 2, :)), lssig(:,i))];
    end


    %%
    %Listening all the binaural recording
    soundsc(soundOutput,48000); 
    %dispaudio() 
    

end