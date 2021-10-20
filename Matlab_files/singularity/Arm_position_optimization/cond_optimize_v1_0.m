3
3clear all
close all
% We now define a position that the robot is currently sitting in (its pose)
x_pwr_on = 0; y_pwr_on = 0.5; z_pwr_on = -0.4; phi_pwr_on = deg2rad(90);

x0 = [0 0 0 0 0 0]' % We choose an initial point
low_bound = [-1 -1 -1 -1 -1 -1]; 
up_bound = [1 1 1 1 1 1]; % We define our constraints as a lower 
% and an upper bound

% Now we find the solution using the cond number of JN as target function
% Set nondefault solver options
options2 = optimoptions('fmincon','MaxFunctionEvaluations',75,'PlotFcn',...
    {'optimplotx','optimplotfunccount','optimplotfvalconstr','optimplotfval',...
    'optimplotstepsize'});
% Solve
[solution,objectiveValue] = fmincon(@CondMountValFunction,x0,[],[],[],[],...
    low_bound,up_bound,[],options2);
clearvars options2
cond_analyse_homemade_2arm_in_middle_final % We plot the optimal arm placement
disp('(Fig 2)Using cond(JN) as target function')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))
% Now we find the solution using the norm of JN as target function
% Set nondefault solver options
options = optimoptions('fmincon','MaxFunctionEvaluations',75,'Display','off');
% Solve
[solution,objectiveValue] = fmincon(@NormMountValFunction,x0,[],[],[],[],...
    low_bound,up_bound,[],options);
clearvars options
cond_analyse_homemade_2arm_in_middle_final
disp('(Fig 3)Using norm(JN) as target function')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))
% What you will see in figure 1 is just the solver working. We thought this
% was interesting. In figure 2 the optimal placement of the arms using the
% cond(JN) as target function is seen, and in figure 3 the optimal
% placement of the arms using norm(JN) is seen.

% We do realize that the found optimal points does not seem very practical 
% at all, but it does give a bit of insight into the problem. If we define
% some more relistic constraints we can get something like what is seen in
% figure 4 and 5

low_bound = [-0.2 -0.2 -0.1 -0.2 -0.2 -0.1];
up_bound = [0.2 0.2 0 0.2 0.2 0];

% Now we find the solution using the cond number of JN as target function
% Set nondefault solver options
x0 = [0 0 0 0 0 0]'
options2 = optimoptions('fminimax','MaxFunctionEvaluations',300,'Display','off');
% Solve
[solution,objectiveValue] = fminimax(@CondMountValFunction,x0,[],[],[],[],...
    low_bound,up_bound,@ineq,options2);
clearvars options2
cond_analyse_homemade_2arm_in_middle_final % We plot the optimal arm placement
disp('(Fig 4)Using cond(JN) FIMIMAX as target function, with better (more realistic) constraints')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))
solution
options2 = optimoptions('fmincon','MaxFunctionEvaluations',500,'Display','off');
[solution,objectiveValue] = fmincon(@CondMountValFunction,x0,[],[],[],[],...
    low_bound,up_bound,@ineq,options2);
clearvars options2
cond_analyse_homemade_2arm_in_middle_final % We plot the optimal arm placement
disp('(Fig 4)Using cond(JN) as target function, with better (more realistic) constraints')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))
solution
% Now we find the solution using the norm of JN as target function
% Set nondefault solver options
options = optimoptions('fmincon','MaxFunctionEvaluations',75,'Display','off');
% Solve
[solution,objectiveValue] = fmincon(@NormMountValFunction,x0,[],[],[],[],...
    low_bound,up_bound,@ineq,options);
clearvars options
cond_analyse_homemade_2arm_in_middle_final
disp('(Fig 5)Using norm(JN) as target function, with better (more realistic) constraints')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))


% Based on these results we think that something like this will be the most
% feasible arm setup:
solution = [0;-0.11;-0.038;0;-0.15;-0.037];
cond_analyse_homemade_2arm_in_middle_final
disp('(Fig 6) The setup we will move forward with (based on fig 4)')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))

g=9.82; % Gravitational constant in [m/s^2]
m = 1.277; % Mass of the platform in [kg]
F = [0 0 g*m 0]'; % We assume that the mass is only pulling in z direction
tau = -(JN') * F; % Forces required my the motors
shaft_diameter = 0.05; % Meters
shaft_circumference = pi*shaft_diameter;
revolutions=200; % 200 steps to do 1 full rotation
res = shaft_circumference/revolutions; % Resolution of the motors. Corresponds to (2*pi)/8000
thetas = [res res res res res res]';
dP = JN * thetas; dP = vpa(dP);

% If we put the robot in the neutral position we obtain:
x_pwr_on = 0; y_pwr_on = 0; z_pwr_on = -0.6; phi_pwr_on = deg2rad(0);
cond_analyse_homemade_2arm_in_middle_final
disp('(Fig 7) The setup we will move forward with in neutral position')
fprintf('Cond(JN) = %f and norm(JN)=%g\n', cond(JN), norm(JN))


fprintf('The force in [N] required by each of the motors to hold the\n platform in the handoff position (fig6)=\n')
vpa(tau,4)
fprintf('The resulting resolution of the platform movement =\n')
vpa(dP,4)
