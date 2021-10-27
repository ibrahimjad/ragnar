function [x,fval,maxfval,exitflag,output,lambda] = ny(x0,Aineq,bineq,lb,ub,MaxIterations_Data)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('fminimax');
%% Modify options setting
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'MaxIterations', MaxIterations_Data);
[x,fval,maxfval,exitflag,output,lambda] = ...
fminimax(@CondMountValFunction_MultiObjective,x0,Aineq,bineq,[],[],lb,ub,[],options);
