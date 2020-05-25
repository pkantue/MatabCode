function demo_brownian(dt)
%DEMO_BROWNIAN - demo Brownian motion
%
%  DEMO_BROWNIAN(T)
%
%   T - sampling period [s], default 0.01
%

if (nargin < 1), dt= 0.01; end

time= [0:999]'*dt;

%noise covariance [u^2]
qd= 0.05;

%discrete solution
%  x(k+1) = 1*x(k) + wd(k)
%  p(k+1) = p(k) + qd(k)

ud= sqrt(qd)*randn(length(time),100);
xd= cumsum(ud);
pd= cumsum(ones(size(time)))*qd;

%continuous case
%  pcdot = 0*pc + pc*0 + qc  -->  pc = qc*time
%

qc= qd/dt;
pc= qc*time;

lh=plot(time,[mean(xd,2) std(xd,[],2) sqrt(pd) sqrt(pc) xd(:,1)]);
grid on
xlabel('Time [s]')
ylabel('[u]')
title('Integrated white noise: 100 realisations')
legend({'\muX','\sigmaX','\surdp_d','\surdp_c'},'location','southwest')
