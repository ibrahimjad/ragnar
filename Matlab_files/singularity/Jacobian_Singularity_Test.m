% Dynamic Simulation 

close all; clear all;

% addpath(genpath('.'));
% addpath(genpath('../Physical parameters')); % Add geometric and mass parameters location
% addpath(genpath('../Dynamics HS/generated')); % Add Dynamic functions location
% addpath(genpath('../Kinematic Jacobian Analysis JDDFM/generated')); % Add Jacobian locations
% addpath(genpath('../FK&IK Open Spider JDDFM')); % Add Draw Ragnar FK and IK locations
% addpath(genpath('../FK&IK Open Spider JDDFM/generated')); % Add Draw Ragnar FK and IK locations

geometric_parameters_ragnar; % Load geometric parameters

% mass_parameters; % Load mass parameters

VISUALIZE_BOOL = true;
N=1;
% Set an initial imaginary postion of arms to start by
x_pwr_on = 0;
y_pwr_on = 0;
z_pwr_on = -0.45;
phi_pwr_on = 0;  % Almost standing in a flat surface. �


cnt=1;
for i=1:N
    pose_pwr_on = [x_pwr_on(i); y_pwr_on(i); z_pwr_on(i); phi_pwr_on(i)];
    % get the initial position of thetas at power on
    [thetas_pwr_on, ~] = Rag_fullIKP_rotate_x_ragnar(base_params_ik_, pose_pwr_on, h_all);
   
    
    theta_1 = thetas_pwr_on(1);
    theta_2 = thetas_pwr_on(2);
    theta_3 = thetas_pwr_on(3);
    theta_4 = thetas_pwr_on(4);
    phi_ = pose_pwr_on(4);
    x_ = pose_pwr_on(1);
    y_ = pose_pwr_on(2);
    z_ = pose_pwr_on(3);
  
    
    Ja = J_a(a_x_1,a_x_2,a_x_3,a_x_4,a_y_1,a_y_2,a_y_3,a_y_4,a_z_1,a_z_2,...
        a_z_3,a_z_4,alpha_1,alpha_2,alpha_3,alpha_4,l_prox,beta_1,beta_2,...
        beta_3,beta_4,phi_,r_x_1,r_x_2,r_x_3,r_x_4,r_y_1,r_y_2,r_y_3,r_y_4,...
        r_z_1,r_z_2,r_z_3,r_z_4,ra_1_1,ra_1_2,ra_1_3,ra_2_1,ra_2_2,ra_2_3,...
        ra_3_1,ra_3_2,ra_3_3,ra_4_1,ra_4_2,ra_4_3,theta_1,theta_2,theta_3,...
        theta_4,x_,y_,z_);
    Jb = J_b(a_x_1,a_x_2,a_x_3,a_x_4,a_y_1,a_y_2,a_y_3,a_y_4,a_z_1,a_z_2,...
        a_z_3,a_z_4,alpha_1,alpha_2,alpha_3,alpha_4,l_prox,beta_1,beta_2,beta_3,...
        beta_4,phi_,r_x_1,r_x_2,r_x_3,r_x_4,r_y_1,r_y_2,r_y_3,r_y_4,r_z_1,r_z_2,...
        r_z_3,r_z_4,ra_1_1,ra_1_2,ra_1_3,ra_2_1,ra_2_2,ra_2_3,ra_3_1,ra_3_2,...
        ra_3_3,ra_4_1,ra_4_2,ra_4_3,theta_1,theta_2,theta_3,theta_4,x_,y_,z_);
    % Constraint jacobian
    Cq = [-Jb  Ja];
    %display('determinand of jacobian arbitrary initial position')
    det(Ja\Jb);
    Jac=Ja\Jb;
    
    [HH II]=eig(Jac)
   
end


