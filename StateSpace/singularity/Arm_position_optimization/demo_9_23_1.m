%% max min https://blog.birost.com/a?ID=01700-32e504a0-899e-417e-b807-8d9f25ddf353
function d=demo_9_23_1(x)% target function file
d(1)=sqrt((x(1)-2)^2+(x(2)-10)^2);
d(2)=sqrt((x(1)-5)^2+(x(2)-13)^2);
d(3)=sqrt((x(1)-8)^2+(x(2)-9)^2);
d(4)=sqrt((x(1)-3)^2+(x(2)-8)^2);
d(5)=sqrt((x(1)-6)^2+(x(2)-6)^2);

%% x = fminimax(fun,x0)
x0=[5;5];
[x,fval]=fminimax(@demo_9_23_1,x0)

% Example two, there are inequality constraints
%% x = fminimax(fun,x0,A,b) has linear inequality constraints 
x0=[5.5;5.5];
A=[1 0;
   -1 0;
   0 1;
   0 -1;];
b=[6;-5;6;-5];
[x,fval]=fminimax(@demo_9_23_1,x0,A,b)
%Example 3 is the equality constraint
%% x = fminimax(fun,x0,A,b,Aeq,beq)% linear equality constraint
x0=[5.5;5.5];
Aeq=[1 -1;];
beq=[-1];
[x,fval]=fminimax(@demo_9_23_1,x0,[],[],Aeq,beq)
% The inequality constraints of Example 2 can also be written as follows
%% x = fminimax(fun,x0,A,b,Aeq,beq,lb,ub) %The upper and lower limits of the solution vector
x0=[5.5;5.5];
[x,fval]=fminimax(@demo_9_23_1,x0,[],[],[],[],[5;5],[6;6])
% Case Four. Nonlinear constraints
%% x = fminimax(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon) %non-linear constraint
%nonlcon stores nonlinear constraints
x0=[5.5;5.5];
[x,fval]=fminimax(@demo_9_23_1,x0,[],[],[],[],[],[],@demo_9_23_2)
end