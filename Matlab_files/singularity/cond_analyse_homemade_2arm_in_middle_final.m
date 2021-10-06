close all; 
%clear all; 
geometric_parameters_ragnar; 

Rx = @(angle) ([1 0 0; 0, cos(angle) -sin(angle); 0, sin(angle) cos(angle)]); 
Ry = @(angle) ([cos(angle) 0 sin(angle); 0 1 0; -sin(angle) 0 cos(angle)]); 
Rz = @(angle) ([cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1]); 

ii = [1 0 0]';
j = [0 1 0]';            
k = [0 0 1]';
solutions = [2,1,2,1];
u_j = [j j -j -j];

syms thet1 thet2 thet3 thet4 thet5 thet6 real
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
JF1=jacobian(B1,[thet1 thet2 thet3 thet4])

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
JF2=jacobian(B2,[thet1 thet2 thet3 thet4])

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
JF3=jacobian(B3,[thet1 thet2 thet3 thet4])

C3 = [x y z]' + Rx(ph)*h_all(:,3) + r_a;
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
JF4=jacobian(B4,[thet1 thet2 thet3 thet4])

C4 = [x y z]' + Rx(ph)*h_all(:,4) + r_a;
JG4=jacobian(C4,[x y z ph])

% Arm 5 and 6
v5 = [0;0.045;-0.02]
v6 = [0;-0.045;-0.02]
C5 = ((C1+C2)/2)
C6 = ((C3+C4)/2)
JG5=jacobian((C5-v5),[x y z ph])
JG6=jacobian((C6-v5),[x y z ph])

%---------------total matrix
AM=[(B1-C1)'*JF1;(B2-C2)'*JF2;(B3-C3)'*JF3;(B4-C4)'*JF4];
AM = [AM,repmat(0,[4,2])]
AM = [AM;repmat(0,[2,6])]
AM(5,5) = thet5
AM(6,6) = thet6
BM=[(B1-C1)'*JG1;(B2-C2)'*JG2;(B3-C3)'*JG3;(B4-C4)'*JG4;(C5-v5)'*JG5;(C6-v6)'*JG6];
%J=BM\AM;
AMNum=matlabFunction(AM);
BMNum=matlabFunction(BM);
%JNum=matlabFunction(J)s

x_pwr_on = 0.0; 
y_pwr_on = 0.5; 
z_pwr_on = -0.4; 
phi_pwr_on = deg2rad(90);

pose_pwr_on = [x_pwr_on; y_pwr_on; z_pwr_on; phi_pwr_on];
% get the initial position of thetas at power on
[thetas_pwr_on, ~] = Rag_fullIKP_rotate_x_ragnar(base_params_ik_, pose_pwr_on, h_all);

L_c5 = subs(C5,[x y z ph],[x_pwr_on y_pwr_on z_pwr_on phi_pwr_on])
L_c6 = subs(C6,[x y z ph],[x_pwr_on y_pwr_on z_pwr_on phi_pwr_on])
theta5_alt = L_c5-v5
theta6_alt = L_c6-v6
L_t5 = norm(theta5_alt)
L_t6 = norm(theta6_alt)
unit_vector_t5 = theta5_alt/L_t5
unit_vector_t6 = theta6_alt/L_t6
%[sol, sol2] = Rag_fullIKP_rotate_x_ragnar_5limb(pose_pwr_on, h_all)


%JN=JNum(phi_pwr_on,thetas_pwr_on(1),thetas_pwr_on(2),thetas_pwr_on(3),thetas_pwr_on(4),x_pwr_on,y_pwr_on,z_pwr_on)
%cond(JN)

AMN=AMNum(phi_pwr_on,thetas_pwr_on(1),thetas_pwr_on(2),thetas_pwr_on(3),thetas_pwr_on(4),L_t5,L_t6,x_pwr_on,y_pwr_on,z_pwr_on);
BMN=BMNum(phi_pwr_on,thetas_pwr_on(1),thetas_pwr_on(2),thetas_pwr_on(3),thetas_pwr_on(4),x_pwr_on,y_pwr_on,z_pwr_on);

JN=pinv(BMN)*AMN;
cond(JN)


draw_ragnar_rotated(thetas_pwr_on,base_params_ik_,pose_pwr_on, h_all)

%%
hold on

A=[0 v5(1)];
B=[0 v5(2)];
C=[0 v5(3)];
plot3(A,B,C,'k-','LineWidth',3,'color','magenta')

A=[0 v6(1)];
B=[0 v6(2)];
C=[0 v6(3)];
plot3(A,B,C,'k-','LineWidth',3,'color','yellow')

% Your two points
P1 = v5';
P2 = (theta5_alt+v5)';
pts = [P1; P2];
plot3(pts(:,1), pts(:,2), pts(:,3),'k-','LineWidth',3,'color','blue')

% Your two points
P1 = v6';
P2 = (theta6_alt+v6)';
pts = [P1; P2];
plot3(pts(:,1), pts(:,2), pts(:,3),'k-','LineWidth',3,'color','red')

% syms zeta eta real
% B=Rz(thet1)*ii*0.3;
% R2=Rz(zeta)*Ry(eta);
% C=B+Rz(thet1)*R2*0.6*ii;
% J1=jacobian(C,thet1)
% J2=jacobian(C,zeta)
% J3=jacobian(C,eta)
% 
% JJ1=cross((Rz(thet1)*k),C);
% JJ2=cross(Rz(thet1)*k,Rz(thet1)*R2*ii*0.6);
% JJ3=cross(Rz(thet1)*Rz(zeta)*j,Rz(thet1)*R2*ii*0.6)

