function demo_randvelo(rv,sigp,sigw,dkf)
%DEMO_RANDVELO - demo random velocity KF
%
%  DEMO_RANDVELO(VEL,SIGP,SIGW[,DKF])
%
%   VEL - true value of velocity [m/s]
%   SIGP - position noise standard deviation [m]
%   SIGW - process noise standard deviation [1]
%   DKF - if ~0 discrete KF, else continuous KF, default 1
%
%   Note: try demo_randvelo(0.1,0.1,0.1);

if (nargin < 4), dkf= 1; end

dt= 0.01;
npts= 1000;
time= dt*[0:npts-1]';

%noise covariances [u^2]
qk= sigw^2;
rk= sigp^2;

qc= qk*dt;
rc= rk*dt;

%measurement data
zkp= cumsum(rv*ones(size(time)))*dt;
zk= zkp + sigp*randn(size(time));

%initialisation
x= [0 0]';                 % 0, z(1), mean(z(1:n)) ?
P= diag([rk/30 qk/30]);
A= [0 1; 0 0];
B= [0; 1];
F= [1 dt; 0 1];
G= [dt*dt; dt];
H= [1 0];

%run the filter
xd= zeros(npts,2);
pd= zeros(npts,2);
kk= zeros(npts,2);
for ix=2:length(time)

  if (dkf)
    [x,P]= time_update(x,P,F,G,qk);
    [x,P,kk]= meas_update(x,P,H,zk(ix),rk);
  else
    [dxdt,dPdt,kk]= ckf(x,P,A,B,H,qc,rc,zk(ix));
  end

  xd(ix,:)= x.';
  pd(ix,:)= diag(P);
  kd(ix,:)= kk.';

  if (~dkf)
    if (ix < 3)
      x= x + dt*dxdt;
      P= P + dt*dPdt;
    else
      x= x + dt*(3*dxdt-dxdt1)/2;
      P= P + dt*(3*dPdt-dPdt1)/2;
    end
    dxdt1= dxdt;
    dPdt1= dPdt;
  end

end

%display
kd(1,:)= kd(2,:);
figure(1)
subplot(221)
  rvp= rv*ones(size(time));
  lh=plot(time,rvp,time,zkp,time,zk);
  set(lh(3),'Markersize',6)
  grid on
  xlabel('Time [s]')
  ylabel('[m/s, m]')
  title('Random velocity KF')
  legend({'V','P','z_k'},'location','northwest','FontSize',7)

subplot(222)
  lh=plot(time,[zkp-xd(:,1) sqrt(pd(:,1))*[-3 3] ]);
  grid on
  xlabel('Time [s]')
  ylabel('[m/s]')
  legend({'P-x_1','-3*\surdp','3*\surdp'},'location','northeast','FontSize',7)

subplot(223)
  lh=plot(time,[rvp-xd(:,2) sqrt(pd(:,2))*[-3 3] ]);
  grid on
  xlabel('Time [s]')
  ylabel('[m/s]')
  title('Random velocity KF')
  legend({'V-x_2','-3*\surdp','3*\surdp'},'location','northeast','FontSize',7)

subplot(224)
  lh=plot(time,kd);
  grid on
  xlabel('Time [s]')
  ylabel('[1]')
  legend({'K_1','K_2'},'location','northeast','FontSize',7)

%time update function
function [x,P]= time_update(x,P,F,G,qk)

  x= F*x;
  P= F*P*F' + G*qk*G';

return

%measurement update function
function [x,P,kk]= meas_update(x,P,H,zk,rk)

  kk= P*H'/(H*P*H' + rk);
  x= x + kk*(zk - H*x);
  P= (eye(size(P)) - kk*H)*P;

return

%continuous filter derivative
function [dxdt,dPdt,kk]= ckf(x,P,A,B,H,qc,rc,zk)

  kk= P*H'/rc;
  dxdt= A*x + kk*(zk - H*x);
  dPdt= A*P + P*A' + B*qc*B' - kk*rc*kk';

return
