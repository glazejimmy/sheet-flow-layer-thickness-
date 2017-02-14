function h = FH(t);
global T H
    h = interp1q(T',H',t);
end