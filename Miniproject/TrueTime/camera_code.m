function [exectime, data] = camera_code(seg,data)

switch seg
    case 1
        exectime = 0;
        for i = 1:175
            ttSendMsg(7, 9, 8*8); % We send a 160 bits msg (containing the 
                               % number 1) to node 5 (ABS)
        end
    case 2
        exectime = -1;
end