function data = kalmanPred(zk,sigv,sigw)

%noise covariances [u^2]
qk= sigw^2;
rk= sigv^2;

xd(1)= 0;              % 0, z(1), mean(z(1:n)) ?
pd(1)= qk+rk;          % worst case?
fk= 1;
hk= 1;

n =length(zk);

%run the filter
for ix=2:(n)
    
    [xd(ix),pd(ix)]= time_update(xd(ix-1),pd(ix-1),fk,qk);
    [xd(ix),pd(ix),kk(ix)]= meas_update(xd(ix),pd(ix),hk,zk(ix),rk);
    
end

data.state = xd;
data.cov = pd;

%time update function
    function [xd,pd]= time_update(xd,pd,fk,qk)
        
        xd= fk*xd;
        pd= fk*pd*fk' + qk;
        
    end

%measurement update function
    function [xd,pd,kk]= meas_update(xd,pd,hk,zk,rk)
        
        kk= pd*hk'/(hk*pd*hk' + rk);
        if (isfinite(zk))
            xd= xd + kk*(zk - hk*xd);
            pd= (eye(size(pd)) - kk*hk)*pd;
        end
    end

end
