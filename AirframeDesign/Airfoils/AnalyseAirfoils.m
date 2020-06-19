% This script is to batch analyse various airfoils and do some optimization
% on airfoil choice.
% Author: P. Kantue
% Date: June 2020

% To get more datapoints --> https://m-selig.ae.illinois.edu/ads/coord_seligFmt/
clearvars;
close all

%% 
name = 'mh62.dat';
fullname = ['Datapoints/' name];
if exist(fullname,'file')
    data = dlmread(['Datapoints/' name],'',1,0);
else
    error('No file exists by that name. Try again');
    return;
end

targetCDperc = 0.15; % target CD for cruise CL
alpha = -5:0.:8;
c_mac = 0.15;
V = 14.5;
xi = 15.11e-6; % kinematic viscosity of air @ 20C
Mach = V/340.3;
Re = V*c_mac/xi;

[pol,foil] = xfoil(data,alpha,Re,Mach,'oper iter 100');

%% plotting

figure; plot(alpha,pol.CL); xlabel('\alpha [deg]'); ylabel('CL'); grid on;
figure; plot(alpha,pol.CD); xlabel('\alpha [deg]'); ylabel('CD'); grid on;
figure; plot(alpha,pol.Cm); xlabel('\alpha [deg]'); ylabel('Cm'); grid on;

%% compute target CD
