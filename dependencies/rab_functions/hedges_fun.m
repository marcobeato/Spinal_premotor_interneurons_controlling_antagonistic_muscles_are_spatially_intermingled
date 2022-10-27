function [hh] = hedges_fun(x,y)
%UNTITLED2 takes two column vectors and caclualtes Hedges effect size
%
nx = size(x,1);
ny = size(y,1);
sdx = std(x);
sdy = std(y);
pooled_s = sqrt( ((nx-1)*sdx^2 + (ny-1)*sdy^2) / (nx + ny-2) );
hh = ((mean(x)-mean(y))/pooled_s);

end

