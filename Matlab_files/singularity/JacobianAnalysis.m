% Jacobian Analysis of the Manipulator
% by Juan de Dios Flores Mendez 
% Manipulator specs: 4 Degrees of freedom 
%                    Rotation in X, translation X Y Z 
%                    4 actuators 

clf 
clear all 
close all
% Rotation angle functions 
R_x = @(angle) ([1 0 0; 0, cos(angle) -sin(angle); 0, sin(angle) cos(angle)]); 
R_y = @(angle) ([cos(angle) 0 sin(angle); 0 1 0; -sin(angle) 0 cos(angle)]); 
R_z = @(angle) ([cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1]); 
skew = @(vector) ([0 -vector(3) vector(2); vector(3) 0 -vector(1); -vector(2) vector(1) 0]);

% unit vectors 
u_i = [1 0 0]';
u_j = [0 1 0]';
u_k = [0 0 1]';

% Definitions 
syms t real; % time 
syms x(t) ... % position of center piece x 
     y(t) ... % position of center piece y 
     z(t) ... % position of center piece z 
   phi(t);    % rotation of center piece 
assumeAlso(x(t),'real'); assumeAlso(y(t),'real');
assumeAlso(z(t),'real'); assumeAlso(phi(t),'real');
  
Z = [x,y,z,phi]';
X = [x,y,z]';
syms a_x_i a_y_i a_z_i real; % cartesian coordinates from global coordinate system to motor axis
a_i = [a_x_i a_y_i a_z_i]';
syms alpha_i beta_i real % tilt and pan angles of motors 
syms theta_i(t); assumeAlso(theta_i(t), 'real'); 
syms b_prox real; % length of proximal link 
syms L_dist real; % length of distal link 
syms r_x_i r_y_i r_z_i real;
r_i = [r_x_i r_y_i r_z_i]'; % a rotating vector in the moving platform 
ra_i = sym('ra_i_', [3 1], 'real'); % attachment point of moving platform to attachment point to C attachment 

R_i = R_z(alpha_i) * R_y(beta_i);
R_theta = R_z(theta_i);
R_phi = R_x(phi);

B_i = a_i + b_prox*R_i*R_theta*u_i; % Point B is located between proximal and distal link at the joint 
C_i = X + R_phi*r_i + ra_i; % Point at the attachment point of the distal link and moving platform 

% specify constraint 
Eq_constraint = transpose(C_i-B_i)*(C_i-B_i) - L_dist^2; 

% diff 



d_Eq_constraint = diff(Eq_constraint); 

% create substitution vectors to not depend on time 
syms x_ y_ z_ phi_ theta_i_ real; 
to_subs_0 = [x_ y_ z_ phi_ theta_i_];
from_subs_0 = [x y z phi theta_i];
% Extract parts 
d_Eq_constraint_t = d_Eq_constraint(t); % evaluate on 't' to substitute
syms dtheta_i dx dy dz dphi real;
syms ddx ddy ddz ddphi real; 
to_subs = [to_subs_0 dtheta_i dx dy dz dphi];
from_subs = [from_subs_0 diff(theta_i) diff(x) diff(y) diff(z) diff(phi)];
from_subs = from_subs(t); 

% substitute to not depend on 't' 
d_Eq_constraint_no_t = subs(d_Eq_constraint_t, from_subs, to_subs); 

coeff_dx       = coeffs(d_Eq_constraint_no_t, dx); 
coeff_dx       = coeff_dx(2); 
coeff_dy       = coeffs(d_Eq_constraint_no_t, dy); 
coeff_dy       = coeff_dy(2);
coeff_dz       = coeffs(d_Eq_constraint_no_t, dz); 
coeff_dz       = coeff_dz(2);
coeff_dphi     = coeffs(d_Eq_constraint_no_t, dphi); 
coeff_dphi     = coeff_dphi(2);
coeff_dtheta_i = coeffs(d_Eq_constraint_no_t, dtheta_i); 
coeff_dtheta_i = coeff_dtheta_i(2);

