function sp_gain=VBAP_stereophony(phi_zero,phi);
% Returns the gains for two speakers in stereophony         
% phi_zero - The angle between the speaker and the central plane
% phi - The angle between the sound source and central plane 
gain(1)=1;
x=tan(phi*pi/180)/tan(phi_zero*pi/180);
gain(2)=(1-x)/(1+x);

c=sqrt(sum(gain.^2));
gain=gain./c;
sp_gain=gain;
