function return_ok = AMplottable(speaker_array_azimuth,speaker_array_elevation,coef_sp_array)
% Plots table         
% coef_sp_array - array with coeficients
% speaker_array_azimuth - array of azimuth angles.
% speaker_array_elevation - array of elevation angles.
r=round(rand()*1000);
f = figure(r);
for i=1:1:length(coef_sp_array)
    data(i,1) = round(i); 
    data(i,2) = speaker_array_azimuth(i);
    data(i,3) = speaker_array_elevation(i);
    data(i,4) = coef_sp_array(i);
end
cnames = {'No','Azimuth angle','Elevation angle','Coeficient'}; 
t = uitable('Data',data,'ColumnNames',cnames,'Parent',f,'Position',[0 0 600 400]);
return_ok=1;

