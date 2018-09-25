function order = AMorder(speakers);
% Calculate the Ambisonics order of given amount of speakers         
% sigma- between 1 - 0.
% sp_array - speaker array.
% ...
sum=0;
for i=0:1:100
    sum=2*i+1+sum;
    if sum>=speakers break;
    end
end
order=i;
    