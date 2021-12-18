function [exectime, bucket] = media_code(seg,bucket)
switch seg
    case 1
        exectime = -1;
        bucket.Arrive();
        ttCreateTimer('media_timer', ttCurrentTime + poissrnd(40) / 1000, 'media_arrive_task');
end