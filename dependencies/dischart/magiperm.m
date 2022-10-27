function i = magiperm(n)
% function i = magiperm(n)

i = [];
if ~n, return; end
i = 1:n;
if n < 3, return; end

s = ceil(sqrt(n+1));
I = magic(s);
i = I(:);
i = i(i <= n)';
i = i(i);

