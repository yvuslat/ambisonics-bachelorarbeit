function re_v = AMplot(speaker_array_azimuth,speaker_array_elevation,show_sp);
% Plot a graphic of given amount of speakers and possition        
% speaker_array_azimuth - array of each speaker azimuth angle.
% speaker_array_elevation - array of each speaker elevation angle.
% show_sp - show sphere

[X,Y,Z] = sphere(100);
xline(1)=plot3(0,0,0,'-.or');
set(xline(1),'Color',[0,0,0],'LineWidth',4);
hold on 
if show_sp==1
    plot3(X,Y,Z,'--');
end
for i=1:1:length(speaker_array_azimuth)
    xp(i)=0+1*cos((pi/180)*speaker_array_azimuth(i))*sin((pi/180)*(speaker_array_elevation(i)+90));
    yp(i)=0+1*sin((pi/180)*speaker_array_azimuth(i))*sin((pi/180)*(speaker_array_elevation(i)+90));
    zp(i)=0+1*sin((pi/180)*speaker_array_elevation(i));
    xline(1+i)=plot3(xp(i),yp(i),zp(i),'-.or');
    set(xline(1+i),'Color',[rand,rand,rand],'LineWidth',4);
end
grid on
axis square
xlabel('Back / Forward')
ylabel('Left / Right')
zlabel('Down / Up')
re_v=1;
