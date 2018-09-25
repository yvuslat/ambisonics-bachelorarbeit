function speakers = AMspeakers(order)
% Calculate the amount of speakers of given order         
% order- Ambisonics order
% 
% ...
sum=0;
for i=0:1:order
    sum=2*i+1+sum;
end
speakers=sum;