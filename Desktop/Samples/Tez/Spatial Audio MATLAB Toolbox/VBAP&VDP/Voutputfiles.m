function res=VBAPoutputfiles(funky,Fs,sp_delay,sp_gain,num_sp,filename)
% Returns an output wave file for each speaker         
% funky - wave array
% f - Frequency (44 100) 
% sp_delay - array with delays
% sp_gain - array with gains
% num_sp - number of speakers
% filename – main file name. For each channel the number of the channel
% will be added at the end.

for j=1:1:num_sp
    funky1=funky*sp_gain(j);
    for i=1:1:sp_delay(j)
        funky1(i,1)=0;
    end
    p=strcat(int2str(j),'.wav');
    filename1=strcat(filename, p);
    wavwrite(funky1,Fs,filename1);
end
res=1;