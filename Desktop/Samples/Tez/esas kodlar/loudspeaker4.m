SOFAstart;
hrtf = SOFAload('HRIR_FULL2DEG.sofa');
%SOFAinfo(hrtf);
SOFAplotGeometry(hrtf);
%size(hrtf.Data.IR)
%%
% Calculate the source position from a listener point of view
apparentSourceVector = SOFAcalculateAPV(hrtf);


%%
%encodingBFormat
% EncodedSignal = encodeBformat(source_signals, source_direction);
 
%EncodedSignal_cells = mat2cell(EncodedSignal, [repelem(128,size(EncodedSignal,1)/128)], [4]);
%%

for sample_no = 1:size(EncodedSignal_cells,1)
% Head-tracking Rotation
% bfsig_rot = rotateBformat(EncodedSignal, yaw, pitch, roll)
% Head-tracking Rotation
% art_udp = dsp.UDPReceiver('LocalIPPort',6666);
% 
% pause(1);
% 
% 
%     
% udp_str = char(step(art_udp))';
% 
% if length(udp_str)>200
%     U = strsplit(udp_str,{' ','[',']'});
% 
% 
%     rot(1) = single(str2double(U(16)));
%     rot(2) = single(str2double(U(17)));
%     rot(3) = single(str2double(U(18)));
%     rot(4) = single(str2double(U(21)));
%     rot(5) = single(str2double(U(24)));
%     rot(6) = single(str2double(U(19)));
%     rot(7) = single(str2double(U(20)));
% 
%     yaw=atan2d(rot(2),rot(1));
%     pitch=atan2d(-rot(3),norm([rot(1) rot(2)]));
%     roll=atan2d(rot(4),rot(5));
% 
% 
%     if pitch==90
%         yaw=0;
%         roll=atan2d(rot(6),rot(7));
%     elseif pitch==-90
%         yaw=0;
%         roll=-atan2(rot(6),rot(7));
%     end
% 
%     if yaw<single(-179)
%         yaw = single(1);
%     else
%         yaw = (round(yaw/single(2)))+single(90);
%     end
% 
%     if pitch<single(-50)
%         pitch = single(1);
%     elseif pitch>single(80)
%         pitch = single(27);
%     else
%         pitch = (round(pitch/single(5)))+single(11);
%     end
% 
%     if roll<single(-35)
%         roll = single(1);
%     elseif roll>single(35)
%         roll = single(15);
%     else
%         roll = (round(roll/single(5)))+single(8);
%     end
% 
% end
% 
    rotated_EncodedSignal = rotateBformat(EncodedSignal_cells{sample_no,1}, yaw, pitch, roll);
    rotated_EncodedSignal_old = rotateBformat(EncodedSignal_cells{sample_no,1}, yaw_old, pitch_old, roll_old);
    yaw_old = yaw;
    pitch_old = pitch;
    roll_old = roll;
    
    
    
%     
%     new_parameter = rotated_EncodedSignal * Beta; 
%     old_parameter = rotated_EncodedSignal_old * Alfa;
%     yaw_old = yaw;
%     pitch_old = pitch;
%     roll_old = roll;
%     result = (old_parameter + new_parameter)/2;


    % EncodedSignal = rotateBformat(EncodedSignal, yaw, pitch, roll)
    %% tetrahedral setup
    [~, ls_dirs_rad] = platonicSolid('tetra');
    ls_dirs = ls_dirs_rad*180/pi;
    ls_num = size(ls_dirs,1);

    %%
    % get ALLRAD decoder
    % Max-rE weighting for the decoder
    MAXRE_ON = 1;
    D_allrad = ambiDecoder(ls_dirs, 'allrad', MAXRE_ON);

    %
    %decodingto4load & creating loudspeaker signals
    DecodedSignal = decodeBformat(EncodedSignal, D_allrad);

    [~,indices] = min(sum(abs(repmat(apparentSourceVector(:,1:2),1,1,ls_num) - permute(repmat(ls_dirs,1,1,size(apparentSourceVector,1)),[3,2,1])) , 2));

    indices = squeeze(indices);



    soundOutput = [conv(squeeze(hrtf.Data.IR(indices(1), 1, :)), DecodedSignal(:,1)) ...
                   conv(squeeze(hrtf.Data.IR(indices(1), 2, :)), DecodedSignal(:,1))];


    %%
    %binaural rendering
    for i=2:size(indices,2)

        soundOutput = soundOutput + [conv(squeeze(hrtf.Data.IR(indices(i), 1, :)), DecodedSignal(:,i)) ...
                   conv(squeeze(hrtf.Data.IR(indices(i), 2, :)), DecodedSignal(:,i))];
    end



    %%
    %Listening all the binaural recording
    soundsc(soundOutput,48000);
    %dispaudio()

    %devamlı audio 
end

% x.append(falte(S{1},M) +0x0)
% 
% l_1 = slice(x,0,128)
% l_2 = slice(x,128,255)
% 
% print( l_1)
% for i in range(len(S)):
% 
%     x.clear()
%     x.append(falte(S{i},M) + 0x0)
% 
%     l_1 = slice(x,0,128)
%     print(l_2)
%     print(l_1)
% 
%     l_2 = slice(x,128,255)

