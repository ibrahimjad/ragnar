function camera_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
starttime = 0;
period = 0.04;

ttCreateTask('camera_task', deadline, 'goto_camera_code');
ttCreateJob('camera_task');

%bucket_camera = TokenBucket(1,3,3,0,0.04);
% ttCreateTask('camera_task', deadline, 'camera_code', meas)
% ttCreateTimeTriggeredDispatcher
% ttAttachTimeTriggeredDispatcher
% 
% ttAttachNetworkHandler('camera_task');

%ttCreatePeriodicTask('tokens_cam', starttime, period, 'camera_token', bucket_camera);