% Start SOFA
SOFAstart;
% Load your impulse response into a struct
hrtf = SOFAload('path/to_your/HRTF.sofa');
% Display some information about the impulse response
SOFAinfo(hrtf);
% Plot a figure with the measurement setup
SOFAplotGeometry(hrtf);
% Have a look at the size of the data
size(hrtf.Data.IR)
% Get information about the measurement setup
hrtf.ListenerPosition       % position of dummy head
hrtf.SourcePosition         % position of loudspeaker
% Head orientation of the dummy head + coordinate system and units
hrtf.ListenerView
hrtf.ListenerView_Type
hrtf.ListenerView_Units
% Calculate the source position from a listener point of view
apparentSourceVector = SOFAcalculateAPV(hrtf);
% Listen to the HRTF with azimuth of -90°
apparentSourceVector(91, 1)
SOFAplotGeometry(hrtf, 91);
soundInput = audioread('fancy_audio_file.wav');
soundOutput = [conv(squeeze(hrtf.Data.IR(91, 1, :)), soundInput) ...
               conv(squeeze(hrtf.Data.IR(91, 2, :)), soundInput)];
sound(soundOutput, hrtf.Data.SamplingRate);