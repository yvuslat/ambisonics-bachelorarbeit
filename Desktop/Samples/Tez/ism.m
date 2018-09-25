clear all

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
X_src = single([4.6; 2.25; 1.65]);

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
qu = ISM_RoomRespSOFA_COUNT(rt_val,X_src,X_rcv,Rr);
fprintf('... done in %4.2f seconds \n', toc);

tic;
fprintf('Computing filtcoef, ftime and positions...');
[filtcoef, ftime, ispos] = ISM_RoomRespSOFA_TM_FD_CALC(Fs,beta,freq,forder,rt_val,X_src,X_rcv,Rr,qu);
fprintf('... done in %4.2f seconds \n', toc);

clear beta freq Rr rt_val

tic;
fprintf('\n Computing sinc, filter and ffts...');

tsinc = single(zeros(TForder, qu));

for o = 1:1:qu
    tsinc(:,o) = sinc((TimePoints-ftime(o))*Fs);
end

clear TimePoints ftime Fs

fftsize = forder+TForder+HRTFlength-2;
if mod(fftsize,2)==single(1)
    fftsize=fftsize+single(1);
end

tmp = fft([tsinc; zeros(fftsize-TForder, qu)]);
tsinc = tmp(1:end/2+1,:);

tmp = fft([filtcoef'; zeros(fftsize-forder-1, qu)]);
filtcoef = tmp(1:end/2+1,:);

clear tmp

tfilt(:,1,:) = tsinc .* filtcoef;
tfilt(:,2,:) = tfilt(:,1,:);

clear tsinc filtcoef

tmp = fft([tmpirs; zeros(fftsize-HRTFlength, 2, size(tmpirs, 3))]);
HRIRs = tmp(1:end/2+1,:,:);

clear tmpirs tmp

fprintf('... done in %4.2f seconds \n', toc);

IRs = single(zeros(fftsize/2+1,2,n_roll_rcv*n_pitch_rcv*n_yaw_rcv));
Pos = single(zeros(n_yaw_rcv,n_pitch_rcv,n_roll_rcv));
tRIRs = single(zeros(fftsize/2+1,2,qu));

if ~exist(rirname,'dir')
    mkdir(rirname);
end

save([pwd filesep rirname filesep rirname sprintf('_src_%i.mat', Src_number)],'IRs','Pos','yaw_rcv','pitch_rcv','roll_rcv','X_rcv','X_src','room','-v7.3');