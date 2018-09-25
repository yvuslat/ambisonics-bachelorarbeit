%%
SOFAstart;
hrtf = SOFAload('HRIR_FULL2DEG.sofa');
%SOFAinfo(hrtf);
%SOFAplotGeometry(hrtf);
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
source_signals = randn(t*fs, 2);
source_direction = [180 0; 90 30];

%%
%encodingBFormat
EncodedSignal = encodeBformat(source_signals, source_direction);

%% define a 12-speaker uniform setup
%A regular icosahedron is a convex polyhedron with 20 faces, 30 edges and 12 vertices
[u12, ls_dirs12_rad, mesh12] = platonicSolid('icosahedron');
ls_dirs12 = ls_dirs12_rad*180/pi;
%ls_dirs12 
%90.0000   31.7175
%  -90.0000   31.7175
%   90.0000  -31.7175
%  -90.0000  -31.7175
%        0   58.2825
%        0  -58.2825
% 180.0000   58.2825
% 180.0000  -58.2825
%  31.7175         0
% -31.7175         0
% 148.2825         0
% -148.2825         0

%%
% get ALLRAD decoder
% Max-rE weighting for the decoder
MAXRE_ON = 1;
D_allrad12 = ambiDecoder(ls_dirs12, 'allrad', MAXRE_ON);
%
%decodingto12load & creating loudspeaker signals
lssig = decodeBformat(EncodedSignal, D_allrad12);
signal1 = lssig(:,1);
signal2 = lssig(:,2);
signal3 = lssig(:,3);
signal4 = lssig(:,4);
signal5 = lssig(:,5);
signal6 = lssig(:,6);
signal7 = lssig(:,7);
signal8 = lssig(:,8);
signal9 = lssig(:,9);
signal10 = lssig(:,10);
signal11 = lssig(:,11);
signal12 = lssig(:,12);

%%
%binaural rendering
soundOutput1 = [conv(squeeze(hrtf.Data.IR(4034, 1, :)), signal1) ...
               conv(squeeze(hrtf.Data.IR(4034, 2, :)), signal1)];
           
soundOutput2 = [conv(squeeze(hrtf.Data.IR(12044, 1, :)), signal2) ...
               conv(squeeze(hrtf.Data.IR(12044, 2, :)), signal2)];

soundOutput3 = [conv(squeeze(hrtf.Data.IR(4066, 1, :)), signal3) ...
               conv(squeeze(hrtf.Data.IR(4066, 2, :)), signal3)];           

soundOutput4 = [conv(squeeze(hrtf.Data.IR(12076, 1, :)), signal4) ...
               conv(squeeze(hrtf.Data.IR(12076, 2, :)), signal4)];

soundOutput5 = [conv(squeeze(hrtf.Data.IR(16, 1, :)), signal5) ...
               conv(squeeze(hrtf.Data.IR(16, 2, :)), signal5)];

soundOutput6 = [conv(squeeze(hrtf.Data.IR(74, 1, :)), signal6) ...
               conv(squeeze(hrtf.Data.IR(74, 2, :)), signal6)];

soundOutput7 = [conv(squeeze(hrtf.Data.IR(8026, 1, :)), signal7) ...
               conv(squeeze(hrtf.Data.IR(8026, 2, :)), signal7)];  
           
soundOutput8 = [conv(squeeze(hrtf.Data.IR(8084, 1, :)), signal8) ...
               conv(squeeze(hrtf.Data.IR(8084, 2, :)), signal8)];  

soundOutput9 = [conv(squeeze(hrtf.Data.IR(1469, 1, :)), signal9) ...
               conv(squeeze(hrtf.Data.IR(1469, 2, :)), signal9)];  

soundOutput10 = [conv(squeeze(hrtf.Data.IR(14641, 1, :)), signal10) ...
               conv(squeeze(hrtf.Data.IR(14641, 2, :)), signal10)]; 

soundOutput11 = [conv(squeeze(hrtf.Data.IR(6631, 1, :)), signal11) ...
               conv(squeeze(hrtf.Data.IR(6631, 2, :)), signal11)];  
 
soundOutput12 = [conv(squeeze(hrtf.Data.IR(9479, 1, :)), signal12) ...
               conv(squeeze(hrtf.Data.IR(9479, 2, :)), signal12)];            

%%
%Listening all the binaural recording

soundOutputogether = soundOutput1+soundOutput2+soundOutput3 +soundOutput4 + soundOutput5 + soundOutput6 + soundOutput7 + soundOutput8 + soundOutput9 + soundOutput10 + soundOutput11 + soundOutput12;
          
%%

soundsc(soundOutputogether); 
%%
% plot RMS distribution of the decoded signals, along speaker directions
%Psig = sqrt(mean(lssig.^2)).';
%Sx = zeros(2,12); Sx(2,:) = u12(:,1); % speaker lines
%Sy = zeros(2,12); Sy(2,:) = u12(:,2); % speaker lines
%Sz = zeros(2,12); Sz(2,:) = u12(:,3); % speaker lines
%figure
%patch('vertices', mesh12.vertices .* (Psig*ones(1,3)), 'faces', mesh12.faces, 'facecolor', 'm')
%line([0 1.5*max(Psig)],[0 0],[0 0],'color','r') % axis lines
%line([0 0],[0 1.5*max(Psig)],[0 0],'color','g') % axis lines
%line([0 0],[0 0],[0 1.5*max(Psig)],'color','b') % axis lines
%line(Sx,Sy,Sz,'color','k') % plot speakers
%axis equal
%xlabel('x'), ylabel('y'), zlabel('z'), grid, view(100,20)
%h = gcf; h.Position(3:4) = 2*h.Position(3:4);
%suptitle('RMS signal power of speaker channels for two decoded sources - icosahedral layout')

%%%% 
