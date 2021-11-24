function LinearAc2_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [];

ttCreateTask('LinearAc2_task', deadline, 'LinearAc2_code', data);

ttAttachNetworkHandler('LinearAc2_task')