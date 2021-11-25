function [exectime, meas] = controller_code(seg,meas)

F_mimo =[ -400.7992         0         0         0  -46.5674         0         0         0
         0 -250.4995         0         0         0  -35.8128         0         0
         0         0 -250.4995         0         0         0  -35.8128         0
         0         0         0   -0.1436         0         0         0   -0.0167];

ref = zeros(1,8);

for i=1:8
    ref(i) = ttAnalogIn(i);
end
switch seg
    case 1 %% We received measurment
        msg = ttGetMsg; % sensor data (actuator position)
        exectime = 0.0000125;
        
        if msg.state == TransmissionStatus.Send
            meas(msg.ActuatorNr) = msg.data(1);
            meas(4+msg.ActuatorNr) = msg.data(2);
        end
        meas(9) = meas(9) + 1;
        
        if (meas(9) ~= 4)
            ttSetNextSegment(5)
        end
    case 2
         if (meas(1) == 0 && meas(2) == 0 && meas(3) == 0 && meas(4) == 0 && meas(5) == 0 && meas(6) == 0 && meas(7) == 0 && meas(8) == 0)
            ttSetNextSegment(4)
        end
        exectime = 0.00122
    case 3
        
        ControllerOut=F_mimo*(meas(1:8)-ref)';
        
        msg.state = TransmissionStatus.Recieve;
        
        for i = 1:4
            msg.data=ControllerOut(i);
            ttSendMsg(i+1, msg, 64);
        end
        
        exectime = 0;
    case 4
        meas(9) = 0;
        msg = [];
        msg.state = TransmissionStatus.Sync;
        ttSendMsg(0, msg, 64);
       exectime = 0.0000025;
        
    case 5
        exectime = -1;
end
