function u = FU(t);

global T U UT
    u = interp1q(T',U',t); %This is depth-averaged velocity
    
end