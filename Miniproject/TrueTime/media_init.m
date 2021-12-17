function media_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
starttime = 0;
period = 0.04;

ttCreatePeriodicTask('media_Task', starttime, period, 'media_code');
