function [r_a,r_e] = AMsp_position(order,type,fix_angle,zero_e)
% Calculate the speakers position of given order         
% order - between 1 - .... type = 1 or 2.
% type defines way of panning speakers. 
%       1 - rotation of azimuth angle, elevation angle fixed +/0/- fix_angle
%       2 or other value - rotation of elevation angle, azimuth angle fixed +/0/- fix_angle
% zero_e - defines if Zero-plane (elevation or azimuth) to be with speakers
%       1 - YES; Any other value NO.
num_sp=0;
if zero_e == 1
    dim_order=3;
else
    dim_order=2;
end

% fix_angle=45;
angle=[];
return_angle=[];
fixed_angle=[];
high_sp=[];
k=5;
num_sp=0;

% Position of first 4 speakers.
if (order==1)
    r_a(1)=0;
    r_e(1)=90;
    r_a(3)=0;
    r_e(3)=0;
else
    r_a(1)=0;
    r_e(1)=90;
    r_a(3)=0;
    r_e(3)=0;
end

r_a(2)=90;
r_e(2)=0;
r_a(4)=275;
r_e(4)=0;
%position end.


for i=2:1:order
    high_sp(i)=i*2+1;
    num_sp=i*2+1+num_sp;
end


sp_per_dim=ceil(num_sp/dim_order);
% sp_per_part=ceil(sp_per_dim/2);
degree_distance=360/sp_per_dim;

if type==1
    if zero_e==1
     for i=1:1:sp_per_dim
        angle(i)=degree_distance*i;
        return_angle(k)=angle(i);
        fixed_angle(k)=0;
        k=k+1;
     end
    end
    for i=1:1:sp_per_dim
        angle(i)=degree_distance*i;
        return_angle(k)=angle(i);
        fixed_angle(k)=fix_angle;
        k=k+1;
    end
    
    fix_angle=-fix_angle;
    for i=1:1:sp_per_dim
        angle(i)=degree_distance*i;
        return_angle(k)=angle(i);
        fixed_angle(k)=fix_angle;
        k=k+1;
    end
else
    
    sp_per_dim=ceil(num_sp/(dim_order*2));
    degree_distance=180/sp_per_dim;
    if zero_e==1
     for i=1:1:sp_per_dim
        angle(i)=degree_distance*i-90;
        return_angle(k)=angle(i);
        fixed_angle(k)=0;
        k=k+1;
        return_angle(k)=angle(i);
        fixed_angle(k)=0+180;
        k=k+1;
     end
    end
    
    for i=1:1:sp_per_dim
        angle(i)=degree_distance*i-90;
        return_angle(k)=angle(i);
        fixed_angle(k)=fix_angle;
        k=k+1;
        return_angle(k)=angle(i);
        fixed_angle(k)=fix_angle+180;
        k=k+1;
    end
    fix_angle=fix_angle+90;
    for i=1:1:sp_per_dim
        angle(i)=degree_distance*i-90;
        return_angle(k)=angle(i);
        fixed_angle(k)=fix_angle;
        k=k+1;
        return_angle(k)=angle(i);
        fixed_angle(k)=fix_angle+180;
        k=k+1;
    end
end


if type==1
    for i=5:1:num_sp+4
        r_a(i)=return_angle(i);
        r_e(i)=fixed_angle(i);
    end
else
    for i=5:1:num_sp+4
        r_e(i)=return_angle(i);
        r_a(i)=fixed_angle(i);
    end
end
% r_a=return_angle(1:num_sp+4);
% r_e=fixed_angle(1:num_sp+4);
        

