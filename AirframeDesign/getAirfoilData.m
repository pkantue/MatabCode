% This script is to extract the airfoil characteristics to be used in wing
% design (mainly t/c and x/c ratios
% Author: P. Kantue
% Date: June 2020

function [t_c,x_c] = getAirfoilData(name)
data = dlmread(['Airfoils/Datapoints/' name],'',1,0);

%% compute maximum thickness

% find the trailing edge by inflection point
[val,ind] = min((data(:,1)));
pos_e = data(ind,:);

% compute the line gradient y/x
grad = (data(1,2) - pos_e(1,2))/(data(1,1) - pos_e(1,1));

% compute y-shift from center line
x_s = linspace(0,1,200);
y_s = grad.*x_s;

% create the two lines
line1 = data(1:ind,:);
line2 = data(ind+1:end,:);

% compute interpolated y-axis lines
thick1 = interp1(line1(:,1),line1(:,2),x_s);
thick2 = interp1(line2(:,1),line2(:,2),x_s);

% compute camber line (distance from chord line)
camber = (thick1 - thick2)./2 - y_s;

% compute thickness
s_t = abs(thick1) + abs(thick2);

% get (t/c) and its location 
[val,ind] = max(s_t);

t_c = val/max(x_s);
x_c = x_s(ind);
