function nodeZ_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [];

ttCreateTask('nodeZ_task', deadline, 'nodeZ_code', data);

ttAttachNetworkHandler('nodeZ_task')
