clear all
clf

load('result_plots.mat','-mat')
w = 12; h=4; lw = 1.5; rlw = 1.8;

P1 = plot(ans.Time,ans.Data(:,2),'b',ans.Time,ans.Data(:,3),'r--',ans.Time,ans.Data(:,1),'k:');
set(P1,'linewidth',lw);
set(P1(2),'linewidth',rlw);
ylabel('x [Meters]');
ylim([-0.011 0.011]);
y = yline(0,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
legend('No network','Network','Reference', 'Operating point','Location','southwest');
set(gcf, 'PaperPosition', [-0.23 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resultx', 'pdf'); %Save figure

P2 = plot(ans.Time,ans.Data(:,5),'b',ans.Time,ans.Data(:,6),'r--',ans.Time,ans.Data(:,4),'k:');
set(P2,'linewidth',lw);
set(P2(2),'linewidth',rlw);
ylabel('y [Meters]');
ylim([0.489 0.511]);
y = yline(0.5,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
set(gcf, 'PaperPosition', [-0.23 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resulty', 'pdf'); %Save figure

P3 = plot(ans.Time,ans.Data(:,8),'b',ans.Time,ans.Data(:,9),'r--',ans.Time,ans.Data(:,7),'k:');
set(P3,'linewidth',lw);
set(P3(2),'linewidth',rlw);
ylabel('z [Meters]');
ylim([-0.411 -0.389]);
y = yline(-0.4,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
set(gcf, 'PaperPosition', [-0.23 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resultz', 'pdf'); %Save figure

P4 = plot(ans.Time,ans.Data(:,11),'b',ans.Time,ans.Data(:,12),'r--',ans.Time,ans.Data(:,10),'k:');
set(P4,'linewidth',lw);
set(P4(2),'linewidth',rlw);
xlabel('Time [Seconds]');
ylabel('\phi [Degrees]');
ylim([84.5 95.5]);
y = yline(90,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
set(gcf, 'PaperPosition', [-0.23 0.03 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resultphi', 'pdf'); %Save figure

% load('result_plots.mat','-mat')
% w = 12; h=4;
% 
% %figure(1)
% P1 = plot(out.x.Time,out.x.Data(:,3),'b',out.x.Time,out.x.Data(:,2),'r--',out.x.Time,out.x.Data(:,1),'k:');
% set(P1,'linewidth',1.5);
% 
% %xlabel('Time [Seconds]')
% ylabel('x [Meters]')
% ylim([-0.011 0.011])
% y = yline(0,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2)
% legend('Network','No network','Reference', 'Operating point')
% set(gcf, 'PaperPosition', [-0.23 0.01 w h]); %Position plot at left hand corner with width and height.
% set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
% saveas(gcf, 'resultx', 'pdf') %Save figure
% %y.LabelHorizontalAlignment = 'center';
% %y.LabelVerticalAlignment = 'middle';
% 
% 
% P2 = plot(out.y.Time,out.y.Data(:,3),'b',out.y.Time,out.y.Data(:,1),'k:',out.y.Time,out.y.Data(:,2),'r--');
% set(P2,'linewidth',1.5);
% %xlabel('Time [Seconds]')
% ylabel('y [Meters]')
% ylim([0.489 0.511])
% y = yline(0.5,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2)
% set(gcf, 'PaperPosition', [-0.23 0.01 w h]); %Position plot at left hand corner with width and height.
% set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
% saveas(gcf, 'resulty', 'pdf') %Save figure
% 
% 
% P3 = plot(out.z.Time,out.z.Data(:,3),'b',out.z.Time,out.z.Data(:,1),'k:',out.z.Time,out.z.Data(:,2),'r--');
% set(P3,'linewidth',1.5);
% %xlabel('Time [Seconds]')
% ylabel('z [Meters]')
% ylim([-0.411 -0.389])
% y = yline(-0.4,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2)
% set(gcf, 'PaperPosition', [-0.23 0.01 w h]); %Position plot at left hand corner with width and height.
% set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
% saveas(gcf, 'resultz', 'pdf') %Save figure
% 
% 
% P4 = plot(out.phi.Time,out.phi.Data(:,3),'b',out.phi.Time,out.phi.Data(:,1),'k:',out.phi.Time,out.phi.Data(:,2),'r--');
% set(P4,'linewidth',1.5);
% xlabel('Time [Seconds]');
% ylabel('\phi [Degrees]');
% ylim([84.5 95.5]);
% y = yline(90,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
% set(gcf, 'PaperPosition', [-0.23 0.03 w h]); %Position plot at left hand corner with width and height.
% set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
% saveas(gcf, 'resultphi', 'pdf') %Save figure

