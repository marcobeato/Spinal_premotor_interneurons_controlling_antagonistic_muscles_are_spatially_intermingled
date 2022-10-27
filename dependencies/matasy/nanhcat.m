function [x] = nanhcat(varargin)
% function [x] = nanhcat(array1, array2, array3, .... , array N);
%
% Horizontally concatenates N arrays padding missing values with nan.

n = length(varargin);

for f = 1 : n
    [rows(f), cols(f)] = size(varargin{f});
    twod(f) = ndims(varargin{f})==2;
end

if ~all(twod), error('All the inputs must be two dimensional.'); end

nrows = max(rows);
ccols = cumsum(cols);
ncols = ccols(n);

j = ccols;
i = [0, j(1:end - 1)] + 1;

x = repmat(nan, [nrows ncols]);

for f = 1 : n;

    x(1:rows(f), i(f):j(f)) = varargin{f};
    
end
