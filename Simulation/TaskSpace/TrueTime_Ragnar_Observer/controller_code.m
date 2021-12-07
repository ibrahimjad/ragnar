function [exectime, data] = controller_code(seg,data)

ref = [0.01 0.51 -0.41 deg2rad(85) 0 0 0 0]';

load workspace.mat;

switch seg
    case 1 %% We received data.measurment
        msg = ttGetMsg; % sensor data (actuator position)
        exectime = 0.005;
        
        if msg.state == TransmissionStatus.Send
            data.meas(msg.ActuatorNr) = msg.data(1);
            data.meas(msg.ActuatorNr+4) = msg.data(2);
        end
        
        data.meas(9) = data.meas(9) + 1;
        
        if (data.meas(9) ~= 4)
            ttSetNextSegment(5)
        end
    case 2
        exectime = 0.01;
    case 3
        
        Xnew = (eye(8,8)+A*period)*data.xold + period*B*u + L*(data.meas(1:8) - data.est(1:8));
        %Xnew=A*data.xold+B*F*data.xold+L*(C*data.xold-data.meas(1:8)')+M*ref';
        u=(N*ref)+F*Xnew;
        data.xold=Xnew;
        
        msg.state = TransmissionStatus.Recieve;
        
        for i = 1:4
            msg.data=u(i);
            ttSendMsg(i+1, msg, 64);
        end
        
        data.meas(9) = 0;
        exectime = 0.0005;
    case 4
        msg = [];
        msg.state = TransmissionStatus.Sync;
        ttSendMsg(0, msg, 64);
        exectime = 0;
        
    case 5
        exectime = -1;
end
