clear all
close all
%% Model of system
A = zeros(8,8); A(1,5) = 1; A(2,6) = 1; A(3,7) = 1; A(4,8) = 1;
B = [zeros(8,4)];B(8,4) = 2180; B(7,3) = 1/1.28; B(6,2) = 1/1.28; B(5,1) = 1/1.28; % B = [0;1/M]
C = eye(8,8);%zeros(4,8); C(1,1) = 1; C(2,2) = 1; C(3,3) = 1; C(4,4) = 1; 

sys_mimo=ss(A,B,C,0);

%% Disigning feedback and observer gain
S=-(sqrt(250/1.28));

Xpole = roots([1.28 2*sqrt(251*1.28) 251]);
Ypole = roots([1.28 2*sqrt(250*1.28) 250]);
Zpole = roots([1.28 2*sqrt(250*1.28) 250]);
Phipole = roots([0.0053 2*sqrt(100*0.0053) 100]);

Desired_poles = real([Xpole' Zpole' Ypole' Phipole']);
Desired_poles_obs = 5*Desired_poles;

F_mimo=-place(A,B,Desired_poles) % State feedback
L_mimo=-place(A',C',Desired_poles_obs)'; % Observer

%% Ref signal
sig1 = [0 0.5 -0.4 deg2rad(90) 0 0 0 0];
sig4 = [0.01 0.51 -0.39 deg2rad(95) 0 0 0 0];
sig5 = [-0.01 0.49 -0.41 deg2rad(85) 0 0 0 0];
sig2 = [0.01 0.51 -0.41 deg2rad(85) 0 0 0 0];
sig3 = [-0.01 0.49 -0.39 deg2rad(95) 0 0 0 0];
sig6 = [0 0.5 -0.4 deg2rad(90) 0 0 0 0];
ref = [sig2; sig3; sig4; sig5; sig6];

sig1 = [0.01 0.5 -0.4 deg2rad(90) 0 0 0 0];
sig2 = [0.01 0.51 -0.4 deg2rad(90) 0 0 0 0];
sig3 = [0.01 0.51 -0.39 deg2rad(90) 0 0 0 0];
sig4 = [0.01 0.51 -0.39 deg2rad(95) 0 0 0 0];
sig5 = [-0.01 0.49 -0.41 deg2rad(85) 0 0 0 0];
sig6 = [0 0.5 -0.4 deg2rad(90) 0 0 0 0];

ref = [sig1;sig2; sig3; sig4; sig5; sig6];
% %% Find N and M
% Desired_zeroes = [-2:1/7:-1];
% 
% L = L_mimo;
% F = F_mimo
% Aza = A+B*F+L*C;
% Cza = -F;
% 
% %M_tilde=-place(Aza',Cza',Desired_zeroes)';
% 
% Acl = [A B*F;-L*C Aza];
% B_tilde_cl = [B;M_tilde];
% Ccl = [C zeros(8,8)];
% N = -pinv(Ccl*(Acl^-1)*B_tilde_cl);
% 
% M = M_tilde*N;
% 

