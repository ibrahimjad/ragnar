function [exectime, meas] = controller_code(seg,meas)

F_mimo =[-95.1662         0         0         0  -24.6981         0         0         0
         0 -250.4995         0         0         0  -35.8128         0         0
         0         0 -250.4995         0         0         0  -35.8128         0
         0         0         0   -0.0341         0         0         0   -0.0089];
% ref = zeros(1,8);
% 
% for i=1:8
%     ref(i) = ttAnalogIn(i);
% end

switch seg
    case 1 %% We received measurment
        
        msg = ttGetMsg; % sensor data (actuator position)
        exectime = 0.000050; % This runs 4 times for each sync frame.
        % total time to unpack 4 = 50 microsecs, so 12.5 micros for each
        % motor measurement
        
        if msg.state == TransmissionStatus.Send
            meas(msg.ActuatorNr) = msg.data(1);
            meas(4+msg.ActuatorNr) = msg.data(2);
        end
        disp(meas);

        meas(9) = meas(9) + 1;
        
        if (meas(9) ~= 4)
            ttSetNextSegment(6)
        end
    case 2
        exectime = 0.0010645+0.001;%-0.00005125; % calculate + send 4 control sig = 1220 microsecs
                                    % 1220 - (256 - 51 - 51) = 1066
    case 3
     
        for i = 1:8
            ttAnalogOut(i, meas(i));
        end
        
        meas(9) = 0;
        exectime = 0;

    case 4
        msg.state = TransmissionStatus.Recieve;

        for i = 1:4
            msg.data=ttAnalogIn(i);
            disp("Sent to node" + num2str(i) + ": " + msg.data);
            ttSendMsg(i+1, msg, 80);
        end
       
        exectime = 0;

    case 5
        msg = [];
        msg.state = TransmissionStatus.Sync;
        ttSendMsg(0, msg, 48);
        exectime = 0.0000025; % Send sync = 2.5 micro
        
    case 6
        exectime = -1;
end
