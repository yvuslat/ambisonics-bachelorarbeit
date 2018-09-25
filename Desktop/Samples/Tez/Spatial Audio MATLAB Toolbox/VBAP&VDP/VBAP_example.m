speaker_coord(1,1) = 1; % Distance must be in metre
speaker_coord(1,2) = 0;
speaker_coord(1,3) = 90; 

speaker_coord(2,1) = 1; % Distance must be in metre
speaker_coord(2,2) = 0;
speaker_coord(2,3) = 0; 
    
speaker_coord(3,1) = 1; % Distance must be in metre
speaker_coord(3,2) = 41.9;
speaker_coord(3,3) = 0; 
    
speaker_coord(4,1) = 1; % Distance must be in metre
speaker_coord(4,2) = 94.6;
speaker_coord(4,3) = 0; 


speaker_coord(5,1) = 1; % Distance must be in metre
speaker_coord(5,2) = 150.6;
speaker_coord(5,3) = 0;

speaker_coord(6,1) = 1; % Distance must be in metre
speaker_coord(6,2) = -152.4;
speaker_coord(6,3) = 0;

speaker_coord(7,1) = 1; % Distance must be in metre
speaker_coord(7,2) = -94.5;
speaker_coord(7,3) = 0;

speaker_coord(8,1) = 1; % Distance must be in metre
speaker_coord(8,2) = -44.0;
speaker_coord(8,3) = 0;

speaker_coord(9,1) = 1; % Distance must be in metre
speaker_coord(9,2) = 0;
speaker_coord(9,3) = 28.3;

speaker_coord(10,1) = 1; % Distance must be in metre
speaker_coord(10,2) = 90;
speaker_coord(10,3) = 27.2;

speaker_coord(11,1) = 1; % Distance must be in metre
speaker_coord(11,2) = 180;
speaker_coord(11,3) = 26.7;

speaker_coord(12,1) = 1; % Distance must be in metre
speaker_coord(12,2) = -90;
speaker_coord(12,3) = 27.5;

speaker_coord(13,1) = 1; % Distance must be in metre
speaker_coord(13,2) = -45;
speaker_coord(13,3) = -29;

speaker_coord(14,1) = 1; % Distance must be in metre
speaker_coord(14,2) = 45;
speaker_coord(14,3) = -30;

speaker_coord(15,1) = 1; % Distance must be in metre
speaker_coord(15,2) = 135;
speaker_coord(15,3) = -25.9;

speaker_coord(16,1) = 1; % Distance must be in metre
speaker_coord(16,2) = -135;
speaker_coord(16,3) = -27.8;

source_pos(1,1) = 1;
source_pos(1,2) = 45;
source_pos(1,3) = 30; 
fs=44100;
SoundSpeed=340.25;

% sp_gain=VBAP_original(3,speaker_coord,source_pos)
sp_gain=VDPgain_dist(16,speaker_coord,source_pos) % Calculating gains using all 16 speakers with VDP
% sp_delay=V_delay(3,speaker_coord,source_pos,fs,SoundSpeed);  % Calculating delays for the first 3 speakers
sp_delay=V_delay(16,speaker_coord,source_pos,fs,SoundSpeed); % Calculating delays for 16 speakers


[funky, f] = wavread('C:\work\test.wav'); % open input wave file
Voutputfiles(funky,f,sp_delay,sp_gain,16,'C:\work\vdp_'); % writes output files for each speaker from 1 to 16


gains=VBAP_stereophony(30,15); % calculating gains in stereophony. theta_zero=30, theta=15.
Vplot(speaker_coord,source_pos,0,16); %plots speaker's position.