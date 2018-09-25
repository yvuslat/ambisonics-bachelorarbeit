function re_v = VBAPplot(speaker_coord,source_pos,show_sp,num_sp);
% Plot a graphic of given amount of speakers and position
% num_use_sp - num. of used speakers
% speaker_coord - array of speaker coordinates (polar) 
% speaker_coord(1,1) = 1; % Distance must be in metre
% speaker_coord(1,2) = 315; azimuth angle
% speaker_coord(1,3) = 45;  elevation angle
% source_pos - array of source possition
% source_pos(1,1) = 1; Distance in metre
% source_pos(1,2) = 0;  azimuth angle
% source_pos(1,3) = 45; elevation angle
% show_sp - show sphere

xs=source_pos(1,1)*cos((pi/180)*source_pos(1,2))*sin((pi/180)*(source_pos(1,3)+90));
ys=source_pos(1,1)*sin((pi/180)*source_pos(1,2))*sin((pi/180)*(source_pos(1,3)+90));
zs=source_pos(1,1)*sin((pi/180)*source_pos(1,3));
    
    
[X,Y,Z] = sphere(100);

xline(1)=plot3(xs,ys,zs,'-.or');
set(xline(1),'Color',[xs,ys,zs],'LineWidth',5);
hold on 
xline(2)=plot3(0,0,0,'-.or');
set(xline(2),'Color',[0,0,0],'LineWidth',6);
hold on 
if show_sp==1
    plot3(X,Y,Z,'--');
end
for ii=1:1:num_sp
    xp(ii) = speaker_coord(ii,1)*cos((pi/180)*speaker_coord(ii,2))*sin((pi/180)*(speaker_coord(ii,3)+90));
    yp(ii) = speaker_coord(ii,1)*sin((pi/180)*speaker_coord(ii,2))*sin((pi/180)*(speaker_coord(ii,3)+90));
    zp(ii) = speaker_coord(ii,1)*sin((pi/180)*speaker_coord(ii,3));
    
    
    xline(2+ii)=plot3(xp(ii),yp(ii),zp(ii),'-.or');
    set(xline(2+ii),'Color',[rand,rand,rand],'LineWidth',4);
end
grid on
axis square
xlabel('Back / Forward')
ylabel('Left / Right')
zlabel('Down / Up')
re_v=1;
