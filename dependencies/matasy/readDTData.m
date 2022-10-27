function [X, S] = readDTData(fn, delstr)
% function [X, S] = readDTData(fn, delstr)
%
% Reads delimited text file fn parsing the output by delimiting
% string delstr (default 9, i.e. ASCII tab), returning numeric
% X and string S outputs.

if nargin < 2, delstr = 9; end

fh = fopen(fn, 'r');
x = fscanf(fh, '%c');
fclose(fh);
t = find(x == delstr);
n = length(t);
if ~n
  n = length(x);
  S = x;
  X = str2num(x);
  return;
end
if t(n) < length(x)
    n = n + 1;
end
X = zeros(1, n);
S = cell(1, n);
for i = 1:n
  if i == 1
      xt = x(1:t(1)-1);
  elseif i == n
      xt = x(t(n-1)+1:end);
  else
      xt = x(t(i-1)+1:t(i)-1);
  end
  S{i} = xt;
  X(i) = str2double(xt);
end
    
