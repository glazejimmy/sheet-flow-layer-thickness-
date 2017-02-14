function h = FH(t);
global T H
    h = interp1(T',H',t);
end