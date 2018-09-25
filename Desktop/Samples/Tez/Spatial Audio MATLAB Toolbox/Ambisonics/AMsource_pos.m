function return_array = AMsource_pos(sigma,sp_array);
% Calculate the output signal depending on possition inside the array         
% sigma- between 1 - 0.
% sp_array - speaker array.
% ...

%     Comment
%signal_output will be with the same lenght as input signal u.
pan_ins=cos((pi/180)*45*sigma);
sp_array=pan_ins*sp_array;
return_array=sp_array;