% This function is used for preliminary wing design for best L/D ratio for
% glider design. Density altitude, glider weight, airfoil section, wing
% span and initial gliding speed prior to correction
% The objective to max lift-to-drag ratio. This is achieved by finding an
% optimized set of parameters to produce a lift coefficient at minimal drag
% defined as: CL_minD = sqrt(CD_0/k)

function [LD,CD,CLminD,CL_desc,VminD,alpha] = wingdesign(weight,b,c_r,t_r,V)

weight = 1.5; % (kg)
b =2.05; % wing span (single) (m)
c_r = 0.2; % root chord (m)
t_r = 0.4; % taper ratio (m)
V = 9; % glide velocity (m/s)

% airfoil parameters (guestimated)
t_c = 0.4; % max thickness to chord
x_c = 0.4;
alpha_0 = -4; %NACA 4412

% parameters 
rho = 0.95;
c_t = t_r*c_r;      % tip chord (m)
e = 0.8;        % wing efficiency factor (guestimated)
ang_LE = 0;    % leading edge angle (degrees)

weight = weight*9.81;

% wing aspect ratio
AR = (2*b)/(c_r + c_t);

% wing planform area
S = b^2/AR;

k = 1/(AR*pi*e);

% mean aerodynamic chord (MAC)
c_mac = (2*c_r/3)*(1 + t_r + t_r^2)/(1 + t_r);

% y-location of MAC
y_r = 0; % y-coordinate of the root chord
y_mac = y_r + (b/2)*(1+2*t_r)/(3+3*t_r);

% x_location of MAC
x_r = 0; % x_coordinate of the root chord
x_mac = 0.25*c_mac + x_r + sind(ang_LE)*(1+2*t_r)/(3+3*t_r);

% sweep angle at 1/4 chord
ang_c4 = atand(tand(ang_LE) - (0.25)*(2*c_r/b)*(1-t_r)); %ang_xc(ang_LE,0.25,b,c_r,t_r);

% mach number
M = V/340.3;

% sweep angle at max t/c
ang_tc = atand(tand(ang_LE) - (t_c)*(2*c_r/b)*(1-t_r)); %ang_xc(ang_LE,t_c,b,c_r,t_r);

%------------------base drag calculation------------------------

% Form factor drag
F = (1 + (0.6/x_c)*t_c + 100*t_c^4)*(1.34*M^0.18*(cosd(ang_tc))^0.28);

% Inteference factor
Q = 1.2;

% Friction coefficient
xi = 15.11e-6; % kinematic viscosity of air @ 20C
Rex = V*cosd(ang_LE)*c_mac/xi;

if sqrt(Rex) > 1000
    C_f = 0.455/(((log10(Rex))^2.58)*(1 + 0.144*M^2)^0.65); %turbulent
else
    C_f = 1.328/sqrt(Rex); % laminar
end

% wetted area
if t_c > 0.05
    S_wet = S*(1.977+0.52*t_c); %thick airfoils
else
    S_wet = 2.003*S; % thin airfoils
end

C_D0 = C_f*F*Q*(S_wet/S);
%---------------------------------------------------------------

CLminD = sqrt(C_D0/k);
CL_desc = sqrt(3*C_D0/k);

% weight to sustain maximum L/D

VminD = sqrt((2*weight)/(rho*CLminD*S));
VDesc = sqrt((2*weight)/(rho*CL_desc*S));

CD = C_D0 + k*CLminD^2;

% compute maximum L/D ratio
LD_max = CLminD/CD;

%3-D lift slope
Meff = M*cosd(ang_LE);
beta = sqrt(1-Meff^2);

slope = (2*pi*AR)/(2 + sqrt(4 + ((AR*beta)^2)*(1 + (tand(ang_tc)/beta)^2)));
slope = slope*pi/180;
% trim settings
alpha = CLminD/slope + alpha_0;

% ------ start of subfunction ang_xc

%function y = ang_xc(ang_LE,x_c,b,c_r,t_r)
% sweep angle at any chord x/c location on the wing
%y = atand(tand(ang_LE) - (x_c)*(2*c_r/b)*(1-t_r));

% ----- end of subfunction ang_xc
