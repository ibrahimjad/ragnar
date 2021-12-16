function nodePhi_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [];

ttCreateTask('nodePhi_task', deadline, 'nodePhi_code', data);

ttAttachNetworkHandler('nodePhi_task')
