
load('weakTransEKEMean.mat')
wtEKEmean = EKEmean;
load('strongTransEKEMean.mat')
strongEKEmean = EKEmean;
FS = 18;
fig1 = figure(2);
x0=10;
y0=10;
width=1000;
height=500;
set(gcf,'position',[x0,y0,width,height])
tcl = tiledlayout(1,2,'TileSpacing','compact');
ax1 = nexttile;;
%ax1 = axes(tcl);
timeVec = (0:length(wtEKEmean)-1)*(30/60);
dateVec = datetime(2019,11,16) + hours(timeVec);
plot(timeVec,(wtEKEmean),'k','LineWidth',2); hold on
ylabel("Eddy Kinetic Energy (m^2/s^2)")
xlabel('Time (Hrs)')
title('a)','HorizontalAlignment','left')
x = [(300*30/60) (636*30/60) (636*30/60) (636*30/60) (300*30/60)];
y = [0 0 0.0 2.5 2.5];
patch(x,y,'k','FaceAlpha',0.3)
text((468*0.5-30)+12.5,0.03,'T','FontSize',14)

x = [(1200*30/60) (1536*30/60) (1536*30/60) (1536*30/60) (1200*30/60)];
y = [0 0 0.0 2.5 2.5];
patch(x,y,'k','FaceAlpha',0.3)
text((1332*30/60),0.03,'W','FontSize',14)



ylim([0 0.035])
set(gca,'TitleHorizontalAlignment','left'); 
grid minor
%set(gca,'XAxisLocation','top')
%xline(600*30/60','g--','LineWidth',2)
xlim([0 max(timeVec)])
ax = ax1; 
ax.FontSize = FS; 


ax1 = nexttile;
timeVec = (0:length(strongEKEmean)-1)*(30/60)-200;
plot(ax1,timeVec,(strongEKEmean),'k','LineWidth',2); hold on
ylabel("Eddy Kinetic Energy (m^2/s^2)")
xlabel('Time (Hrs)')
title('b)','HorizontalAlignment','left')
xline(ax1,600*30/60-200,'r:','LineWidth',2)
x = [(1000*30/60)-200 (1336*30/60)-200 (1336*30/60)-200 (1336*30/60)-200 (1000*30/60)-200];
y = [0 0 0.0 2.5 2.5];
patch(x,y,'k','FaceAlpha',0.3)
text((1132*30/60)-200,0.03,'S','FontSize',14)
ylim(ax1,[0 0.035])
xlim(ax1,[0 max(timeVec)])
set(gca,'TitleHorizontalAlignment','left'); 
grid minor
ax = gca; 
ax.FontSize = FS; 
