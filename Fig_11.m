load('fig11_Data.mat')

FS = 18;
fig1 = figure(1);
x0=10;
y0=10;
width=1200;
height=750;
set(gcf,'position',[x0,y0,width,height])
tiledlayout(1,3,"TileSpacing","tight")


a = nexttile;
pcolor(lonTransect,0:0.5:length(timeVec)/2-0.5,wTransect);
shading interp
clim([-0.005 0.005])
title('a)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
colormap(a,cmocean('balance','pivot',0))
%xlim([-63.5 -62.8])
xlabel('Longitude \circW')
ylabel('Time (Hrs)')
title('a)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
h = colorbar;
h.Label.String = "Vertical Velocity(m/s)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
ax = gca; 
ax.FontSize = FS; 


b = nexttile;
pcolor(lonTransect,0:0.5:length(timeVec)/2-0.5,((smoothdata(mlTransect,1))));
shading interp
colormap(b,cmocean('deep'))
xlim([-63.5 -62.8])
xlabel('Longitude \circW')
ylabel('Time (Hrs)')
colorbar;
clim
clim([51 200])
title('b)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
h = colorbar;
h.Label.String = "MLD (m)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
ax = gca; 
ax.FontSize = FS; 


c = nexttile;
pcolor(lonTransect,0:0.5:length(timeVec)/2-0.5,(gradient(smoothdata(mlTransect,1),1)));
shading interp
clim([-4 4])
colormap(c,cmocean('balance','pivot',0))
xlim([-63.5 -62.8])
xlabel('Longitude \circW')
ylabel('Time (Hrs)')
colorbar
title('c)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
h = colorbar;
h.Label.String = "MLD Gradient(m/km)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
ax = gca; 
ax.FontSize = FS; 
