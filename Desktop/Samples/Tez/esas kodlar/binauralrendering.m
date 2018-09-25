%%
SOFAstart;
hrtf = SOFAload('HRIR_FULL2DEG.sofa');
SOFAinfo(hrtf);
SOFAplotGeometry(hrtf);
size(hrtf.Data.IR)
%%
% Calculate the source position from a listener point of view
apparentSourceVector = SOFAcalculateAPV(hrtf);
%%
% Listen to the HRTF with azimuth of -90
apparentSourceVector(91, 1)
SOFAplotGeometry(hrtf, 91);
%%
%input 
soundInput = audioread('handel.wav');
%%
%output
soundOutput = [conv(squeeze(hrtf.Data.IR(2000, 1, :)), soundInput) ...
               conv(squeeze(hrtf.Data.IR(2000, 2, :)), soundInput)];
%%          
%listen           
sound(soundOutput);