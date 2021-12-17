function wheel1_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
starttime = 0;
period = 0.01;

ttCreatePeriodicTask('wheel1_Task', starttime, period, 'wheel_code');
