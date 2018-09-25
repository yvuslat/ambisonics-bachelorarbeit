function return_coef_array = AMbisonicsCF(phi,theta,order)
% Returns Ambisonics coefficients of given order and sound source location.         
% phi - elevation angle
% theta - azimuth angle
% order - Ambisonics order


Xp=sin((pi/180)*phi);

sp_array = [];
sp_array(1)=1;
tos=2;

for i=1:1:order
    temp_arr=legendre(i,Xp,'sch');
    sp_array(tos)=temp_arr(1);
    tos=tos+1;
        for j=2:1:length(temp_arr)
                sp_array(tos)=temp_arr(j)*cos((j-1)*(pi/180)*theta);
                tos=tos+1;
                sp_array(tos)=temp_arr(j)*sin((j-1)*(pi/180)*theta);
                tos=tos+1;
        end
end

return_coef_array=sp_array;