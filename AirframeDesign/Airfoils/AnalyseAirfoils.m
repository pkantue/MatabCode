% This script is to batch analyse various airfoils and do some optimization
% on airfoil choice.
% Author: P. Kantue
% Date: June 2020

% To get more datapoints --> https://m-selig.ae.illinois.edu/ads/coord_seligFmt/
clearvars;
close all

COMPUTE_TARGET_CD = 0;
PLOT_FIG = 1;
SAVE_DATA = 0;

%%
name = 'mh60.dat';
fullname = ['Datapoints/' name];
if exist(fullname,'file')
    data = dlmread(['Datapoints/' name],'',1,0);
else
    error('No file exists by that name. Try again');
    return;
end

targetCDperc = 0.15; % target CD for cruise CL
alpha = -5:0.2:8;
c_mac = 0.15;
V = 14;
V_vec = 8:1:20;

for i=1:length(V_vec)
V = V_vec(i);    

xi = 15.11e-6; % kinematic viscosity of air @ 20C
Mach = V/340.3;
Re = V*c_mac/xi;

[pol,foil] = xfoil(data,alpha,Re,Mach,'oper iter 250');

data_pol{1,i}.pol = pol;
data_pol{1,i}.foil = foil;

end
%% plotting
if PLOT_FIG
    figure; plot(pol.alpha,pol.CL); xlabel('\alpha [deg]'); ylabel('CL'); grid on;
    figure; plot(pol.alpha,pol.CD); xlabel('\alpha [deg]'); ylabel('CD'); grid on;
    figure; plot(pol.alpha,pol.Cm); xlabel('\alpha [deg]'); ylabel('Cm'); grid on;
end

%% compute target CD
if COMPUTE_TARGET_CD
    
    minCD = min(pol.CD);
    ind1 = find(pol.alpha >= 0);
    alph_s = pol.alpha(ind1);
    CD_s = pol.CD(ind1);
    CL_s = pol.CL(ind1);
    Cm_s = pol.Cm(ind1);
    
    ind = find( pol.CD(ind1) > (targetCDperc + 1)*minCD,1);
    disp(['TargAlph: ' num2str(alph_s(ind))...
        ' TargCL: ' num2str(CL_s(ind))...
        ' TargCD: ' num2str(CD_s(ind))...
        ' TargCm: ' num2str(Cm_s(ind))...
        ' L/D: ' num2str(CL_s(ind)/CD_s(ind))]);
end

%% save data
if SAVE_DATA
[~,nm,~] = fileparts(name);
save(nm,'foil','pol');
end