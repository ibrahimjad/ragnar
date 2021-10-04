
close all; 
clear all; 
geometric_parameters_ragnar; 

Rx = @(angle) ([1 0 0; 0, cos(angle) -sin(angle); 0, sin(angle) cos(angle)]); 
Ry = @(angle) ([cos(angle) 0 sin(angle); 0 1 0; -sin(angle) 0 cos(angle)]); 
Rz = @(angle) ([cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1]); 

ii = [1 0 0]';
j = [0 1 0]';            
k = [0 0 1]';
solutions = [2,1,2,1];
u_j = [j j -j -j];

syms thet1 thet2 thet3 thet4 thet5 real
syms x y z ph real

%function [sol, sol2] = Rag_fullIKP_rotate_x_ragnar(parameter, pose, h_all)
%[thetas_pwr_on, ~] = Rag_fullIKP_rotate_x_ragnar(base_params_ik_, pose_pwr_on, h_all);

%limb1 ------------------

leg = base_params_ik_(1, :);
a = leg(1); b = leg(2); % base platform
alpha = leg(3); beta = leg(4); l = leg(5); % inner link
L = leg(6); % outer link length
rx = leg(7);
ry = leg(8);
rz = leg(9);
h_d = leg(10);
r_a = [rx; ry; rz];

R = Rz(alpha) * Ry(beta) * Rz(thet1);
A = [a; b; 0];
S = R * (l*ii);
B1 = A+S;
JF1=jacobian(B1,[thet1 thet2 thet3 thet4 thet5])

C1 = [x y z]' + Rx(ph)*h_all(:,1) + r_a;
JG1=jacobian(C1,[x y z ph])

%limb2 ------------

leg = base_params_ik_(2, :);
a = leg(1); b = leg(2); % base platform
alpha = leg(3); beta = leg(4); l = leg(5); % inner link
L = leg(6); % outer link length
rx = leg(7);
ry = leg(8);
rz = leg(9);
h_d = leg(10);
r_a = [rx; ry; rz];

R = Rz(alpha) * Ry(beta) * Rz(thet2);
A = [a; b; 0];
S = R * (l*ii);
B2 = A+S;
JF2=jacobian(B2,[thet1 thet2 thet3 thet4 thet5])

C2 = [x y z]' + Rx(ph)*h_all(:,2) + r_a;
JG2=jacobian(C2,[x y z ph])

%limb3 ------------

leg = base_params_ik_(3, :);
a = leg(1); b = leg(2); % base platform
alpha = leg(3); beta = leg(4); l = leg(5); % inner link
L = leg(6); % outer link length
rx = leg(7);
ry = leg(8);
rz = leg(9);
h_d = leg(10);
r_a = [rx; ry; rz];

R = Rz(alpha) * Ry(beta) * Rz(thet3);
A = [a; b; 0];
S = R * (l*ii);
B3 = A+S;
JF3=jacobian(B3,[thet1 thet2 thet3 thet4 thet5])

C3 = [x y z]' + Rx(ph)*h_all(:,2) + r_a;
JG3=jacobian(C3,[x y z ph])

%limb4 ------------

leg = base_params_ik_(4, :);
a = leg(1); b = leg(2); % base platform
alpha = leg(3); beta = leg(4); l = leg(5); % inner link
L = leg(6); % outer link length
rx = leg(7);
ry = leg(8);
rz = leg(9);
h_d = leg(10);
r_a = [rx; ry; rz];

R = Rz(alpha) * Ry(beta) * Rz(thet4);
A = [a; b; 0];
S = R * (l*ii);
B4 = A+S;
JF4=jacobian(B4,[thet1 thet2 thet3 thet4 thet5])

C4 = [x y z]' + Rx(ph)*h_all(:,2) + r_a;
JG4=jacobian(C4,[x y z ph])

%%
%%limb5 ------------ linear aktuator

JF5=jacobian(thet5,[thet1 thet2 thet3 thet4 thet5])
JG5=jacobian(x^2+y^2+z^2,[x y z ph])
%%

%---------------total matrix
AM=[(B1-C1)'*JF1;(B2-C2)'*JF2;(B3-C3)'*JF3;(B4-C4)'*JF4;JF5*thet5];
BM=[(B1-C1)'*JG1;(B2-C2)'*JG2;(B3-C3)'*JG3;(B4-C4)'*JG4;JG5];
% AM*Theta'=BM*Pose'
J=AM\BM;
% Pose' = J*Theta'
AMNum=matlabFunction(AM);
BMNum=matlabFunction(BM);
JNum=matlabFunction(J)

x_pwr_on = 0.1 
y_pwr_on = 0.2; 
z_pwr_on = -0.45; 
phi_pwr_on = deg2rad(20);

pose_pwr_on = [x_pwr_on; y_pwr_on; z_pwr_on; phi_pwr_on];
% get the initial position of thetas at power on
[thetas_pwr_on, ~] = Rag_fullIKP_rotate_x_ragnar(base_params_ik_, pose_pwr_on, h_all)
[sol, sol2] = Rag_fullIKP_rotate_x_ragnar_5limb(pose_pwr_on, h_all)

%JN=JNum(phi_pwr_on,thetas_pwr_on(1),thetas_pwr_on(2),thetas_pwr_on(3),thetas_pwr_on(4),norm([x y z])^2,x_pwr_on,y_pwr_on,z_pwr_on)
%cond(JN)



AMN=AMNum(phi_pwr_on,thetas_pwr_on(1),thetas_pwr_on(2),thetas_pwr_on(3),thetas_pwr_on(4),x_pwr_on,y_pwr_on,z_pwr_on);
BMN=BMNum(phi_pwr_on,thetas_pwr_on(1),thetas_pwr_on(2),thetas_pwr_on(3),thetas_pwr_on(4),x_pwr_on,y_pwr_on,z_pwr_on);
JNN=BMN\AMN;
cond(JNN)

draw_ragnar_rotated(thetas_pwr_on,base_params_ik_,pose_pwr_on, h_all)
a = 0; b = 0; % base platform
alpha = 0; beta = 0; l = 0.0 % inner link
r_a = [0.08; 0; 0.024];

R = Rz(alpha) * Ry(beta) * Rz(sol(2));
A = [a; b; 0];
S = R * (l*ii);
B5 = A+S;
C5 = [x_pwr_on; y_pwr_on; z_pwr_on] + Rx(phi_pwr_on)*h_all(:,2) + r_a;

plot3([A(1),B5(1)],[A(2),B5(2)],[A(3),B5(3)],'b','LineWidth',3); 
plot3([B5(1),C5(1)],[B5(2),C5(2)],[B5(3),C5(3)],'b','LineWidth',3); 
cond(JNN)