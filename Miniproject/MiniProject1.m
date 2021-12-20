clear all
close all
set(0,'DefaultLineLineWidth',2)
%% Arrival curve periodic
% rtccurve([start x, start y, slope],start y, period , offset on y)
% Arrival flow for 4 wheels
f_wheels = rtccurve([0 0 0],0,10,20*4)
% Arrival flow for 4 wheels
f_ESP = rtccurve([0 0 0],0,10,8)
f_network = rtccurve([[0 0 1000/8]])
f_MM = rtccurve([0 0 0],0,40,1400)
f_RC = rtccurve([0 0 0],0,40,1400)
f_combined = rtcplus(rtccurve([0 0 0],0,40,1400+1400),rtccurve([0 0 0],0,10,(20*4*4)+(8*4)))

figure(1)
rtcplot(f_network,f_combined,200);%ylim([0 6000]);
xlabel('Time [ms]')
ylabel(' Bytes [Bytes]')
title('Staircase arrival curves')
legend('Network','Mean network arrival')

%% 2.3
%possion prob
%  x=[15:65];
%  y = poisspdf(x,40);
% figure(2)
% bar(x,y,1)
% xlabel('Time beteen packets [ms]')
% ylabel('Probability')

%% 2.4 rtccurve([[0 startY 0];[skiftvedtid skift_til 0]], 0, skift_igen, skiftilstarty+værdi);
f_tokenbucketoutput1 = rtccurve([[0 10 105];[40 1400*3 35]]);
%f_tokenbucketoutput2 = rtccurve([[0 0 105];[40 35 0]], 0, 40, 4000);
figure(2)
rtcplot(f_network,f_tokenbucketoutput1,100)

%% 2.4 
time = 200;
% rtccurve([[startX startY startHældning];[shiftAtX ShiftAtY ShiftHældning]], 0, skift_igen, skiftilstarty+værdi);
f_tokenbucketoutput = rtccurve([[0 1400*3 0];[40 1400*0 0]], [[0 1400 0];[11.2 1400 0]], 40, 1400*3, 40, 1400);
%rtccurve([[0 0 125]], [[0 0 0];[40-33.6 2 125]], 33.6, 1400*3, 40, 5);
f_tokenbucketnetwork = rtccurve([[0 0 125];[33.6 1400*3 0]], [[0 0 125];[11.2 1400 0]], 40, 1400*3, 40, 1400);
P2 = figure(2)
rtcplot(f_network,f_tokenbucketnetwork,f_tokenbucketoutput,time);

grid on
hold on
xlabel('Time [ms]')
ylabel(' Bytes [Bytes]')
title('Token bucket output')
legenden = ["Network","Network usage from one token bucket", "Output of token bucket"]
legend(legenden)

%%

% 2.5 Backlog
%Inputflow = poissrnd(40,1,25)
%figure(3)
%rtcplot(f_tokenbucketoutput1,100)

% 2.5 token bucket arrivel curves 
% Sloap when full of tokens.
f_arrival = rtccurve([[0 1400*6 0]], [[0 1400 0];[20 1400 0]], 40, 1400*6, 40, 1400)
rtcplot(f_arrival,time); legenden(end+1)="Arrival to token bucket"; legend(legenden);
backlog = rtcplotv(f_arrival,f_tokenbucketoutput)
legenden(end+1)="Max backlog"; legend(legenden);
delay = rtcploth(f_arrival,f_tokenbucketoutput)
legenden(end+1)="Max delay"; legend(legenden);


