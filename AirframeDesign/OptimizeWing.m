% This script computes the optimal static stability using an optimization
% function given the various parameters variations

clearvars;
COMPUTE_THEORY = 0;
COMPUTE_XFOIL = 1; %takes into account boundary later viscosity (2D)

%%
weight = 1.5; % (kg)
b = 2.05; % wing span (single) (m)
c_r = 0.25; % root chord (m)
t_r = 0.8; % taper ratio (m)
ang_LE = 25; % leading edge angle (degrees)
V0 = 9; % initial cruise velocity (m/s)

V = V0; % initial theoretical value

% airfoil parameters
name = 'mh60.dat';
[t_c,x_c] = getAirfoilData(name);

% parameters
rho = 0.95;
xi = 15.11e-6; % kinematic viscosity of air @ 20C
c_t = t_r*c_r;      % tip chord (m)
e = 0.8;        % wing efficiency factor (guestimated)

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

% sweep angle at max t/c
ang_tc = atand(tand(ang_LE) - (t_c)*(2*c_r/b)*(1-t_r)); %ang_xc(ang_LE,t_c,b,c_r,t_r);

%% 2-D emperical computation
if COMPUTE_THEORY
    
    % execute until the correct velocity is achieved
    VminD = 0;
    err = VminD - V;
    
    while abs(err) > 1e-3
        
        % mach number
        M = V/340.3;
        
        %------------------base drag calculation------------------------
        
        % Form factor drag
        F = (1 + (0.6/x_c)*t_c + 100*t_c^4)*(1.34*M^0.18*(cosd(ang_tc))^0.28);
        
        % Inteference factor
        Q = 1.2;
                
        Rex = V*c_mac/xi;
        
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
        
        % handle of velocity error dynamics
        err = VminD - V;
        dV = err*0.05;
        V = V + dV;
        
    end
    
    %
    CD = C_D0 + k*CLminD^2;
    
    % compute maximum L/D ratio
    LD_max = CLminD/CD;
    
end
%% Xfoil resulting 2D L/D
if COMPUTE_XFOIL
    
    % load xfoil data if available
    [~,nm,~] = fileparts(name);
    if exist(['Airfoils/' nm '.mat'],'file')
        load(['Airfoils/' nm '.mat']);
    end
    
    Rex = V*c_mac/xi;
    
    % compute CL value for user requirements
    CLx = (2*weight)/(rho*V0^2*S);
    
    % get the closest Reynolds
    for i = 1:length(AFdata)
        Rvec(i) = AFdata{1,i}.pol.Re;
    end    
    [val,ind] = min(abs(Rvec-Rex));
    
    if CLx > max(AFdata{1,ind}.pol.CL)
        error('requested lift coefficient is out of range');
    else
        alphx = interp1(AFdata{1,ind}.pol.CL,AFdata{1,ind}.pol.alpha,CLx);
    end
    
    % compute associated CD and Cm
    CDx = interp1(AFdata{1,ind}.pol.alpha,AFdata{1,ind}.pol.CD,alphx);
    Cmx = interp1(AFdata{1,ind}.pol.alpha,AFdata{1,ind}.pol.Cm,alphx);
    
end

%% 3D lift characteristics - theoretical
%3-D lift slope
M = V/340.3;

Meff = M*cosd(ang_LE);
beta = sqrt(1-Meff^2);

alpha_0 = 0; %NACA 4412

slope = (2*pi*AR)/(2 + sqrt(4 + ((AR*beta)^2)*(1 + (tand(ang_tc)/beta)^2)));
slope = slope*pi/180;
% trim settings

% alpha = CLminD/slope + alpha_0;