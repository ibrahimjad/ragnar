function [exectime, data] = request_Code(seg,data)

switch seg
    
    case 1
        exectime = 0.0000025;
    case 2
        msg.state = TransmissionStatus.Request;
        ttSendMsg(0,msg,48,1);
        exectime = -1;
end