
%%
clear all
close all

FS = 16;
load('NESMgrd.mat')
lat = grdNESM.Bathymetry.lat;
lon = grdNESM.Bathymetry.lon;

load('medium1100.mat')
strongCT = muCT; %strongCTstd = sigmaCT;
strongSA = muSA; %strongSAstd = sigmaSA;
strongSpeed = muSpeed; %strongSpeedstd = sigmaSpeed;
strongVort = muXi; %strongVortstd = sigmaXi;
strongW = muW; %strongWstd = sigmaW;
strongSSP = muSSP; %strongSSPstd = sigmaSSP;
strongRho = muRHO; %strongRHOstd = sigmaRHO;

water_column_disc = -flip([0:5:100 110:10:1000 1025:25:5675]); %New WaterColumn
pressure = gsw_p_from_z(flip(water_column_disc),lat(150,150));

%% Stats Area
boxTop = 135;
boxBot = 85; row = boxBot:boxTop;
boxLeft = 165;
boxRight = 180; col = boxLeft:boxRight;
[m,n] = size(muXi(:,:,1));
count = 1;
for j = row
ii(count,:) = sub2ind([m,n],j*ones(size(col)),col);
count = count + 1;
end
ii = reshape(ii,[1,size(ii,1)*size(ii,2)]);

%% Plot Transects of Vertical Velocity overlayed with isopycnals
upperSliceIdx = 139;
lowerSliceIdx = 109;
centerSliceIdx = 116;
% Check Slice
LatProfile = 38.5;
[ ~, ProfileIdx ] = min( abs( lat(:,99)-LatProfile ) );
singleSSPProfile = squeeze(muV(ProfileIdx,:,:));


%% Plot Transects

westernSliceIdx = 165;

latLimits = 57:168;
%latLimits = 25:200;

latMinimum = lat(57,1);
latMaximum = lat(168,1);


%Vorticity 
VortwesternSlice = squeeze(strongVort(latLimits,westernSliceIdx,:));
[ARCLEN,~] = distance(lat(latLimits(1),1),lon(1,westernSliceIdx),lat(latLimits(end),1),lon(1,westernSliceIdx));
rangeEW = linspace(0,deg2km(ARCLEN),length(latLimits));

% Vertical Velocity
lonIDX = [-64 -62];% [lat(eddySliceIdx,1) lat(eddySliceIdx,1)]
[~,idxWest] = min(abs(lon(1,:)-(lonIDX(1)))); [~,idxEast] = min(abs(lon(1,:)-(lonIDX(2))));
lonRange =lon(1,idxWest:idxEast);
lowerSlice = squeeze(muW(lowerSliceIdx,idxWest:idxEast,:))*3600;
lowerSliceDensity = squeeze(muRHO(lowerSliceIdx,idxWest:idxEast,:));
[ARCLEN, ~] = distance(lat(lowerSliceIdx,1),lonRange(1),lat(lowerSliceIdx,1),lonRange(end));
range = linspace(0,deg2km(ARCLEN),length(lonRange));
latMin = min(min(lat)); latMax = max(max(lat));
lonMin = min(min(lon)); lonMax = max(max(lon));

%%
fig1 = figure(1);
x0=10;
y0=10;
width=1250;
height=750;
set(gcf,'position',[x0,y0,width,height])
tiledlayout(2,2,"TileSpacing","tight");

