function [exectime, data] = engine_code(seg,data)

switch seg
    case 1
        exectime = 0;
        data(1) = ttGetMsg;

    case 2
        exectime = -1;
end