% Checking that the coefficients are the same 
expand(d_Eq_constraint_no_t) - expand(coeff_dx*dx + coeff_dy*dy + coeff_dz*dz+...
                                      coeff_dphi*dphi + coeff_dtheta_i*dtheta_i)

% Jacobian as 
%            J_a dZ = J_b dtheta
J_a = sym(zeros(4,4));
J_b = sym(zeros(4,4));
% Evaluate in different i's to get the full thing 
for i=1:4
    % create strings to evaluate with changing parameter 
    to_eval = sprintf(['syms a_x_%i a_y_%i a_z_%i alpha_%i beta_%i real;\n',...
                       'syms theta_%i r_x_%i r_y_%i r_z_%i dtheta_%i real;\n',...
                       'syms ddtheta_%i real;\n',...
                       'ra_%i = sym(''ra_%i_'', [3 1], ''real'');\n',...
                       'from_subs_0 = [a_x_i a_y_i a_z_i alpha_i beta_i ...\n',...
                       '              theta_i_ r_x_i r_y_i r_z_i dtheta_i];\n',...
                       'to_subs_0 = [a_x_%i a_y_%i a_z_%i alpha_%i beta_%i ...\n',...
                       '              theta_%i r_x_%i r_y_%i r_z_%i dtheta_%i];\n',...
                       'cf_dx_%i = subs(coeff_dx, from_subs_0, to_subs_0);\n',...
                       'cf_dx_%i = subs(cf_dx_%i, ra_i, ra_%i);\n',...
                       'cf_dy_%i = subs(coeff_dy, from_subs_0, to_subs_0);\n',...
                       'cf_dy_%i = subs(cf_dy_%i, ra_i, ra_%i);\n',...
                       'cf_dz_%i = subs(coeff_dz, from_subs_0, to_subs_0);\n',...
                       'cf_dz_%i = subs(cf_dz_%i, ra_i, ra_%i);\n',...
                       'cf_dphi_%i = subs(coeff_dphi, from_subs_0, to_subs_0);\n',...
                       'cf_dphi_%i = subs(cf_dphi_%i, ra_i, ra_%i);\n',...
                       'cf_dtheta_%i = subs(coeff_dtheta_i, from_subs_0, to_subs_0);\n',...
                       'cf_dtheta_%i = subs(cf_dtheta_%i, ra_i, ra_%i);\n',...                       
                       'J_a(%i,1) = cf_dx_%i;\n',...
                       'J_a(%i,2) = cf_dy_%i;\n',...
                       'J_a(%i,3) = cf_dz_%i;\n',...
                       'J_a(%i,4) = cf_dphi_%i;\n',...
                       'J_b(%i,%i) = -cf_dtheta_%i;\n'...
                       ], i*ones(1,54));
    eval(to_eval);
end

% Now the Jacobians are collected in J_a dZ = J_b dtheta
% differentiate dJ_a * dZ + J_a * ddZ = dJ_b dtheta + J_b ddtheta
dJ_a = diff(J_a, x_)*dx + diff(J_a, y_)*dy + diff(J_a, z_)*dz + ...
    diff(J_a, phi_)*dphi;
dJ_b = diff(J_b, x_)*dx + diff(J_b, y_)*dy + diff(J_b, z_)*dz + ...
    diff(J_b, phi_)*dphi;

disp('Jacobian Z')
disp(J_a)

disp('Jacobian \theta')
disp(J_b)

% matlabFunction(J_a, 'File','generated/J_a');
% matlabFunction(J_b, 'File','generated/J_b');
% matlabFunction(dJ_a, 'File','generated/dJ_a');
% matlabFunction(dJ_b, 'File','generated/dJ_b');

% Constraint Jacobian 


% JACOBIAN TO THE END EFFECTOR

% Introduce the gear ratio to the end effector 
% Define end effector position 
syms h_p real; % vertical distance to end effector 
to_end = sym('toend_',[3 1],'real');
syms end_ratio real; % gear ratio to end effector 

% define the end effector variables 
syms x_e(t) ... 
     y_e(t) ...
     z_e(t) ...
     phi_e(t);
