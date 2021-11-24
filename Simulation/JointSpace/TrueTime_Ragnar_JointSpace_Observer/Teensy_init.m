function Teensy_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
meas([1:1:7],1)=0;
deadline = 10;
starttime = 0;
period = 1;

ttCreatePeriodicTask('request_Task', starttime, period, 'request_Code');
ttCreateTask('controller_task', deadline, 'controller_code', meas)

ttAttachNetworkHandler('controller_task');