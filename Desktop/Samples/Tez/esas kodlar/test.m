SOFAstart;
hrtf = SOFAload('HRIR_FULL2DEG.sofa');
apparentSourceVector = SOFAcalculateAPV(hrtf);

load('/Users/yaseminvuslatyavuz/Desktop/Samples/Tez/source_directions.mat')
load('/Users/yaseminvuslatyavuz/Desktop/Samples/Tez/source_signals.mat')
 %% define a 12-speaker uniform setup
    [~, ls_dirs_rad] = platonicSolid('icosahedron');
    ls_dirs = ls_dirs_rad*180/pi;
    ls_num = size(ls_dirs,1);
    
        %%
    % get ALLRAD decoder
    % Max-rE weighting for the decoder
    MAXRE_ON = 1;
    D_allrad = ambiDecoder(ls_dirs, 'allrad', MAXRE_ON);

    %% 
    %%decodingto4load & creating loudspeaker signals
    

    [~,indices] = min(sum(abs(repmat(apparentSourceVector(:,1:2),1,1,ls_num) - permute(repmat(ls_dirs,1,1,size(apparentSourceVector,1)),[3,2,1])) , 2));

    indices = squeeze(indices);
%%
%encodingBFormat
    EncodedSignal_test = encodeBformat(source_signals, source_directions);
    RotatedSignal_test = rotateBformat( EncodedSignal_test, 0, 0, 0);


lssig = decodeBformat(RotatedSignal_test, D_allrad);


    soundOutput_test = [conv(squeeze(hrtf.Data.IR(indices(1), 1, :)), lssig(:,1)) ...
                   conv(squeeze(hrtf.Data.IR(indices(1), 2, :)), lssig(:,1))];


    %%
    %binaural rendering
    for i=2:size(indices,2)

        soundOutput_test = soundOutput_test + [conv(squeeze(hrtf.Data.IR(indices(i), 1, :)), lssig(:,i)) ...
                   conv(squeeze(hrtf.Data.IR(indices(i), 2, :)), lssig(:,i))];
    end
    %%
    c = max(soundOutput_test);
   soundOutput_test1 = soundOutput_test./c;
    

    %%
    %Listening all the binaural recording
    sound(soundOutput_test1,48000); 
    %dispaudio()

 


%speaker(soundOutput_test1); 