assumeAlso(x_e(t), 'real'); assumeAlso(y_e(t), 'real');
assumeAlso(z_e(t), 'real'); assumeAlso(phi_e(t), 'real');

X_end = [x_e; y_e; z_e];
phi_sub = phi_e/end_ratio;
% X_end_effector = X + R_x(end_ratio*phi)*h_p*u_k;
% X_sub = X_end + R_x(phi_e)*h_p*u_k;

X_sub = X_end + R_x(phi_e)*to_end;

Z_sub = [X_sub; phi_sub];
% now substitute to have it in terms of the end effector position 

Eq_constraint_end = subs(Eq_constraint, Z, Z_sub);

% diff 
d_Eq_constraint_end = diff(Eq_constraint_end); 

% create substitution vectors to not depend on time 
syms x_end y_end z_end phi_end real; 
to_subs_0 = [x_end y_end z_end phi_end theta_i_];
from_subs_0 = [x_e y_e z_e phi_e theta_i];
% Extract parts 
d_Eq_constraint_end_t = d_Eq_constraint_end(t); % evaluate on 't' to substitute
syms dtheta_i dx_end dy_end dz_end dphi_end real;
to_subs = [to_subs_0 dtheta_i dx_end dy_end dz_end dphi_end];
from_subs = [from_subs_0 diff(theta_i) diff(x_e) diff(y_e) diff(z_e) diff(phi_e)];
from_subs = from_subs(t); 

% substitute to not depend on 't' 
d_Eq_constraint_end_no_t = subs(d_Eq_constraint_end_t, from_subs, to_subs); 

coeff_end_dx       = coeffs(d_Eq_constraint_end_no_t, dx_end); 
coeff_end_dx       = coeff_end_dx(2); 
coeff_end_dy       = coeffs(d_Eq_constraint_end_no_t, dy_end); 
coeff_end_dy       = coeff_end_dy(2);
coeff_end_dz       = coeffs(d_Eq_constraint_end_no_t, dz_end); 
coeff_end_dz       = coeff_end_dz(2);
coeff_end_dphi     = coeffs(d_Eq_constraint_end_no_t, dphi_end); 
coeff_end_dphi     = coeff_end_dphi(2);
coeff_end_dtheta_i = coeffs(d_Eq_constraint_end_no_t, dtheta_i); 
coeff_end_dtheta_i = coeff_end_dtheta_i(2);

% Checking that the coefficients are the same 
expand(d_Eq_constraint_end_no_t) - expand(coeff_end_dx*dx_end + coeff_end_dy*dy_end + coeff_end_dz*dz_end+...
                                      coeff_end_dphi*dphi_end + coeff_end_dtheta_i*dtheta_i)

% Jacobian as 
%            J_end_a Z_end = J_end_b theta
J_end_a = sym(zeros(4,4));
J_end_b = sym(zeros(4,4));

% Evaluate in different i's to get the full thing 
for i=1:4
    % create strings to evaluate with changing parameter 
    to_eval = sprintf(['syms a_x_%i a_y_%i a_z_%i alpha_%i beta_%i real;\n',...
                       'syms theta_%i r_x_%i r_y_%i r_z_%i dtheta_%i real;\n',...
                       'ra_%i = sym(''ra_%i_'', [3 1], ''real'');\n',...
                       'from_subs_0 = [a_x_i a_y_i a_z_i alpha_i beta_i ...\n',...
                       '              theta_i_ r_x_i r_y_i r_z_i dtheta_i];\n',...
                       'to_subs_0 = [a_x_%i a_y_%i a_z_%i alpha_%i beta_%i ...\n',...
                       '              theta_%i r_x_%i r_y_%i r_z_%i dtheta_%i];\n',...
                       'cf_dx_%i = subs(coeff_end_dx, from_subs_0, to_subs_0);\n',...
                       'cf_dx_%i = subs(cf_dx_%i, ra_i, ra_%i);\n',...
                       'cf_dy_%i = subs(coeff_end_dy, from_subs_0, to_subs_0);\n',...
                       'cf_dy_%i = subs(cf_dy_%i, ra_i, ra_%i);\n',...
                       'cf_dz_%i = subs(coeff_end_dz, from_subs_0, to_subs_0);\n',...
                       'cf_dz_%i = subs(cf_dz_%i, ra_i, ra_%i);\n',...
                       'cf_dphi_%i = subs(coeff_end_dphi, from_subs_0, to_subs_0);\n',...
                       'cf_dphi_%i = subs(cf_dphi_%i, ra_i, ra_%i);\n',...
                       'cf_dtheta_%i = subs(coeff_end_dtheta_i, from_subs_0, to_subs_0);\n',...
                       'cf_dtheta_%i = subs(cf_dtheta_%i, ra_i, ra_%i);\n',...                       
                       'J_end_a(%i,1) = cf_dx_%i;\n',...
                       'J_end_a(%i,2) = cf_dy_%i;\n',...
                       'J_end_a(%i,3) = cf_dz_%i;\n',...
                       'J_end_a(%i,4) = cf_dphi_%i;\n',...
                       'J_end_b(%i,%i) = -cf_dtheta_%i;\n'...
                       ], i*ones(1,53));
    eval(to_eval);
