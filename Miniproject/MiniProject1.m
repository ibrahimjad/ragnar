clear all
close all
%% Arrival curve periodic
% rtccurve([start x, start y, slope],start y, period , offset on y)
% Arrival flow for 4 wheels
f_wheels = rtccurve([0 0 0],0,10,20*4)
% Arrival flow for 4 wheels
f_ESP = rtccurve([0 0 0],0,10,8)

figure(1)
rtcplot(f_wheels,f_ESP,100)
xlabel('t [Ms]')
ylabel('k*v_T [B]')
title('Staircase arrival curves')
legend('4 * wheels','ESP')

%% 2.4
%possion prob
 x=[15:65];
 y = poisspdf(x,40);
figure(2)
bar(x,y,1)
xlabel('Time beteen packets [ms]')
ylabel('Probability')

%%
% 2.5 token bucket arrivel curves 
% Sloap when full of tokens.
a1 = (400000-352)/(40) %[B p ms]

% Sloap when no tokans
a2 = (1400)/(20*10^-3) %[B p ms]


