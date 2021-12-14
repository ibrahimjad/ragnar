NPxv = out.x1.Data(:,1);
NPyv = out.y1.Data(:,1);
NPzv = out.z1.Data(:,1);
NPphiv = out.phi1.Data(:,1);
NPxTv = out.x1.Time;
NPyTv = out.y1.Time;
NPzTv = out.z1.Time;
NPphiTv = out.phi1.Time;

%%
plb = 0.7;
ple = 0.9;

w = 9; h=3; lw = 1.5; rlw = 1.8;

P1 = plot(NPxTv,NPxv,'b',out.x1.Time,out.x1.Data(:,1),'r--');
set(P1,'linewidth',lw);
set(P1(2),'linewidth',rlw);
xlabel('Time [s]');
ylabel('x [m/s]');
ylim([-0.07 0.01]);
%y = yline(0,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
x = xline(plb,'-.','color',[0.8 0.5 0.9],'LineWidth',1.2);
x2 = xline(ple,'-.','color',[0.4 0.5 0.7],'LineWidth',1.2);
legend('Observer','No observer','Packet loss start','Packet loss stop','Location','southwest');
set(gcf, 'PaperPosition', [-0.45 +0.05 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.20 h-0.1]); %Set the paper to have width and height.
saveas(gcf, 'PacketxVel', 'pdf'); %Save figure

P2 = plot(NPyTv,NPyv,'b',out.y1.Time,out.y1.Data(:,1),'r--');
set(P2,'linewidth',lw);
set(P2(2),'linewidth',rlw);
xlabel('Time [s]');
ylabel('y [m/s]');
ylim([-0.12 0.05]);
%y = yline(0,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
x = xline(plb,'-.','color',[0.8 0.5 0.9],'LineWidth',1.2);
x2 = xline(ple,'-.','color',[0.4 0.5 0.7],'LineWidth',1.2);
legend('Observer','No observer','Packet loss start','Packet loss stop','Location','southwest');
set(gcf, 'PaperPosition', [-0.45 +0.05 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.20 h-0.1]); %Set the paper to have width and height.
saveas(gcf, 'PacketyVel', 'pdf'); %Save figure


P3 = plot(NPzTv,NPzv,'b',out.z1.Time,out.z1.Data(:,1),'r--');
set(P3,'linewidth',lw);
set(P3(2),'linewidth',rlw);
xlabel('Time [s]');
ylabel('z [m/s]');
ylim([-0.12 0.05]);
%y = yline(0,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
x = xline(plb,'-.','color',[0.8 0.5 0.9],'LineWidth',1.2);
x2 = xline(ple,'-.','color',[0.4 0.5 0.7],'LineWidth',1.2);
set(gcf, 'PaperPosition', [-0.45 +0.05 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.20 h-0.1]); %Set the paper to have width and height.
saveas(gcf, 'PacketzVel', 'pdf'); %Save figure

P4 = plot(NPphiTv,NPphiv,'b',out.phi1.Time,out.phi1.Data(:,1),'r--');
set(P4,'linewidth',lw);
set(P4(2),'linewidth',rlw);
xlabel('Time [s]');
ylabel('$\varphi$ [Deg/s]','Interpreter','latex');
ylim([-35 5]);
%y = yline(0,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
x = xline(plb,'-.','color',[0.8 0.5 0.9],'LineWidth',1.2);
x2 = xline(ple,'-.','color',[0.4 0.5 0.7],'LineWidth',1.2);
set(gcf, 'PaperPosition', [-0.45 +0.05 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.20 h-0.1]); %Set the paper to have width and height.
saveas(gcf, 'PacketphiVel', 'pdf'); %Save figure


