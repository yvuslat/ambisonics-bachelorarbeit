function sp_dellay=VBAPdelay(num_use_sp,speaker_coord,source_pos,fs,SoundSpeed,filename)
% Returns array of gains for all speakers         
% num_use_sp - num. of used speakers
% speaker_coord - array of speaker coordinates (polar) 
% speaker_coord(n,1) = 1; % Distance must be in metre
% speaker_coord(n,2) = 315; azimuth angle
% speaker_coord(n,3) = 45;  elevation angle
% n is the speaker number.
% source_pos - array of source possition
% source_pos(1,1) = 1; Distance in metre
% source_pos(1,2) = 0;  azimuth angle
% source_pos(1,3) = 45; elevation angle
% fs - sample rate
% Sound Speed - the speed of sound
% filename – main file name. For each channel the number of the channel will be added at the end.



for i=1:1:num_use_sp
    sp_x(i) = speaker_coord(i,1)*cos((pi/180)*speaker_coord(i,2))*sin((pi/180)*(speaker_coord(i,3)+90));
    sp_y(i) = speaker_coord(i,1)*sin((pi/180)*speaker_coord(i,2))*sin((pi/180)*(speaker_coord(i,3)+90));
    sp_z(i) = speaker_coord(i,1)*sin((pi/180)*speaker_coord(i,3));
end
source_x = source_pos(1,1)*cos((pi/180)*source_pos(1,2))*sin((pi/180)*(source_pos(1,3)+90));
source_y = source_pos(1,1)*sin((pi/180)*source_pos(1,2))*sin((pi/180)*(source_pos(1,3)+90));
source_z = source_pos(1,1)*sin((pi/180)*source_pos(1,3));

for i=1:1:num_use_sp
    dist_f(i)=sqrt((sp_x(i))^2+(sp_y(i))^2+(sp_z(i))^2);
    source_produce(i)=0;
end
dist_f;
[vv,nn]=max(dist_f);
for i=1:1:num_use_sp
    sp_dellay(i)=(vv-dist_f(i))/(SoundSpeed*1/fs);
end