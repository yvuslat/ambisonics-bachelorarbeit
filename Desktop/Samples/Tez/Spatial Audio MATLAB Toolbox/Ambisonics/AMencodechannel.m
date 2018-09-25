function res=AMencodechannel(funky,Fs,sp_gain,num_sp,filename)
% Returns wave file for each speaker         
% funky - wave array
% f - Frequency (44 100) 
% sp_delay - array with delays
% sp_gain - array with gains
% num_sp - number of speakers

for j=1:1:num_sp
    funky1=funky*sp_gain(j);
    p=strcat(int2str(j),'.wav');
    filename1=strcat(filename, p);
    wavwrite(funky1,Fs,filename1);
end
res=1;