clear variables
close all

water_column_disc = flip([0:5:100 110:10:1000 1025:25:5675]);
FS = 16;

%% Weak
load('weak1200_1536.mat')
weakVort = muXi; weakVortstd = sigmaXi;
weakW = muW;

%% Transition

load('weak300_636.mat')
transitionVort = muXi; transitionstd = sigmaXi;
transitionW = muW;

%% Strong
load('medium1000_1336.mat')
strongVort = strongXi;

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

%% 
depth = 1850;
depthidx = find(depth == water_column_disc);

strongVortStats = reshape(strongVort(:,:,:),[],size(strongVort,3)); 
strongVortStats = speedTransGen(strongVortStats,ii,size(strongVort,3));
vorticityStatsStrong = reshape(strongVortStats(:,depthidx:end),1,[]);

transitionVortStats = reshape(transitionVort(:,:,:),[],size(transitionVort,3)); 
transitionVortStats = speedTransGen(transitionVortStats,ii,size(transitionVort,3));
vorticityStatsTransition = reshape(transitionVortStats(:,depthidx:end),1,[]);

weakVortStats = reshape(weakVort(:,:,:),[],size(weakVort,3)); 
weakVortStats = speedTransGen(weakVortStats,ii,size(weakVort,3));
vorticityStatsWeak = reshape(weakVortStats(:,depthidx:end),1,[]);

%% 
depth = 1850;
depthidx = find(depth == water_column_disc);

strongWStats = reshape(strongW(:,:,:),[],size(strongW,3)); 
strongWStats = speedTransGen(strongWStats,ii,size(strongW,3));
WStatsStrong = reshape(strongWStats(:,depthidx:end),1,[]);

transitionWStats = reshape(transitionW(:,:,:),[],size(transitionW,3)); 
transitionWStats = speedTransGen(transitionWStats,ii,size(transitionW,3));
WStatsTransition = reshape(transitionWStats(:,depthidx:end),1,[]);

weakWStats = reshape(weakW(:,:,:),[],size(weakW,3)); 
weakWStats = speedTransGen(weakWStats,ii,size(weakW,3));
WStatsWeak = reshape(weakWStats(:,depthidx:end),1,[]);


% %% Stats
% strongStats = load("medium1000_7dayStats.mat");
% wStrong = strongStats.muW;
% wStrongExtract = wStrong(82:160,120:275,:);
% wStrongStats1 = (reshape(wStrongExtract(:,:,depthidx:end),1,[]))*86400;
% 
% weakStats = load("weak200_7dayStats.mat");
% wWeak = weakStats.muW;
% wWeakExtract = wWeak(82:160,120:275,:);
% wWeakStats1 = (reshape(wWeakExtract(:,:,depthidx:end),1,[]))*86400;

%% Plotting
% Vertical Velocity
[fStrongW,xiStrongW,bw] = ksdensity(WStatsStrong);
[fTransitionW,xiTransitionW,bw] = ksdensity(WStatsTransition);
[fweakW,xiweakW,bw] = ksdensity(WStatsWeak);

%Vorticity
[fStrongVort,xiStrongVort,bw] = ksdensity(vorticityStatsStrong);
[fTransitionVort,xiTransitionVort,bw] = ksdensity(vorticityStatsTransition);
[fweakVort,xiweakVort,bw] = ksdensity(vorticityStatsWeak);

fig1 = figure(1);
x0=10;
y0=10;
width=950;
height=600;
set(gcf,'position',[x0,y0,width,height])
tiledlayout(1,2)
nexttile();
plot(xiweakVort,fweakVort,'b','LineWidth',2); hold on
plot(xiTransitionVort,fTransitionVort,'k','LineWidth',2)
plot(xiStrongVort,fStrongVort,'r','LineWidth',2);
grid minor
ylabel('PDF','FontSize',16)
xlabel('Relative Vorticity(ξ/f)','FontSize',16)
title('a)','FontSize',16);
set(gca,'TitleHorizontalAlignment','left'); 
ax = gca; 
ax.FontSize = FS; 

xlim([-1.25 1.25])
ylim([10^-4 10^1])
set(gca,'YScale','log')

nexttile();
plot(xiweakW,fweakW,'b','LineWidth',2); hold on
plot(xiTransitionW,fTransitionW,'k','LineWidth',2)
plot(xiStrongW,fStrongW,'r','LineWidth',2);

ylabel('PDF','FontSize',16)
xlabel('w (m/s)','FontSize',16)
title('b)','FontSize',16)
set(gca,'TitleHorizontalAlignment','left'); 
ax = gca; 
ax.FontSize = FS; 

legend('Weak','Transition','Strong','Fontsize',12)
xlim([-0.015 0.015])
ylim([10^-1 10^4])
set(gca,'YScale','log')
grid minor







