function nodeX_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [];

ttCreateTask('nodeX_task', deadline, 'nodeX_code', data);

ttAttachNetworkHandler('nodeX_task')
