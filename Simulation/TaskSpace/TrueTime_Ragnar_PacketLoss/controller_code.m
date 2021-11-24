function [exectime, meas] = controller_code(seg,meas)

F_mimo =[-1.4629         0         0         0   -2.7429         0         0         0
         0   -3.4482         0         0         0   -4.2057         0         0
         0         0   -3.0563         0         0         0   -4.0229         0
         0         0         0   -0.0013         0         0         0   -0.0016];
ref = [0.01 0.51 -0.41 deg2rad(85) 0 0 0 0];

switch seg
    case 1 %% We received measurment
        msg = ttGetMsg; % sensor data (actuator position)
        exectime = 0.005;
        
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
        exectime = 0.01;
    case 3
        
        ControllerOut=F_mimo*(meas(1:8)-ref)';
        
        msg.state = TransmissionStatus.Recieve;
        
        for i = 1:4
            msg.data=ControllerOut(i);
            ttSendMsg(i+1, msg, 64);
        end
        
        exectime = 0.0005;
    case 4
        meas(9) = 0;
        msg = [];
        msg.state = TransmissionStatus.Sync;
        ttSendMsg(0, msg, 64);
        exectime = 0;
        
    case 5
        exectime = -1;
end
