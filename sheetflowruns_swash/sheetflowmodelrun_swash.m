%% RUN SHEET FLOW MODEL FOR SWASH DATASET RUN
clear
clear -global;

addpath('..\sassmodel');%Load the model path

%% LOAD RUN DATA
series = 'A6';
rn = 4;
load(sprintf('..//data//%s_%02u_sassinput.mat',series,rn));

%Remove sheet flow data before first swash event
sassinput.sheet.ds(sassinput.sheet.t<sassinput.T(find(sassinput.H>0,1)))=nan;
%Exclude swash events with depth < 0.07 m
sassinput = exclude_small_events(sassinput,0.07);

rho = 1000; %Water density
c0 = 0.6;   %Sediment packing
tanphip = 0.32;%Dynamic friction factor (tangent of phi ' )
g=9.81;     %Gravity

%% CALIBRATION FACTORS
calib = [ 49.55760 1.70786  317.3590]; % Alpha = [2/3 1/3];
% calib = [ 63.87328 1.73818  362.6811]; % Alpha = [1/2 1/2];
% calib = [ 83.56820 1.81621   417.7310]; % Alpha = [0 1];

%% RUN MODEL
tic;
mute = false; %Choose whether or not the sass-function displays a bunch of extra info
fast = false;%Choose whether or not to do fast integration (larger tolerances)
[...
    sassoutput.ds,...
    sassoutput.db,...
    sassoutput.tau,...
    sassoutput.f,...
    sassoutput.U0,...
    sassoutput.shields,...
    sassoutput.sleath,...
] = sass(...
    sassinput.T,...
    sassinput.U,...
    sassinput.UT,...
    sassinput.H,...
    sassinput.Px,...
    sassinput.B,...
    sassinput.d50,...
    sassinput.w0,...
    asin(sassinput.sinB),...
    sassinput.ds0,...
    calib,...
    mute,...
    fast);
toc;

%% SAVE OUTPUT PARAMETERS
sassoutput.T = sassinput.T;
sassoutput.calib = calib;
save(sprintf('..//data//%s_%02u_sassoutput.mat',series,rn),'sassoutput');

%% COMPARE PREDICTIONS AGAINST MEASURED DATA
sheetpred = interp1(sassoutput.T,sassoutput.ds,sassinput.sheet.t,'linear',0)';
u_sheet = interp1(sassinput.T,sassinput.U,sassinput.sheet.t,'linear','extrap')';

pred = sheetpred;
meas = sassinput.sheet.ds;

ok = ~isnan(meas)&~isnan(pred);
pred=pred(ok);
meas=meas(ok);
u_sheet_ok = u_sheet(ok);

rmse = sqrt(mean((pred-meas).^2));
r = corr(pred',meas');
R2 = coeffdet(meas,pred);

%Briers skill score
[p_baseline2,~] = fto(u_sheet_ok.^2,meas);
baseline_pred2 = u_sheet_ok.^2.*p_baseline2;
BSS = 1 - mean((pred-meas).^2)/mean((baseline_pred2-meas).^2);

fprintf('RMSE = %3.3f mm \tr^2 = %3.3f\t R2=%3.3f \t BSS = %3.3f\n',rmse*1000,r.^2,R2,BSS);


