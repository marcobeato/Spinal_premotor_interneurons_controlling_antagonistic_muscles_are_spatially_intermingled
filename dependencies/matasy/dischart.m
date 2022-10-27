function [P, xy, XY] = dischart(Data, loc, maxd, bw, pstr, fcol, dstr) 
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

% Plaguarised from my own dischart() in chart.asy.
% Gary Bhumbra

if iscell(Data)
  N = length(Data);
  X = cell(1, N);
  n = zeros(1, N);
  for i = 1:N
    x = Data{i};
    X{i} = x(~isnan(x));
    n(I) = length(X{i});
  end
else
  N = size(Data, 2);
  X = cell(1, N);
  n = zeros(1, N);
  for i = 1:N
    x = Data(:, i);
    X{i} = x(~isnan(x));
    n(i) = length(X{i});
  end
end

if nargin < 2, loc = 1; end
if nargin < 3, maxd = 0.8; end
if nargin < 4, bw = []; end
if nargin < 5, pstr = 'k'; end
if nargin < 6, fcol = ''; end
if nargin < 7, dstr = ''; end
if length(loc) == 1, loc = loc * (1:N); end
if ~iscell(maxd)
  if length(maxd) == 1, maxd = maxd * [-0.5, 0.5]; end
  maxd = repmat({maxd}, [1, N]);
end

W = zeros(1, N);
xy = cell(N, 2);
BHI = cell(N, 3);

for i = 1:N
  x = X{i}(:)';
  minx = min(x);
  maxx = max(x);
  if bw
    w = bw;
  else
    w = binw(x);
  end
  W(i) = w;
  b = (minx-w):w:(maxx+w);
  [h, I] = histc(x, b);
  h = h / (max(h) + 1e-300);
  dlo = maxd{i}(1) * h;
  dhi = maxd{i}(2) * h;
  xy{i, 1} = loc(i) + [dlo, fliplr(dhi)];
  xy{i, 2} = [b, fliplr(b)];
  BHI{i, 1} = b;
  BHI{i, 2} = h;
  BHI{i, 3} = I;
end

XY = cell(N, 2);

for i = 1:N
  x = X{i}(:)';
  b = BHI{i, 1};
  h = BHI{i, 2};
  I = BHI{i, 3};
  w = W(i);
  dlo = maxd{i}(1) * h;
  dhi = maxd{i}(2) * h;
  lo = 1;
  for j = 1:max(I)
    Ij = I == j;
    J = find(Ij);
    nJ = length(J);
    if nJ
      if j < max(I)
        lo = 0.5 * (dlo(j) + dlo(j+1));
        hi = 0.5 * (dhi(j) + dhi(j+1));
      else
        lo = dlo(j);
        hi = dhi(j);
      end
      xs = loc(i) + linspace(lo, hi, nJ);
      XY{i, 1}(end+1:end+nJ) = xs(magiperm(nJ));
      XY{i, 2}(end+1:end+nJ) = sort(x(Ij));
    end
  end
end

np = length(pstr) > 0 + length(dstr) > 0;
P = cell(np, N);
p = 0;

if length(pstr)
  if ~iscell(pstr), pstr = repmat({pstr}, [1, N]); end
  p = p + 1;
  holdon = ishold;

  for i = 1:N
    if i == 1
      hold on;
    end
    if length(fcol)
      if ~iscell(fcol), fcol = repmat({fcol}, [1, N]); end
      P{p, i} = patch(xy{i, 1}, xy{i, 2}, pstr{i});
      set(P{p, i}, 'FaceColor', fcol{i});
      set(P{p, i}, 'EdgeColor', pstr{i});
    else
      if isstr(pstr{i})
        P{p, i} = plot(xy{i, 1}, xy{i, 2}, pstr{i});
      else
        P{p, i} = plot(xy{i, 1}, xy{i, 2});
        set(P{p, i}, 'Color', pstr{i});
      end
    end
  end

  if ~holdon, hold off; end
end

if length(dstr)
  if ~iscell(dstr), dstr = repmat({dstr}, [1, N]); end
  p = p + 1;
  holdon = ishold;

  for i = 1:N
    if i == 1
      hold on;
    end
    if isstr(dstr{i})
      P{p, i} = plot(XY{i, 1}, XY{i, 2}, dstr{i});
    else
      P{p, i} = plot(XY{i, 1}, XY{i, 2}, 'o');
      set(P{p, i}, 'Color', dstr{i});
    end
  end

  if ~holdon, hold off; end
end

