function Teensy_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
meas([1:9])=0;
xold = [0 0.5 -0.4 deg2rad(90) 0 0 0 0]';
data.meas = meas;
data.xold = xold;
deadline = 10;
starttime = 0;
period = 0.002;

ttCreatePeriodicTask('request_Task', starttime, period, 'request_Code');
ttCreateTask('controller_task', deadline, 'controller_code', data)

ttAttachNetworkHandler('controller_task');