function [exectime, data] = nodePhi_code(seg,data)

switch seg
    
    case 1
        exectime = 0.001;
        msg = ttGetMsg;
        
        if (msg.state == TransmissionStatus.Request)
            msg.data(1) = ttAnalogIn(1);
            msg.data(2) = ttAnalogIn(2);
            msg.ActuatorNr = 4;
            msg.state = TransmissionStatus.Send;
            ttSendMsg(1, msg, 80);     % send msg to Teensy
        end
        
        if  (msg.state == TransmissionStatus.Recieve)
            data = msg.data;
        end
        
        if (msg.state == TransmissionStatus.Sync)
           ttAnalogOut(1,data); 
        end
        
    case 2
        exectime = -1;
end