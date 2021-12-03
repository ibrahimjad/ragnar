clear all
clf

load('NwT.mat','-mat')
w = 12; h=6; lw = 1.5; rlw = 1.8;

figure(1)
P1 = plot(ans.Time,ans.Data(:,5)-1);
plotfeats(P1,lw)
hold on 

P1 = plot(ans.Time,ans.Data(:,4)-1);
plotfeats(P1,lw)

P1 = plot(ans.Time,ans.Data(:,3)-1);
plotfeats(P1,lw)

P1 = plot(ans.Time,ans.Data(:,2)-1);
plotfeats(P1,lw)

P1 = plot(ans.Time,ans.Data(:,1)-1);
plotfeats(P1,lw)

ylabel('Node and sending status');
xlabel('Time [s]')

title('b)')
xlim([0 0.00006])
set(gcf, 'PaperPosition', [-0.75 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.7 h-0.15]); %Set the paper to have width and height.
saveas(gcf, 'NwTstartpdf', 'pdf'); %Save figure

title('a)')
xlim([0 0.0033])
legend('Node 4','Node 3','Node 2', 'Node 1','Node 0 (Teensy)','Location','north');
set(gcf, 'PaperPosition', [-0.75 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.7 h-0.17]); %Set the paper to have width and height.
saveas(gcf, 'NwTpdf', 'pdf'); %Save figure

function[] = plotfeats(plot,lw)
set(plot,'linewidth',lw);
end