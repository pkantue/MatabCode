function [time,xd,pd,kd]=demo_dragcoeff(sigp,sigw)
%DEMO_DRAGCOEFF - demo drag coefficient estimation KF
%
%  DEMO_DRAGCOEFF(SIGP,SIGW)
%
%   SIGP - position noise standard deviation [m]
%   SIGW - process noise standard deviation [1]
%
%   Note: try demo_dragcoeff(20,1);

dt= 0.04;
npts= 1000;
time= dt*[0:npts-1]';

% model data
p.sref= 0.02;
p.mass= 10;
p.rho0= 1.225;
p.h= 9500;

%noise covariances [u^2]
rk= sigp^2;
qk= sigw^2;
qc= qk*dt;

%measurement data
x0= [-5000; 0; 1];
[tsim,xsim]= ode23(@(t,x) dragsim(t,x,p),[0 time(end)],x0);
xp= interp1(tsim,xsim(:,1:2),time);
zk= xp(:,1) + sigp*randn(size(time));

%initialisation
x= [-5000 0 0]';                 % 0, z(1), mean(z(1:n)) ?
P= diag([rk/10 rk qk]);
B= [0; 0; 1];
H= [1 0 0];

%run the filter
xd= zeros(npts,3);
xd(1,:)= x.';
pd= zeros(npts,3);
pd(1,:)= diag(P);
kk= zeros(npts,3);
for ix=2:length(time)

  [x,P,kk]= meas_update(x,P,H,zk(ix),rk);
  dxdt= dragsim(time(ix),x,p);
  A= linmdl(x,p);

  xd(ix,:)= x.';
  pd(ix,:)= diag(P);
  kd(ix,:)= kk.';

  %covariance time update
  P= cov_update(A,P,B,qc,dt);

  % state time update
  if (ix < 3)
    x= x + dt*dxdt;
  else
    x= x + dt*(3*dxdt-dxdt1)/2;
  end
  dxdt1= dxdt;

end

%display
kd(1,:)= kd(2,:);
figure(1)
subplot(221)
  lh=plot(time,xp(:,1),time,zk);
  set(lh(2),'Markersize',6)
  grid on
  xlabel('Time [s]')
  ylabel('Posn [m]')
  title('Drag Coefficient KF')
  legend({'x_1','z_k'},'location','northwest','FontSize',7)

subplot(222)
  lh=plot(time,[xp(:,1)-xd(:,1) sqrt(pd(:,1))*[-3 3] ]);
  grid on
  xlabel('Time [s]')
  ylabel('Posn error [m]')
  title('Drag Coefficient KF')
  legend({'x-x_1','-3*\surdp','3*\surdp'},'location','northeast','FontSize',7)

subplot(223)
  lh=plot(time,[1-xd(:,3) sqrt(pd(:,3))*[-3 3] ]);
  grid on
  xlabel('Time [s]')
  ylabel('Coeff error [1]')
  legend({'C_d-x_3','-3*\surdp','3*\surdp'},'location','northeast','FontSize',7)

figure(2)
subplot(221)
  lh=plot(time,xp(:,2),time,xd(:,2));
  grid on
  xlabel('Time [s]')
  ylabel('Speed [m/s]')
  title('Drag Coefficient KF')
  legend({'v','x_2'},'location','southeast','FontSize',7)

subplot(222)
  lh=plot(time,[xp(:,2)-xd(:,2) sqrt(pd(:,2))*[-3 3] ]);
  grid on
  xlabel('Time [s]')
  ylabel('Speed error [m/s]')
  title('Drag Coefficient KF')
  legend({'v-x_2','-3*\surdp','3*\surdp'},'location','northeast','FontSize',7)

subplot(223)
  lh=plot(time,kd);
  grid on
  xlabel('Time [s]')
  ylabel('Kalman Gain [1]')
  legend({'K_1','K_2','K_3'},'location','northeast','FontSize',7)

%measurement update function
function [x,P,kk]= meas_update(x,P,H,zk,rk)

  kk= P*H'/(H*P*H' + rk);
  x= x + kk*(zk - H*x);
  P= (eye(size(P)) - kk*H)*P;

return

%covariance time update
function P= cov_update(A,P,B,qc,dt)

  % F = I + A*T + A^2*T^2/2 + ...
  %     [   1      T         0
  %   =   a21*T (1+a22)*T a23*T
  %         0      0         T ]
  F= eye(3) + A*dt;

  % Qk= int(F(t)*B*qc*B'F'(t)
  %   = [ 0    0     0
  %       0   q22   q23
  %       0   g23   q33 ]
  q22= A(2,3)^2*dt^3/3;
  q23= A(2,3)*dt^2/2;
  q33= dt;
  Qk= qc*[0  0   0;...
          0 q22 q23;... 
          0 q23 q33];
  P= F*P*F.' + Qk;

return

%non-linear model equations of motion
function dxdt= dragsim(t,x,p)

kd= 0.5*p.sref/p.mass;
rho= p.rho0*exp(x(1)/p.h);

dxdt= 0*x;

dxdt(1)= x(2);
dxdt(2)= 9.81 - kd*rho*x(2)*x(2)*x(3);
dxdt(3)= 0;

%linearised state equation
function A= linmdl(x,p)

kd= 0.5*p.sref/p.mass;
rho= p.rho0*exp(x(1)/p.h);

a21= -p.rho0*kd*rho*x(2)^2*x(3)/p.h;
a22= -2*kd*rho*x(2)*x(3);
a23= -kd*rho*x(2)^2;

A= [ 0   1   0
    a21 a22 a23
     0   0   0 ];

