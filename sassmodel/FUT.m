function ut = FUT2(t);
global T U UT
%     ut = interp1(T,UT,t,'cubic');
    ut = interp1q(T',UT',t);
end