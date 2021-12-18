function [exectime, bucket] = camera_token(seg, bucket)

switch seg
    case 1
        exectime = -1;
        bucket.ReplinishToken();
end