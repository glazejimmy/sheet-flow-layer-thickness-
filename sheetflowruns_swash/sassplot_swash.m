% Plot results from the grand model

% %% Make the figure window
set(0,'defaulttextfontsize',10);
set(0,'defaulttextfontName','Times New Roman');
set(0,'defaultaxesfontsize',10);
set(0,'defaultaxesfontName','Times New Roman');
figure('units','inches','position',[1 1 16 6],'color','w');

nax= 7;
nay = 1;
axn = 1;

sd = 24*3600;

%% Water depth
axs(axn)=subaxis(nax,nay,axn,...
    'mb',0.11,'mt',0.08,'mr',0.02,'ml',0.1,'sh',0.03,'sv',0.03);
title(rn,'interpreter','none');

hold all;
plot(sassinput.T,sassinput.H,'k','linewidth',1);
plot(sassinput.T,0*sassinput.H,'k');

% plot((PT.mtime-stm)*sd,PT.PTh,'r')
% plot((BLS.mtime-stm)*sd,BLS.h1,'m')

yl(axn)=ylabel('h (m)');
box on
set(gca,'xticklabel',{});
ylim([0 0.4]);


axn = axn+1;

%% Velocity
axs(axn)=subaxis(nax,nay,axn);

hold all;
plot(sassinput.T,sassinput.U,'k','linewidth',1);
plot(sassoutput.T,sassoutput.U0,'b');
plot(sassinput.T,0*sassinput.T,'k');

plot((EM.mtime-stm)*sd,EM.EMx,'r','linewidth',1,'displayname','EMCM')

yl(axn)=ylabel('u (m/s)');
box on
set(gca,'xticklabel',{});
ylim([-5 3]);

axn = axn+1;

%% Boundary layer thickness
axs(axn)=subaxis(nax,nay,axn);
title(rn);

hold all;
plot(sassoutput.T,sassoutput.db,'k');
plot(sassoutput.T,0*sassoutput.db,'k');

    yl(axn)=ylabel('\delta (m)');
box on
axn = axn+1;
set(gca,'xticklabel',{});
ylim([0 0.4]);



%% Shear stress
axs(axn)=subaxis(nax,nay,axn);
hold all;
plot(sassoutput.T,sassoutput.tau,'k');
plot(sassoutput.T,0*sassoutput.T,'k');
yl(axn)=ylabel('\tau');
axn = axn+1;
box on
set(gca,'xticklabel',{});
ylim([-30 30]);



%% Bore forcing
axs(axn)=subaxis(nax,nay,axn);
hold all;
plot(sassinput.T,sassinput.B,'k');
ylabel('B');
axn = axn+1;

%% Forcing terms
axs(axn)=subaxis(nax,nay,axn);
hold all;
plot(sassoutput.T,sassoutput.shields,'k-');
plot(sassoutput.T,sassoutput.ds/sassinput.d50.*sassoutput.sleath.*sign(sassinput.U),'b-');
plot(sassoutput.T,-1*sassoutput.ds/sassinput.d50.*sassinput.sinB.*sign(sassinput.U)*calib(2)*0.425*c0,'r-');
% plot(T,-1/2*ds/d50*c0*tanphip.*calib(2),'r:');
% plot(T,shields +ds/d50.*sleath.*sign(U) -1/2.*ds/d50.*c0.*tanphip.*calib(2),'k','linewidth',2);
plot(sassoutput.T,0*sassoutput.T,'k');
    ylabel('Forcing terms');
axn = axn+1;
box on
set(gca,'xticklabel',{});
ylim([-3 3]);


%% Sheet layer thickness;
axs(axn)=subaxis(nax,nay,axn);
hold all;
plot(sassoutput.T,sassoutput.ds,'k');
plot([sassinput.sheet.t],sassinput.sheet.ds,'r.');


ylim([0 0.03]);
yl(axn)=ylabel('\delta_s (m)');
box on
axn = axn+1;
xlabel('time (s)');


%% Common for all axes
warning off;
linkaxes(axs,'x');
warning on;
xlim([0 max(sassoutput.T)]);