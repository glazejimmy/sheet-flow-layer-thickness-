function b = FB(t);

global T B
    b = interp1q(T',B',t);
end