end

% Now the Jacobians are collected in J_a Z = J_b theta



Ja_N=matlabFunction(J_a);
Jb_N=matlabFunction(J_b);
J_end_aN=matlabFunction(J_end_a);
J_end_bN=matlabFunction(J_end_b);


% disp('Jacobian Z end effector')
% disp(J_end_a)
% 
% disp('Jacobian \theta end effector')
% disp(J_end_b)

geometric_parameters_ragnar

x_pwr_on = 0.0; 
y_pwr_on = 0.0; 
z_pwr_on = -0.45; 
phi_pwr_on = deg2rad(0);

pose_pwr_on = [x_pwr_on; y_pwr_on; z_pwr_on; phi_pwr_on];
% get the initial position of thetas at power on
[thetas_pwr_on, ~] = Rag_fullIKP_rotate_x_ragnar(base_params_ik_, pose_pwr_on, h_all);
draw_ragnar_rotated(thetas_pwr_on,base_params_ik_,pose_pwr_on, h_all)

 JaN=Ja_N(a_x_1,a_x_2,a_x_3,a_x_4,a_y_1,a_y_2,a_y_3,a_y_4,a_z_1,a_z_2,a_z_3,a_z_4,alpha_1,alpha_2,alpha_3,alpha_4,l_prox,beta_1,beta_2,beta_3,beta_4,phi_pwr_on,r_x_1,r_x_2,r_x_3,r_x_4,r_y_1,r_y_2,r_y_3,r_y_4,r_z_1,r_z_2,r_z_3,r_z_4,ra_1_1,ra_1_2,ra_1_3,ra_2_1,ra_2_2,ra_2_3,ra_3_1,ra_3_2,ra_3_3,ra_4_1,ra_4_2,ra_4_3,thetas_pwr_on(1),thetas_pwr_on(2),thetas_pwr_on(3),thetas_pwr_on(4),x_pwr_on,y_pwr_on,z_pwr_on);
JbN=Jb_N(a_x_1,a_x_2,a_x_3,a_x_4,a_y_1,a_y_2,a_y_3,a_y_4,a_z_1,a_z_2,a_z_3,a_z_4,alpha_1,alpha_2,alpha_3,alpha_4,l_prox,beta_1,beta_2,beta_3,beta_4,phi_pwr_on,r_x_1,r_x_2,r_x_3,r_x_4,r_y_1,r_y_2,r_y_3,r_y_4,r_z_1,r_z_2,r_z_3,r_z_4,ra_1_1,ra_1_2,ra_1_3,ra_2_1,ra_2_2,ra_2_3,ra_3_1,ra_3_2,ra_3_3,ra_4_1,ra_4_2,ra_4_3,thetas_pwr_on(1),thetas_pwr_on(2),thetas_pwr_on(2),thetas_pwr_on(4),x_pwr_on,y_pwr_on,z_pwr_on);

cond(JbN\JaN)
