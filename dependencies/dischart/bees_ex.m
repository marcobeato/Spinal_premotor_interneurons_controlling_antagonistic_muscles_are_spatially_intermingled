% function [P, xy, XY] = dischart(Data, loc, maxd, bw, pstr, fcol, dstr) 
%
%DISCHART(Data) draws a violin plot for data X which
% may be a cell or matrix of columns at locations
% loc (which if single element defines separation;
% default 1.) occupying maximum width maxd (default .8) 
% adopting a bin width of bw (if 0 or omitted defaults to a
% variable bin width adapted to the data distribution) drawn
% according a line string pstr (default 'k') and optional fill 
% string fcol. If maxd is a two-element vector, asymmetric
% violins of (left, right) extents (default [-0.4, 0.4]) are
% drawn. Optional input dstr (default '') can be used to specify 
% a plot string to draw the associated beeswarm.
%
% Outputs
%
% P = cell array of patch/plot handles for violin and beeswarm plot
% xy = cell array of (x, y) values for violin plot
% XY = cell array of (x, y) values for associated beeswarm plot.

close all
figure
n = [5, 100];
X = cell(n(1), 1);
for i = 1:n(1)
  X{i} = normrnd(0, 5, 1, n(2));
end

dischart(X, 1, 0.8, [], '', '', 'ko') ;

