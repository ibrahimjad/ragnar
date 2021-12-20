clear all
time = [0:1:25];
R = exp(-0.5*10^(-6)*24*365*time);
figure(1)
plot(time,1-R)
xlabel('Time [Years]'); ylabel('Probabillity')
title('Probabillity that component fails')
R_tots = R.*R.*R.*R.*R.*R;
figure(2)
plot(time,1-R_tots);
xlabel('Time [Years]'); ylabel('Probabillity')
title('Probabillity that system fails in serial case')
xline(10)
yline(1-0.768895661066485,'-','1-0.76889 = 0.2311')
%xticks([24*365*1:24*365*1:24*365*25])
%xtickformat('%.1f')
% figure(3)
% R_totp = 1 - (1-R).*(1-R).*(1-R).*(1-R).*(1-R).*(1-R);
% plot(time,1-R_totp)
% xlabel('Time [Years]'); ylabel('Probabillity')
% title('Probabillity that system fails in parallel case')