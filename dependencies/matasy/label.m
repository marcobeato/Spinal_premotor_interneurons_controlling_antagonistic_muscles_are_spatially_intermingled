function t = label(L, x, y, alignment, siz, col);
% function t = label(L, x, y, alignment, siz, col);

% Gary Bhumbra

if nargin < 4, alignment = ''; end

t = text(x, y, L);
alignment = lower(alignment);

if contains(alignment, 'n')
  set(t, 'VerticalAlignment', 'bottom');
elseif contains(alignment, 's')
  set(t, 'VerticalAlignment', 'top');
else
  set(t, 'VerticalAlignment', 'middle');
end

if contains(alignment, 'e')
  set(t, 'HorizontalAlignment', 'left');
elseif contains(alignment, 'w')
  set(t, 'HorizontalAlignment', 'right');
else
  set(t, 'HorizontalAlignment', 'center');
end

if nargin > 4, set(t, 'FontSize', siz); end
if nargin > 5, set(t, 'Color', col); end

