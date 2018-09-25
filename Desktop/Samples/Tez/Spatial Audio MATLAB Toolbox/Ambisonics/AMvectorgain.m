function sp_array = AMvectorgain(speaker_array_azimuth,speaker_array_elevation,filename,position_distance,position_azimuth,position_elevation)
% Change the coef speakers, depending on listener possition         
% coef_sp_array - array with coeficients /deleted
% speaker_array_azimuth - array of azimuth angles.
% speaker_array_elevation - array of elevation angles.
% position_distance - normalize distance between center of the array and
% new listener position. Sphere radius = 1;
% position_azimuth - azimuth angle between sphere center and listener position.
% position_elevation - elevation angle between sphere center and listener
% position.
% ...
sp_array=[];
max_v=0;
max_index=0;
%position_elevation=position_elevation+90;
for i=1:1:length(speaker_array_azimuth)
    x = position_distance*cos((pi/180)*position_azimuth)*sin((pi/180)*(position_elevation+90));
    y = position_distance*sin((pi/180)*position_azimuth)*sin((pi/180)*(position_elevation+90));
    z = position_distance*sin((pi/180)*position_elevation);
    
    a = cos((pi/180)*speaker_array_azimuth(i))*sin((pi/180)*(speaker_array_elevation(i)+90));
    b = sin((pi/180)*speaker_array_azimuth(i))*sin((pi/180)*(speaker_array_elevation(i)+90));
    c = sin((pi/180)*speaker_array_elevation(i));
    
    dif_coef=sqrt((a-x)^2+(b-y)^2+(c-z)^2);
    sp_array(i)=dif_coef; % multiply by coef_sp_array in original version.
end
    [max_v,max_index] = max(sp_array);
    
    for i=1:1:length(sp_array)
        
        p=strcat(int2str(i),'.wav');
        filename1=strcat(filename, p);
        [funky11, f] = wavread(filename1);
        
        sp_array(i)=sp_array(i)*(1/max_v);
        funky11=funky11*sp_array(i);
        
        wavwrite(funky11,f,filename1);
        
    end