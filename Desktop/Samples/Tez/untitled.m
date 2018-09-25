load handel.mat
audiowrite('handel.wav',y,Fs)
info = audioinfo('handel.wav')
[y,Fs] = audioread('handel.wav');
