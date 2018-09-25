function [t, y] = PlaySound()
f=1000;
Amp=1;
fs = 44100;
ts=1/44100;
T=7;
t=0:ts:T;
y=sin(2*pi*f*t);
sound(y,fs);