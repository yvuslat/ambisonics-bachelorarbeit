function [azimuth1,elevation1] = arakod(X_rcv , X_src)
    
%X_rcv = single([2.38; 1.99; 1.25]);
%X_src = single([4.6; 2.25; 1.65]);

direction = X_rcv - X_src;
direction_unit = direction - X_rcv;
direction_unit = direction/norm(direction_unit);

[azimuth,elevation,r] = cart2sph(direction_unit(1),direction_unit(2),direction_unit(3));

elevation1 = (90 - elevation)/pi
azimuth1 = azimuth/pi

%azimuth = acos(direction_unit(3));
%elevation = acos(direction_unit(2)/direction_unit(1))

end 

