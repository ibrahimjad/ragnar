function Teensy_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
meas([1:9])=0;
deadline = 10;
starttime = 0;
period = 0.003;

ttCreatePeriodicTask('request_Task', starttime, period, 'request_Code');
ttCreateTask('controller_task', deadline, 'controller_code', meas)

ttAttachNetworkHandler('controller_task');
