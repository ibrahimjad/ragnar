function [exectime, bucket] = goto_camera_code(seg,bucket)
switch seg
    case 1
    exectime = -1;
    ttSleep(poissrnd(40));
    ttCreateTask('cam',1,'camera_code');

end