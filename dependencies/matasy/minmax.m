function y = minmax(x, m2)
% function y = minmax(x, m2)

% Gary Bhumbra

if nargin < 2, m2 = 0; end

n = length(x);
m = floor(m2 / 2);

if n <= m,
  y = x(:)';
  return;
end

ind = linspace(1, n, m+1);

y = zeros(1, m2);

i = 1;
k = 1;

for h = 1:m
  j = min(n - 1, ceil(ind(h)));
  xij = x(i:j);
  y(k) = min(xij);
  k = k + 1;
  y(k) = max(xij);
  k = k + 1;
  i = j + 1;
end


