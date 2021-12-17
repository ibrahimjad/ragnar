function abs_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [0 0];
disp('motors')
ttCreateTask('abs_task', deadline, 'abs_code', data);

ttAttachNetworkHandler('abs_task')
