function demo_realpole(dt)
%DEMO_REALPOLE - demo Real-pole response to white noise
%
%  DEMO_REALPOLE(T)
%
%   T - sampling period [s], default 0.01
%
%   The real pole is at 0.7 r/s

if (nargin < 1), dt= 0.01; end

time= [0:2999]'*dt;

%noise intensity [u^2/Hz]
qc= 0.5;

%noise covariance [u^2]
qd= qc/dt;

%continuous case
a= 0.7;
pc= qc*a/2*(1-exp(-2*a*time));

% ensemble
n= 100;
uc= sqrt(qd)*randn(length(time),n);
for ix=1:n
  xc(:,ix)= lsim(tf(a,[1 a]),uc(:,ix),time);
end

%discrete case
f= exp(-a*dt);
g= 1-f;
pd= 0*time;
for ix=2:length(time)
  pd(ix)= f^2*pd(ix-1)+g^2*qd;
end

figure(1)
lh= plot(time,[xc(:,1) mean(xc,2) 3*std(xc,[],2) 3*sqrt(pc) 3*sqrt(pd) ]);
grid on
xlabel('Time [s]')
ylabel('[u]')
title('Real pole - white noise')
legend({'x','\mux','3\sigma','3\surdpc','3\surdpd'},'location','southwest')

figure(2)
lh= plot(1:n,[mean(xc); 3*std(xc)],'.');
grid on
title('Real pole - time averages')
legend({'\mux(t)','3\sigmax(t)'})
xlabel('Realisation number [1]')
figure(1)
