function [X, data] = readSVFile(fn, delstr, nanconv)
% function [X, data] = readSVFile(fn, delstr, nanconv)
%
% Reads tab-separated values files according the TSV format, outputting
% numeric X values. Where possible 2D cell arrays are converted to arrays 
% unless with NaN values interpreted accordingly if nanconv is true.

if nargin < 2, delstr = 9; end
if nargin < 3, nanconv = 1; end

NOTANUMBER = -1.797693134859999934634121101919578678721769031470241902291691506646167202234885490647760027322138495e+308;
if isstr(fn)
  [data, strdata] = readDTData(fn, delstr);
else
  data = fn;
  strdata = arrayfun(@num2str, data, 'UniformOutput', false);
end

data = data(:);
N = length(data);
if N < 4; X = data; return; end
k = 1;
n = round(data(k));
if n ~= 3 
  disp('Cannot import data with non-three dimensionality');
  X = data;
  return;
end
k = k + 1;
n = round(data(k));
X = cell(1, n);
k = k + 1;
for h = 1:n
  nr = round(data(k));
  k = k + 1;
  x = cell(nr, 1);
  Nc = zeros(nr, 1);
  NC = repmat(true, [nr, 1]);
  for i = 1:nr
    nc = round(data(k));
    Nc(i) = nc;
    k = k + 1;
    l = k + nc - 1;
    xi = data(k:l);
    isn = zeros(1, nc);
    for j = 1:nc
      xij = str2double(xi(j));
      isn(j) = ~isnan(xij);
    end
    isN = all(isn);
    if isN && nanconv
      xi = double(xi);
      xi(xi == NOTANUMBER) = NaN;
    else
      NC(l) = false;
      for j = 1:nc
        if isn(j), xi(j) = double(xi(j)); end
        if nanconv
          xj = xi(j);
          xj(xj == NOTANUMBER) = NaN;
          xi(j) = xj;
        end
      end
    end
    x{i} = xi;
    k = l + 1;
    if h + 1 <= n & k > N
      disp('Warning: dimension specification exceeds file size');
      return;
    end
  end
  if min(NC) == max(NC)
    X{h} = zeros(nr, nc);
    for i = 1:nr
      for j = 1:nc
        X{h}(i, j) = x{i}(j);
      end
    end
  else
    X{h} = x;
  end
end
if k < N
  disp('Dimension specification below file size');
end

