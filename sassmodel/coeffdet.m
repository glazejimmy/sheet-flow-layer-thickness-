function [ r2 ] = coeffdet(y,f)
%COEFFDET Calculate coefficient of determination a
%   [ r2 ] = coeffdet(y,f)
%   Coefficient of determination is calculated as 1-SSE/SST, in exact same 
%   way as MATLAB's curve fit r2 does. Not: r2 only equals r squared for
%   linear fits (see Wikipedia)
%   Input:  y: raw values
%           f: fitted values
%   Output: r2:r2 coefficient of determination for fit
    sst=norm(y-mean(y),2)^2;
    sse=norm(y-f,2)^2;
    r2=1-sse/sst;

end

