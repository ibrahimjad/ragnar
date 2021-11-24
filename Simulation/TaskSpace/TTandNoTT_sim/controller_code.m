function [exectime, meas] = controller_code(seg,meas)

F_mimo =[ -230.9401         0         0         0  -34.4133         0         0         0
         0 -250.4995         0         0         0  -35.8128         0         0
         0         0 -250.4995         0         0         0  -35.8128         0
         0         0         0   -0.0828         0         0         0   -0.0123];
ref = zeros(1,8);

for i=1:8
    ref(i) = ttAnalogIn(i);
end

switch seg
    case 1 %% We received measurment
        
        
        
        msg = ttGetMsg; % sensor data (actuator position)
        exectime = 0.001;
        
        if msg.state == TransmissionStatus.Send
            meas(msg.ActuatorNr) = msg.data(1);
            meas(4+msg.ActuatorNr) = msg.data(2);
        end
        meas(9) = meas(9) + 1;
        
        if (meas(9) ~= 4)
            ttSetNextSegment(5)
        end
    case 2
        exectime = 0.001;
    case 3
     
        ControllerOut=F_mimo*(meas(1:8)-ref)';
        
        msg.state = TransmissionStatus.Recieve;
        
        for i = 1:4
            msg.data=ControllerOut(i);
            ttSendMsg(i+1, msg, 64);
        end
        
        meas(9) = 0;
        exectime = 0.0005;
    case 4
        msg = [];
        msg.state = TransmissionStatus.Sync;
        ttSendMsg(0, msg, 64);
        exectime = 0;
        
    case 5
        exectime = -1;
end
