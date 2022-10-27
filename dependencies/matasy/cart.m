% Cart class copied from Asymptote

classdef cart < handle
  properties
    n
    NXY
    m
    r
    xlo
    xhi
    ylo
    yhi
    Xlo
    Xhi
    Ylo
    Yhi
    xrn
    yrn
    Xrn
    Yrn
    xX
    Xx
    yY
    Yy
    x
    y
    xy
    X
    Y
    XY
    G
  end
  methods
    function obj = cart(x_, y_)
      obj.n = 0;
      if length(x_) && length(y_)
        obj.setxy(x_, y_);
      end
    end
    function setXY(obj, X_, Y_)
      obj.X = X_;
      obj.Y = Y_;
      obj.XY = {obj.X; obj.Y};
      obj.NXY = max(numel(X_), numel(Y_));
    end
    function G = graphXY(obj)
      nX = size(obj.X, 2);
      nY = size(obj.Y, 2);
      obj.G = cell(1, obj.m);
      for i = 1:obj.m
        jx = min(i, nX);
        jy = min(i, nY);
        obj.G{i}.XData = obj.X(:, jx);
        obj.G{i}.YData = obj.Y(:, jy);
      end
      G_ = obj.G;
    end
    function X_ = x2X(obj, x_)
      X_ = obj.Xx .* (x_ - obj.xlo) + obj.Xlo; 
    end
    function Y_ = y2Y(obj, y_)
      Y_ = obj.Yy .* (y_ - obj.ylo) + obj.Ylo; 
    end
    function x_ = X2x(obj, X_)
      x_ = obj.xX .* (X_ - obj.Xlo) + obj.xlo;
    end
    function y_ = Y2y(obj, Y_)
      y_ = obj.yY .* (Y_ - obj.Ylo) + obj.ylo;
    end
    function [X_, Y_] = xy2XY(obj, x_, y_)
      X_ = obj.x2X(x_);
      Y_ = obj.y2Y(y_);
    end
    function [x_, y_] = XY2xy(obj, X_, Y_)
      x_ = obj.X2x(X_);
      y_ = obj.Y2y(Y_);
    end
    function calcXY(obj, Xlo_, Xhi_, Ylo_, Yhi_, xlo_, xhi_, ylo_, yhi_)
      if nargin < 2, Xlo_ = 0; end 
      if nargin < 3, Xhi_ = 1; end 
      if nargin < 4, Ylo_ = 1; end 
      if nargin < 5, Yhi_ = 1; end 
      if nargin < 6, xlo_ = -inf; end 
      if nargin < 7, xhi_ = +inf; end 
      if nargin < 8, ylo_ = -inf; end 
      if nargin < 9, yhi_ = +inf; end 
      mino = 1e-300;
      havexy = obj.n > 0;
      havinf = 0;
      obj.Xlo = Xlo_;
      obj.Xhi = Xhi_;
      obj.Ylo = Ylo_;
      obj.Yhi = Yhi_;
      obj.xlo = xlo_;
      obj.xhi = xhi_;
      obj.ylo = ylo_;
      obj.yhi = yhi_;
      if isinf(obj.xlo)
        if havexy
          obj.xlo = min(obj.x(:));
        else
          havinf = 1;
        end
      end
      if isinf(obj.xhi)
        if havexy
          obj.xhi = max(obj.x(:));
        else
          havinf = 1;
        end
      end
      if isinf(obj.ylo)
        if havexy
          obj.ylo = min(obj.y(:));
        else
          havinf = 1;
        end
      end
      if isinf(obj.yhi)
        if havexy
          obj.yhi = max(obj.y(:));
        else
          havinf = 1;
        end
      end

      obj.xrn = obj.xhi - obj.xlo;
      obj.yrn = obj.yhi - obj.ylo;
      obj.Xrn = obj.Xhi - obj.Xlo;
      obj.Yrn = obj.Yhi - obj.Ylo;
      obj.xX = obj.xrn / (obj.Xrn + mino);
      obj.yY = obj.yrn / (obj.Yrn + mino);
      obj.Xx = obj.Xrn / (obj.xrn + mino);
      obj.Yy = obj.Yrn / (obj.yrn + mino);
      obj.X = obj.x2X(obj.x);
      obj.Y = obj.y2Y(obj.y);
      obj.setXY(obj.X, obj.Y);
    end
    function setxylims(obj, xlo_, xhi_, ylo_, yhi_)
    if nargin < 2, xlo_ = -inf; end
    if nargin < 3, xhi_ = +inf; end
    if nargin < 4, ylo_ = -inf; end
    if nargin < 5, yhi_ = +inf; end
      if nargin == 3
        yhi_ = xhi_(2);
        ylo_ = xhi_(1);
        xhi_ = xlo_(2);
        xlo_ = xlo_(1);
      end
      if isinf(xlo_), xlo_ = obj.xlo; end
      if isinf(xhi_), xhi_ = obj.xhi; end
      if isinf(ylo_), ylo_ = obj.ylo; end
      if isinf(yhi_), yhi_ = obj.yhi; end
      obj.calcXY(obj.Xlo, obj.Xhi, obj.Ylo, obj.Yhi, xlo_, xhi_, xhi_, yhi_); 
    end
    function setxy(obj, x_, y_)
      if size(x_, 1) == 1, x_ = x_(:); end
      if size(y_, 1) == 1, y_ = y_(:); end
      maxn = max(numel(x_), numel(y_));
      minn = min(numel(x_), numel(y_));
      obj.m = round(maxn/minn);
      obj.r = round(maxn/obj.m);
      obj.x = x_;
      obj.y = y_;
      obj.n = minn;
      obj.calcXY();
    end
    function [X_, Y_] = relxy(obj, x_, y_)
      x_ = min(1., max(-1, x_))
      y_ = min(1., max(-1, y_))
      X_ = (0.5 * (x_ + 1.) * obj.Xrn) + obj.Xlo;
      Y_ = (0.5 * (y_ + 1.) * obj.Yrn) + obj.Ylo;
    end
    function P = drawgraph(obj, spec)
      obj.graphXY();
      P = cell(obj.m, 1);
      holdon = ishold;
      hold on;
      for i = 1:obj.m
        if nargin < 2
          P{i} = plot(obj.G{i}.XData, obj.G{i}.YData);
        else
          if isstr(spec)
            P{i} = plot(obj.G{i}.XData, obj.G{i}.YData, spec);
          elseif isnumeric(spec)
            P{i} = plot(obj.G{i}.XData, obj.G{i}.YData);
            set(P{i}, 'color', spec);
          else
            P{i} = plot(obj.G{i}.XData, obj.G{i}.YData, spec{i});
          end
        end
      end
      if ~holdon, hold off; end
    end
    function [ph, th] = linelabel(obj, xy0, xy1, plotStr, lbl, pos, lblSiz, lblCol)
      if nargin < 6, pos = ''; end
      xym = 0.5 * (xy0 + xy1);
      holdon = ishold;
      hold on
      ph = plot([xy0(1), xy1(1)], [xy0(2), xy1(2)], plotStr);
      if nargin < 5
        th = [];
      elseif nargin < 7, 
        th = label(lbl, xym(1), xym(2), pos);
      elseif nargin < 8,
        th = label(lbl, xym(1), xym(2), pos, lblSiz);
      else
        th = label(lbl, xym(1), xym(2), pos, lblSiz, lblCol);
      end
      if ~holdon, hold off; end
    end
  end
end
