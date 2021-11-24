function [exectime, meas] = controller_code(seg,meas)

Task_op = [0; 0.5; -0.4; deg2rad(90)];
J =[-0.2069   -0.2328   -0.0018   -0.0027   -0.0466   -0.0044
   -0.0944    0.1021    0.0781   -0.0721    0.7805   -0.0403
   -0.2163    0.2256    0.0598   -0.0539    0.2362   -0.1841
   -0.0415    0.1116    0.9661   -0.9396  -11.3071    4.4612];
Joint_op = [1.0187; 2.0405; 0.0915; 2.9254; 0.58469; 0.62011];
F_mimo =[-1.4629         0         0         0   -2.7429         0         0         0
         0   -3.4482         0         0         0   -4.2057         0         0
         0         0   -3.0563         0         0         0   -4.0229         0
         0         0         0   -0.0013         0         0         0   -0.0016];


switch seg
    case 1 %% We received measurment
        msg = ttGetMsg; % sensor data (actuator position)
        exectime = 0.005;
        
        if msg.state == TransmissionStatus.Send
            meas(msg.ActuatorNr) = msg.data;
        end
        meas(7) = meas(7) + 1;
        
        if (meas(7) ~= 6)
            ttSetNextSegment(4)
        end
       disp('R')
    case 2
        disp('C')
        ControllerIn=Task_op+(J'\(meas(1:6)-Joint_op));
        
        stats = [ControllerIn;0;0;0;0];
        
        ControllerOut=F_mimo*stats;
        Input=J'*ControllerOut;
        
        msg.state = TransmissionStatus.Recieve;
        
        for i = 1:6
            disp(i)
            msg.data=Input(i);
            ttSendMsg(i+1, msg, 250000);
        end
        
        meas(7) = 0;
        exectime = 0.1;
    case 3
        msg = [];
        msg.state = TransmissionStatus.Sync;
        ttSendMsg(0, msg, 64);
        exectime = 0.005;
        
    case 4
        exectime = -1;
end
