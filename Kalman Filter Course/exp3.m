% script to get 
clearvars
close all

syms x y wn zeta p1 p2 p3 p4 q pdot

p11 = [0 1; -wn^2 -2*zeta*wn];
p22 = [p1 p3; p3 p2];
p33 = [0 -wn^2; 1 -2*zeta*wn];
p44 = [0 0; 0 q*wn^4];

pdot = p11*p22 + p22*p33 + p44; % + [p1 p3; p3 p2]*[0 -wn^2; 1 - 2*zeta*wn] + [0 0; 0 q*wn^2];
