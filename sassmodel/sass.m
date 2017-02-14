function [ds,db,tau,f,U0,shields,sleath] = sass(T_,U_,UT_,H_,Px_,B_,d50_,w_,beta_,ds0,calib,mute,varargin);
% function [ds,db,tau,f,U0,shields,sleath]
%     = sass(T_,U_,UT_,H_,Px_,B_,d50_,w_,sinB_,ds0,calib,mute,*fast);
%% SEMI-ANALYTICAL MODEL FOR SHEAR STRESS AND SHEET FLOW THICKNESS
% Thijs Lanckriet
% University of Delaware, 2014
%
%% INPUT PARAMETERS
%   T: Time vector (in seconds)
%   U: Velocity timeseries(in m/s);
%   UT: Time derivative of velocity timeseries (in m/s2)
%   Px: Pressure gradient time series
%   d50: Median grain diameter
%   w: Sediment fall velocity
%   sinB: Bottom slope
%   h: height of the water column
%   Calib: 4x1 matrix of calibration values
%   mute: Whether to display information while running the model
%   *fast (optional): Whether to use larger integration tolerances (faster integration)
%% OUTPUT PARAMETERS
%   delta: Boundary layer thickness (in m)
%   tau: Bed shear stress
%   f: Friction factor
%   ds: sheet flow layer thickness
%   ds_steady: Steady-state sheet flow layer thickness
%   ds_steady_nopress: Steady-state sheet flow layer thickness (no pressure gradient)

%% Deal with variable arguments
if ~isempty(varargin);
    fast=varargin{1};
else
    fast = false;
end

%Share variables with sub-functions
global  T U UT H B Px kappa rhos rho g c0 tanphip d50 sinB cosB C1 C2 C3 w signU

% Put input variables into the global workspace to share with sub-variables
T = T_;
U = U_;
UT = UT_;
H = H_;
Px = Px_;
B = B_;
d50 = d50_;
w = w_;
sinB = sin(beta_);       %So that we only have to calculate this once
cosB = cos(beta_);       %So that we only have to calculate this once
% Calibration vector
C1 = calib(1);          %Calibration factor for grain inertia
C2 = calib(2);          %Calibration factor Mobile Bottom roughness
C3 = calib(3);          %Calibration factor for bore term

%Physical variables
kappa = 0.41;           %Von Karman constant
rho = 1000;             %Density of water
rhos = 2650;            %Density of sediment
g=9.81;                 %Gravitational acceleration
c0 = 0.6;               %Sediment bed concentration
tanphip = 0.32;         %Tangent of dynamic friction angle

%% Extend input time series to avoid interpolation problems toward the end of the time series
T = [T T(end)+100];
U = [U U(end)];
UT= [UT UT(end)];
Px= [Px Px(end)];
H = [H H(end)];
B = [B B(end)];

%% INITIAL CONDITIONS
Kn0 = 2.50 * d50;%Nikuradze roughness
z00 = Kn0/30;   %Initial z0

%% Initialize solution variables
db0 = d50; %Initial boundary layer thickness
Z0 = log((db0+z00)/z00); % Initial Z for momentum integral theory
Y0 = ds0/d50;

X0 = [Z0 Y0]'; %Initial condition vector

Tsol = [T(1)];          %Solution time vector
X = X0;                 %Solution vector

signU = sign(U(find(U~=0,1)));

%% Solve ODE set
dtzero = 1e-9; %Initial time step

if ~mute;
    tic;
end

if fast;
    solveropts = odeset('maxstep',max(diff(T(1:end-1))),'events',@BLevents,'abstol',5e-3,'reltol',1e-2);
else
    solveropts = odeset('maxstep',max(diff(T(1:end-1))),'events',@BLevents);
end

nextsolver = 'reg'; %Start of with regular solver

while Tsol(end) < T(end-1);
    %     fprintf('FR: %3.3f',Tsol(end));
    if Tsol(end)>0;
        signU = sign(FU(Tsol(end)));
        if signU ==0;
            signU = sign(FU(Tsol(end)+1e-10));
        end
    end
    
    if ~mute;
        fprintf('%3.2f; %i ; %s|',Tsol(end),signU,nextsolver);
    end
    switch nextsolver
        case 'reg';
            sol = ode15s(@FX,[Tsol(end) T(end-1)],X(:,end),solveropts);
            
            %Append solution vectors with new section
            Tsol = [Tsol sol.x];
            X = [X sol.y];
            
            
            
        case 'noflow'
            sol = ode15s(@FX_noflow,[Tsol(end) T(end-1)],X(:,end),solveropts);
            
            %Append solution vectors with new section
            Tsol = [Tsol sol.x];
            X = [X sol.y];
            
            
            
    end
    if Tsol(end) < T(end-1);
        switch sol.ie(end)
            case 1; %Events function found flow reversal
                
                %Reset boundary layer thickness
                Tsol = [Tsol Tsol(end)];
                Xnext = [Z0 X(2,end)]';
                X = [X Xnext];
                
                nextsolver = 'reg';
            case 2 %Events function found water depth SMALLER than sheet flow layer thickness
                nextsolver = 'noflow';
            case 3 %Events function found water depth LARGER than sheet flow layer thickness
                nextsolver = 'reg';
        end
    end
    if Tsol(end)>155;
    end
end
if ~mute;
    fprintf('\n');
end
%% Get derived quantities
Z =X(1,:);
ds = X(2,:)*d50;

%Clip that last value of T again
T = T(1:end-1);
U = U(1:end-1);
UT = UT(1:end-1);
Px = Px(1:end-1);
H = H(1:end-1);
B = B(1:end-1);

%Interpolate to original time vector
[~,ia]=unique(Tsol);
if strcmp(version,'7.11.0.584 (R2010b)');
    [~,ib]=unique(Tsol,'last');
else
    [~,ib]=unique(Tsol,'last','legacy');
end

Z = interp1(Tsol(ia),mean([Z(ia);Z(ib)]),T,'linear');
ds = interp1(Tsol(ia),mean([ds(ia);ds(ib)]),T,'linear');

Kn = 2.50 * d50 + 0.50 *ds;%Nikuradze roughness

z0 = Kn/30;

db = z0 .* (exp(Z)-1);      %Boundary layer thickness

U0 = nan(size(U));          %Free stream velocity
for i = 1:length(U0);
    U0(i) = FU2(T(i),db(i),z0(i));
end

Uf = U0./Z*kappa;           %Friction velocity
% Uf(FHmat(T)<hcut)=0;        %Set friction velocity to 0 when no flow

% Px2 = FP(Tsol);
tau = rho*Uf.^2.*sign(U);   %Bed shear stress
f = 2 * Uf.^2 ./ U0.^2;     %Friction factor

shields = abs(tau/((rhos-rho)*g*d50)); %Shields number
sleath = -Px /((rhos-rho)*g);          %Sleath  number

end