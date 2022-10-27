function y = strparse(x, dl)
%function y = strparse(x, dl)

y = {};

if nargin < 2
    while length(x);
        [y{end+1}, x] = strtok(x);
    end
    return
end

while length(x);
  [y{end+1}, x] = strtok(x, dl);
end
