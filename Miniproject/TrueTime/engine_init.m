function engine_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [0 0];

ttCreateTask('engine_task', deadline, 'engine_code', data);

ttAttachNetworkHandler('engine_task')