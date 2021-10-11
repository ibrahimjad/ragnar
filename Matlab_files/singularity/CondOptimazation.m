clear all
objective = @(V) CondMountValFunction(V)

% initial guess
x0=[0;0.045;-0.02;0;-0.045;-0.02];
% 
% % variable bounds
lb = -0.5 * ones(6);
ub = 0.5 * ones(6);

% show initial objective
disp(['Initial Objective: ' num2str(objective(x0))])

% linear constraints
A = [];
b = [];
Aeq = [];
beq = [];

% nonlinear constraints
nonlincon = []

% optimize with fmincon
%[X,FVAL,EXITFLAG,OUTPUT,LAMBDA,GRAD,HESSIAN]
% = fmincon(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON,OPTIONS)
x = fmincon(objective,x0,A,b,Aeq,beq,lb,ub,nonlincon);

% show final objective
disp(['Final Objective: ' num2str(objective(x))])

% print solution
disp('Solution')
disp(['x1 = ' num2str(x(1))])
disp(['x2 = ' num2str(x(2))])
disp(['x3 = ' num2str(x(3))])
disp(['x4 = ' num2str(x(4))])
disp(['x5 = ' num2str(x(5))])
disp(['x6 = ' num2str(x(6))])