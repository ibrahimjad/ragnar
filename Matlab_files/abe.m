function [x,fval,exitflag,output,lambda,grad,hessian] = abe(MaxIterations_Data)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('fmincon');
%% Modify options setting
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'MaxIterations', MaxIterations_Data);
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon([],[],[],[],[],[],[],[],[],options);
