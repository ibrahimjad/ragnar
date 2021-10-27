clear all
close all

nvars = 6;
x0 = [0 0 0 0 0 0];
Aineq = [0 -1 0 0 1 0; 0 0 -1 0 0 1];
bineq = [-0.05;0];
lb = [-0.2 -0.2 -0.1 -0.2 -0.2 -0.1];
ub = [0.2 0.2 0 0.2 0.2 0];
MaxIterations_Data = 100;

% lb = [];
% ub = [];

[x,fval,exitflag,output,population,score] = ny(x0,Aineq,bineq,lb,ub,MaxIterations_Data)
optimal_solution = x

% Based on these results we think that something like this will be the most
% feasible arm setup:
x_pwr_on = 0; y_pwr_on = 0.5; z_pwr_on = -0.4; phi_pwr_on = deg2rad(90);
solution = optimal_solution(1,:);
cond_analyse_homemade_2arm_in_middle_final
disp('(Fig 1) Solution in handoff position')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))

x_pwr_on = 0; y_pwr_on = 0; z_pwr_on = -0.6; phi_pwr_on = deg2rad(0);
solution = optimal_solution(1,:);
cond_analyse_homemade_2arm_in_middle_final
disp('(Fig 1) Solution in pickup position')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))
% 
% g=9.82; % Gravitational constant in [m/s^2]
% m = 1.277; % Mass of the platform in [kg]
% F = [0 0 g*m 0]'; % We assume that the mass is only pulling in z direction
% tau = -(JN') * F; % Forces required my the motors
% shaft_diameter = 0.05; % Meters
% shaft_circumference = pi*shaft_diameter;
% revolutions=200; % 200 steps to do 1 full rotation
% res = shaft_circumference/revolutions; % Resolution of the motors. Corresponds to (2*pi)/8000
% thetas = [res res res res res res]';
% dP = JN * thetas; dP = vpa(dP);
% 
% 
% fprintf('The force in [N] required by each of the motors to hold the\n platform in the handoff position (fig6)=\n')
% vpa(tau,4)
% fprintf('The resulting resolution of the platform movement =\n')
% vpa(dP,4)
% 
% % If we put the robot in the neutral position we obtain:
% x_pwr_on = 0; y_pwr_on = 0; z_pwr_on = -0.6; phi_pwr_on = deg2rad(0);
% cond_analyse_homemade_2arm_in_middle_final
% disp('(Fig 7) The setup we will move forward with in neutral position')
% fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))