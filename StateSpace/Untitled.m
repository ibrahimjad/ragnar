x0 = [0.1 0.1 0.1 0.1 0.1 0.1]'
x0 = [-0.1 -0.1 -0.1 -0.1 -0.1 -0.1]'
x0 = [0.2 0.2 0.2 0.2 0.2 0.2]'
x0 = [-0.2 -0.2 -0.2 -0.2 -0.2 -0.2]'
x0 = [-0.2 -0.2 -0.2 0.2 0.2 0.2]'
x0 = [0.2 0.2 0.2 -0.2 -0.2 -0.2]'
x0 = [0.2 0.2 0.2 0.2 -0.2 -0.2]'
x0 = [0.2 0.2 0.2 0.2 0.2 -0.2]'
x0 = [0.2 0.2 -0.2 -0.2 -0.2 -0.2]'
x0 = [0.2 -0.2 -0.2 -0.2 -0.2 -0.2]'
x0 = [-0.2 0.2 0.2 0.2 0.2 0.2]'
x0 = [-0.2 -0.2 0.2 0.2 0.2 0.2]'
x0 = [-0.2 -0.2 -0.2 0.2 0.2 0.2]'
x0 = [-0.2 -0.2 -0.2 -0.2 0.2 0.2]'
x0 = [-0.2 -0.2 -0.2 -0.2 -0.2 0.2]'
x0 = [0.2 0.2 -0.2 0.2 0.2 -0.2]'
options2 = optimoptions('fminimax','MaxFunctionEvaluations',75,'Display','off');
% Solve
[solution,objectiveValue] = fminimax(@CondMountValFunction,x0,[],[],[],[],...
    low_bound,up_bound,@ineq,options2);
clearvars options2
solution = x0
cond_analyse_homemade_2arm_in_middle_final % We plot the optimal arm placement
disp('(Fig 4)Using cond(JN) as target function, with better (more realistic) constraints')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))
solution