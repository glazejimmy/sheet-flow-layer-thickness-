function u0 = FU2(t,delta,z0);

global T U UT
    u = interp1q(T',U',t); %This is depth-averaged velocity
    
    h = FH(t);
    
    if delta+z0<h;
        u0 = u * (h-z0) * log((delta+z0)/z0) / (h * log((delta+z0)/z0)-delta);
    else
        u0 = u * (h-z0) * log(h/z0) / (h *log(h/z0) - (h - z0) );
        
    end
    
%     u0 = u;
end