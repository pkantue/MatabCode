% script to compute a kalman filter dynamics

close all
clearvars

time = 0:0.01:100;
n = length(time);

wk = 0.1; % process noise
vk = 0.05; % measurement noise

qk = wk^2; % process covariance
rk = vk^2; % measurement coviance

xk = sin(2*pi*time);
zk = xk + randn(1,n)*sqrt(qk);

return;

function [xd,pd,kk] = meas_update(xd,pd,hk,zk,rk)
    kk = pd*hk'/(hk*pd*hk' + rk);
    xd = xd + kk*(zk - hk*xd);
    pd = (eye(size(pd)) - kk*hk)*pd;
end

function [xd,pd] = time_update(xd,pd,fk,qk)
    xd = fk*xd;
    pd = fk*pd*fk' + qk;
end