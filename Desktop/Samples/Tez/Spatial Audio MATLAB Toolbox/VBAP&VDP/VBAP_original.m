function sp_gain=VBAP_original(num_use_sp,speaker_coord,source_pos);
% Returns array of gains for VBAP triplet of speakers.         
% num_use_sp - num. of used speakers
% speaker_coord - array of speaker coordinates (polar) 
% speaker_coord(1,1) = 1; % Distance must be in metre
% speaker_coord(1,2) = 315; azimuth angle
% speaker_coord(1,3) = 45;  elevation angle
% source_pos - array of source possition
% source_pos(1,1) = 1; Distance in metre
% source_pos(1,2) = 0;  azimuth angle
% source_pos(1,3) = 45; elevation angle


for i=1:1:num_use_sp
sp(i,1) = speaker_coord(i,1)*cos((pi/180)*speaker_coord(i,2))*sin((pi/180)*(speaker_coord(i,3)+90));
sp(i,2) = speaker_coord(i,1)*sin((pi/180)*speaker_coord(i,2))*sin((pi/180)*(speaker_coord(i,3)+90));
sp(i,3) = speaker_coord(i,1)*sin((pi/180)*speaker_coord(i,3));
end
source(1) = source_pos(1,1)*cos((pi/180)*source_pos(1,2))*sin((pi/180)*(source_pos(1,3)+90));
source(2) = source_pos(1,1)*sin((pi/180)*source_pos(1,2))*sin((pi/180)*(source_pos(1,3)+90));
source(3) = source_pos(1,1)*sin((pi/180)*source_pos(1,3));


gain=source*inv(sp);
c=sqrt(sum(gain.^2));
gain=gain./c;
sp_gain=gain;
