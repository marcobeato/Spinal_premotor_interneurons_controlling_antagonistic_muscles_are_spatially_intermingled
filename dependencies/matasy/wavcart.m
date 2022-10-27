% Wavcart class copied from Asymptote

classdef wavcart < handle
  properties
    carts
    Data
    dt
    X
    Y
    minx
    maxx
    xlims
    ylims
    M
    m
    n
    sx
    sy
  end
  methods
    function obj = wavcart(Data_, dt_, m2_)
      if nargin < 1, Data_ = {}; end
      if nargin < 2, dt_ = 1.; end
      if nargin < 3, m2_ = 0; end
      obj.setData(Data_, dt_, m2_);
    end
    function setData(obj, Data_, dt_, m2_)
      if nargin < 2, Data_ = {}; end
      if nargin < 3, dt_ = 1.; end
      if nargin < 4, m2_ = 0; end
      if iscell(Data_)
        obj.Data = Data_;
      else
        if ndims(Data_) == 3
          obj.Data = cell(size(Data_, 1), 1);
          for i = 1: size(Data_, 1)
            obj.Data{i} = Data_(i, :, :);
          end
        elseif ndims(Data_) == 2
          obj.Data = {Data_};
        else 
          error(['Unrecognised input data dimensionality of ', num2str(ndims(Data_))]);
        end
      end
      obj.M = length(obj.Data);
      if length(dt_) == 1
        dt_ = repmat(dt_, [1, obj.M]);
      end
      obj.dt = dt_;
      obj.m = zeros(1, obj.M);
      obj.n = zeros(1, obj.M);
      for i = 1:obj.M
        [obj.m(i), obj.n(i)] = size(obj.Data{i});
      end
      if obj.M < 1, return; end
      obj.carts = cell(obj.M, 1);
      obj.X = cell(obj.M, 1);
      obj.Y = cell(obj.M, 1);
      obj.minx = 0;
      obj.maxx = -inf;
      for i = 1:obj.M
        if (m2_ == 0) || (m2_ >= obj.m(i))
          obj.X{i} = (0:(obj.m(i)-1)) * obj.dt(i);
          obj.Y{i} = obj.Data{i};
        else
          obj.X{i} = linspace(0, (obj.m(i)-1)*obj.dt(i), m2_);
          obj.Y{i} = zeros(m2_, obj.n(i));
          for j = 1:obj.n(i)
            obj.Y{i}(:, j) = minmax(obj.Data{i}(:, j), m2_);
          end
          obj.m(i) = m2_;
        end
        obj.maxx = max(obj.maxx, max(obj.X{i}(:)));
        obj.carts{i} = cart(obj.X{i}, obj.Y{i});
      end
      obj.setSize();

    end
    function setSize(obj, yrel, ymar, xlims_, ylims_, sxy)
      if nargin < 2, yrel = []; end
      if nargin < 3, ymar = -0.01; end
      if nargin < 4, xlims_ = [0,0]; end
      if nargin < 5, ylims_ = []; end
      if nargin < 6, sxy = [1., 1.]; end
      obj.sx = sxy(1);
      obj.sy = sxy(2);
      if obj.M < 1, return; end
      obj.xlims = xlims_;
      obj.ylims = ylims_;
      if (obj.xlims(1) == obj.xlims(2))
        obj.xlims = [obj.minx, obj.maxx];
      end
      if isempty(obj.ylims)
        obj.ylims = zeros(obj.M, 2);
        for i = 1:obj.M
          obj.ylims(i, 1) = min(obj.Y{i}(:));
          obj.ylims(i, 2) = max(obj.Y{i}(:));
        end
      end

      if isempty(yrel) && obj.M > 0
        yrel = repmat(1./obj.M, [1, obj.M, 1]);
      end
      ysum = sum(yrel);
      if ymar < 0., ymar = -ymar *abs(ysum); end

      ysiz = obj.sy * yrel / ysum;
      yi = obj.sy;
      for i = 1:obj.M
        obj.carts{i}.calcXY(0., obj.sx, yi - ysiz(i), yi, ...
                           obj.xlims(1), obj.xlims(2), obj.ylims(i, 1), obj.ylims(i, 2));
        yi = yi - (ysiz(i) + ymar);
      end
    end
    function P = draw(obj, spec)
      P = cell(obj.M, 1);
      for i = 1:obj.M
        if nargin < 2,
          P{i} = obj.carts{i}.drawgraph();
        elseif isstr(spec)
          P{i} = obj.carts{i}.drawgraph(spec);
        elseif isnumeric(spec)
          P{i} = obj.carts{i}.drawgraph(spec);
        else
          P{i} = obj.carts{i}.drawgraph(spec{i});
        end
      end
    end
    function [mY, P] = drawmean(obj, spec)
      mY = cell(obj.M, 1);
      P = cell(obj.M, 1);
      for i = 1:mY
        mX = obj.carts{i}.X;
        mY{i} = mean(obj.Y, 2)
        if length(mY{i}) > length(mX)
          mY{i} = minmax(mY{i}, length(mX));
        end
        if nargin < 2
          P{i} = plot(mX, mY{i});
        elseif isstr(spec)
          P{i} = plot(mX, mY{i}, spec);
        else
          P{i} = plot(mX, mY{i}, spec{i});
        end
      end
    end
    function [ph, th] = xscale(obj, barpos, value, units, lblpos, linecols, lblcols)
      if nargin < 2, barpos = []; end
      if nargin < 3, value = []; end
      if nargin < 4, units = []; end
      if nargin < 5, lblpos = []; end
      if nargin < 6, linecols = []; end
      if nargin < 7, lblcols = []; end
      if isempty(barpos), barpos = repmat([0, -1], [obj.M, 1]); end
      if isempty(value)
        value = zeros(1, obj.M);
        for i = 1:M
          value(i) = nearmag(0.5 * abs(obj.xlims(1) - obj.xlims(2)));
        end
      end
      if isempty(units), units = repmat({'units'}, [1, obj.M]); end
      if isempty(lblpos), lblpos = repmat({'s'}, [1, obj.M]); end
      if isempty(linecols), linecols = repmat({'k'}, [1, obj.M]); end
      if isempty(lblcols), lblcols = repmat({'k'}, [1, obj.M]); end
      if isstr(units), units = repmat({units}, [1, obj.M]); end
      if isstr(lblpos), lblpos = repmat({lblpos}, [1, obj.M]); end
      if isstr(linecols), linecols = repmat({linecols}, [1, obj.M]); end
      if isstr(lblcols), lblcols = repmat({lblcols}, [1, obj.M]); end

      ph = cell(1, obj.M);
      th = cell(1, obj.M);
      for i = 1:obj.M
        xym = [0.5 * (barpos(i, 1)+1) * (obj.xlims(2) - obj.xlims(1)) + obj.xlims(1), ...
               0.5 * (barpos(i, 2)+1) * (obj.ylims(i, 2) - obj.ylims(i, 1)) + obj.ylims(i, 1)];
        xy0 = [xym(1) - 0.5 * value(i), xym(2)];
        xy1 = [xym(1) + 0.5 * value(i), xym(2)];
        XY0 = zeros(1, 2);
        XY1 = zeros(1, 2);
        [XY0(1), XY0(2)] = obj.carts{i}.xy2XY(xy0(1), xy0(2));
        [XY1(1), XY1(2)] = obj.carts{i}.xy2XY(xy1(1), xy1(2));
        if any(xy0(:) ~= xy1(:))
          lblstr = [num2str(value(i)), ' ', units{i}]; 
          [ph{i}, th{i}] = obj.carts{i}.linelabel(XY0, XY1, linecols{i}, lblstr, lblpos{i});
        end
      end
    end
    function [ph, th] = yscale(obj, barpos, value, units, lblpos, linecols)
      if nargin < 2, barpos = []; end
      if nargin < 3, value = []; end
      if nargin < 4, units = []; end
      if nargin < 5, lblpos = []; end
      if nargin < 6, linecols = []; end
      if nargin < 7, lblcols = []; end
      if isempty(barpos), barpos = repmat([-1, 0], [obj.M, 1]); end
      if isempty(value)
        value = zeros(1, obj.M);
        for i = 1:M
          value(i) = nearmag(0.5 * abs(obj.ylims(i, 1) - obj.ylims(i, 2)));
        end
      end
      if isempty(units), units = repmat({'units'}, [1, obj.M]); end
      if isempty(lblpos), lblpos = repmat({'w'}, [1, obj.M]); end
      if isempty(linecols), linecols = repmat({'k'}, [1, obj.M]); end
      if isempty(lblcols), lblcols = repmat({'k'}, [1, obj.M]); end
      if isstr(units), units = repmat({units}, [1, obj.M]); end
      if isstr(lblpos), lblpos = repmat({lblpos}, [1, obj.M]); end
      if isstr(linecols), linecols = repmat({linecols}, [1, obj.M]); end
      if isstr(lblcols), lblcols = repmat({lblcols}, [1, obj.M]); end

      ph = cell(1, obj.M);
      th = cell(1, obj.M);
      for i = 1:obj.M
        xym = [0.5 * (barpos(i, 1)+1) * (obj.xlims(2) - obj.xlims(1)) + obj.xlims(1), ...
               0.5 * (barpos(i, 2)+1) * (obj.ylims(i, 2) - obj.ylims(i, 1)) + obj.ylims(i, 1)];
        xy0 = [xym(1), xym(2) - 0.5 * value(i)];
        xy1 = [xym(1), xym(2) + 0.5 * value(i)];
        XY0 = zeros(1, 2);
        XY1 = zeros(1, 2);
        [XY0(1), XY0(2)] = obj.carts{i}.xy2XY(xy0(1), xy0(2));
        [XY1(1), XY1(2)] = obj.carts{i}.xy2XY(xy1(1), xy1(2));
        if any(xy0(:) ~= xy1(:))
          lblstr = [num2str(value(i)), ' ', units{i}]; 
          [ph{i}, th{i}] = obj.carts{i}.linelabel(XY0, XY1, linecols{i}, lblstr, lblpos{i});
        end
      end
    end
  end
end