a = nexttile;
depth = 2800;
depthIdx = abs(water_column_disc)==depth;
m_proj('miller','lon',lonIDX,'lat',[38 latMaximum+0.13]);
m_pcolor(lon(57:170,idxWest:idxEast),lat(57:170,idxWest:idxEast),muSpeed(57:170,idxWest:idxEast,depthIdx)); shading interp; hold on
colorbar;
clim([0 0.6])
colormap(a,cmocean('dense'))
title('a)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 

% Quiver
skip = 10;
uSurf = muU(57:180,idxWest:idxEast,depthIdx);
vSurf = muV(57:180,idxWest:idxEast,depthIdx);
lonS = lon(57:180,idxWest:idxEast);
latS = lat(57:180,idxWest:idxEast);
lonQ = lonS(:,1:skip:end);
latQ = latS(:,1:skip:end);
lon_rf = lonQ(end-5,:);
lat_rf = latQ(end-5,:);
lonQ = lonQ(10:skip:end-10,:);
latQ = latQ(10:skip:end-10,:);
uSurf = uSurf(10:skip:end-10,1:skip:end);
vSurf = vSurf(10:skip:end-10,1:skip:end);

u_rf=zeros(1,size(uSurf,2));
v_rf=zeros(1,size(uSurf,2));

u_rf(1,7)=0.5;
m_quiver([lon_rf;lonQ],[lat_rf;latQ],[u_rf;uSurf],[v_rf;vSurf],2,'k');
m_text(lonIDX(1)+0.055,latMaximum+0.075,2.3,'Arrow scale: 0.5 m/s')

m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
h = colorbar;
h.Label.String = "Current (m/s)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;

ax = gca; 
ax.FontSize = FS; 

b = nexttile;
depthIdx = abs(water_column_disc)==depth;
var = (muRHO(:,:,depthIdx));
m_proj('miller','lon',lonIDX,'lat',[38 latMaximum]);
m_pcolor(lon,lat,var); shading interp; hold on
colorbar;
colormap(b,cmocean('dense'));
title(['\sigma_2 at ' sprintf('%gm',depth)]);
title('b)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
%m_plot(lon(1,westernSliceIdx)*ones(length(latLimits),1),lat(latLimits,1),"LineWidth",2,'Color','k')
m_plot(lonRange,lat(lowerSliceIdx,1)*ones(length(lonRange),1),"LineWidth",2,'Color','k');
m_plot(lon(1,westernSliceIdx)*ones(length(rangeEW),1),lat(latLimits,1),"LineWidth",2,'Color','k');

ax = gca; 
ax.FontSize = FS; 
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
h = colorbar;
h.Label.String = "\sigma_2 (kg/m^3)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;

c = nexttile;
pcolor(range,-water_column_disc,fliplr(rot90(lowerSlice,3)));shading interp; 
colormap(c,cmocean('balance','pivot',0));
clim([-35 35]);
hold on;
contour(range,-water_column_disc,fliplr(rot90(lowerSliceDensity,3)),36.82:.005:39,'Show','off','color','k');
ylim([1500 5000])
set(gca,"YDir",'reverse')
title('w(m/hr) with Isopycnals');
title('c)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
xlabel('Range (km)','Fontsize',FS)
h = colorbar;
h.Label.String = "w (m/hr)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
ylabel('Depth (m)','Fontsize',FS);
xticks([0 25 50 75 100 125 150])
ax = gca; 
ax.FontSize = FS; 

d = nexttile;
pcolor(rangeEW,-water_column_disc,fliplr(rot90(VortwesternSlice,3)));shading interp; hold on; clim([-1 1]); 
colormap(d,cmocean('balance','pivot',0)) 
title('Relative Vorticty(\zeta/f)');
title('d)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
xlabel('Range (km)','Fontsize',FS)
set(gca,"YDir",'reverse')
ylabel('Depth (m)','Fontsize',FS);
h = colorbar;
h.Label.String = "Relative Vorticty(\zeta/f)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
ylabel('Depth (m)','Fontsize',FS);
ax = gca; 
ax.FontSize = FS; 
xticks([0 25 50 75 100 125])

%% Lee Wave

lonIDXLee = [-63.5 -63];% [lat(eddySliceIdx,1) lat(eddySliceIdx,1)]
[~,idxWest] = min(abs(lon(1,:)-(lonIDXLee(1)))); [~,idxEast] = min(abs(lon(1,:)-(lonIDXLee(2))));
lonRange =lon(1,idxWest:idxEast);

centerSlice = squeeze(muW(centerSliceIdx,idxWest:idxEast,:))*3600;

centerSliceDensity = squeeze(muRHO(centerSliceIdx,idxWest:idxEast,:));
[ARCLEN, ~] = distance(lat(lowerSliceIdx,1),lonRange(1),lat(lowerSliceIdx,1),lonRange(end));

LeeRange = linspace(0,deg2km(ARCLEN),length(lonRange));



lonIDXLee = [-63.5 -62.5];% [lat(eddySliceIdx,1) lat(eddySliceIdx,1)]
[~,idxWest] = min(abs(lon(1,:)-(lonIDXLee(1)))); [~,idxEast] = min(abs(lon(1,:)-(lonIDXLee(2))));

lonRange =lon(1,idxWest:idxEast);

upperSlice = squeeze(muW(upperSliceIdx,idxWest:idxEast,:))*3600;

upperSliceDensity = squeeze(muRHO(upperSliceIdx,idxWest:idxEast,:));
[ARCLEN, AZ] = distance(lat(lowerSliceIdx,1),lonRange(1),lat(lowerSliceIdx,1),lonRange(end));

UpperLeeRange = linspace(0,deg2km(ARCLEN),length(lonRange));



%%

fig2 = figure(2);
x0=10;
y0=10;
height = 950;
set(gcf,'position',[x0,y0,width,height])
tcl = tiledlayout(2,2,'TileSpacing','tight');

a = nexttile;
depthIdx = abs(water_column_disc)==depth;
var = (muW(:,:,depthIdx))*3600;
m_proj('miller','lon',lonIDX,'lat',[38 latMaximum]);
m_pcolor(lon,lat,var); shading interp; hold on

clim([-35 35])
colormap(a,cmocean('balance','pivot',0));

m_plot([-63.5 -63], [lat(centerSliceIdx,1) lat(centerSliceIdx,1)],'LineWidth',2,'Color','k')
title('a)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
ax = gca; 
ax.FontSize = FS; 
h = colorbar;
h.Label.String = "w (m/hr)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
b = nexttile;
depthIdx = abs(water_column_disc)==depth;
var = (muSpeed(:,:,depthIdx));
m_proj('miller','lon',lonIDX,'lat',[38 latMaximum]);
m_pcolor(lon,lat,var); shading interp; hold on

clim([0 0.5])
m_plot([-64 -62.5], [lat(upperSliceIdx,1) lat(upperSliceIdx,1)],'LineWidth',2,'Color','k')
colormap(b,cmocean('dense'));
title('b)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
h = colorbar;
h.Label.String = "Current (m/s)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
ax = gca; 
ax.FontSize = FS; 

c = nexttile;
pcolor(LeeRange,-water_column_disc,fliplr(rot90(centerSlice,3)));shading interp; 
hold on;
contour(LeeRange,-water_column_disc,fliplr(rot90(centerSliceDensity,3)),27,'Show','off','color','k');
clim(c,[-35 35])
colormap(c,cmocean('balance','pivot',0));

ylim([0 1800])
set(gca,"YDir",'reverse')
title('c)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
xlabel('Range (km)','FontSize',FS)
h = colorbar;
h.Label.String = "w (m/hr)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
ylabel('Depth(m)','FontSize',FS)
ax = gca; 
ax.FontSize = FS; 

d = nexttile;
pcolor(UpperLeeRange,-water_column_disc,fliplr(rot90(upperSlice,3)));shading interp; 
clim([-35 35])
colormap(d,cmocean('balance','pivot',0));
hold on;
contour(UpperLeeRange,-water_column_disc,fliplr(rot90(upperSliceDensity,3)),[35:0.2:36.8 36.85:.01:36.91],'Show','off','color','k');
ylim([0 5000])
set(gca,"YDir",'reverse')
title('d)','Fontsize',FS,'HorizontalAlignment','center');set(gca,'TitleHorizontalAlignment','left'); 
xlabel('Range (km)','FontSize',FS)
x = [0.6695 0.66];
y = [0.68 0.73];
h = colorbar;
h.Label.String = "w (m/hr)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
ylabel('Depth(m)','FontSize',FS)
ax = gca; 
ax.FontSize = FS; 

