function [m,rmse] = fto(x,y);
%   [m,rmse] = fto(x,y);
%   Fit through origin
%   Computes slope m of best-fit line through origin, so that y = m x
%   and rmse (root mean square of errors) value
        m=sum(x.*y)./sum(x.^2);%Slope
        
        ye=m*x;%Estimate for dependent variable
        
        rmse=sqrt(1/(length(y-1)) * sum((y-ye).^2));
end