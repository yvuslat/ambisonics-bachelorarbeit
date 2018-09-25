SOFAstart;
hrtf = SOFAload('HRIR_FULL2DEG.sofa');
%SOFAinfo(hrtf);
SOFAplotGeometry(hrtf);
%size(hrtf.Data.IR)
%%
% Calculate the source position from a listener point of view
apparentSourceVector = SOFAcalculateAPV(hrtf);


%% creating two random noices
fs = 48000;
%t = 5;
%src_sig = randn(t*fs, 2);
fs = 48000;
t = 5;
%source_signals = randn(t*fs, 2);
source_direction = [56 4];
%%
[y,Fs] = audioread('Cat.wav');
y1 = y(:,1);
y2 = y(:,2);

%% 
soundOutputdirekt = [conv(squeeze(hrtf.Data.IR(2535, 1, :)), y1) ...
               conv(squeeze(hrtf.Data.IR(2535, 2, :)), y1)];
           
%%

soundsc(soundOutputdirekt); 