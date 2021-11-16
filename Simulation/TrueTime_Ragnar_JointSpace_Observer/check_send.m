 

if (msg.state; == TransmissionStatus.Send)
    msg.data = ttAnalogIn(1);
    ttSendMsg(1, msg, 250);     % send msg to Teensy
    exectime = 0.005;
    ttnetxsegment(4)
else
    exectime = 0;
end