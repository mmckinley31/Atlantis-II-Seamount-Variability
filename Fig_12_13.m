load('figs12_13_particleData.mat')

%%
water_column_disc = -flip([0:5:100 110:10:1000 1025:25:5675]); %New WaterColumn
depthPlot = -3600;


lonLim = [-64.3 -61.5];
latLim = [38. 39.5];
fig1 = figure(1);
set(fig1,'Position',[100 100 1450 850])
tiledlayout(3,3,'TileSpacing','tight'); nexttile;
m_proj('miller','lon',lonLim,'lat',latLim);
m_pcolor(lonB,latB,weakVort(:,:,water_column_disc==depthPlot)); hold on; shading interp
%contour(lonB,latB,bathy);
clim([-0.5 0.5])

colormap(cmocean('balance','pivot',0))
m_scatter(lonWeak(:,end),latWeak(:,end),1,'k','filled');
title('a)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 
h = colorbar(); 
h.Label.String = "(\zeta/f)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;

nexttile;
m_proj('miller','lon',lonLim,'lat',latLim);

m_scatter(lonWeak(:,end),latWeak(:,end),1,depthWeak(:,1)-depthWeak(:,end),'filled');
title('b)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 
h = colorbar();
h.Label.String = "Depth (m)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
clim([-2000 2000])
h = colorbar;
h.Label.String = "Depth (m)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;

nexttile;
m_proj('miller','lon',lonLim,'lat',latLim);

m_scatter(lonWeak(:,end),latWeak(:,end),1,densityWeak(:,1)-densityWeak(:,end),'filled');
title('c)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left');
clim([-0.025 0.025])
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 

h = colorbar;
h.Label.String = "\Delta\sigma_2";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;

nexttile;    m_proj('miller','lon',lonLim,'lat',latLim);

m_pcolor(lonB,latB,transitionVort(:,:,find(water_column_disc==depthPlot))); hold on; shading interp
clim([-0.5 0.5])
colormap(cmocean('balance','pivot',0))
m_scatter(lonTransition(:,end),latTransition(:,end),1,'k','filled');
title('d)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 

h = colorbar(); 
h.Label.String = "(\zeta/f)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;

nexttile;    m_proj('miller','lon',lonLim,'lat',latLim);

m_scatter(lonTransition(:,end),latTransition(:,end),1,depthTransition(:,1)-depthTransition(:,end),'filled');
title('e)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 


clim([-2000 2000])
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 

h = colorbar;
h.Label.String = "Depth (m)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;

nexttile;    m_proj('miller','lon',lonLim,'lat',latLim);

m_scatter(lonTransition(:,end),latTransition(:,end),1,densityTransition(:,1)-densityTransition(:,end),'filled');
title('f)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 


clim([-0.025 0.025])
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 

h = colorbar;
h.Label.String = "\Delta\sigma_2";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;


nexttile;    m_proj('miller','lon',lonLim,'lat',latLim);

m_pcolor(lonB,latB,strongVort(:,:,find(water_column_disc==depthPlot))); hold on; shading interp
clim([-0.5 0.5])

colormap(cmocean('balance','pivot',0));
m_scatter(lonStrong(:,321),latStrong(:,321),1,'k','filled');
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 

title('g)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 

h = colorbar(); 
h.Label.String = "(\zeta/f)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;

nexttile;      m_proj('miller','lon',lonLim,'lat',latLim);
m_scatter(lonStrong(:,end),latStrong(:,end),1,depthStrong(:,1)-depthStrong(:,end),'filled');
colormap(cmocean('balance'))
title('h)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
clim([-2000 2000])
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 
h = colorbar;
h.Label.String = "Depth (m)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;

nexttile;        
m_proj('miller','lon',lonLim,'lat',latLim);
m_scatter(lonStrong(:,end),latStrong(:,end),1,densityStrong(:,1)-densityStrong(:,end),'filled');
colormap(cmocean('balance'))
title('i)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
clim([-0.025 0.025])
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 
h = colorbar;
h.Label.String = "\Delta\sigma_2";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;
    
   %% Plotting
fig3 = figure(3);
x0=10;
y0=10;
width=950;
height=425;
set(gcf,'position',[x0,y0,width,height])

tiledlayout(1,2,'TileSpacing','tight')
nexttile()
m_proj('miller','lon',lonLimB,'lat',latLimB);
m_contourf(lonB,latB,-bathy);shading interp; hold on;
m_scatter(lonWeak(:,1),latWeak(:,1),0.7,'w','filled');
cmocean('deep')
title('a)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 
h = colorbar;
h.Label.String = "Depth (m)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;

nexttile()
m_proj('miller','lon',[min(lonWeak(:,1)) max(lonWeak(:,1))],'lat',[min(latWeak(:,1)) max(latWeak(:,1))]);
m_scatter(lonWeak(:,1),latWeak(:,1),0.9,depthWeak(:,1),'filled');
cmocean('deep')
title('b)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 

h = colorbar;
h.Label.String = "Depth (m)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;