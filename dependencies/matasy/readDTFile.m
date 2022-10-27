function X = readDTFile(f, dl, bufsize)
% function X = readDTFile(f, dl, bufsize)
%
% Reads tab-delimited file f using delimited
% dl and buffer size bufsize (Default 131072)

% Gary Bhumbra

if nargin < 2, dl = []; end
if nargin < 3, bufsize = 131072; end

x = textread(f, '%s', 'delimiter', '\n', 'bufsize', bufsize);

n = length(x);
X = {};
I = 1;

for i = 1:n
  xi = x{i};
  xn = sscanf(xi, '%f');
  in = 1;
  if length(xn) < 2
    if isempty(dl)
      xs = strparse(xi);
    else
      xs = strparse(xi, dl);
    end
    in = 0;
    if ~length(xn) & ~length(xs{1})
      in = NaN;
    end
  end
  if isnan(in)
    I = I + 1;
  else
    if length(X) < I, X{end+1} = {}; end
    if in
      X{I}{end+1} = xn(:)';
    else
      X{I}{end+1} = xs;
    end
  end
end

for i = 1:length(X);
  Xi = X{i}(:);
  Ni = length(Xi);
  if Ni == 1
    X{i} = Xi{1};
  else 
    ni = zeros(Ni, 1);
    in = zeros(Ni, 1);
    for j = 1:Ni
      ni(j) = length(Xi{j});
      in(j) = isnumeric(Xi{j});
    end
    if all(in) & max(diff(in)) < 0.5
      X{i} = cell2mat(Xi);
    else
      X{i} = Xi;
    end
  end
end

