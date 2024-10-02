%%
clear all
close all
%Set Fontsize
FS = 16;

% Load and assign weak and strong variables
load('NESMgrd.mat')
lon = grdNESM.Bathymetry.lon;
lat = grdNESM.Bathymetry.lat;

%% Weak
load('weak1200_1536.mat')
weakCT = muCT; weakCTstd = sigmaCT;
weakSA = muSA; weakSAstd = sigmaSA;
weakSpeed = muSpeed; weakSpeedstd = sigmaSpeed;
weakVort = muXi; weakVortstd = sigmaXi;
weakW = abs(muW)*86400; weakWstd = sigmaW;
weakSSP = muSSP; weakSSPstd = sigmaSSP;
weakRho = muRHO; weakRHOstf = sigmaRHO;

%% Transition
load('weak300_636.mat')
transitionCT = muCT; transitionCTstd = transitionCT;
transitionSA = muSA; transitionSAstd = sigmaSA;
transitionSpeed = muSpeed; transitionSpeedstd = sigmaSpeed;
transitionVort = muXi; transitionstd = sigmaXi;
transitionW = abs(muW)*86400; transitionWstd = sigmaW;
transitionSSP = muSSP; transitionSSPstd = sigmaSSP;
transitionRho = muRHO; transitionRHOstd = sigmaRHO;

%% Strong
load('medium1000_1336.mat')
strongW = abs(strongW)*86400; 

%%
%Load mean currents and vertical velocity
load('mean_spd_w_avg_20181213_20220824.mat')
% Vertical velocity deep
load('w_mean_deep.mat')
% Load wake indices
load('spd_meanWake.mat')
load('C:\Users\mmckinley31\GaTech Dropbox\GT-mmckinley31\Big Data\wakeIdx.mat')


water_column_disc = -flip([0:5:100 110:10:1000 1025:25:5675]); %New WaterColumn
%% Stats Area
boxTop = 135;
boxBot = 85; row = boxBot:boxTop;
boxLeft = 125;
boxRight = 180; col = boxLeft:boxRight;
[m,n] = size(muXi(:,:,1));
count = 1;
for j = row
ii(count,:) = sub2ind([m,n],j*ones(size(col)),col);
count = count + 1;
end
ii = reshape(ii,[1,size(ii,1)*size(ii,2)]);

%% Run Stats

strongSpeedStats = reshape(strongSpeed(:,:,:),[],size(strongSpeed,3)); 
strongSpeedStats = speedTransGen(strongSpeedStats,ii,size(strongSSP,3));
strongSpeedmean = mean(strongSpeedStats,1,"omitnan");
strongSpeedstd  = std(strongSpeedStats,1,"omitnan");
strongSpeedrange = range(strongSpeedStats);

transitionSpeedStats = reshape(transitionSpeed(:,:,:),[],size(weakSSP,3)); 
transitionSpeedStats = speedTransGen(transitionSpeedStats,ii,size(weakSSP,3));
transitionSpeedmean = mean(transitionSpeedStats,1,"omitnan");
transitionSpeedstd  = std(transitionSpeedStats,1,"omitnan");
transitionSpeedrange = range(transitionSpeedStats);

weakSpeedStats = reshape(weakSpeed(:,:,:),[],size(weakSSP,3)); 
weakSpeedStats = speedTransGen(weakSpeedStats,ii,size(weakSSP,3));
weakSpeedmean = mean(weakSpeedStats,1,"omitnan");
weakSpeedstd  = std(weakSpeedStats,1,"omitnan");
weakSpeedrange = range(weakSpeedStats);


%% Plotting

%figure;
curve1 = strongSpeedmean + strongSpeedstd;
curve2 = strongSpeedmean - strongSpeedstd;
curve3 = weakSpeedmean + weakSpeedstd;
curve4 = weakSpeedmean - weakSpeedstd;
curve5 = transitionSpeedmean + transitionSpeedstd;
curve6 = transitionSpeedmean - transitionSpeedstd;

waterColumnStrong = abs(water_column_disc(isfinite(strongSpeedstd)));
waterColumnTransition = abs(water_column_disc(isfinite(transitionSpeedstd)));
waterColumnWeak = abs(water_column_disc(isfinite(weakSpeedstd)));

x12 = [waterColumnStrong, fliplr(waterColumnStrong)];
x34 = [waterColumnWeak, fliplr(waterColumnWeak)];
x56 = [waterColumnTransition, fliplr(waterColumnTransition)];

