% A figure example file

% PARAMETERS

% Figure settings
nrows = 2;                                  % Number of rows in pnel grid
ncols = 3;                                  % Number of columns in panel grid
sizex = 12;                                 % Absolute width of figure (in cm)
sizey = 10;                                 % Absolute height of figure (in cm)
margx = 0.1;                                % x-margin between and around panels (normalised units)
margy = 0.1;                                % y-margin between and around panels (normalised units)
labelalign = 'sw';                          % NESW alignment of labels
labelfsize = 24;                            % Label font size
lblcol = 'k';                               %label color
% ADC settings
sampinterv = 0.001;                         % Sampling interval (nominal here)
colours = {'r', [0, 0.5, 0], 'b'};          % Colours used to plot ADC data
xunits = {'cm', 'cm', 'cm'};                % Units of x-scale bars
xscalebars = [0, 0, 0.1];                   % Size of x-scale bars
xscalebarpos = [0, 0; 0, 0; 0.8, 1.];       % Position of xscale-bars in normalised units
xscalelblpos = ['', '', 's'];               % NESW alignment of scale bar text
yunits = {'units', 'units', 'units'};       % Units of y-scale bars
yscalebars = [150, 200, 200];               % Size of y-scale bars
yscalebarpos = [-1, 0.4; -1, 0.4; -1, 0.4]; % Position of yscale-bars in normalised units
yscalelblpos = ['n', 'n', 'n'];             % NESW alignment of scale bar text
scalebarlinewidth = 2;                      % Size of lines drawn for scale bars

% Group data settings
nboxes = 8;                                 % Number of boxes to plot per graph
xlimits = [0.5, 8.5];                       % Box-plot x-limits
ylimits = [0, 270];                         % Box-plot y-limits
xlbl = 'Position';                          % Box-plot x-label
ylbl = 'Measure / units';                   % Box-plot y-label

% INPUT

% Read MATLAB demo figure
rgb = imread('peppers.png');

% Generate ADC Data
adc = {double(rgb(:, :, 1)), double(rgb(:, :, 2)), double(rgb(:, :, 3))};
%adc = {(rgb(:, :, 1)), (rgb(:, :, 2)), (rgb(:, :, 3))};


% Generate group data (this is contrived code just to simulate data)
c = size(rgb, 1) * size(rgb, 2) / nboxes;
Data = cell(1, 3);
for i = 1:3, Data{i} = reshape(rgb(:, :, i), [c, nboxes]); end 

% PROCESSING 

% Enter ADC data and sampling interval to a virtual axes wave-plotter class instance
ADC = wavcart();  % first assignment gives properties to ADC (instantiation)
ADC.setData(adc, sampinterv); %assigns data to ADC (setData is on of the methods)
%ADC.setSize([2/5 2/5 1/5]); %setSize is another methods

% OUTPUT

fh = figure();
h = 0;
Panels = panels([nrows, ncols], [sizex, sizey], 1, [margx, margy]); % Initialise panel class instance
Panels.setLabels(Panels.lbl, labelalign, labelfsize, lblcol);       % Configure labels
Panels.tweak(1, [-0.2, -0.0], [2, 0.9]);                            % Offset and resize 
Panels.tweak(2, [0.7, -0.0], [1.4, 0.9]);                           % panels (using
Panels.tweak(5, [0.12, 0.0], [0.9, 1.0]);                           % normalised
Panels.tweak(6, [0.1, 0.0], [0.9, 1.0]);                            % units)

% Panel 1

h = h + 1; ax = Panels.setPanel(h);                                 % Begin drawing panel 1
imshow(rgb);                                                        % Just show the image

% Panel 2

h = h + 1; ax = Panels.setPanel(h);                                 % Begin drawing panel 2
ADC.draw(colours);                                                  % Plot the ADC traces on virtual axes
axis off;
xscales = ADC.xscale(xscalebarpos, xscalebars, xunits, xscalelblpos);  % Scale bars
set(xscales{end}, 'linewidth', scalebarlinewidth);
[yscales, ylabels]= ADC.yscale(yscalebarpos, yscalebars, yunits, yscalelblpos);
for i = 1:length(yscales) 
  set(yscales{i}, 'linewidth', scalebarlinewidth);
  set(ylabels{i}, 'rotation', 90);
end
set(gca, 'xlim', [0, 1]); set(gca, 'ylim', [0, 1]);                 % Virtual axes assumes normalised real axes

% Panels 3-5
h = h + 1;
for i = 1:3
  h = h + 1; ax = Panels.setPanel(h);                               % Begin drawing panel h
  boxplot(Data{i});                                                 % Box-plot of data
  set(ax, 'xlim', xlimits);
  set(ax, 'ylim', ylimits);
  xlabel(xlbl);
  if i == 1, ylabel(ylbl); else set(ax, 'yticklabels', {}); end
  box off; 
end

% Add labels and finalise figure
lh = Panels.addLabel(1, 'A', [-0.1, 0]); set(lh, 'Color', 'w');     % Change colour of A label
Panels.addLabel(2, 'B', [0.05, 0]);
Panels.addLabel(4, 'C', [0.14, 0]);
Panels.addLabel(5, 'D', [-0.15, 0]);
Panels.addLabel(6, 'E', [-0.15, 0]);

Panels.addPanels();

