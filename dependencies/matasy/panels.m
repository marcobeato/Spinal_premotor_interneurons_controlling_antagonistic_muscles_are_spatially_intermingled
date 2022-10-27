% Panels class copied from Asymptote

classdef panels < handle
  properties
    ax
    defm
    oxy
    xyo
    xya
    pos
    rxym
    xym
    xys
    dxy
    rc
    r
    c
    n
    siz
    keepAspect
    lbl
    lblalign
    lblsiz
    lblcol
    nudges
    fudges
  end
  methods
    function obj = panels(rc_, siz_, keepAspect_, rxym_)
      obj.defm = [0.15, 0.15];
      if nargin < 1, rc_ = [0, 0]; end
      if nargin < 2, siz_ = [0, 0]; end
      if nargin < 3, keepAspect_ = true; end
      if nargin < 4, rxym_ = obj.defm; end
      obj.initialise(rc_, siz_, keepAspect_, rxym_);
    end
    function initialise(obj, rc_, siz_, keepAspect_, rxym_)
      if nargin < 2, rc_ = [0, 0]; end
      if nargin < 3, siz_ = [0, 0]; end
      if nargin < 4, keepAspect_ = true; end
      if nargin < 5, rxym_ = obj.defm; end
      obj.setLabels();
      obj.setMarg(rxym_);
      obj.setDims(rc_);
      obj.setSize(siz_, keepAspect_);
      if obj.siz(1) * obj.siz(2) <= 0 || obj.n <= 0
        return;
      end
      obj.calcSize();
    end
    function oxy_ = calcOrig(obj, xyo_)
      if nargin < 2, xyo_ = [0, 0]; end
      oxy_ = xyo_ + [0.5, 1.] .* obj.xym;
    end
    function setMarg(obj, rxym_)
      if nargin < 2, rxym_ = obj.defm; end
      obj.rxym = rxym_;
      obj.xym = obj.rxym;
    end
    function setDims(obj, rc_)
      if nargin < 2, rc_ = [0, 0]; end
      obj.rc = rc_;
      obj.r = obj.rc(1);
      obj.c = obj.rc(2);
      obj.n = obj.r * obj.c;
      if ~obj.n, return; end
      obj.ax = cell(1, obj.n);
      obj.nudges = zeros(obj.n, 2);
      obj.fudges = ones(obj.n, 2);
      obj.calcSize();
    end
    function setSize(obj, siz_, keepAspect_)
      if nargin < 2, siz_ = [0, 0]; end
      if nargin < 3, keepAspect = true; end
      obj.siz = siz_;
      obj.keepAspect = keepAspect_;
      obj.calcSize();
    end
    function calcSize(obj)
      obj.dxy = [0, 0];
      obj.xym = [0, 0];
      obj.xys = [0, 0];
      %if obj.siz(1) == 0 || obj.siz(2) == 0, return; end
      if obj.rc(1)  == 0 || obj.rc(2)  == 0, return; end
      % obj.dxy = [obj.siz(1) / obj.c, obj.siz(2) / obj.r);
      obj.dxy = [1. / obj.c, 1. / obj.r]; % subplot() uses normalised units
      obj.xym = [obj.rxym(1) * obj.dxy(1), obj.rxym(2) * obj.dxy(2)];
      obj.xys = [obj.dxy(1) - obj.xym(1), obj.dxy(2) - obj.xym(2)];
    end
    function nudge(obj, i, nudge_)
      if nargin < 2, i = 1; end
      if nargin < 3, nudge_ = [0, 0]; end
      obj.nudges(i, :) = nudge_;
    end
    function fudge(obj, i, fudge_)
      if nargin < 2, i = 1; end
      if nargin < 3, fudge_ = [1, 1]; end
      obj.fudges(i, :) = fudge_;
    end
    function tweak(obj, i, nudge_, fudge_)
      if nargin < 2, i = 1; end
      if nargin < 3, nudge_ = [0, 0]; end
      if nargin < 4, fudge_ = [1, 1]; end
      obj.nudge(i, nudge_)
      obj.fudge(i, fudge_)
    end
    function nv = notValid(obj, i)
      nv = true;
      if nargin < 2, i = 0; end
      if i > obj.n
        disp('Warning: panel.notValid(): panel index exceeds row and column specification');
      end
      if (obj.xys(1) == 0. || obj.xys(2) == 0.), return; end
      if obj.n < 1, return; end
      nv = false;
    end
    function xy = calcPos(obj, i) % Note this differs slightly from asymptote version
      if nargin < 2,  i = 1; end
      xy = [0, 0];
      if obj.notValid(i), return; end
      ri = floor((i-1)/obj.c);
      if ri <= 0
        ci = i - 1;
      else
        ci = (i - 1) - obj.c*ri;
      end
      ri = obj.r - ri;
      obj.xyo = obj.calcOrig();
      xy = obj.xyo + [obj.dxy(1) * ci, obj.dxy(2) * (ri-1)];
    end
    function a = setPanel(obj, i)
      a = [];
      if nargin < 2, i = 1; end
      if obj.notValid(i), return; end
      xy = obj.calcPos(i);
      position = [xy(1), xy(2), obj.xys(1), obj.xys(2)];
      position(1) = position(1) + obj.nudges(i, 1) * obj.xys(1);
      position(2) = position(2) + obj.nudges(i, 2) * obj.xys(2);
      position(3) = position(3) * obj.fudges(i, 1);
      position(4) = position(4) * obj.fudges(i, 2);
      obj.ax{i} = subplot('position', position);
      a = obj.ax{i};
    end
    function setLabels(obj, lbl_, lblalign_, lblsiz_, lblcol_)
      if nargin < 2, lbl_ = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; end
      if nargin < 3, lblalign_ = 'nw'; end
      if nargin < 4, lblsiz_ = 12; end
      if nargin < 5, lblcol_ = 'k'; end
      obj.lbl = lbl_;
      obj.lblalign = lblalign_;
      obj.lblsiz = lblsiz_;
      obj.lblcol = lblcol_;
    end
    function [lbl, pos] = addLabel(obj, i, indoffset, offset) % modified from asymptote version
      if nargin < 2, i = 1; end
      if nargin < 3, indoffset = 0; end
      if nargin < 4, offset = [0,0]; end
      if isstr(indoffset)
        L = indoffset;
      else
        L = obj.lbl(i + indoffset);
      end
      pos = false;
      a = obj.ax{i};
      if isempty(a), return; end
      xlim = get(a, 'xlim');
      ylim = get(a, 'ylim');
      if strcmp(get(a, 'XDir'), 'reverse'), xlim = fliplr(xlim); end
      if strcmp(get(a, 'YDir'), 'reverse'), ylim = fliplr(ylim); end
      pos = [xlim(1) - diff(xlim)*offset(1), ylim(2) + diff(ylim)*offset(2)];
      axes(a);
      lbl = label(L, pos(1), pos(2), obj.lblalign, obj.lblsiz, obj.lblcol);
    end 
    function addLabels(obj, I, indoffset, offset); 
      if nargin < 2, I = 1:obj.n; end
      if nargin < 3, indoffset = 0; end
      if nargin < 4, offset = [0,0]; end
      for k = 1:length(I)
        obj.addLabel(I(k), indoffset, offset);
      end
    end
    function addPanel(obj, i, bgcol) % modified from asymptote version
      if nargin < 2, i = 1; end
      if nargin < 3, bgcol = 'w'; end
      if obj.notValid(i), return; end
      if isempty(obj.ax{i}), return; end
      set(gcf, 'Color', bgcol);
      set(gcf, 'MenuBar', 'none');
      set(gca, 'Color', bgcol);
      if ~all(obj.siz), return; end
      set(gcf, 'PaperSize', obj.siz);
      if obj.siz(1) > obj.siz(2)
        orient landscape;
      else
        orient portrait;
      end
      if obj.keepAspect
        pos = get(gcf, 'Position');
        pos(3) = round(obj.siz(1)*72);
        pos(4) = round(obj.siz(2)*72);
        pos(1) = round(pos(3) / 2);
        pos(2) = pos(4) - round(pos(1));
        set(gcf, 'Position', pos);
      end
    end
    function addPanels(obj, I, bgcol)
      if nargin < 2, I = 1:obj.n; end
      if nargin < 3, bgcol = 'w'; end
      for k = 1:length(I)
        obj.addPanel(I(k), bgcol);
      end
    end
  end
end
