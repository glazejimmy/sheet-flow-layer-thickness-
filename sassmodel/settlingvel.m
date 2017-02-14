function w0 = settlingvel(d50);
%% Free settling of sheet layer
s = 2.65;
g = 9.81;
rho = 1000;
rhos= 2650;
nu = 1e-6;

w00 = (s-1)*g*d50.^2/(18*nu); %Stokes drag law
w0_old = w00;
Re = w0_old*d50/nu; 

w0=100*w0_old;
while abs(w0/w0_old-1)>1e-3;
    w0_old = w0;
    Re = w0_old*d50/nu; 
    Cd = 1.4 + 36/Re;
    w0 = sqrt(4*(s-1)*g*d50/(3*Cd));
end
