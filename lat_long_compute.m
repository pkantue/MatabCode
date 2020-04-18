% This scripts helps calculated distance and bearing betwwen two GPS points
% This will be implemented in C source code for autopilot heading control

%-26.182634,28.091054
%-26.182037,28.094144

gps_lat1 = -26.182634*(pi/180); % -25.979677
gps_long1 = 28.091054*(pi/180); % 28.123798

gps_lat2 = -26.182037*(pi/180); % -25.958534
gps_long2 = 28.094144*(pi/180); % 28.130322

R = 6371; % earth radius [km]
dlat = gps_lat2 - gps_lat1;
dlong = gps_long2 - gps_long1;

a = (sin(dlat/2))^2 + cos(gps_long1)*cos(gps_long2)*(sin(dlong/2))^2;
c = 2*atan2(sqrt(a),sqrt(1-a));
d = R*c*1000; % distance between points

% calculate bearing
y = sin(dlong)*sin(gps_lat2);
x = cos(gps_lat1)*sin(gps_lat2) - sin(gps_lat1)*cos(gps_lat2)*cos(dlong);
psi = atan2(y,x)*(180/pi);

%convert to degrees then change to compass bearing (0 - 360)
psi = mod((psi+360),360);
