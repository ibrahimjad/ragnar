clear all
%close all
%Number of sensors
N = 8
%Bandwidth
bw = rtccurve([0 0 (1*10^6)/1000])
% Arrival flow for N sensors
f = rtccurve([0 0 0],0,1,100*N)
% Service curve for N sensors
g = rtccurve([0 0 0],0,4,500*N)

rtcplot(f,g,bw,20)

delay = rtch(f,g)
backlog = rtcv(f,g)
rtcploth(f,g)
rtcplotv(f,g)
