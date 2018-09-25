filename = 'Angry-cat-sounds.wav';
[y,Fs] = audioread('Cat.wav');

a = y(:,1);
b = y(:,2)
c = a + b ;
soundsc(c)
