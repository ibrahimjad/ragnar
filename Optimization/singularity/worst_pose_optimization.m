clear all
close all
% Script to find the pose that result in the worst conditioned jacobian.
% This is an attempt to prove that the cond(JN) does not become singular in
% any feasible end-effector pose.
% Target function is however not convex, meaning that the function won't
% neccesarily converge to the minimizer
x0 = [0 0 -0.3 0]; % Inital point. Different x0 results in different results :(
Aineq = [];
bineq = [];
ub = [0 0.5 -0.3 pi/2];
lb = [0 -0.1 -0.7 0];
MaxIterations_Data = 100;

[x,fval,exitflag,output,population,score] = fminimax_func(@worst_pose_targetfunction,x0,Aineq,bineq,lb,ub,MaxIterations_Data)
optimal_solution = x

% Based on these results we think that something like this will be the most
% feasible arm setup:
%x_pwr_on = 0; y_pwr_on = 0.5; z_pwr_on = -0.4; phi_pwr_on = deg2rad(90);
solution = optimal_solution(1,:);
worst_pose_draw
disp('(Fig 1) Solution in handoff position')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))