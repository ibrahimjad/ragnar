function [exectime, bucket] = camera_token(seg,bucket)

switch seg
    case 1
        bucket.ReplinishToken();
        exectime = -1;
end