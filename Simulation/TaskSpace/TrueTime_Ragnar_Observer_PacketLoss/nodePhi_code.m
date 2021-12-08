function [exectime, data] = nodePhi_code(seg,data)

switch seg
    case 1
        msg = ttGetMsg;
        %exectime = 0.000032;
        exectime = 0;
        if (msg.state == TransmissionStatus.Request)
            %exectime = 0.001;
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