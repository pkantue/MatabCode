% script to example real pole (LPF)

clearvars;
close all;

dT = 0.01; % time step for a discrete
time = 0:dT:20;

n = length(time);
realz = 60; % number of realisations

qc= 0.5; %noise intensity [u^2/Hz]
qd = qc/dT; % noise covariance - NB!

a = 0.5; % real pole

% system equation using lsim
sys = tf(a,[1 a]);

% system equation using inverse laplace transform (wihout transfer
% function) - This is to result in a DC-gain of ONE
f = exp(-a*dT);
g = 1 - f;

% input to random noise ensemble
Wk = sqrt(qd)*rand(n,realz);

% computation of the ensemble for real pole with DC-gain
for i=1:realz
    Xc(:,i) = lsim(sys,Wk(:,i),time);
end

