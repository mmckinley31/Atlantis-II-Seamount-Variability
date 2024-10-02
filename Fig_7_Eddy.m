clear all
FS = 16;

%% NC File
NumLayers = 100; type = 'r'; coef = 1; gname = 'grd.nc';  
month =' Weak'; 
tindex = 1;
%dirHR = 'C:\Users\mmckinley31\GaTech Dropbox\CoS-EXT\EAS-Ext\EAS-Bracco-TEAM-Ext\NESM\NESM Weak and Transition\';
dirHR = [];
gridfile = [dirHR gname];
time = 500;
fname   = sprintf('Transition_NESM1km_avg.%05d.nc',time); hisfile = [dirHR fname];
lon     = pagetranspose(ncread(gridfile,'lon_rho'));
lat     = pagetranspose(ncread(gridfile,'lat_rho'));
temp    = pagetranspose(ncread([dirHR fname],'temp'));
salt    = pagetranspose(ncread([dirHR fname],'salt'));
rho     = gsw_sigma2(salt,temp);
w   = pagetranspose(ncread([dirHR fname],'w'));
for vlevel = 1:NumLayers
 [~,~,~,xi(:,:,vlevel)]=get_vort(hisfile,gridfile,tindex,vlevel,coef);
 [lat,lon,mask,spd(:,:,vlevel),u_rho(:,:,vlevel),v_rho(:,:,vlevel)]=get_speed(hisfile,gridfile,tindex,vlevel,coef);
end

%Calculate Coriolis Frequency
Omega   = 7.2921e-5;  % Earth's angular velocity in rad/s
f       = 2*Omega*sin(deg2rad(mean(lat(:,1))));

%Normalize by coriolis
xi = xi./f;


%% Load Grid Data and assign variables

% Calculate Depth
tindex = 1;
[zr]=get_depths([dirHR fname],gname,tindex,type);     
zr = shiftdim(zr,1);    
bathy = zr(:,:,1); bathy = reshape(bathy,[300*278*1,1]);
water_column_disc = -flip([0:5:100 110:10:1000 1025:25:5675]); %New WaterColumn
load('WaterColumnMat')

%Bathymetry
bathy = reshape(bathy,[278 300]);


%Interp onto regular grid for plotting
[transitionVorticity] = parameterInterpOW(xi, zr, water_column);
[transitionW] = parameterInterpOW(w, zr, water_column);
[transitionSpeed] = parameterInterpOW(spd, zr, water_column);
[transitionU] = parameterInterpOW(u_rho, zr, water_column);

[transitionV] = parameterInterpOW(v_rho, zr, water_column);
[transitionRHO] = parameterInterpOW(rho, zr, water_column);


%% Plot Transects of Vertical Velocity overlayed with isopycnals
eddySliceIdx = 146;
eddySliceW = squeeze(transitionW(eddySliceIdx,:,:))*3600;
eddySliceDensity = squeeze(transitionRHO(eddySliceIdx,:,:));

%% Plot Transects


lonIDX = [-63.5 -62];

[~,idxWest] = min(abs(lon(1,:)-(lonIDX(1)))); [~,idxEast] = min(abs(lon(1,:)-(lonIDX(2))));

lonRange =lon(1,idxWest:idxEast);
eddySliceSpeed = squeeze(transitionV(eddySliceIdx,idxWest:idxEast,:));
eddySliceVorticity = squeeze(transitionVorticity(eddySliceIdx,idxWest:idxEast,:));

[ARCLEN, AZ] = distance(lat(eddySliceIdx,1),lonRange(1),lat(eddySliceIdx,1),lonRange(end));

range = linspace(0,deg2km(ARCLEN),length(lonRange));

latMin = min(min(lat)); latMax = max(max(lat));
lonMin = min(min(lon)); lonMax = max(max(lon));

%% Vorticity with Velocity Verctor Field
fig1 = figure(1);
x0=10;
y0=10;
width=1100;
height=750;
set(gcf,'position',[x0,y0,width,height])
tcl = tiledlayout(2,2,'TileSpacing','tight');a = nexttile;
depthVec = 2800;
depth = depthVec(1);
depthIdx = abs(water_column_disc)==depth;
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax+0.2]);
m_pcolor(lon,lat, transitionVorticity(:,:,depthIdx)); shading interp; hold on
colorbar;
clim([-0.5 0.5])
colormap(cmocean('balance'))
title('a)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 

% Quiver
skip = 10;
uSurf = transitionU(:,:,depthIdx);
vSurf = transitionV(:,:,depthIdx);

lonQ = lon(:,1:skip:end);
latQ = lat(:,1:skip:end);
lon_rf = lonQ(end-5,:);
% lat_rf = latQ(end-5,:);
lonQ = lonQ(10:skip:end-10,:);
latQ = latQ(10:skip:end-10,:);
lat_rf = 40.1*ones(size(lat(1,1:skip:end)));
uSurf = uSurf(10:skip:end-10,1:skip:end);
vSurf = vSurf(10:skip:end-10,1:skip:end);

u_rf=zeros(1,size(uSurf,2));
v_rf=zeros(1,size(uSurf,2));
ylim([37.5 40.2])

u_rf(1,15)=0.5;

h = colorbar;
h.Label.String = "Relative Vorticity (\zeta/f)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;
m_quiver([lon_rf;lonQ],[lat_rf;latQ],[u_rf;uSurf],[v_rf;vSurf],2,'k');
text(-65,40.1,'0.5 m/s')
ax = gca; 
ax.FontSize = 16; 
m_text(lonMin+0.1,latMax+0.1,2.3,'Arrow scale: 0.5 m/s')

m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');

b = nexttile;
depth = 2800;
depthIdx = abs(water_column_disc)==depth;
var = (transitionRHO(:,:,depthIdx));
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax]);
m_pcolor(lon,lat,var); shading interp; hold on

m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
colormap(b,cmocean('dense'));
% xlabel('Longitude (\circ)','FontSize',16);
% ylabel('Latitude (\circ)','FontSize',16);  
title(['\sigma_2 at ' sprintf('%gm',depth)]);
title('b)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
m_plot([lon(1,idxWest) lon(1,idxEast)], [lat(eddySliceIdx,1) lat(eddySliceIdx,1)],'LineWidth',2,'Color','k')
h = colorbar;
h.Label.String = "\sigma_2 (kg/m^3)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;
ax = gca; 
ax.FontSize = 16; 

c = nexttile;
pcolor(range,-water_column_disc,fliplr(rot90(eddySliceSpeed,3)));shading interp; 
colormap(c,cmocean('balance','pivot',0));
clim([-.5 .5])
hold on;
set(gca,"YDir",'reverse')
title('v(m/s) with Isopycnals');
title('c)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
xlabel('Range (km)','FontSize',16)
h = colorbar;
h.Label.String = "v (m/s)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;
ylabel('Depth (m)','FontSize',16)
ax = gca; 
ax.FontSize = 16; 
xticks([0 25 50 75 100 125])


d = nexttile;
pcolor(range,-water_column_disc,fliplr(rot90(eddySliceVorticity,3)));shading interp; 
colormap(d,cmocean('balance','pivot',0));
clim([-.5 .5])
hold on;
set(gca,"YDir",'reverse')
title('d)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
xlabel('Range (km)','FontSize',16)
x = [0.6695 0.66];
y = [0.68 0.73];
h = colorbar;
h.Label.String = "Vorticity (\zeta/f)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = 16;
ylabel('Depth (m)','FontSize',16)
ax = gca; 
ax.FontSize = 16; 
xticks([0 25 50 75 100 125])

