function media_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority

starttime = 0;
period = 0.04;
global bucketMedia;
bucketMedia = TokenBucket(1, 3, 3, 0, @media_send);

ttCreatePeriodicTask('media_token_task', starttime, period, 'media_token', bucketMedia);

ttCreateHandler('media_arrive_task', 8, 'media_code', bucketMedia);
ttCreateTimer('media_arrive_timer', ttCurrentTime + poissrnd(40) / 1000, 'media_arrive_task');