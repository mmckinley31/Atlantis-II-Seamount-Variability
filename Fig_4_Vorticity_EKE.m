%%
clear variables
close all
% Load and assign weak and strong variables

%% EKE Stats
load('uv_2800.mat')

%% Weak
load('weak1200_1536.mat')
weakCT = muCT; weakCTstd = sigmaCT;
weakSA = muSA; weakSAstd = sigmaSA;
weakSpeed = muSpeed; weakSpeedstd = sigmaSpeed;
weakXi = muXi; weakVortstd = sigmaXi;
weakW = abs(muW)*86400; weakWstd = sigmaW;
weakSSP = muSSP; weakSSPstd = sigmaSSP;
weakRho = muRHO; weakRHOstf = sigmaRHO;
weakU = muU; weakV = muV;

%% Transition

load('weak300_636.mat')
transitionCT = muCT; transitionCTstd = transitionCT;
transitionSA = muSA; transitionSAstd = sigmaSA;
transitionSpeed = muSpeed; transitionSpeedstd = sigmaSpeed;
transitionXi = muXi; transitionstd = sigmaXi;
transitionW = abs(muW)*86400; transitionWstd = sigmaW;
transitionSSP = muSSP; transitionSSPstd = sigmaSSP;
transitionRho = muRHO; transitionRHOstd = sigmaRHO;
transitionU = muU; transitionV = muV;

%% Strong
load('medium1000_1336.mat')

%% EKE Stats
load('uv_2800.mat')

%% Other Constants
NumLayers = 100;
type = 'r';
coef = 1;
gname = 'grd.nc'; 
month =' Weak';
dirHR =     'C:\Users\mmckinley31\GaTech Dropbox\CoS-EXT\EAS-Ext\EAS-Bracco-TEAM-Ext\NESM\NESM Weak and Transition\';
addpath(dirHR);
N = 2;
gridfile = [dirHR gname];

%Extract NC file variables
time = 1275;
fname   = sprintf('NESM1km_avg.%05d.nc',time); hisfile = fname;
lon     = pagetranspose(ncread(gridfile,'lon_rho'));
lat     = pagetranspose(ncread(gridfile,'lat_rho'));

water_column_disc = -flip([0:5:100 110:10:1000 1025:25:5675]); %New WaterColumn

latMin = min(min(lat)); latMax = max(max(lat));
lonMin = min(min(lon)); lonMax = max(max(lon));

FS = 16;
%% Box locatin for EKE
idxNorth = 150;
idxSouth = 115;
range = lon(99,:);
% Check Slice
LatProfile = 38.5;

lonIDXLee = [-63.3 -62.75];% [lat(eddySliceIdx,1) lat(eddySliceIdx,1)]
[~,idxWest] = min(abs(lon(1,:)-(lonIDXLee(1)))); [~,idxEast] = min(abs(lon(1,:)-(lonIDXLee(2))));

%% Weak 
figure;
depthVec = [0 2800];
climTempVec = [-1. 1. -0.25 0.25];

x0=10;
y0=10;
width=1825;
height=1400;
set(gcf,'position',[x0,y0,width,height])

t = tiledlayout(2,3);
nexttile;
depthIdx = abs(water_column_disc)==depthVec(2);
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax+0.2]);
m_pcolor(lon,lat, weakXi(:,:,depthIdx)); shading interp; hold on
clim([climTempVec(3) climTempVec(4)])
colormap(cmocean('balance'))
title('a)','FontSize',FS);
set(gca,'TitleHorizontalAlignment','left'); 

% Quiver
skip = 10;
uSurf = weakU(:,:,depthIdx);
vSurf = weakV(:,:,depthIdx);
lonQ = lon(:,1:skip:end);
latQ = lat(:,1:skip:end);
lon_rf = lonQ(end-5,:);
lonQ = lonQ(10:skip:end-10,:);
latQ = latQ(10:skip:end-10,:);
lat_rf = 40.1*ones(size(lat(1,1:skip:end)));
uSurf = uSurf(10:skip:end-10,1:skip:end);
vSurf = vSurf(10:skip:end-10,1:skip:end);

u_rf=zeros(1,size(uSurf,2));
v_rf=zeros(1,size(uSurf,2));
ylim([37.5 40.2])
u_rf(1,12)=0.5;

h = colorbar;
h.Label.String = "Relative Vorticity (\zeta/f)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;
m_quiver([lon_rf;lonQ],[lat_rf;latQ],[u_rf;uSurf],[v_rf;vSurf],2,'k');
m_text(lonMin+0.1,latMax+0.1,2.3,'Arrow scale: 0.5 m/s')
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');
ax = gca; 
ax.FontSize = FS; 


nexttile;
depthIdx = abs(water_column_disc)==depthVec(2);
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax+0.2]);
m_pcolor(lon,lat, transitionXi(:,:,depthIdx)); shading interp; hold on
% Quiver
skip = 10;
uSurf = transitionU(:,:,depthIdx);
vSurf = transitionV(:,:,depthIdx);
lonQ = lon(:,1:skip:end);
latQ = lat(:,1:skip:end);
lon_rf = lonQ(end-5,:);
lonQ = lonQ(10:skip:end-10,:);
latQ = latQ(10:skip:end-10,:);
lat_rf = 40.1*ones(size(lat(1,1:skip:end)));
uSurf = uSurf(10:skip:end-10,1:skip:end);
vSurf = vSurf(10:skip:end-10,1:skip:end);

