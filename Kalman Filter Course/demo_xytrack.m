function [time,xd,pd]=demo_xytrack(siga,sigr,sigw)
%DEMO_XYTRACK - demo x-y tracking with range & angle
%
%  DEMO_XYTRACK(SIGA,SIGR,SIGW)
%
%   SIGA - angle noise standard deviation [rad]
%   SIGR - range noise standard deviation [m]
%   SIGW - process noise standard deviation [1]
%
%   Note: try demo_xytrack(0.01,20,3);

dt= 0.05;
npts= 800;
time= dt*[0:npts-1]';
niter= 1;

%noise covariances [u^2]
Rk= diag([siga^2 sigr^2]);
qk= sigw^2;
qc= qk*dt;

%measurement data - ballistic trajectory
g0= 9.81;
x0= -4000;
v0= 200;
vxt= v0*ones(npts,1);
pxt= x0 + vxt.*time;
vyt= v0 - g0*time;
pyt= v0*time - 0.5*g0*time.^2;

adata= atan2(pyt,pxt);
rdata= hypot(pxt,pyt);
zk= [adata, rdata] + randn(npts,2)*sqrt(Rk);

%initialisation
sigv= 10;
x= [x0 0.9*v0 0 1.1*v0]';
P= diag([Rk(2,2) sigv^2/3 Rk(2,2) sigv^2/3]);
% F= I + A*T
F= [1 dt 0 0; 0 1 0 0; 0 0 1 dt; 0 0 0 1];
% G= int(F(t)*Bdt)
G= [0; 0; -dt^2/2; -dt];

%run the filter
xd= zeros(npts,4);
xd(1,:)= x.';
pd= zeros(npts,4);
pd(1,:)= diag(P);
kd= zeros(npts,8);
for ix=2:length(time)

  %H= linmeas(x);
 [x,P,kk]= meas_update(x,P,zk(ix,:)',Rk,niter);
  x= time_update(x,F,G,g0);
  xd(ix,:)= x.';
  kd(ix,:)= kk(:).';
  pd(ix,:)= diag(P);

  %covariance time update
  P= cov_update(F,P,qc,dt);

end

kd(1,:)= kd(2,:);

%display
figure(1)
subplot(221)
  lh=plot(time,[pxt-xd(:,1) sqrt(pd(:,1))*[-3 3] ]);
  grid on
  xlabel('Time [s]')
  ylabel('Px error [m]')
  title('Tracking KF')
  legend({'dpx','-3\sigmapx','3\sigmapx'},'location','southeast','FontSize',7)

subplot(222)
  lh=plot(time,[pyt-xd(:,3) sqrt(pd(:,3))*[-3 3] ]);
  grid on
  xlabel('Time [s]')
  ylabel('Py error [m]')
  title('Tracking KF')
  legend({'dpy','-3\sigmapy','3\sigmapy'},'location','southeast','FontSize',7)

subplot(223)
  lh=plot(time,[vxt-xd(:,2) sqrt(pd(:,2))*[-3 3] ]);
  grid on
  xlabel('Time [s]')
  ylabel('Vx error [m/s]')
  %legend({'dvx','-3\sigmavx','3\sigmavx'},'location','northeast','FontSize',7)

subplot(224)
  lh=plot(time,[vyt-xd(:,4) sqrt(pd(:,4))*[-3 3] ]);
  grid on
  xlabel('Time [s]')
  ylabel('Vy error [m/s]')
  %legend({'dvy','-3\sigmavy','3\sigmavy'},'location','northeast','FontSize',7)

figure(2)
subplot(211)
  lh=plot(time,kd(:,1:4));
  grid on
  xlabel('Time [s]')
  ylabel('K(:,1)')
  title('Tracking EKF')
  legend({'1','2','3','4'},'location','southeast','FontSize',7)

subplot(212)
  lh=plot(time,kd(:,5:8));
  grid on
  xlabel('Time [s]')
  ylabel('K(:,2)')
  legend({'1','2','3','4'},'location','southeast','FontSize',7)

%measurement update function
function [x,P,kk]= meas_update(x,P,zk,Rk,niter)

  xk_= x;
  Pk_= P;

  for i=1:niter
    H= linmeas(x);
    zhat= [atan2(xk_(3),xk_(1)); hypot(xk_(1),xk_(3)) ];
    zhat= zhat + H*(xk_ - x);

    kk= Pk_*H'/(H*Pk_*H' + Rk);
    x= xk_ + kk*(zk - zhat);
    P= (eye(size(P)) - kk*H)*Pk_;
  end

return

%covariance time update
function P= cov_update(F,P,qc,dt)

  % Qk= int(F(t)*B*qc*B'F'(t)
  %   = [q11  q12    0    0
  %      q12  q22    0    0
  %       0    0    q33  g44
  %       0    0    q34  q44 ]
  q11= dt^3/3;
  q12= dt^2/2;
  q22= dt;

  % x & y acceleration process noise identical
  Qk= qc*[q11 q12 0 0; q12 q22 0 0; 0 0 q11 q12; 0 0 q12 q22];
  P= F*P*F.' + Qk;

return

%linear model equations of motion
function x= time_update(x,F,G,grav)

  x= F*x + G*grav;

return

%linearised measurement equation
function H= linmeas(x)

r= hypot(x(1),x(3));

H= [-x(2)/r  0  x(1)/r  0
     x(1)    0  x(2)    0 ]/r;


