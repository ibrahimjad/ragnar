function [exectime, data] = stepper3_code(seg,data)

switch seg
    
    case 1
        exectime = 0.005;
        
        msg = ttGetMsg;
        
        if (msg.state == TransmissionStatus.Request)
            msg.data = ttAnalogIn(1);
            msg.ActuatorNr = 3;
            msg.state = TransmissionStatus.Send;
            ttSendMsg(1, msg, 250);     % send msg to Teensy
        end
        
        if  (msg.state == TransmissionStatus.Recieve)
            disp('stepper 3')
            data = msg.data;
        end
        
        if (msg.state == TransmissionStatus.Sync)
            disp('syncing')
           ttAnalogOut(1,data); 
        end
        
    case 2
        exectime = -1;
end