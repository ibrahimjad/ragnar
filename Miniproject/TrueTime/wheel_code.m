function [exectime, data] = wheel_code(seg,data)

switch seg
    case 1
        exectime = 0;
        ttSendMsg(5, 1, 20*8); % We send a 160 bits msg (containing the 
                               % number 1) to node 5 (ABS)

    case 2
        exectime = -1;
end