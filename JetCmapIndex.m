%% Jet Colormap indexing for 1-D vector
% This only for JET COLORMAP as specified in Matlab Colormap editor!!

% CODE LIMITATIONS
% ================
%
%
% Author: P. Kantue

% Version Control
%----------------
% 04/13         - Baseline
% 05/14         - Changed how the algorithm executes the max parameters
%                 Added choice variable to distinguish between probability
%                 and normal scatter variable.
% 03/14         - Corrected the offset calculation that would set the range
%                 between 0 and 1 for color specification

%% Start of Code
function [ColorSpec] = JetCmapIndex(vector,choice)

% get min value
vec_min = min(vector);
if (vec_min < 0)
    error('Only +ve values are permitted');
end

% if nxm matrix return error
vec_size = size(vector,2);
if (vec_size > 1)
    error('Only 1-D vector is permitted');
end

% get max value
if (choice == 0)
    vec_max = 100;
    data_set = vector/vec_max;
else    
    vec_min = min(vector);
    % remove offset (start at 0) and re-scale values to fall within band [0 1]
    data_set = vector - vec_min;
    data_set = data_set/max(data_set);
end

% given a value from 0 to 1, a specific RGB value from the JET COLORMAP
% spectrum can be selected

ColorSpec = [];

for i = 1:length(data_set)
    x = data_set(i);  
    
        %% Color Index 8/64 and below
    if (x <= 8/64)
        R_pix = 0;
        G_pix = 0;
        B_pix = (143 + ((255-143)/(8/64))*x)/255;
        %% Color Index 24/64 and below
    elseif (x <= 24/64)
        R_pix = 0;
        G_pix = (0 + ((255-0)/(24/64 - 8/64))*(x - 8/64))/255;
        B_pix = 255/255;
        %% Color Index 40/64 and below
    elseif (x <= 40/64)
        R_pix = (0 + ((255-0)/(40/64 - 24/64))*(x - 24/64))/255;
        G_pix = 255/255;
        B_pix = (255 + ((0-255)/(40/64 - 24/64))*(x - 24/64))/255;
        %% Color Index 56/64 and below
    elseif (x <= 56/64)
        R_pix = 255/255;
        G_pix = (255 + ((0-255)/(56/64 - 40/64))*(x - 40/64))/255;
        B_pix = 0;
        %% Color Index 56/64 and below
    elseif (x <= 64/64)
        R_pix = (255 + ((128-255)/(64/64 - 56/64))*(x - 56/64))/255;
        G_pix = 0;
        B_pix = 0;
    end
    temp = [R_pix G_pix B_pix];
    ColorSpec = [ColorSpec ; temp];    
end
