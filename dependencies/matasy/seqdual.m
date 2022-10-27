function ind = seqdual(n)
  ind = [];
  if ~n, return; end
  if n < 3
    ind = 1:n;
    return;
  end
  m = n;
  if mod(m, 2), m = m + 1; end
  k = round(m / 2);
  ind = reshape(1:m, [k, 2])';
  ind = ind(:);
  ind = ind(1:n)';

