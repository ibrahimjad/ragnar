function LinearAc1_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [];

ttCreateTask('LinearAc1_task', deadline, 'LinearAc1_code', data);

ttAttachNetworkHandler('LinearAc1_task')