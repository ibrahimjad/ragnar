function nodeY_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [];

ttCreateTask('nodeY_task', deadline, 'nodeY_code', data);

ttAttachNetworkHandler('nodeY_task')
