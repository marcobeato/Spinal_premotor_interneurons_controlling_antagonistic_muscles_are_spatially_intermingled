function [x, y] = circle(x0, y0, r, n)
% function [x, y] = circle(x0, y0, r, n)

if nargin < 1, x0 = 0; end
if nargin < 2, y0 = 0; end
if nargin < 3, r = 1; end
if nargin < 4, n = 100; end

th = linspace(-pi, pi, n);
x = r .* cos(th) + x0;
y = r .* sin(th) + y0;

