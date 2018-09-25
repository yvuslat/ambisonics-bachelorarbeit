%%% creating two random noices
fs = 48000;
t = 5;
src_sig = randn(t*fs, 2);
src_dir = [0 0; 90 30];
%%%

%%
%encodingBFormat
hoasig = encodeBformat(src_sig, src_dir);
%%
%define a 12-speaker uniform setup

[u84, ls_dirs84_rad] = getTdesign(12);
ls_dirs84 = ls_dirs84_rad*180/pi;
mesh84.vertices = u84;
mesh84.faces = sphDelaunay(ls_dirs84_rad);
%%
% get a sampling decoder
MAXRE_ON = 1;
D_sad84 = ambiDecoder(ls_dirs84, 'sad', MAXRE_ON);
%%
% decode signals
LSsig84 = decodeBformat(hoasig, D_sad84);