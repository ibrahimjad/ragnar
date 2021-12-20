clear all
close all
n = 10000000;
tokens = 3;
buffer = 3;
packet = poissrnd(40);
tokens = 3;
for i = 2:n
    if i == packet(end)
        tokens(i) = tokens(i-1) - 1;
        packet(end+1) = packet(end) + poissrnd(40);
    else
        tokens(i) = tokens(i-1);
    end
    if mod(i,40) == 0 && tokens(i-1) < 3
        tokens(i) = tokens(i-1) + 1;
    end

end
time = ([1:1:n]./1000)./60;
plot(time,tokens, 'Linewidth',0.01)
xlim([0 time(end)])
xlabel('Minutes')
ylabel('Tokens and backlog')
title('Token bucket filter with replenishment rate of 40 ms')
(n/1000)/60