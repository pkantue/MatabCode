function demo_randconst(rc,sigv,sigw,gaps)
%DEMO_RANDCONST - demo random constant KF
%
%  DEMO_RANDCONST(C,SIGV,SIGW[,GAPS])
%
%   C - true value of random constant [1]
%   SIGV - measurement noise standard deviation [1]
%   SIGW - process noise standard deviation [1]
%   GAPS - if > 0, fraction of data invalid [0:1], default 0
%
%   Try: demo_randconst(0,0.1,0,0)     - no process noise
%        demo_randconst(0,0.1,0.05,0)  - process noise
%        demo_randconst(0,0.1,0.05,1)  - gaps in measurement data


if (nargin < 4), gaps= 0; end

npts= 100;
time= [0:npts-1]';

%noise covariances [u^2]
qk= sigw^2;
rk= sigv^2;

%measurement data
zk= rc*ones(size(time)) + sigv*randn(size(time));
if (gaps)
  % periodically mark measurements invalid
  tmp= sin(time/5);
  zk(tmp < 0)= nan;
end

%initialisation
xd= zeros(npts,1);
pd= zeros(npts,1);
kk= zeros(npts,1);
xd(1)= 0;              % 0, z(1), mean(z(1:n)) ?
pd(1)= qk+rk;          % worst case?
fk= 1;
hk= 1;

%run the filter
for ix=2:length(time)

  [xd(ix),pd(ix)]= time_update(xd(ix-1),pd(ix-1),fk,qk);
  [xd(ix),pd(ix),kk(ix)]= meas_update(xd(ix),pd(ix),hk,zk(ix),rk);

end

%display
kk(1)= kk(2);
figure(1)
subplot(221)
  rcp= rc*ones(size(time));
  lh=plot(time,[rcp xd],time,zk,'.');
  set(lh(3),'Markersize',6)
  grid on
  xlabel('Sample number [1]')
  ylabel('[u]')
  title('Random constant KF')
  legend({'C','x','z_k'},'location','southwest','FontSize',7)

%figure(2)
subplot(222)
  lh=plot(time,[rcp-xd sqrt(pd)*[-3 3] ]);
  grid on
  xlabel('Sample number [1]')
  ylabel('[u]')
  title('Random constant KF')
  legend({'C-x','-3*\surdp','3*\surdp'},'location','northeast','FontSize',7)

%figure(3)
subplot(223)
  lh=plot(time,kk);
  grid on
  xlabel('Sample number [1]')
  ylabel('[1]')
  title('Random constant KF')
  legend({'K'},'location','northeast','FontSize',7)

%time update function
function [xd,pd]= time_update(xd,pd,fk,qk)

  xd= fk*xd;
  pd= fk*pd*fk' + qk;

return

%measurement update function
function [xd,pd,kk]= meas_update(xd,pd,hk,zk,rk)

  kk= pd*hk'/(hk*pd*hk' + rk);
  if (isfinite(zk))
    xd= xd + kk*(zk - hk*xd);
    pd= (eye(size(pd)) - kk*hk)*pd;
  end

