
%load('figs14_15_particleData.mat')
%%
figure;
x0=10;
y0=10;
width=3*450;
height=450;
set(gcf,'position',[x0,y0,width,height])
grayColor = [.7 .7 .7];

tiledlayout(1,3)
nexttile()
scatter(initDensityWeak,finalDensityWeak,[],pdfWeak,"filled"); hold on
colormap(flip(cmocean('deep')))
ylim([36.6 36.95]); xlim([36.6 36.95])
plot([36.6 36.95],[36.6 36.95],'color','k','linewidth',1.5)
title('a)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
xlabel('\sigma_2 Initial','Fontsize',16)
ylabel('\sigma_2 Final','Fontsize',16)
clim([0.3925 0.3985])
ax = gca; 
ax.FontSize = FS; 
grid minor

nexttile()
scatter(initDensityTransition,finalDensityTransition,[],pdfTransition,"filled"); hold on
ylim([36.6 36.95]); xlim([36.6 36.95])
plot([36.6 36.95],[36.6 36.95],'color','k','linewidth',1.5)
xlabel('\sigma_2 Initial','Fontsize',16)
ylabel('\sigma_2 Final','Fontsize',16)
clim([0.3925 0.3985])
title('b)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
ax = gca; 
ax.FontSize = FS; 
grid minor
nexttile()
scatter(initDensityStrong,finalDensityStrong,[],pdfStrong,"filled"); hold on
title('c)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
grid minor
ylim([36.6 36.95]); xlim([36.6 36.95])
plot([36.6 36.95],[36.6 36.95],'color','k','linewidth',1.5)
%annotation('doublearrow',[0.15 0.3],[0.25 0.15])
xlabel('\sigma_2 Initial','Fontsize',16)
ylabel('\sigma_2 Final','Fontsize',16)
clim([0.3925 0.3985])
text(0.018,0.07,'Denser')
text(0.075,0.01,'Lighter')
colorbar
ax = gca; 
ax.FontSize = FS; 

%%
figure;
x0=10;
y0=10;
width=900;
height=650;
set(gcf,'position',[x0,y0,width,height])
StrongVerticalDispersion_Plot = mean(verticalDispersion_MeanStrong,2,"omitnan");
StrongVerticalDispersion_STD = std(verticalDispersion_MeanStrong,[],2,"omitnan");

WeakVerticalDispersion_Plot = mean(verticalDispersion_MeanWeak,2,"omitnan");
WeakVerticalDispersion_STD = std(verticalDispersion_MeanWeak,[],2,"omitnan");

MedVerticalDispersion_Plot = mean(verticalDispersion_MeanTransition,2,"omitnan");
MedVerticalDispersion_STD = std(verticalDispersion_MeanTransition,[],2,"omitnan");
%
numSkipStrong = 12;
numSkipWeak = numSkipStrong/4;
subplot(1,2,1)
loglog(weakTimeVec,WeakVerticalDispersion_Plot,'b','LineWidth',2); hold on
loglog(medTimeVec,MedVerticalDispersion_Plot,'k','LineWidth',2); hold on
loglog(strongTimeVec(5:end),StrongVerticalDispersion_Plot(5:end),'r','LineWidth',2); hold on
errorbar(weakTimeVec(1:numSkipWeak:end),WeakVerticalDispersion_Plot(1:numSkipWeak:end),WeakVerticalDispersion_STD(1:numSkipWeak:end),'LineStyle','none','Color','b')
errorbar(strongTimeVec(1:numSkipStrong:end),StrongVerticalDispersion_Plot(1:numSkipStrong:end),StrongVerticalDispersion_STD(1:numSkipStrong:end),'LineStyle','none','Color','r')
errorbar(medTimeVec(1:numSkipWeak:end),MedVerticalDispersion_Plot(1:numSkipWeak:end),MedVerticalDispersion_STD(1:numSkipWeak:end),'LineStyle','none','Color','k')
xlim([0 6])
xlabel('Time(Days)','Fontsize',16)
ylabel('Absolute Vertical Dispersion','Fontsize',16)
legend('Weak','Transition','Strong','Location','southeast','Fontsize',16)
title('a) Absolute Vertical Dispersion (m^2)')
title('a)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
xticks([10^-1 10^0])
ax = gca; 
ax.FontSize = FS; 
grid minor

% Density Dispersion
StrongDensityDispersion_Plot = mean(densityDispersion_MeanStrong,2,"omitnan");
StrongDensityDispersion_STD = std(densityDispersion_MeanStrong,[],2,"omitnan");

WeakDensityDispersion_Plot = mean(densityDispersion_MeanWeak,2,"omitnan");
WeakDensityDispersion_STD = std(densityDispersion_MeanWeak,[],2,"omitnan");

MedDensityDispersion_Plot = mean(densityDispersion_MeanTransition,2,"omitnan");
MedDensityDispersion_STD = std(densityDispersion_MeanTransition,[],2,"omitnan");

subplot(1,2,2)

loglog(weakTimeVec,WeakDensityDispersion_Plot,'b','LineWidth',2); hold on
loglog(medTimeVec,MedDensityDispersion_Plot,'k','LineWidth',2); hold on
loglog(strongTimeVec(5:end),StrongDensityDispersion_Plot(5:end),'r','LineWidth',2); hold on


errorbar(weakTimeVec(1:numSkipWeak:end),WeakDensityDispersion_Plot(1:numSkipWeak:end),WeakDensityDispersion_STD(1:numSkipWeak:end),'LineStyle','none','Color','b')
errorbar(strongTimeVec(1:numSkipStrong:end),StrongDensityDispersion_Plot(1:numSkipStrong:end),StrongDensityDispersion_STD(1:numSkipStrong:end),'LineStyle','none','Color','r')
errorbar(medTimeVec(1:numSkipWeak:end),MedDensityDispersion_Plot(1:numSkipWeak:end),MedDensityDispersion_STD(1:numSkipWeak:end),'LineStyle','none','Color','k')
xlim([0 6])
xlabel('Time(Days)','Fontsize',16)
ylabel('Density Dispersion','Fontsize',16)
legend('Weak','Transition','Strong','Location','southeast','Fontsize',16)
title('b) Absolute Density Dispersion (kg/m^3)^2')
title('b)','Fontsize',16);set(gca,'TitleHorizontalAlignment','left'); 
grid minor
xticks([10^-1 10^0])

ax = gca; 
ax.FontSize = FS; 

