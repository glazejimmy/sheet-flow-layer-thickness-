% Plot results from the grand model

clear
clear global

%% LOAD RUN DATA
series = 'A6';
rn = 4;
load(sprintf('..//data//%s_%02u_sassinput.mat',series,rn));
load(sprintf('..//data//%s_%02u_forcingmeasurements_public.mat',series,rn));
load(sprintf('..//data//%s_%02u_sassoutput.mat',series,rn),'sassoutput');

%Remove sheet flow data before first swash event
sassinput.sheet.ds(sassinput.sheet.t<sassinput.T(find(sassinput.H>0,1)))=nan;

calib = sassoutput.calib;

rho = 1000; %Water density
c0 = 0.6;   %Sediment packing
tanphip = 0.32;%Dynamic friction factor (tangent of phi ' )
g=9.81;     %Gravity

%% MAKE THE FIGURE WINDOW
set(0,'defaulttextfontsize',9);
set(0,'defaulttextfontName','Times New Roman');
set(0,'defaultaxesfontsize',9);
set(0,'defaultaxesfontName','Times New Roman');
figure('units','centimeters','position',[4 4 45 20],'color','w');

nax= 8;     %Number of panels in the vertical
nay = 1;    %Number of panels in the horizontal
axn = 1;

sd = 24*3600; %Conversion factor between seconds and days (for time vectors)

xt = 0.9821; %Location of panel number text

%% Water depth
axs(axn)=subaxis(nax,nay,axn,...
    'mb',0.18,'mt',0.02,'mr',0.005,'ml',0.03,'sh',0.01,'sv',0.03);

hold all;
plot(sassinput.T,sassinput.H,'k');
plot(sassinput.T,0*sassinput.H,'k');

plot((BLS.mtime-stm)*sd,BLS.h,'r')

yl(axn)=ylabel('h (m)');
box on
set(gca,'xticklabel',{});
ylim([0 0.4]);
text(xt,0.882,'(a)','units','normalized')

axn = axn+1;

%% Velocity
axs(axn)=subaxis(nax,nay,axn);

hold all;
plot(sassinput.T,sassinput.U,'k');
plot(sassinput.T,0*sassinput.T,'k');

plot((EM.mtime-stm)*sd,EM.EMx,'r','displayname','EMCM')

yl(axn)=ylabel('u (m/s)');
box on
set(gca,'xticklabel',{});
ylim([-5 3]);

axn = axn+1;
text(xt,0.882,'(b)','units','normalized')


%% Shields number stress
axs(axn)=subaxis(nax,nay,axn);
hold all;
plot(sassoutput.T,sassoutput.shields.*sign(sassinput.U),'k-');

plot(sassoutput.T,0*sassoutput.shields,'k-');
    yl(axn)=ylabel('\theta');
axn = axn+1;
box on
set(gca,'xticklabel',{});
ylim([-4 5]);
text(xt,0.882,'(c)','units','normalized')

%% Sleath number
axs(axn)=subaxis(nax,nay,axn);
hold all;
plot(sassoutput.T,sassoutput.sleath,'k');
    yl(axn)=ylabel('S');

axn = axn+1;
box on
set(gca,'xticklabel',{});
ylim([-.1 .8]);

text(xt,0.882,'(d)','units','normalized')



%% Forcing terms
axs(axn)=subaxis(nax,nay,axn);
hold all;

F1 = sassoutput.shields;
F2 = sassoutput.ds/sassinput.d50.*sassoutput.sleath.*sign(sassinput.U);
F3 = -sassoutput.ds/sassinput.d50.*0.425 * c0 * calib(2) .* tanphip;
F4 = -1*sassoutput.ds/sassinput.d50.*sassinput.sinB.*sign(sassinput.U)*0.425*c0;
plot(sassoutput.T,F1,'-','color',[0 0.6 0]);
plot(sassoutput.T,F2,'b-');
plot(sassoutput.T,F4,'m-');


plot(sassoutput.T,0*sassoutput.T,'k');
yl(axn)=ylabel('Forcing terms');
axn = axn+1;
box on
set(gca,'xticklabel',{});
ylim([-7 7]);

text(xt,0.882,'(e)','units','normalized')

%% Bore forcing
axs(axn)=subaxis(nax,nay,axn);
hold all;
plot(sassinput.T,sassinput.B,'k');
plot(sassinput.T,0*sassinput.B,'k');
yl(axn)=ylabel('B');
ylim([-10 150])
set(gca,'xticklabel',{});

axn = axn+1;
text(xt,0.882,'(f)','units','normalized')


%% Sheet layer thickness;
axs(axn)=subaxis(nax,nay,axn);
hold all;
plot(sassoutput.T,sassoutput.ds,'k');
plot([sassinput.sheet.t],sassinput.sheet.ds,'m.');
sassinput = exclude_small_events(sassinput,0.07);
plot([sassinput.sheet.t],sassinput.sheet.ds,'r.');

ylim([0 0.03]);
yl(axn)=ylabel('\delta_s (m)');
box on
axn = axn+1;
set(gca,'xticklabel',{});

text(xt,0.882,'(g)','units','normalized')

%% Sediment concentration
cn = 1;
axs(axn)=subaxis(nax,nay,axn);
hold all;
pcolor((ccp.(cps{cn}).mtime(1:1:end)-stm)*sd,ccp.(cps{cn}).z(1:1:end),ccp.(cps{cn}).conc(1:1:end,1:1:end));
shading interp
caxis([-0.000001 0.65]);

plot((ccp.(cps{cn}).mtime-stm)*sd,ccp.(cps{cn}).sboto,'k','linewidth',2);
plot((ccp.(cps{cn}).mtime-stm)*sd,ccp.(cps{cn}).stop,'m','linewidth',2);

rectangle('position',[253.6,0,20,1],'facecolor','w','edgecolor','w');
cb= colorbar('location','east');
set(cb,'position',[0.9824 0.183 0.010 0.0496],'ytick',[0:0.2:0.6]);



ylim([0 0.028]);
yl(axn)=ylabel('z (m)');
xlabel('t (s)');

text(xt,0.882,'(h)','units','normalized')


%% Common for all axes
warning off;
linkaxes(axs,'x');
warning on;
xlim([0 max(sassoutput.T)]);
% xlim([198 250]);

yl1=get(yl(1),'position');

    
for i = 1:8;
    yli = get(yl(i),'position');
    yli(1)=yl1(1);
    set(yl(i),'position',yli);
end

%% Figure caption
annotation(gcf,'textbox',...
    [0.30 0.01 0.40 0.13],'edgecolor','none',...
    'String',{'Appendix figure: Full time series of swash zone dataset. Black lines indicate result from the FUNwave (panel a,b) and sheet flow layer thickness (panel f) model; red lines indicate measurements. (a) Water depth. (b) Cross-shore flow velocity. (c) Shields number (d) Sleath number (e) Mobilizing force terms: \theta: green line; -YS sign (U): blue line; -Y 0.425 c_0  sin\beta sign(U): magenta line. (f) Bore stirring term. (g) Sheet flow layer thickness. Magenta dots indicate measurements during small swash events (h_{max}<0.07 m). (h) Sediment concentration measurements. Red colors indicate non-moving sediment bed; blue colors indicate water column. Magenta and black lines indicate top and bottom of the sheet flow layer according to Lanckriet et al.[2014] , respectively.'},...
    'FitBoxToText','off');