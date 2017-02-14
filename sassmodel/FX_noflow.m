function DX = FX(t,X)
%% function DZ = FX(t,X)
% Coupled differential equation for shear stress and sheet flow
% Shape of X (column vector):
% X = [
%    Z
%    Y = ds/d50 (sheet layer thickness)
%    ];

Z = X(1);
Y = X(2);
global  T U UT Px B kappa rhos rho g c0 tanphip d50 sinB cosB C1 C2 C3 w signU

Kn = 2.50 * d50 + 0.50 * Y * d50;%Nikuradze roughness
z0 = Kn/30;

if FU(t) ==0;
    DZ = 0;
    
    S = -FP(t)/((rhos-rho)*g);
    theta = 0;
else
        S = 0 ;
        theta = 0;
        db = z0 .* (exp(Z)-1);
%         
        U1 = FU2(t,db,z0);      %Free-stream velocity
        UT1 = FUT2(t,db,z0);    %Free stream velocity gradient
        
                DZ = (kappa^2*abs(U1/z0) -Z*(exp(Z)-Z-1)/U1 *UT1)/(exp(Z)*(Z-1)+1); %Momentum integral method
                DZ = min(abs(DZ),1e4)*sign(DZ); %Cap DZ for numerical stability

end

DY = C3/C1 * FB(t) + ...
    g/(w*C1) * ...
    (theta*signU  ...
    - Y * (0.425 * c0 * (sinB*signU + C2 .* tanphip*cosB) - S*signU )...
    );

DY = min(abs(DY),1e4)*sign(DY); %Cap DY for numerical stability

if Y*d50<z0 && DY<0; %Make sure sheet flow layer thickness does not become negative
    DY = 0;
end


DX = [DZ DY]';

% fprintf('%3.3f\t %3.3f\t',t,FU(t));
% % fprintf('%3.3g\t',DX);
% fprintf('\n');
end