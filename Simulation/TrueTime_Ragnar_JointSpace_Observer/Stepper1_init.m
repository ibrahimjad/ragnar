function Stepper1_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [];

ttCreateTask('stepper1_task', deadline, 'stepper1_code', data);

ttAttachNetworkHandler('stepper1_task')
