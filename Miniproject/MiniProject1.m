clear all
close all
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
grid on
xlabel('Time [ms]')
ylabel(' Bytes [Bytes]')
title('Token bucket output')
legend('Network','Output of one token bucket')

%%
% 2.5 Backlog
Inputflow = poissrnd(40,1,25)
figure(3)
rtcplot(f_tokenbucketoutput1,100)