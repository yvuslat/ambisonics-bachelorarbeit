
SOFAstart;
hrtf = SOFAload('HRIR_FULL2DEG.sofa');
%SOFAinfo(hrtf);
SOFAplotGeometry(hrtf);
%size(hrtf.Data.IR)
%%
% Calculate the source position from a listener point of view
apparentSourceVector = SOFAcalculateAPV(hrtf);

%fs = 48000;
%t = 5;
%source_direction = [60 60,0 0];

%% source signals 
%FRAGE AN HERR PAUKNER: WİE WİRD ROTATİONS HİER İMPLEMENTİERT ? muss ich
%einen rotationsmatrix format suchen?
%2. Frage Muss ich hier gesamt core1.m nutzen ? 
[y1,Fs1] = audioread('HellOfAGuy_GitL.wav' , [1,480000*3]); 
[y2,Fs2] = audioread('HellOfAGuy_GitR.wav', [1,480000*3]);
[y3 ,Fs3] = audioread('HellOfAGuy_Voc.wav', [1,480000*3]); 



signal_direkt1 = y;
soundOutputdirekt1 = [conv(squeeze(hrtf.Data.IR(2685, 1, :)), signal_direkt1) ...
               conv(squeeze(hrtf.Data.IR(2685, 2, :)), signal_direkt1)];

           [y2,Fs2] = audioread('HellOfAGuy_GitR.wav', [1,4800000]);
soundOutputdirekt1 = [conv(squeeze(hrtf.Data.IR(2685, 1, :)), signal_direkt1) ...
               conv(squeeze(hrtf.Data.IR(2685, 2, :)), signal_direkt1)];           

           [y1,Fs] = audioread('HellOfAGuy_Voc.wav',[1,480000]);           
soundOutputdirekt2 = [conv(squeeze(hrtf.Data.IR(44, 1, :)), y1) ...
               conv(squeeze(hrtf.Data.IR(44, 2, :)), y1)];           
           
%%
soundsc(soundOutputdirekt2,48000); 
%dispaudio()
