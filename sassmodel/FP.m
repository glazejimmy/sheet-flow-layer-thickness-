function px = FP(t);

global T U UT Px kappa d65 d50 rhos rho g c0 tanphip
%     px = interp1(T,Px,t,'cubic');
    px = interp1q(T',Px',t);

end