function sp_gain=VDPgain_dist(num_use_sp,speaker_coord,source_pos);
% Returns array of gains for number of speakers using VDP         
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
sp_x(i) = speaker_coord(i,1)*cos((pi/180)*speaker_coord(i,2))*sin((pi/180)*(speaker_coord(i,3)+90));
sp_y(i) = speaker_coord(i,1)*sin((pi/180)*speaker_coord(i,2))*sin((pi/180)*(speaker_coord(i,3)+90));
sp_z(i) = speaker_coord(i,1)*sin((pi/180)*speaker_coord(i,3));
end
source_x = source_pos(1,1)*cos((pi/180)*source_pos(1,2))*sin((pi/180)*(source_pos(1,3)+90));
source_y = source_pos(1,1)*sin((pi/180)*source_pos(1,2))*sin((pi/180)*(source_pos(1,3)+90));
source_z = source_pos(1,1)*sin((pi/180)*source_pos(1,3));

for i=1:1:num_use_sp
gain(i)=(source_x-sp_x(i))^2+(source_y-sp_y(i))^2+(source_z-sp_z(i))^2;
end 
[minv,kk]=min(gain);

if minv==0
   for i=1:1:num_use_sp
    gain(i)=0;
   end 
    gain(kk)=1;
else
    for i=1:1:num_use_sp
    gain(i)=minv/gain(i);
    end 
end


c=sqrt(sum(gain.^2));
gain=gain./c;
sp_gain=gain;
