function Stepper3_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [];

ttCreateTask('stepper3_task', deadline, 'stepper3_code', data);

ttAttachNetworkHandler('stepper3_task')
