% ------------------------------------------------------------------------- 
% ------------------------------------------------------------------------- 
%                         ZOOMPLOT 
%  
% This function zooms your plot. 
% Enter:        [] = zoomPlot (figureNumber,axis1,zoom1,axis2,zoom2,axis3,zoom3); 
% Module:       Visualization 
% Version:      0.1 
%  
% Inputs:       figureNumber        number of figure        [double]
%               axis1               name of axis 1          [char]
%               zoom1               zoom range for axis 1   [double]
%               axis2               name of axis 2          [char]
%               zoom2               zoom range for axis 2   [double]
%               axis3               name of axis 3          [char]
%               zoom3               zoom range for axis 3   [double]
% Outputs:      -
% Functions:    - 
%  
% Description:  This function zooms your plot defined by figure number, 
%               axis and corresponding range.
% Limitations:  Not perfectly applicable for subplot figures with different  
%               axis ranges. 
% Assumptions:  - 
% 
% Example 1:    plot(1:10,21:30)
%               zoomPlot ('x',[4 8],'y',[23 28]);
%
% Example 2:    figure(1)
%               plot(1:10,21:30)
%               [X,Y] = meshgrid(-8:.5:8);
%               R = sqrt(X.^2 + Y.^2) + eps;
%               Z = sin(R)./R;
%               figure(10)
%               mesh(Z);
%               zoomPlot (10,'x',[10 24],'y',[10 24],'z',[0 1]);

% Author:       S.Herbst 
% Date:         2014-7-13
% MATLAB:       R2013a 
% Contact:      sebastian.herbstmatlab@yahoo.de 
% Copyright:    2014 Sebastian Herbst
% ------------------------------------------------------------------------- 

