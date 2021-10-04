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

% Set an initial imaginary postion of arms to start by 
x_pwr_on = -0.0; 
y_pwr_on = 0.0; 
z_pwr_on = -0.45; 
phi_pwr_on = deg2rad(1); % Almost standing in a flat surface. �

% x_pwr_on = 0; 
% y_pwr_on = 0.1235; 
% z_pwr_on = -0.5482; 
% phi_pwr_on = 0.0611; % Almost standing in a flat surface. �

pose_pwr_on = [x_pwr_on; y_pwr_on; z_pwr_on; phi_pwr_on];
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
display('determinand of jacobian arbitrary initial position')
det(Ja\Jb)
%pause;
% left_hand = [ [eye(4); zeros(4)] -transpose(Cq)]; 
% % Gravity compensator 
% Tau_lambda = left_hand\G_vector;
% 
% G_comp = Tau_lambda(1:4) % Newton meter 


% Do a trajectory testing 
dt = 0.01;
duration = 2; % seconds 
t_ = 0:dt:duration; t_ = t_(:);
[rs,~] = size(t_);
traj_x = 0.0*ones(rs,1); 
% Parametrize a half circle 
y_center = 0.16; 
z_center = -0.28; 
radius_traj = 0.05; 
phi_final_deg = 180/5; 

traj_y = y_center + radius_traj*cos(deg2rad(t_*90/duration+270)); traj_y = traj_y(:);
traj_z = z_center + radius_traj*sin(deg2rad(t_*90/duration+240)); traj_z = traj_z(:);
traj_phi = deg2rad(0:phi_final_deg/(rs-1):phi_final_deg);traj_phi = traj_phi(:); % make sure is column vector 

% This is Henriks traj 
traj_y = 0.3*t_/duration; traj_y = traj_y(:);
traj_z = -0.4 + 0.1*t_/duration; traj_z = traj_z(:);

traj = [traj_x traj_y traj_z traj_phi];
% Numerical differentiation of trajectory for velocity and acceleration 
dtraj = diff(traj)/dt;
ddtraj = diff(dtraj)/dt;
% Accomodate position and velocity getting rid of first positions of vector
% 
traj = traj(3:end,:); % trajectory minus 2 values cause of differentiation 
dtraj = dtraj(2:end,:); % derivative of trajectory 

[sim_size,~] = size(traj); 

% Jacobians are collected in J_a dZ = J_b dtheta
% differentiate dJ_a * dZ + J_a * ddZ = dJ_b dtheta + J_b ddtheta
traj_thetas = zeros(sim_size, 4); 
dtraj_thetas = zeros(sim_size, 4); 
ddtraj_thetas = zeros(sim_size, 4); 
Taus = zeros(sim_size,4);

for ijk = 1:sim_size
    % get the i-th pose 
    pose_ijk = traj(ijk,:); pose_ijk = pose_ijk(:);
    phi_ = pose_ijk(4); 
    x_ = pose_ijk(1);
    y_ = pose_ijk(2);
    z_ = pose_ijk(3);
    [thetas_ijk, ~] = Rag_fullIKP_rotate_x_ragnar(base_params_ik_, pose_ijk, h_all);
    theta_1 = thetas_ijk(1); 
    theta_2 = thetas_ijk(2); 
    theta_3 = thetas_ijk(3); 
    theta_4 = thetas_ijk(4); 
    traj_thetas(ijk,:) = [theta_1, theta_2, theta_3, theta_4];
    % get the velocity with the jacobian 
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
    dpose_ijk = dtraj(ijk,:); dpose_ijk = dpose_ijk(:);
    dx = dpose_ijk(1); 
    dy = dpose_ijk(2);
    dz = dpose_ijk(3); 
    dphi = dpose_ijk(4); 
    dthetas = (Jb\Ja)*dpose_ijk;
    display('det of jacobian')
    display(det(Ja\Jb))
    display('norm of jacobian')
    display(norm(Ja\Jb))
    normJab(ijk) = norm(Ja\Jb);
    condJab(ijk) = cond(Ja\Jb); 
    if norm(Ja\Jb) > 900
        
        disp(t_(ijk));
        % pause();
    end
    dtraj_thetas(ijk,:) = dthetas';
    dtheta_1 = dthetas(1);
    dtheta_2 = dthetas(2);
    dtheta_3 = dthetas(3);
    dtheta_4 = dthetas(4);
    % get the acceleration 
    ddpose_ijk = ddtraj(ijk,:); ddpose_ijk = ddpose_ijk(:);
    dJa = dJ_a(a_y_1,a_y_2,a_y_3,a_y_4,a_z_1,a_z_2,a_z_3,a_z_4,alpha_1,...
        alpha_2,alpha_3,alpha_4,l_prox,beta_1,beta_2,beta_3,beta_4,dphi,...
        dx,dy,dz,phi_,r_y_1,r_y_2,r_y_3,r_y_4,r_z_1,r_z_2,r_z_3,r_z_4,...
        ra_1_2,ra_1_3,ra_2_2,ra_2_3,ra_3_2,ra_3_3,ra_4_2,ra_4_3,theta_1,...
        theta_2,theta_3,theta_4,y_,z_);
    dJb = dJ_b(alpha_1,alpha_2,alpha_3,alpha_4,l_prox,beta_1,beta_2,...
        beta_3,beta_4,dphi,dx,dy,dz,phi_,r_y_1,r_y_2,r_y_3,r_y_4,r_z_1,...
        r_z_2,r_z_3,r_z_4,theta_1,theta_2,theta_3,theta_4);
    % dJ_a * dZ + J_a * ddZ = dJ_b dtheta + J_b ddtheta
    % dJ_a * dZ + J_a * ddZ -dJ_b dtheta =  + Jb ddtheta
    ddthetas_ijk = inv(Jb)*(dJa*dpose_ijk + Ja*ddpose_ijk - dJb*dthetas);
    ddtraj_thetas(ijk,:) = ddthetas_ijk';
    ddx = ddpose_ijk(1);
    ddy = ddpose_ijk(2);
    ddz = ddpose_ijk(3);
    ddphi = ddpose_ijk(4);
    ddtheta_1 = ddthetas_ijk(1);
    ddtheta_2 = ddthetas_ijk(2);
    ddtheta_3 = ddthetas_ijk(3);
    ddtheta_4 = ddthetas_ijk(4);
    % compute constraint jacobian 
    Cq_ = [-Jb Ja]; 
    left_hand_ = [ [eye(4); zeros(4)] -transpose(Cq_)]; 
    % get gravity vector 
    
