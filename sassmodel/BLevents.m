function [value,isterminal,direction] = BLevents(t,X);
% function [value,isterminal,direction] = BLtopevent(t,X);
% Terminate integration at flow reversal (must reset BL thickness at that
% point).

global T d50;


value(1) = [FU(t)];         %Flow reversal
value(2) = 0.99*X(2)*d50-FH(t);  %Depth becomes SMALLER than 99% of sheet flow layer thickness
value(3) = 1.01*X(2)*d50-FH(t);  %Depth becomes LARGER  than 101% of sheet flow layer thickness

% 

isterminal = [1 1 1];
direction = [0 1 -1];



