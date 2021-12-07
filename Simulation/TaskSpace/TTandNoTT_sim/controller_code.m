function [exectime, meas] = controller_code(seg,meas)

F_mimo =[-2457.0,      0,      0,       0, -193.7,      0,      0,        0
      0, -250.5,      0,       0,      0, -35.81,      0,        0
      0,      0, -250.5,       0,      0,      0, -35.81,        0
      0,      0,      0, -0.8806,      0,      0,      0, -0.06942];
ref = zeros(1,8);

for i=1:8
    ref(i) = ttAnalogIn(i);
end

switch seg
    case 1 %% We received measurment
        
        msg = ttGetMsg; % sensor data (actuator position)
        %%
        JN = [-0.20938225, -0.23075509, -0.0066385861, 0.0018545359, -0.044730209, 0.040108118
        -0.10107797,  0.12024544,    0.10008853, -0.092520614,   0.87582034, -0.24672376
         -0.2010277,  0.20910422,   0.079599813, -0.072758771,   0.21543337, -0.38709117
        0.061111646, -0.10516286,    0.80279105,  -0.78924007,   -12.634661,   6.4044305];
        res = [deg2rad(360)/1024 deg2rad(360)/1024 deg2rad(360)/1024 deg2rad(360)/1024 (1*10^-2)/1024 (1*10^-2)/1024]';
        TSResf = norm(JN*res);
        

        exectime = 0.000050; % This runs 4 times for each sync frame.
        % total time to unpack 4 = 50 microsecs, so 12.5 micros for each
        % motor measurement
        
        if msg.state == TransmissionStatus.Send
            meas(msg.ActuatorNr) = msg.data(1);
            meas(4+msg.ActuatorNr) = msg.data(2);
        end
        meas(9) = meas(9) + 1;
        
        if (meas(9) ~= 4)
            ttSetNextSegment(5)
        end
    case 2
        exectime = 0.0010645+0.001;%-0.00005125; % calculate + send 4 control sig = 1220 microsecs
                                    % 1220 - (256 - 51 - 51) = 1066
    case 3
     
        ControllerOut=F_mimo*(meas(1:8)-ref)';
        
        msg.state = TransmissionStatus.Recieve;
        
        for i = 1:4
            msg.data=ControllerOut(i);
            ttSendMsg(i+1, msg, 80); 
        end
        
        meas(9) = 0;
        exectime = 0;
    case 4
        msg = [];
        msg.state = TransmissionStatus.Sync;
        ttSendMsg(0, msg, 48);
        exectime = 0.0000025; % Send sync = 2.5 micro
        
    case 5
        exectime = -1;
end
