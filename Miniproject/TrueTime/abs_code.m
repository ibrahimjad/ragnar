function [exectime, data] = abs_code(seg,data)

switch seg
    case 1
        exectime = 0;
        data(1) = ttGetMsg;
        data(2) = data(2) +1;
        if (data(2) ~= 4)
            ttSetNextSegment(3)
        end

    case 2    
        exectime = 0;
        ttSendMsg(6, data(1)*5, 8*8);
        data(2) = 0;

        
    case 3
        exectime = -1;
end