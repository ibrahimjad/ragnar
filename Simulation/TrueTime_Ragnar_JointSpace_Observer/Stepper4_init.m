function Stepper4_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [];

ttCreateTask('stepper4_task', deadline, 'stepper4_code', data);

ttAttachNetworkHandler('stepper4_task')
