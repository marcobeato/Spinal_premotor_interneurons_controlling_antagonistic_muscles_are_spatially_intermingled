function y = nearmag(x, steps)
% function y = nearmag(x, steps)

% Gary Bhumbra.

if nargin < 2, steps = [1, 2, 5]; end

steps = sort(steps, 'descend');
x = abs(x);
if x == 0.
  y = 0.;
else
  m = floor(log10(x));
  y = x / (10^m);
  i = find(y - steps >= 0.);
  y = steps(i(1)) * (10^m);
end



