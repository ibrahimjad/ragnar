function [x,fval,exitflag,output,population,score] = gen_code(nvars,Aineq,bineq,lb,ub)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('gamultiobj');
%% Modify options setting
options = optimoptions(options,'CrossoverFcn', {  @crossoverintermediate [] });
options = optimoptions(options,'Display', 'off');
[x,fval,exitflag,output,population,score] = ...
gamultiobj(@CondMountValFunction_MultiObjective,nvars,Aineq,bineq,[],[],lb,ub,[],options);
