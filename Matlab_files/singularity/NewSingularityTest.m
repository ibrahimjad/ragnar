% Dynamic Simulation 

close all; clear all;
Rx = @(angle) ([1 0 0; 0, cos(angle) -sin(angle); 0, sin(angle) cos(angle)]); 

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
x_pwr_on = 0.3;
y_pwr_on = 0;
z_pwr_on = -0.3;
phi_pwr_on = 0; 


for i=1:N
    pose_pwr_on = [x_pwr_on(i); y_pwr_on(i); z_pwr_on(i); phi_pwr_on(i)];
    % get the initial position of thetas at power on
    [thetas_pwr_on, the2,Bret,Cret,Aret] = Rag_fullIKP_rotate_x_ragnar_wB_C(base_params_ik_, pose_pwr_on, h_all);
    
    It=eye(3);
    Atot=[[It Aret(:,1)]'*(Bret(:,1)-Cret(:,1)) [It Aret(:,2)]'*(Bret(:,2)-Cret(:,2)) [It Aret(:,3)]'*(Bret(:,3)-Cret(:,3)) [It Aret(:,4)]'*(Bret(:,4)-Cret(:,4))];
    [HA IA]=eig(Atot*Atot')
    
    
    theta_1 = thetas_pwr_on(1);
    theta_2 = thetas_pwr_on(2);
    theta_3 = thetas_pwr_on(3);
    theta_4 = thetas_pwr_on(4);
    phi_ = pose_pwr_on(4);
    x_ = pose_pwr_on(1);
    y_ = pose_pwr_on(2);
    z_ = pose_pwr_on(3);
    
end


