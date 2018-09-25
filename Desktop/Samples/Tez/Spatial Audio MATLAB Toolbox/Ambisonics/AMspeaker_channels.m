function ret = AMspeaker_channels(order,speaker_array_azimuth,speaker_array_elevation,filename,output_f)
% Calculate the output signal for each speaker of given order         
% coef_sp_array - encoding channels
% speaker_array_azimuth - array of each speaker azimuth angle
% speaker_array_elevation - array of each speaker elevation angle
% filename - base filename for encoded channels.
% output_f - base filename for decoded channels.
num_sp=length(speaker_array_azimuth);
filename2=output_f;


for i=1:1:num_sp
    p=strcat(int2str(i),'.wav');
    filename1=strcat(filename, p);
    [f_content(:,i), f] = wavread(filename1);
end

for i=1:1:num_sp
    phis=speaker_array_elevation(i);
    thetas=speaker_array_azimuth(i);
    speaker_ar_coeff=AMbisonicsCF(phis,thetas,order);
    speaker_coeff_r=f_content(:,i)*speaker_ar_coeff;
    
    output_s=speaker_coeff_r(:,1);
    for h=2:1:num_sp
        output_s=output_s+speaker_coeff_r(:,h);
    end
    output_s=output_s/num_sp;
    p=strcat(int2str(i),'.wav');
    filename1=strcat(filename2, p);
    wavwrite(output_s,f,filename1);
end

ret=1;