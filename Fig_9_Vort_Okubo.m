clear all

%% NC File
NumLayers = 100; type = 'r'; coef = 1; gname = 'grd.nc';  
dirHR = [];
gridfile = [dirHR gname];
%tindex = 1;
time = 1100;
fname   = sprintf('NESM1km_avg.%05d.nc',time); hisfile = [dirHR fname];
lon     = pagetranspose(ncread(gridfile,'lon_rho'));
lat     = pagetranspose(ncread(gridfile,'lat_rho'));
Omega   = 7.2921e-5;  % Earth's angular velocity in rad/s
f       = 2*Omega*sin(deg2rad(mean(lat(:,1))));

load('WaterColumnMat')

%% EKE Stats
load('uv_2800.mat')

%% Load Grid Data and assign variables
% Get Depth
tindex = 1;
[zr]=get_depths(fname,gname,tindex,type);     
zr = shiftdim(zr,1);    
bathy = zr(:,:,1); bathy = reshape(bathy,[300*278*1,1]);

%%
for vlevel = 1:NumLayers
 [~,~,~,lambda2(:,:,vlevel)]=get_okubo(hisfile,gridfile,tindex,vlevel,coef);
 [~,~,~,xi(:,:,vlevel)]=get_vort(hisfile,gridfile,tindex,vlevel,coef);
end

water_column_disc = flip([0:5:100 110:10:1000 1025:25:5675]); %New WaterColumn
%Normalize by coriolis 
xi = xi./f;
%Interpolate onto regular grid for plotting
[lambda2] = parameterInterpOW(lambda2, zr, water_column);
[xi] = parameterInterpOW(xi, zr, water_column);
%%
lonMax = max(max(lon));
lonMin = -64;
latMin = 38;
latMax = 39.5;
FS = 20;
fig1 = figure(1);
x0=10;
y0=10;
width=1200;
height=500;
set(gcf,'position',[x0,y0,width,height])
tcl = tiledlayout(1,2,'TileSpacing','compact');

a = nexttile;
depth = 2800;
depthIdx = abs(water_column_disc)==depth;
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax]);
m_pcolor(lon,lat, xi(:,:,depth == water_column_disc)); shading interp; hold on

clim([-0.5 0.5])
colormap(cmocean('balance'))
title('Vorticity (\xi/f)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','center'); 
title('a)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
h = colorbar;
h.Label.String = "Relative Vorticity (\xi/f)";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
ax = gca; 
ax.FontSize = FS; 

b = nexttile;
m_proj('miller','lon',[lonMin lonMax],'lat',[latMin latMax]);
m_pcolor(lon,lat, lambda2(:,:,depth == water_column_disc)); shading interp; hold on
colorbar;
clim([-0.5e-8 0.5e-8])
colormap(cmocean('balance'))
title('OW Parameter (W)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','center'); 
title('b)','Fontsize',FS);set(gca,'TitleHorizontalAlignment','left'); 
m_grid('box','fancy','tickdir','out','fontsize',FS,'linestyle','none');colorbar;
h = colorbar;
h.Label.String = "Okubo-Weiss (s^{-1})";
h.Label.Rotation = 270;
h.Label.VerticalAlignment = "bottom";
h.Label.FontSize = FS;
ax = gca; 
ax.FontSize = FS; 
