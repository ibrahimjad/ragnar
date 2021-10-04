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
N=100000;
% Set an initial imaginary postion of arms to start by
x_pwr_on = 0.3*(rand(1,N)-0.5);
y_pwr_on = 0.3*(rand(1,N)-0.5);
z_pwr_on = -0.45+0.3*rand(1,N);
phi_pwr_on = 0.3*(rand(1,N)-0.5);  % Almost standing in a flat surface. �
plot3(x_pwr_on(1),y_pwr_on(1),z_pwr_on(1),'r.')
hold on

% x_pwr_on = 0;
% y_pwr_on = 0.1235;
% z_pwr_on = -0.5482;
% phi_pwr_on = 0.0611; % Almost standing in a flat surface. �
cnt=1;
for i=1:N
    pose_pwr_on = [x_pwr_on(i); y_pwr_on(i); z_pwr_on(i); phi_pwr_on(i)];
    % get the initial position of thetas at power on
    [thetas_pwr_on, ~] = Rag_fullIKP_rotate_x_ragnar(base_params_ik_, pose_pwr_on, h_all);
    % Imagining that we only have the thetas power on, get the initial position
    % by forward kinematics
    % [x_fk_pwr_on, y_fk_pwr_on, z_fk_pwr_on, phi_fk_pwr_on] = ...
    %                         OS_FK_test_1(thetas_pwr_on, base_params_ik_, true);
    % pose_fk_pwr_on = [x_fk_pwr_on; y_fk_pwr_on; z_fk_pwr_on; phi_fk_pwr_on];
    % Compare the values
    % disp('if is a vector zero (or very close), then it is correct');
    % disp(pose_pwr_on' - pose_fk_pwr_on');
    
    theta_1 = thetas_pwr_on(1);
    theta_2 = thetas_pwr_on(2);
    theta_3 = thetas_pwr_on(3);
    theta_4 = thetas_pwr_on(4);
    phi_ = pose_pwr_on(4);
    x_ = pose_pwr_on(1);
    y_ = pose_pwr_on(2);
    z_ = pose_pwr_on(3);
    % Compute gravity compensator
    % G_vector = G_robot_OS(L_d_1,L_d_2,L_d_3,L_d_4,L_p_1,L_p_2,L_p_3,L_p_4,...
    %     alpha_1,alpha_2,alpha_3,alpha_4,beta_1,beta_2,beta_3,beta_4,...
    %     end_ratio,g_x,g_y,g_z,m_end_effector,m_platform,phi_,r_y_1,r_y_2,...
    %     r_y_3,r_y_4,r_z_1,r_z_2,r_z_3,r_z_4,rho_d_1,rho_d_2,rho_d_3,rho_d_4,...
    %     rho_p_1,rho_p_2,rho_p_3,rho_p_4,theta_1,theta_2,theta_3,theta_4,...
    %     toend_2,toend_3);
    
    % Now the Jacobians are collected in J_a dZ = J_b dtheta
    % Cq [dtheta] = 0             [-Jb  Ja] [dtheta] = 0
    %    [ dZ   ]                           [ dZ   ]
    % Cq size is 4x8
    % Cq = [-Jb  Ja] , Cq^T size is 8x4
    % Dynamic formulation is as follows
    % M ddq + H + G + Cq^T lambda = [Tau]
    %                               [ 0 ]
    % Solving for Tau
    %[ I        ][Tau   ] = M ddq + H + G
    %[    -Cq^T ]
    %[ 0        ][Lambda]
    
    %[ Tau  ] = [ I        ]^-1 [ M ddq + H + G]
    %[lambda]   [    -Cq^T ]
    %           [ 0        ]
    
    
    
    
    % Compute the gravity compensator
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
    norm(Ja\Jb);
    i
    cnt
    if(cond(Ja\Jb)>10000)
    %if(1==1)
        ill_poses(:,cnt)=pose_pwr_on;
        cnt=cnt+1;
        %plot3(pose_pwr_on(1),pose_pwr_on(2),pose_pwr_on(3),'.')
        %pause(0.05)
    end
end
plot3(ill_poses(1,:),ill_poses(2,:),ill_poses(3,:),'.')

