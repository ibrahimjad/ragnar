% numerical values 

% define some unitary vectors 
u_i   = [1 0 0]';
u_j   = [0 1 0]';
u_k   = [0 0 1]';

ax = 280/1000; 
ay = 114/1000;

a_x_1 = ax;
a_x_2 = -ax;
a_x_3 = -ax;
a_x_4 = ax;

a_y_1 = ay;
a_y_2 = ay;
a_y_3 = -ay;
a_y_4 = -ay;

a_z_1 = 0; 
a_z_2 = 0; 
a_z_3 = 0; 
a_z_4 = 0; 

alpha_g = deg2rad(15);

alpha_1 = -alpha_g;
alpha_2 = alpha_g;
alpha_3 = -alpha_g;
alpha_4 = alpha_g;

beta_g = deg2rad(45);

beta_1 = -beta_g;
beta_2 = beta_g;
beta_3 = beta_g;
beta_4 = -beta_g;

l_prox = 0.3; 
l_dist = 0.6; 
 

end_ratio = 1.0; 

L_d_1 = l_dist; 
L_d_2 = l_dist; 
L_d_3 = l_dist; 
L_d_4 = l_dist;

L_p_1 = l_prox;  
L_p_2 = l_prox; 
L_p_3 = l_prox;  
L_p_4 = l_prox;  


platform_to_rotation_arm_1_2 = [0, 48e-3, 24.259e-3]'; 
platform_to_rotation_arm_3_4 = [0, -48e-3, 24.259e-3]'; 
r1 = platform_to_rotation_arm_1_2;
r2 = r1; 
r3 = platform_to_rotation_arm_3_4;
r4 = r3; 

h_all = [platform_to_rotation_arm_1_2, platform_to_rotation_arm_1_2, platform_to_rotation_arm_3_4, platform_to_rotation_arm_3_4];


% Rotating vectors
% The vector goes from center of moving platform to axis rotating. 
r_x_1 = r1(1); r_y_1 = r1(2); r_z_1 = r1(3); 
r_x_2 = r2(1); r_y_2 = r2(2); r_z_2 = r2(3);
r_x_3 = r3(1); r_y_3 = r3(2); r_z_3 = r3(3);
r_x_4 = r4(1); r_y_4 = r4(2); r_z_4 = r4(3);

% Fixed vectors 
% The vector goes from rotating axis to attachment point 
r_a_1 = [80e-3, 22e-3, 24e-3]';
r_a_2 = [-60e-3, 57e-3, 24e-3]';
r_a_3 = [-60e-3, -57e-3, 24e-3]';
r_a_4 = [80e-3, -22e-3, 24e-3]';

% r_a_1 = [60e-3, 22e-3, 100e-3]';
% r_a_2 = [-60e-3, 22e-3, 100e-3]';
% r_a_3 = [-80e-3, -57e-3, 24e-3]';
% r_a_4 = [80e-3, -57e-3, 24e-3]';





ra_1_1 = r_a_1(1); 
ra_1_2 = r_a_1(2);
ra_1_3 = r_a_1(3);

ra_2_1 = r_a_2(1); 
ra_2_2 = r_a_2(2);
ra_2_3 = r_a_2(3);

ra_3_1 = r_a_3(1); 
ra_3_2 = r_a_3(2);
ra_3_3 = r_a_3(3);

ra_4_1 = r_a_4(1); 
ra_4_2 = r_a_4(2);
ra_4_3 = r_a_4(3);

base_params_ = [a_x_1 a_y_1 alpha_1 beta_1 l_prox l_dist;
                a_x_2 a_y_2 alpha_2 beta_2 l_prox l_dist;
                a_x_3 a_y_3 alpha_3 beta_3 l_prox l_dist;
                a_x_4 a_y_4 alpha_4 beta_4 l_prox l_dist];
r_all_ = [r_a_1 r_a_2 r_a_3 r_a_4];
h_d_ = 0.1; % this parameter it is not used 
base_params_ik_ = [base_params_ r_all_' h_d_*ones(4,1)];

% vector from rotating point to end effector 
to_end = [0; 0; -10e-2];
toend_1 = to_end(1); 
toend_2 = to_end(2); 
toend_3 = to_end(3);