function [] = zoomPlot (figureNumber,axis1,zoom1,axis2,zoom2,axis3,zoom3)
%% Check if figure handle exists
figureHandles   = findobj('Type','figure');
if isempty(figureHandles) == false
    %% No figure number defined and zoom one axis
    if nargin == 2
        if length(figureHandles) == 1 && ischar(figureNumber) == true
            children    = get(figureHandles,'Children');
            axes        = handle(children);
            % Rename input variables >> figureNumber is axis1; axis1 is zoom1
            if strcmpi(figureNumber,'x') == 1
                if length(axis1) == 2
                    set(axes,'Xlim',[axis1(1),axis1(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(figureNumber,'y') == 1
                if length(axis1) == 2
                    set(axes,'Ylim',[axis1(1),axis1(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(figureNumber,'z') == 1
                if length(axis1) == 2
                    set(axes,'Zlim',[axis1(1),axis1(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            else
                warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
            end
        else
            warning('ZOOMPLOT:Input','Define figure number if more than one is currently open, or axis and corresponding zoom range required!')
        end
    elseif nargin == 3
        %% Figure number defined and zoom one axis
        if figureNumber >= 1 && mod(figureNumber,1) == 0      
            exist = ismember(figureHandles,figureNumber);
            if sum(exist) == 1
                children    = get(figureHandles(exist),'Children');
                axes        = handle(children);
                if strcmpi(axis1,'x') == 1
                    if length(zoom1) == 2
                        set(axes,'Xlim',[zoom1(1),zoom1(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis1,'y') == 1
                    if length(zoom1) == 2
                        set(axes,'Ylim',[zoom1(1),zoom1(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis1,'z') == 1
                    if length(zoom1) == 2
                        set(axes,'Zlim',[zoom1(1),zoom1(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                else
                    warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
                end
            else
                warning('ZOOMPLOT:Handle','Figure can not be found!')
            end
        else
            warning('ZOOMPLOT:Handle','Required figure can not be found!')
        end
    elseif nargin == 4
        %% No figure number defined and zoom two axes
        if length(figureHandles) == 1 && ischar(figureNumber) == true && ischar(zoom1) == true
            children    = get(figureHandles,'Children');
            axes        = handle(children);
            % Axis 1: rename input variables >> figureNumber is axis1; axis1 is zoom1
            if strcmpi(figureNumber,'x') == 1
                if length(axis1) == 2
                    set(axes,'Xlim',[axis1(1),axis1(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(figureNumber,'y') == 1
                if length(axis1) == 2
                    set(axes,'Ylim',[axis1(1),axis1(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(figureNumber,'z') == 1
                if length(axis1) == 2
                    set(axes,'Zlim',[axis1(1),axis1(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            else
                warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
            end
            % Axis 2: rename input variables >> zoom1 is axis2; axis2 is zoom2
            if strcmpi(zoom1,'x') == 1
                if length(axis2) == 2
                    set(axes,'Xlim',[axis2(1),axis2(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(zoom1,'y') == 1
                if length(axis2) == 2
                    set(axes,'Ylim',[axis2(1),axis2(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(zoom1,'z') == 1
                if length(axis2) == 2
                    set(axes,'Zlim',[axis2(1),axis2(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            else
                warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
            end
        else
            warning('ZOOMPLOT:Input','Define figure number if more than one is currently open, or axis and corresponding zoom range required!')
        end
    elseif nargin == 5
        %% Figure number defined and zoom two axes
        if figureNumber >= 1 && mod(figureNumber,1) == 0       
            exist = ismember(figureHandles,figureNumber);
            if sum(exist) == 1
                children    = get(figureHandles(exist),'Children');
                axes        = handle(children);
                if strcmpi(axis1,'x') == 1
                    if length(zoom1) == 2
                        set(axes,'Xlim',[zoom1(1),zoom1(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis1,'y') == 1
                    if length(zoom1) == 2
                        set(axes,'Ylim',[zoom1(1),zoom1(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis1,'z') == 1
                    if length(zoom1) == 2
                        set(axes,'Zlim',[zoom1(1),zoom1(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                else
                    warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
                end
                if strcmpi(axis2,'x') == 1
                    if length(zoom1) == 2
                        set(axes,'Xlim',[zoom2(1),zoom2(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis2,'y') == 1
                    if length(zoom1) == 2
                        set(axes,'Ylim',[zoom2(1),zoom2(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis2,'z') == 1
                    if length(zoom1) == 2
                        set(axes,'Zlim',[zoom2(1),zoom2(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                else
                    warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
                end
            else
                warning('ZOOMPLOT:Handle','Figure can not be found!')
            end
        else
            warning('ZOOMPLOT:Handle','Required figure can not be found!')
        end
    elseif nargin == 6
        %% No figure number defined and zoom three axes
        if length(figureHandles) == 1 && ischar(figureNumber) == true && ischar(zoom1) == true
            children    = get(figureHandles,'Children');
            axes        = handle(children);
            % Axis 1: rename input variables >> figureNumber is axis1; axis1 is zoom1
            if strcmpi(figureNumber,'x') == 1
                if length(axis1) == 2
                    set(axes,'Xlim',[axis1(1),axis1(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(figureNumber,'y') == 1
                if length(axis1) == 2
                    set(axes,'Ylim',[axis1(1),axis1(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(figureNumber,'z') == 1
                if length(axis1) == 2
                    set(axes,'Zlim',[axis1(1),axis1(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            else
                warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
            end
            % Axis 2: rename input variables >> zoom1 is axis2; axis2 is zoom2
            if strcmpi(zoom1,'x') == 1
                if length(axis2) == 2
                    set(axes,'Xlim',[axis2(1),axis2(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(zoom1,'y') == 1
                if length(axis2) == 2
                    set(axes,'Ylim',[axis2(1),axis2(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(zoom1,'z') == 1
                if length(axis2) == 2
                    set(axes,'Zlim',[axis2(1),axis2(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            else
                warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
            end
            % Axis 3: rename input variables >> zoom2 is axis3; axis3 is zoom3
            if strcmpi(zoom2,'x') == 1
                if length(axis3) == 2
                    set(axes,'Xlim',[axis3(1),axis3(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(zoom2,'y') == 1
                if length(axis3) == 2
                    set(axes,'Ylim',[axis3(1),axis3(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            elseif strcmpi(zoom2,'z') == 1
                if length(axis3) == 2
                    set(axes,'Zlim',[axis3(1),axis3(2)])
                else
                    warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                end
            else
                warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
            end
        else
            warning('ZOOMPLOT:Input','Define figure number if more than one is currently open, or axis and corresponding zoom range required!')
        end
    elseif nargin == 7
        %% Figure number defined and zoom two axes
        if figureNumber >= 1 && mod(figureNumber,1) == 0       
            exist = ismember(figureHandles,figureNumber);
            if sum(exist) == 1
                children    = get(figureHandles(exist),'Children');
                axes        = handle(children);
                if strcmpi(axis1,'x') == 1
                    if length(zoom1) == 2
                        set(axes,'Xlim',[zoom1(1),zoom1(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis1,'y') == 1
                    if length(zoom1) == 2
                        set(axes,'Ylim',[zoom1(1),zoom1(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis1,'z') == 1
                    if length(zoom1) == 2
                        set(axes,'Zlim',[zoom1(1),zoom1(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                else
                    warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
                end
                if strcmpi(axis2,'x') == 1
                    if length(zoom1) == 2
                        set(axes,'Xlim',[zoom2(1),zoom2(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis2,'y') == 1
                    if length(zoom1) == 2
                        set(axes,'Ylim',[zoom2(1),zoom2(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis2,'z') == 1
                    if length(zoom1) == 2
                        set(axes,'Zlim',[zoom2(1),zoom2(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                else
                    warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
                end
                if strcmpi(axis3,'x') == 1
                    if length(zoom1) == 2
                        set(axes,'Xlim',[zoom3(1),zoom3(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis3,'y') == 1
                    if length(zoom1) == 2
                        set(axes,'Ylim',[zoom3(1),zoom3(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                elseif strcmpi(axis3,'z') == 1
                    if length(zoom1) == 2
                        set(axes,'Zlim',[zoom3(1),zoom3(2)])
                    else
                        warning('ZOOMPLOT:Input','Two inputs for zoom range required!')
                    end
                else
                    warning('ZOOMPLOT:Input','''x'', ''y'' or ''z'' required as axis input!')
                end
            else
                warning('ZOOMPLOT:Handle','Figure can not be found!')
            end
        else
            warning('ZOOMPLOT:Handle','Required figure can not be found!')
        end
    else
        warning('ZOOMPLOT:Input','Too less input arguments')
    end
else
    warning('ZOOMPLOT:Handle','No figure handles can be found!')
end
end

% Revision history: 
%{
%       2014-7-13
        v0.1 was created by SH
%}