function ut0 = FUT2(t,delta,z0);
global T U UT
    ut = interp1q(T',UT',t);
    
    h = FH(t);
    
    if delta+z0<h;
        ut0 = ut * (h-z0) * log((delta+z0)/z0) / (h * log((delta+z0)/z0)-delta);
    else
        ut0 = ut * (h-z0) * log(h/z0) / (h *log(h/z0) - (h - z0) );
        
    end
%     ut0 = ut;
end