% script to compute the 
clearvars
close all

% assuming a particular time constant

dT = 0.01; % time step for a discrete
time = 0:dT:20;

qd = 0.05; %noise covariance
qc = 
n = length(time);

% random ensemble
% scaling of the random ensemble to get variance qk is 
Wk = sqrt(qd)*randn(n,60);

% integration 
Xk = cumsum(Wk,1);

% calculation of the covariance 
pk = cumsum(ones(1,n))*qk;

meanX = mean(Xk,2);
sigX = std(Xk,[],2);

plot(meanX); hold on; plot(sigX); plot(sqrt(pk)); grid on
legend('\muX','\sigmaX',' \sqrtP');
