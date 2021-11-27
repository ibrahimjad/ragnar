clear all
close all
%Script to find the best placement of the two linear actuators, optimizing
%for two positions: Pick-up and Hand-off.
x0 = [0 0 0 0 0 0]; % Inital point
Aineq = [0 -1 0 0 1 0; 0 0 -1 0 0 1];
bineq = [-0.05;0];
ub = [0.2 0.2 0 0.2 0.2 0];
lb = [-0.2 -0.2 -0.1 -0.2 -0.2 -0.1];
MaxIterations_Data = 100;

[x,fval,exitflag,output,population,score] = fminimax_func(@cond_optimize_targetfunction,x0,Aineq,bineq,lb,ub,MaxIterations_Data)
optimal_solution = x

% Based on these results we think that something like this will be the most
% feasible arm setup:
x_pwr_on = 0; y_pwr_on = 0.5; z_pwr_on = -0.4; phi_pwr_on = deg2rad(90);
solution = optimal_solution(1,:);
cond_optimize_draw
disp('(Fig 1) Solution in handoff position')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))

x_pwr_on = 0; y_pwr_on = 0; z_pwr_on = -0.6; phi_pwr_on = deg2rad(0);
solution = optimal_solution(1,:);
cond_optimize_draw
disp('(Fig 1) Solution in pickup position')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))