clear all
close all
%% Model of system
A = zeros(8,8); A(1,5) = 1; A(2,6) = 1; A(3,7) = 1; A(4,8) = 1;
B = [zeros(8,4)];B(8,4) = 2180; B(7,3) = 1/1.28; B(6,2) = 1/1.28; B(5,1) = 1/1.28; % B = [0;1/M]
C = eye(8,8);%zeros(4,8); C(1,1) = 1; C(2,2) = 1; C(3,3) = 1; C(4,4) = 1; 

sys_mimo=ss(A,B,C,0);
ref = [0.01 0.51 -0.41 deg2rad(85) 0 0 0 0];

%% Disigning feedback and observer gain
Desired_poles = [0.5:0.4/7:0.9];
Desired_poles_obs = [0.2:0.4/7:0.6];

sysd=c2d(sys_mimo,0.05)

F_mimo=-place(sysd.A,sysd.B,Desired_poles); % State feedback
L_mimo=-place(sysd.A',sysd.C',Desired_poles_obs)'; % Observer
