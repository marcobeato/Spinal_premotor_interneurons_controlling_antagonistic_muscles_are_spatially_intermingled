function [pf] = exportfigure(type, res)
% function [pf] = exportfigure(type, res)
%
% Exports current figure as a picture
% file using a UI dialogue box to
% preserving the figure background.
% Without any input argument, a colour 
% Level 2 EPS is used. Otherwise
% the 'type' variable gives the format
% as defined by PRINT. Res (see PRINT)
% sets the export resolution (default
% '-r600'. 
%
% The output path and filename are outputted.

% Gary Bhumbra.

if nargin < 1; type = '-depsc2'; end
if nargin < 2, res = '-r600'; end
typeStr = '*.*';

switch type
case '-deps2', typeStr = {'*.eps';'*.*'};
case '-depsc2', typeStr = {'*.eps';'*.*'};
case '-dtiffnocompression', typeStr = {'*.tif';'*.*'};    
case '-dtiff', typeStr = {'*.tif';'*.*'}; 
case '-djpeg100', typeStr = {'*.jpg';'*.*'};
end

[fname, pname] = uiputfile(typeStr, 'Export Figure');

if fname;
    
    pf = strcat(pname, fname);

    prevsetting = get(gcf, 'InvertHardcopy');

    set(gcf, 'InvertHardcopy', 'off');

    print(gcf, type, pf, res);
    
    set(gcf, 'InvertHardcopy', prevsetting);
    
end
