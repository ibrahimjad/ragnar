function Stepper2_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [];

ttCreateTask('stepper2_task', deadline, 'stepper2_code', data);

ttAttachNetworkHandler('stepper2_task')
