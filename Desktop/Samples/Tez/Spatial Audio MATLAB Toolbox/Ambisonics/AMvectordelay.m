function sp_dellay=AMvectordelay(speaker_array_azimuth,speaker_array_elevation,dists,azimuths,elevs,fs,SoundSpeed,filename)
% Adds delay to each speaker         
% speaker_array_azimuth – azimuth angle of each speaker
% speaker_array_elevation – elevation angle of each speaker
% filename – basic file name. For example if decoded files are:
% decsp _1 – encoded channel 1
% decsp _2 – encoded channel 2
% decsp _3 – encoded channel 3
% distance – the distance between center of the sphere and new position.
% azimuth – the azimuth angle of the new position
% elevation – the elevation angle of the new position
% fs – sample rate
% SoundSpeed – The speed of sound

source_pos(1,1)=dists;
source_pos(1,2)=azimuths;
source_pos(1,3)=elevs;
num_use_sp=length(speaker_array_azimuth);

for i=1:1:num_use_sp
    sp_x(i) = cos((pi/180)*speaker_array_azimuth(i))*sin((pi/180)*(speaker_array_elevation(i)+90));
    sp_y(i) = sin((pi/180)*speaker_array_azimuth(i))*sin((pi/180)*(speaker_array_elevation(i)+90));
    sp_z(i) = sin((pi/180)*speaker_array_elevation(i));
end
source_x = source_pos(1,1)*cos((pi/180)*source_pos(1,2))*sin((pi/180)*(source_pos(1,3)+90));
source_y = source_pos(1,1)*sin((pi/180)*source_pos(1,2))*sin((pi/180)*(source_pos(1,3)+90));
source_z = source_pos(1,1)*sin((pi/180)*source_pos(1,3));

for i=1:1:num_use_sp
    dist_f(i)=sqrt((sp_x(i)-source_x)^2+(sp_y(i)-source_y)^2+(sp_z(i)-source_z)^2);
    source_produce(i)=0;
end
dist_f;
[vv,nn]=max(dist_f);
for i=1:1:num_use_sp
    sp_dellay(i)=(vv-dist_f(i))/(SoundSpeed*1/fs);
end

for i=1:1:num_use_sp
        
        p=strcat(int2str(i),'.wav');
        filename1=strcat(filename, p);
        [funky11, f] = wavread(filename1);
        
        
            for j=1:1:sp_dellay(i)
            funky11(j)=0;
            end
        
        wavwrite(funky11,f,filename1);
        
    end