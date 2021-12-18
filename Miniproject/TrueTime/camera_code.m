function [exectime, bucket] = camera_code(seg,bucket)
switch seg
    case 1
        exectime = -1;
        bucket.Arrive();
        ttCreateTimer('camera_timer', ttCurrentTime + poissrnd(40) / 1000, 'camera_arrive_task');
end