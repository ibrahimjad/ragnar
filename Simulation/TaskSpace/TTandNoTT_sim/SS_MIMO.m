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
Phipole = roots([0.0053 2*sqrt(2.50*0.0053*0.06) 2.50*0.06]);

Desired_poles = real([Xpole' Zpole' Ypole' Phipole']);
Desired_poles_obs = 5*Desired_poles;

F_mimo=-place(A,B,Desired_poles) % State feedback
L_mimo=-place(A',C',Desired_poles_obs)'; % Observer

%%
A_K = A+B*F_mimo+L_mimo*C;
B_K = L_mimo;
C_K = -F_mimo;
D_K = 0;
sys_K = ss(A_K,B_K,C_K,D_K);
CL = feedback(sys_mimo,sys_K,1);
bode(CL(1,1),CL(2,2),CL(3,3),CL(4,4))

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

%%
JN = [-0.20938225, -0.23075509, -0.0066385861, 0.0018545359, -0.044730209, 0.040108118
-0.10107797,  0.12024544,    0.10008853, -0.092520614,   0.87582034, -0.24672376
 -0.2010277,  0.20910422,   0.079599813, -0.072758771,   0.21543337, -0.38709117
0.061111646, -0.10516286,    0.80279105,  -0.78924007,   -12.634661,   6.4044305];
res = [deg2rad(360)/1024 deg2rad(360)/1024 deg2rad(360)/1024 deg2rad(360)/1024 (1*10^-2)/1024 (1*10^-2)/1024]';
TSRes = norm(JN)*norm(res)
TSResf = JN*res;
norm(TSResf)
