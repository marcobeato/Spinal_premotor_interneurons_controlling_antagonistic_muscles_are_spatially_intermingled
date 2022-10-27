function [bw, b, C] = binw(x)
% function [bw, b, C] = binw(x)
%
% Uses optimisation method of Shimazaki and Shinomoto with sensible bounds :
%  [minbw = range/length, maxbw = range/sqrt(length))]
%      @article{shimazaki2007method,
%      title={A method for selecting the bin size of a time histogram},
%      author={Shimazaki, H. and Shinomoto, S.},
%      journal={Neural Computation},
%      volume={19},
%      number={6},
%      pages={1503--1527},
%      year={2007},
%      publisher={MIT Press}
%     }
%
% This code is plagiarised from my own Asymptote code in chart.asy using 
% thought-free code translation.

% Gary Bhumbra
                                         

MD = 0;
x = x(:);
x = x(~isnan(x));
minx = min(x);
maxx = max(x);
ranx = maxx - minx;
n = length(x);
if ranx == 0. | (n < 3 | ranx < 1e-300)
  b = ranx;
  return
end
minb = ranx / n;
maxb = ranx / sqrt(n);
b = exp(linspace(log(minb), log(maxb), n));
m = zeros(1, n);
if n < 256
  inc = round(sqrt(n));
elseif n < 512
  inc = 1;
else
  inc = 0;
end

for i = 1:n
  if inc > 0
    m(i) = ceil(b(i)/minb) + inc;
  else
    m(i) = 2;
  end
end

C = zeros(1, n);

for i = 1:n
  mi = m(i);
  m2 = 0.5 * mi;
  bi = b(i);
  b2 = 0.5 * bi;
  bs = bi^2;
  nb = round( (ranx+bi)/bi );
  b0 = linspace(minx-b2, maxx+b2, nb);
  db = linspace(-b2, b2, mi);
  c = zeros(1, mi);
  for j = 1:mi;
    h = histc(x, b0 + db(j));
    lh = length(h);
    if j < m2
      lh = lh - 1;
      h = h(1:lh);
    elseif j > m2
      h = h(2:lh);
      lh = lh - 1;
    end
    mh = mean(h);
    vh = var(h);
    c(j) = (2. * mh - vh) / bs;
  end
  C(i) = mean(c);
end
minc = min(C);
i = find(abs(C - minc) <= 0.);
bw = b(i(1));

