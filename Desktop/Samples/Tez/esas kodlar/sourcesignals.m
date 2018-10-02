% SOFAstart;
% hrtf = SOFAload('HRIR_FULL2DEG.sofa');
% %SOFAinfo(hrtf);
% SOFAplotGeometry(hrtf);
% %size(hrtf.Data.IR)
%%
% Calculate the source position from a listener point of view
% apparentSourceVector = SOFAcalculateAPV(hrtf);
%% Source Signals
[y1,Fs1] = audioread('HellOfAGuy_GitR.wav', [1,480000*3]);
[y2,Fs2] = audioread('HellOfAGuy_GitL.wav' , [1,480000*3]); 
[y3 ,Fs3] = audioread('HellOfAGuy_Voc.wav', [1,480000*3]);
%source_signals = [y1 y2 y3];
X_src = [([4.2; 2.25; 1.65]),([2; 2.25; 1.65]),([6; 3; 1.65])];

%%ç
%ISM
%clear all

table_ispos = cell(1,3);
table_tsinc = cell(1,3);
table_filtcoef = cell(1,3);
table_tfilt = cell(1,3);
conv_y1 = cell(1,2);
conv_y2 = cell(1,2);
conv_y3 = cell(1,2);

for i = 1:3
    
    rirname = 'brir';

    Fs = single(48000);
    rt_val = single(.17);
    forder = single(256);
    c = single(343);

    addpath(genpath([pwd filesep 'ISM' filesep]));
    addpath(genpath([pwd filesep 'API_MO' filesep]));

    [beta_walls,freq] = absorbCoeffList(21);
    freq = single(freq);
    beta_floor = absorbCoeffList(14);

    beta = [beta_walls';beta_walls';beta_walls'; beta_walls';beta_floor';beta_walls'];
    clear beta_floor beta_walls

    room = single([6.29 3.92 2.82]);
    X_rcv = single([2.38; 1.99; 1.25]);

    Src_number = single(1);
    %X_src = single([4.6; 2.25; 1.65]);
    X_src(:,i);
    %yaw_rcv = single(-178:2:180);
    %pitch_rcv = single(-46:4:50);
    %roll_rcv = single(-30:10:30);

    yaw_rcv = single(50);
    pitch_rcv = single(50);
    roll_rcv = single(50);

    n_yaw_rcv = single(length(yaw_rcv));
    n_pitch_rcv = single(length(pitch_rcv));
    n_roll_rcv = single(length(roll_rcv));

    %-=:=- Check user input:
    if X_rcv(1)>=room(1) || X_rcv(2)>=room(2) || X_rcv(3)>=room(3) || X_rcv(1)<=0 || X_rcv(2)<=0 || X_rcv(3)<=0
        error('Receiver must be within the room boundaries!');
    elseif X_src(1)>=room(1) || X_src(2)>=room(2) || X_src(3)>=room(3) || X_src(1)<=0 || X_src(2)<=0 || X_src(3)<=0
        error('Source must be within the room boundaries!');
    elseif ~isempty(find(beta>=1,1)) || ~isempty(find(beta<0,1))
        error('Parameter ''BETA'' must be in the range [0...1).');
    end

    beta = -abs(beta);      % implement phase inversion in Lehmann & zohansson's ISM implementation

    Rr = single(2)*room(:);         % Room dimensions

    filename = 'HRIR_FULL2DEG';
    hrirpath = [pwd filesep 'HRIRs' filesep];
    fprintf('Loading %s.sofa\n',filename);
    %z = SOFAload([hrirpath filename '.sofa']);
    z=SOFAload('HRIR_FULL2DEG.sofa');

    clear hrirpath filename

    tmpirs = single(permute(z.Data.IR,[3 2 1]));

    Hpos = single(zeros(360,181));

    n_hrirs = single(size(z.SourcePosition,1));

    for x = single(1):1:size(Hpos, 1)
        for y = single(1):1:size(Hpos, 2)
            [~, Hpos(x,y)] = min(sqrt(sum(abs(repmat([x-1,y-91],size(z.SourcePosition(:,1),1),1)-z.SourcePosition(:,1:2)).^2,2)));
        end
    end

    clear x y z
    HRTFlength = single(size(tmpirs,1));
    TForder = ceil(rt_val*Fs);
    TimePoints = single(((0:TForder-1)/Fs).');

    tic;
    fprintf('Computing number of sources...');   
    qu = ISM_RoomRespSOFA_COUNT(rt_val,X_src(:,i),X_rcv,Rr);
    fprintf('... done in %4.2f seconds \n', toc);

    tic;
    fprintf('Computing filtcoef, ftime and positions...');
    [filtcoef, ftime, ispos] = ISM_RoomRespSOFA_TM_FD_CALC(Fs,beta,freq,forder,rt_val,X_src(:,i),X_rcv,Rr,qu);
    fprintf('... done in %4.2f seconds \n', toc);

    table_ispos{1,i} = ispos;
    
    
    clear beta freq Rr rt_val

    tic;
    fprintf('\n Computing sinc, filter and ffts...');

    tsinc = single(zeros(TForder, qu));

    for o = 1:qu
        tsinc(:,o) = sinc((TimePoints-ftime(o))*Fs);
    end

    clear TimePoints Fs ftime 

    fftsize = forder+TForder+HRTFlength-2;
    if mod(fftsize,2)==single(1)
        fftsize=fftsize+single(1);
    end

    tmp = fft([tsinc; zeros(fftsize-TForder, qu)]);
    tsinc = tmp(1:end/2+1,:);

    tmp = fft([filtcoef'; zeros(fftsize-forder-1, qu)]);
    filtcoef = tmp(1:end/2+1,:);
    
    table_tsinc{1,i} = tsinc;
    table_filtcoef{1,i} = filtcoef;
    
    clear tmp tfilt
    tfilt = tsinc .* filtcoef;
    table_tfilt{1,i} = tfilt;
    %tfilt(:,1,:) = tsinc .* filtcoef;
    %tfilt(:,2,:) = tfilt(:,1,:);
    %will be used for the next section für die faltung -tsinc and filtcoef
    %FRAGE an Herr Paukner: Für welcher Domain sind diese Koeffizienten
    %geeignet ? 
    %clear tsinc filtcoef

    %tmp = fft([tmpirs; zeros(fftsize-HRTFlength, 2, size(tmpirs, 3))]);
    %HRIRs = tmp(1:end/2+1,:,:);

    %clear tmpirs tmp

    fprintf('... done in %4.2f seconds \n', toc);

    IRs = single(zeros(fftsize/2+1,2,n_roll_rcv*n_pitch_rcv*n_yaw_rcv));
    Pos = single(zeros(n_yaw_rcv,n_pitch_rcv,n_roll_rcv));
    tRIRs = single(zeros(fftsize/2+1,2,qu));

    if ~exist(rirname,'dir')
        mkdir(rirname);
    end

    %save([pwd filesep rirname filesep rirname sprintf('_src_%i.mat', 'Src_number')],'IRs','Pos','yaw_rcv','pitch_rcv','roll_rcv','X_rcv','room','-v7.3');
    
end    

%%
%real(ifft(table_tfilt{1,1}));
%bunlar hangi domainde tfilt... zamana geri cevirmeliyi miyim conv öncesi ?
table_tfilt{1,1} = real(ifft(table_tfilt{1,1}));
table_tfilt{1,2} = real(ifft(table_tfilt{1,2}));
table_tfilt{1,3} = real(ifft(table_tfilt{1,3}));
for s=1:2
    conv_y1{1,s} = conv(y1, table_tfilt{1,1}(:,s));
    conv_y2{1,s} = conv(y2, table_tfilt{1,2}(:,s));
    conv_y3{1,s} = conv(y3, table_tfilt{1,3}(:,s));
end
%% 
conv_y1 = cell2mat(conv_y1);
conv_y1 = conv_y1(1:480000*3,:);
conv_y2 = cell2mat(conv_y2);
conv_y2 = conv_y2(1:480000*3,:);
conv_y3 = cell2mat(conv_y3);
conv_y3 = conv_y3(1:480000*3,:);
%% Input Signals inclusive ism signals
source_signals = [conv_y1 conv_y2 conv_y3];

%% Winkel rechnung für die Encoding Operation
table_azimuth = cell(1,3);
table_elevation = cell(1,3);
for x = 1:3
    azimuth = zeros(1,2); 
    elevation = zeros(1,2); 
    z = table_ispos{:,x};
    z_5 = z(:,1:2);
    for y = 1:2
       [azimuth1 , elevation1] = arakod(single([2.38; 1.99; 1.25]),z_5(:,y));
       azimuth(1,y)= azimuth1;
       elevation(1,y)= elevation1;
    end
    table_azimuth{1,x} = azimuth;
    table_elevation{1,x} = elevation;
end     

%table_ispot taki cellerideki her değerden ilk 5 değeri alıp ordan onları arakod içine koyup degeleri hesaplamak
     
azimuth_total = cell2mat(table_azimuth);
elevation_total = cell2mat(table_elevation);
directions_ism = [azimuth_total ; elevation_total]'; % [azimuth elevation]
% Source direction inclusive ism
source_directions = [directions_ism];
%% encoding 
%EncodedSignal = encodeBformat(source_signals, source_directions);
%EncodedSignal_cells = mat2cell(EncodedSignal, [repelem(size(EncodedSignal,1)/128,128)], [4]) ;