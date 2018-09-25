phi=25; % elevation angle of the sound source
theta=40; % azimuth angle of the sound source
order=AMorder(41); % returns order of ambisonics witch can be used with particular number of speakers
order=3;
num_speakers=AMspeakers(order); % returns the number of speakers needed for given ambisonics order
fs=44100; % sample rate
SoundSpeed=340.25; % speed of sound

min_speakers=4;
speaker_array_azimuth=[];
speaker_array_elevation=[];




coef_sp_array=AMbisonicsCF(phi,theta,order); % Generates the coefficients for the encoding
[funky, f] = wavread('C:\work\test.wav'); %Opens wave file
filename='C:\work\enc_'; % setting file name for encoded channels
AMencodechannel(funky,f,coef_sp_array,num_speakers,filename); % generating encoded channels

min_num_speakers=length(coef_sp_array); % gives the minimum speakers required


[speaker_array_azimuth,speaker_array_elevation]=AMsp_position(order,2,45,0); % Generates the speaker elevation and azimuth angles. 
output_f='C:\work\decsp_'; % setting file name for output channels
AMspeaker_channels(order,speaker_array_azimuth,speaker_array_elevation,filename,output_f); % Generates decoded channels and save the files.

figure(4);

AMplot(speaker_array_azimuth,speaker_array_elevation,0); % Plot speaker location



new_coef_sp_array=AMvectorgain(speaker_array_azimuth,speaker_array_elevation,output_f,0.5,180,0); % Moving listener from original position gain changing
new_sp_delay=AMvectordelay(speaker_array_azimuth,speaker_array_elevation,0.5,180,0,fs,SoundSpeed,output_f); %Adding delay