inBetween12 = [curve1(isfinite(curve1)'), fliplr(curve2(isfinite(curve2)'))];
inBetween34 = [curve3(isfinite(curve3)'), fliplr(curve4(isfinite(curve3)'))];
inBetween56 = [curve5(isfinite(curve5)'), fliplr(curve6(isfinite(curve6)'))];

%% Plot CDF of Mean surface velocity

[f1,x1,up,low]=ecdf(spd_mean,'Bounds','on','function','survivor','Alpha',0.05);
idx = ~isnan(up) & ~isnan(low);
figure;
set(gcf,'Position',[100 100 1050 800])
tiledlayout(2,2); nexttile;
plot(x1(idx), f1(idx), '-k','LineWidth',2)
hold on
patch([x1(idx); flipud(x1(idx))], [up(idx); flipud(low(idx))], 'k', 'FaceAlpha',0.25, 'EdgeColor','none')
hold off
grid minor
legend('CDF', '95% CI', 'Location','NE','Fontsize',16)
title('a)','FontSize',16);set(gca,'TitleHorizontalAlignment','left'); 
ylabel('CDF','FontSize',16)
xlabel('Mean Surface Velocity (m/s)','FontSize',16)
ax = gca; 
ax.FontSize = 16; 

nexttile;
plot(weakSpeedmean(isfinite(weakSpeedmean)),waterColumnWeak,'LineWidth',2,'Color','b');% set(gca,"Ydir",'reverse')
hold on
plot(transitionSpeedmean(isfinite(transitionSpeedmean)),waterColumnTransition,'LineWidth',2,'Color','k');% set(gca,"Ydir",'reverse')
plot(strongSpeedmean(isfinite(strongSpeedmean)),waterColumnStrong,'LineWidth',2,'Color','r');

fill(inBetween12,x12, 'r','FaceAlpha',0.3);
fill(inBetween34,x34, 'b','FaceAlpha',0.3);
fill(inBetween56,x56, 'k','FaceAlpha',0.3);
legend('Weak','Transition','Strong','','','','Location','east','Fontsize',16)
set(gca,"Ydir",'reverse')
title('b)','FontSize',16);set(gca,'TitleHorizontalAlignment','left'); 

xlabel('Current Speed (m/s)','FontSize',16)
ylabel('Depth(m)','FontSize',16)
ylim([0 4500])
grid minor
ax = gca; 
ax.FontSize = 16; 

% plot time series
nexttile([1 2]);
yyaxis('left')
plot(tnum(18:end),w_mean(18:end),'LineWidth',1.5); hold on
plot(tnum(18:end),w_mean_bottom(18:end),'LineWidth',1.5,'Color','k','LineStyle','-')
datetick('x', 'mmmyy',"keepticks")
xlim([tnum(18) 738758])
xlim([tnum(18) 738758])
ylim([0 0.03])
ylabel('Mean Vertical Velocity (m/s)','FontSize',16)

yyaxis("right")
plot(tnum(18:end),spd_mean(18:end),'LineWidth',1.5); hold on
plot(tnum(wakeIdx),spd_mean(wakeIdx),'*','Color','k')
plot(tnum(158:161),spd_mean(158:161),'*','Color','k')
ylim([0 1.6])
ax = gca; 
ax.FontSize = 16; 
ylabel('Mean Surface Velocity (m/s)','FontSize',16)
%title('Mean Surface Velocity in Region around Atlantis II')
title('c)','FontSize',16);set(gca,'TitleHorizontalAlignment','left'); 
grid minor

%Weak Month
start = 73;
x = [tnum(start) tnum(start+4) tnum(start+4) tnum(start+4) tnum(start)];
y = [0 0 0.0 2.5 2.5];
patch(x,y,'b','FaceAlpha',0.3)

%Transition Month
start = 68
x = [tnum(start) tnum(start+4) tnum(start+4) tnum(start+4) tnum(start)];
y = [0 0 0.0 2.5 2.5];
patch(x,y,'k','FaceAlpha',0.3)

%High Month
start = 158;
x = [tnum(start) tnum(start+4) tnum(start+4) tnum(start+4) tnum(start)];
y = [0 0 0.0 2.5 2.5];
patch(x,y,'r','FaceAlpha',0.3)
%legend('','Weak','Transition','Strong','Location','east')



