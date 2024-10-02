%clear all

%% Load Grid Data and assign variables
load('NESMgrd.mat')
lat = grdNESM.Bathymetry.lat;
lon = grdNESM.Bathymetry.lon;
depth = grdNESM.Bathymetry.depth;
% Load SST temperature data
load('jplMURSST41_d958_40c8_61f9.mat')

latitude = double(jplMURSST41.latitude);
longitude = double(jplMURSST41.longitude);
sst = squeeze(jplMURSST41.analysed_sst);


latMin = min(min(lat)); latMax = max(max(lat));
lonMin = min(min(lon)); lonMax = max(max(lon));

SSTlatMin = min(min(latitude)); SSTlatMax = max(max(latitude));
SSTlonMin = min(min(longitude)); SSTlonMax = max(max(longitude));

FS = 16;

%% Plotting
fig1 = figure(1);
x0=10;
y0=10;
%width=950;
height=950;
set(gcf,'position',[x0,y0,(95/85)*height,height])
tcl = tiledlayout(2,2,'TileSpacing','tight');

latlim = [20 46];
lonlim = [-82 -50];
nesmLat = ([37.5 40]); nesmLon = -([65 61.5]);
latNESM = [nesmLat(1) nesmLat(2) nesmLat(2) nesmLat(1) nesmLat(1)]; 
lonNESM = [nesmLon(1) nesmLon(1) nesmLon(2) nesmLon(2) nesmLon(1)];

nexttile();
m_proj('miller','lon',[SSTlonMin SSTlonMax],'lat',[SSTlatMin SSTlatMax]);
m_pcolor(longitude,latitude, sst); shading interp; hold on
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');
cmocean('thermal'); 
m_plot(lonNESM,latNESM,'LineWidth',2,'Color','k')
h = colorbar;
h.Label.String = "Sea Surface Temperature (\circC)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
title('a)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
ax = gca; 
ax.FontSize = FS; 

nexttile()
titleSTR = {'b)', 'c)', 'd)'};
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax]);
m_contourf(lon,lat,-depth);
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');
title((titleSTR{1}),'FontSize',FS);set(gca,'TitleHorizontalAlignment','left'); 

h = colorbar;
h.Label.String = "Depth (m)";
h.Label.FontSize = FS;
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
ax = gca; 
ax.FontSize = FS; 
nexttile()
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax]);
m_contourf(lon,lat,-depth);
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');
title((titleSTR{2}),'FontSize',FS);set(gca,'TitleHorizontalAlignment','left'); 
ax = gca; 
ax.FontSize = FS; 

h = colorbar;%('Position',[0.93 0.FS8 0.022 0.7]); 
h.Label.String = "Depth (m)";
h.Label.FontSize = FS;
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
ax = gca; 
ax.FontSize = FS; 
nexttile()
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax]);
m_contourf(lon,lat,-depth);
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');
title((titleSTR{3}),'FontSize',FS);set(gca,'TitleHorizontalAlignment','left'); 

% xlabel('Longitude (\circ)','FontSize',FS)
% ylabel('Latitude (\circ)','FontSize',FS)
h = colorbar;
h.Label.String = "Depth (m)";
h.Label.FontSize = FS;
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
ax = gca; 
ax.FontSize = FS; 

%% Figure 2
fig1 = figure(2);
x0=10;
y0=10;
width=800;
height=650;
set(gcf,'position',[x0,y0,width,height])
surf(lon,lat,-depth); shading interp;hold on 
contour3(lon,lat,-depth,40,'k')
colormap(flip(jet))
set(gca,"ZDir","reverse")
zlim([1500 5700])
ylim([37.5 39.5])
xlim([-64 -62.3])
xticks([- 63.8 -63.5  -63.2 -62.9 -62.6])
xticklabels({'63.8^{\circ}W'  '63.5^{\circ}W' '63.2^{\circ}W' '62.9^{\circ}W' '62.6^{\circ}W'})
yticks([37.6 38   38.4  38.8   39.2])
yticklabels({'37.6^{\circ}N'  '38^{\circ}N' '38.4^{\circ}N' '38.8^{\circ}N' '39.2^{\circ}N'})
zlabel('Depth (m)')
daspect([1 1 5000])
text(-62.94,39.25,2766,'Atlantis II','FontSize',16)
text(-63.8,39.2,2500,'Kelvin','FontSize',16)
text(-62.68,38.25,1050,'Gosnold','FontSize',16)

h = colorbar;
h.Label.String = "Depth (m)";
h.Label.FontSize = FS;
h.Label.Rotation =270 ;
h.Label.VerticalAlignment = "bottom";
h.Direction = 'reverse';
ax = gca; 
ax.FontSize = FS; 

