
% Inverse kinematics with the passive joints solution
function [sol, sol2] = Rag_fullIKP_rotate_x_ragnar(parameter, pose, h_all)
% create function handles for rotations 
Rx = @(angle) ([1 0 0; 0, cos(angle) -sin(angle); 0, sin(angle) cos(angle)]); 
Ry = @(angle) ([cos(angle) 0 sin(angle); 0 1 0; -sin(angle) 0 cos(angle)]); 
Rz = @(angle) ([cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1]); 

%% mobile platform motion
x = pose(1); y = pose(2); z = pose(3);
P = [x; y; z]; % position [mm] P = [0; 40; -80];
phi = pose(4);
%%%%%%%%%%%%%%%%%%%%%%%%%%% rotation matrix
%Q = [cos(phi) -sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1];

%% the position vector of A, B, C in the reference frame Oxyz

% O--------A
%    ...
%               B
% ...
% P---C

SOL = zeros(2, 4);
SOL2 = zeros(2,4);
ii = [1 0 0]';
j = [0 1 0]';
k = [0 0 1]';
solutions = [2,1,2,1];
u_j = [j j -j -j];
% platform_to_rotation_arm_1_2 = [0, 48e-3, 24.259e-3]'; 
% platform_to_rotation_arm_3_4 = [0, -48e-3, 24.259e-3]'; 
% 
% h_all = [platform_to_rotation_arm_1_2, platform_to_rotation_arm_1_2, platform_to_rotation_arm_3_4, platform_to_rotation_arm_3_4];

    
% create the r vector just in case 
% this vectors goes from center of upper or lower platform to arms
% attachment 
for i = 1 : 4
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% the i-th leg parameters
    leg = parameter(i, :);
    a = leg(1); b = leg(2); % base platform
    alpha = leg(3); beta = leg(4); l = leg(5); % inner link
    L = leg(6); % outer link length
    rx = leg(7);
    ry = leg(8);
    rz = leg(9);
    h_d = leg(10);
    r_a = [rx; ry; rz];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   position vectors in xyz
    A = [a; b; 0]; % point A
    %%%modified for testing, Q = identity
    
    %%%%% MODIFICATIONS FOR ROTATING PLATFORM 
    % P1 = P + h_d * Rx(phi) * u_j; %  r_all(:,i);
    % P2 = P + h_d * Rx(phi) * (-u_j);
    % P_points = [P1 P1 P2 P2];
    % for i=1:4
    %     C(:,i) = P_points(:,i) + r_all(:,i); 
    % end 
    C = P + h_d * Rx(phi) * u_j(:,i) + r_a;
    C = P + Rx(phi)*h_all(:,i) + r_a;
    % C = P + Rx(phi)*h_all(i)*k + r_all(:,i);
    
    %%%%% FINISH MODIFICATIONS FOR ROTATING PLATFORM 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  segment vector of CA
    CA = C - A;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%  coefficent of the trigonmetry function
    % e = [r*cos(phi+gama) + x - a; r*cos(phi+gama) + y - b; z];
    I = 2*l*((C(1) - a)*sin(alpha) - (C(2) - b)*cos(alpha));
    J = -2*l*((C(1) - a)*cos(alpha)*cos(beta) ...
        + (C(2) - b)*sin(alpha)*cos(beta) - C(3)*sin(beta));
    K = CA.'*CA + l^2 - L^2;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  solution
    sqrt_Term = I^2 + J^2 - K^2;
    % This solves when the term is negative, just for the small errors
    if sqrt_Term < 0
        sqrt_Term = 0;
    end
    SOL(:, i) = [2*atan((-I + sqrt(sqrt_Term))/(K - J));
        2*atan((-I - sqrt(sqrt_Term))/(K - J))];
    
    %%%%%%%%%%%%%%%%%%%%%%%% solving for the passive joints
    R1 = Rz(alpha) * Ry(beta) * Rz(SOL(solutions(i),i));
    A1 = [a; b; 0];
    S1_1 = R1 * (l*ii);
    B1 = A1+S1_1;
    %% TODO solve this inverse matrix for singularity
    if abs(det(R1))<0.005^2
        [U,S,V] = svd(R1);
        for si=1:1:3
            if S(si,si)<0.005
                S(si,si) = 0;
            else
                S(si,si) = 1/S(si,si);
            end
        end
        R1inv = V*S*U';
    else
        R1inv = inv(R1);
    end
    
    %     R1inv = inv(R1);
    % x1 = [cos(gama); sin(gama); 0]*r + P;
    
    % this is another change for it 
    x1 = C;
    
    temp_term = R1inv*(x1 - A1 - S1_1);
    YY = j'*temp_term;
    XX = ii'*temp_term;
    zeta = atan2(YY,XX);
    
    YY1 = cos(zeta)*k'*temp_term;
    XX1 = ii'*temp_term;
    eta = atan2(-YY1,XX1);
    %%sanity check for the angles
    if eta>pi/2
        eta = eta - pi;
    end
    if eta<-pi/2
        eta = eta + pi;
    end
    SOL2(1,i) = zeta;
    SOL2(2,i) = eta;
    
end

sol = [SOL(2, 1); SOL(1, 2) ;SOL(2, 3) ;SOL(1, 4)];
sol2 = SOL2;
%% Solving for passive angles
 