%     G_vector = G_robot_OS(L_d_1,L_d_2,L_d_3,L_d_4,L_p_1,L_p_2,L_p_3,L_p_4,...
%             alpha_1,alpha_2,alpha_3,alpha_4,beta_1,beta_2,beta_3,beta_4,...
%             end_ratio,g_x,g_y,g_z,m_end_effector,m_platform,phi_,r_y_1,r_y_2,...
%             r_y_3,r_y_4,r_z_1,r_z_2,r_z_3,r_z_4,rho_d_1,rho_d_2,rho_d_3,rho_d_4,...
%             rho_p_1,rho_p_2,rho_p_3,rho_p_4,theta_1,theta_2,theta_3,theta_4,...
%             toend_2,toend_3);
%     H_vector = H_robot_OS(L_d_1,L_d_2,L_d_3,L_d_4,L_p_1,L_p_2,L_p_3,...
%         L_p_4,alpha_1,alpha_2,alpha_3,alpha_4,beta_1,beta_2,beta_3,...
%         beta_4,dphi,dtheta_1,dtheta_2,dtheta_3,dtheta_4,dx,dy,dz,...
%         end_ratio,m_end_effector,phi_,r_x_1,r_x_2,r_x_3,r_x_4,r_y_1,...
%         r_y_2,r_y_3,r_y_4,r_z_1,r_z_2,r_z_3,r_z_4,ra_1_1,ra_1_2,ra_1_3,...
%         ra_2_1,ra_2_2,ra_2_3,ra_3_1,ra_3_2,ra_3_3,ra_4_1,ra_4_2,ra_4_3,...
%         rho_d_1,rho_d_2,rho_d_3,rho_d_4,theta_1,theta_2,theta_3,theta_4,...
%         toend_2,toend_3,x_,y_,z_);
%     M_matrix = M_robot_OS(I_end_1_1,I_pl_1_1,L_d_1,L_d_2,L_d_3,L_d_4,...
%         L_p_1,L_p_2,L_p_3,L_p_4,alpha_1,alpha_2,alpha_3,alpha_4,beta_1,...
%         beta_2,beta_3,beta_4,end_ratio,m_end_effector,m_platform,phi_,...
%         r_x_1,r_x_2,r_x_3,r_x_4,r_y_1,r_y_2,r_y_3,r_y_4,r_z_1,r_z_2,...
%         r_z_3,r_z_4,ra_1_1,ra_1_2,ra_1_3,ra_2_1,ra_2_2,ra_2_3,ra_3_1,...
%         ra_3_2,ra_3_3,ra_4_1,ra_4_2,ra_4_3,rho_d_1,rho_d_2,rho_d_3,...
%         rho_d_4,rho_p_1,rho_p_2,rho_p_3,rho_p_4,theta_1,theta_2,theta_3,...
%         theta_4,toend_2,toend_3,x_,y_,z_);
%     ddq = [ddthetas_ijk(:); ddpose_ijk(:)];
%     right_hand = M_matrix*ddq + H_vector + G_vector;

%     disp('left hand')
%     left_hand_
%     disp('inv left hand')
%     inv(left_hand_)
%     Taus_lambdas = left_hand_\right_hand;
%     Taus_i = Taus_lambdas(1:4); 
%     Taus(ijk,:) = Taus_i(:);

end


% check that it makes sense the jacobian 
diftrajth = diff(traj_thetas)/dt; % thetas velocity 
if false
    figure
    plot(diftrajth);
    title('velocities theta differentiation and multiplied by jacobian')
    hold on 
    grid on 
    grid minor 
    plot(dtraj_thetas);
end
% Also for acceleration 
%{
ddiftrajth = diff(diftrajth)/dt; 
figure
plot(ddiftrajth);
hold on 
grid on 
grid minor 

plot(ddtraj_thetas);
%}
if VISUALIZE_BOOL
    figure
    frame_skip = 15; 
    for ix=1:4:(rs-2)
        pose_num = traj(ix,:);
        theta_num = traj_thetas(ix,:);
        theta_num = theta_num(:);
        draw_ragnar_rotated(theta_num,base_params_ik_,pose_num, h_all);
        pause(0.05);
        if t_(ix)>1.71
           % pause()
        end
    end
end

figure
plot(t_(1:end-2),Taus(:,1))
hold on 
plot(t_(1:end-2),Taus(:,2))
plot(t_(1:end-2),Taus(:,3))
plot(t_(1:end-2),Taus(:,4))
plot(t_(1:end-2),normJab)
plot(t_(1:end-2),condJab)


title('Condition and Norm')
legend('Motor 1','Motor 2','Motor 3', 'Motor 4', 'norm','cond')
grid on 
grid minor 

% figure
% plot(traj)
