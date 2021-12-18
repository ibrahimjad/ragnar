function camera_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority

starttime = 0;
period = 0.04;
bucket = TokenBucket(1, 3, 3, 0, @camera_send);

ttCreatePeriodicTask('camera_token_task', starttime, period, 'camera_token', bucket);

ttCreateHandler('camera_arrive_task', 9, 'camera_code', bucket);
ttCreateTimer('camera_arrive_timer', ttCurrentTime + poissrnd(40) / 1000, 'camera_arrive_task');