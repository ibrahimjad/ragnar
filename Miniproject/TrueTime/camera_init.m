function camera_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority

starttime = 0;
period = 0.04;
global bucketCamera;
bucketCamera = TokenBucket(1, 3, 3, 0, @camera_send);

ttCreatePeriodicTask('camera_token_task', starttime, period, 'camera_token', bucketCamera);

ttCreateHandler('camera_arrive_task', 9, 'camera_code', bucketCamera);
ttCreateTimer('camera_arrive_timer', ttCurrentTime + poissrnd(40) / 1000, 'camera_arrive_task');