u_rf=zeros(1,size(uSurf,2));
v_rf=zeros(1,size(uSurf,2));
u_rf(1,12)=0.5;
h = colorbar;
h.Label.String = "Relative Vorticity (\zeta/f)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;
m_quiver([lon_rf;lonQ],[lat_rf;latQ],[u_rf;uSurf],[v_rf;vSurf],2,'k');
m_text(lonMin+0.1,latMax+0.1,2.3,'Arrow scale: 0.5 m/s')

m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none')
clim([climTempVec(3) climTempVec(4)])
colormap(cmocean('balance'))
title('b)','FontSize',FS);set(gca,'TitleHorizontalAlignment','left'); 
ax = gca; 
ax.FontSize = FS; 

nexttile;
depthIdx = abs(water_column_disc)==depthVec(2);
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax+0.2]);
m_pcolor(lon,lat, strongXi(:,:,depthIdx)); shading interp; hold on
% Quiver
skip = 10;
uSurf = strongU(:,:,depthIdx);
vSurf = strongV(:,:,depthIdx);
lonQ = lon(:,1:skip:end);
latQ = lat(:,1:skip:end);
lon_rf = lonQ(end-5,:);
lonQ = lonQ(10:skip:end-10,:);
latQ = latQ(10:skip:end-10,:);
lat_rf = 40.1*ones(size(lat(1,1:skip:end)));
uSurf = uSurf(10:skip:end-10,1:skip:end);
vSurf = vSurf(10:skip:end-10,1:skip:end);
u_rf=zeros(1,size(uSurf,2));
v_rf=zeros(1,size(uSurf,2));
ylim([37.5 40.2])
u_rf(1,12)=0.5;

h = colorbar;
h.Label.String = "Relative Vorticity (\zeta/f)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;
m_quiver([lon_rf;lonQ],[lat_rf;latQ],[u_rf;uSurf],[v_rf;vSurf],2,'k');
m_text(lonMin+0.1,latMax+0.1,2.3,'Arrow scale: 0.5 m/s')
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none')

clim([climTempVec(3) climTempVec(4)])
colormap(cmocean('balance'))
title('c)','FontSize',FS);set(gca,'TitleHorizontalAlignment','left'); 
ax.FontSize = FS; 
h = colorbar;
h.Label.String = "Relative Vorticity (\xi/f)";
h.Label.FontSize = FS;
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
ax = gca; 
ax.FontSize = FS; 

weakuPrime =  weakU(:,:,depthIdx)-u_2800;
weakvPrime =  weakV(:,:,depthIdx)-v_2800;
weakEKE = 0.5*(weakuPrime.^2+weakvPrime.^2);

transitionuPrime =  transitionU(:,:,depthIdx)-u_2800;
transitionvPrime =  transitionV(:,:,depthIdx)-v_2800;
transitionEKE = 0.5*(transitionuPrime.^2+transitionvPrime.^2);

stronguPrime =  strongU(:,:,depthIdx)-u_2800;
strongvPrime =  strongV(:,:,depthIdx)-v_2800;
strongEKE = 0.5*(stronguPrime.^2+strongvPrime.^2);


nexttile;
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax]);
m_pcolor(lon,lat, weakEKE   ); shading interp; hold on
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');
clim([0 .05])
colormap(cmocean('balance'))
title('d)','FontSize',FS);
set(gca,'TitleHorizontalAlignment','left');
h = colorbar;
h.Label.String = "Eddy Kinetic Energy (m^2/s^2)";
h.Label.FontSize = FS;
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";

ax = gca; 
ax.FontSize = FS; 



nexttile;
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax]);
m_pcolor(lon,lat, transitionEKE); shading interp; hold on
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none')
clim([0 .05])
colormap(cmocean('balance'))
% xlabel('Longitude (\circ)','FontSize',FS);
% ylabel('Latitude (\circ)','FontSize',FS);  
title('e)','FontSize',FS);set(gca,'TitleHorizontalAlignment','left'); 
h = colorbar;
h.Label.String = "Eddy Kinetic Energy (m^2/s^2)";
h.Label.FontSize = FS;
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";

ax = gca; 
ax.FontSize = FS; 

nexttile;
depthIdx = abs(water_column_disc)==depthVec(2);
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax]);
m_pcolor(lon,lat, strongEKE); shading interp; hold on
m_plot(lonIDXLee, [lat(idxNorth,1) lat(idxNorth,1)],'LineWidth',2,'Color','k')
m_plot(lonIDXLee, [lat(idxSouth,1) lat(idxSouth,1)],'LineWidth',2,'Color','k')
m_plot([lon(1,idxEast) lon(1,idxEast)], [lat(idxNorth,1) lat(idxSouth,1)],'LineWidth',2,'Color','k')
m_plot([lon(1,idxWest) lon(1,idxWest)], [lat(idxNorth,1) lat(idxSouth,1)],'LineWidth',2,'Color','k')

m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none')

clim([0 .05])
colormap(cmocean('balance'))
% xlabel('Longitude (\circ)','FontSize',FS);
% ylabel('Latitude (\circ)','FontSize',FS);  
title('f)','FontSize',FS);set(gca,'TitleHorizontalAlignment','left'); 
ax.FontSize = FS; 
h = colorbar;
h.Label.String = "Eddy Kinetic Energy (m^2/s^2)";
h.Label.FontSize = FS;
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
ax = gca; 
ax.FontSize = FS; 



