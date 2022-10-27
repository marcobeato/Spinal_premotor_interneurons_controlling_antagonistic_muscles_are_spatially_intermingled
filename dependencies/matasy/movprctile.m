function [Y, XI, I] = movprctile(X, P, k)
%function [Y, XI, I] = movprctile(X, P, k)
%
% Calculates perctile (see prctile) values of
% X(:) at P(:)' using a sliding window of size
% k.

% Gary Bhumbra

X = X(:);
P = P(:)';

n = length(X);
a = 1:(n-k+1);
m = 0:(k-1);

[A, M] = meshgrid(a, m);
I = A + M;
XI = X(I);
Y = prctile(XI, P, 1);

