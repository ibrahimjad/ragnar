NPx = out.x.Data(:,2);
NPy = out.y.Data(:,2);
NPz = out.z.Data(:,2);
NPphi = out.phi.Data(:,2);
NPxT = out.x.Time;
NPyT = out.y.Time;
NPzT = out.z.Time;
NPphiT = out.phi.Time;

%%
plb = 0.6;
ple = 0.8;

w = 9*1.35; h=3*1.35; lw = 1.45; rlw = 1.8;

P1 = plot(NPxT,NPx,'b',out.x.Time,out.x.Data(:,2),'r--',out.x.Time,out.x.Data(:,1),'k:');
set(P1,'linewidth',lw);
set(P1(2),'linewidth',rlw);
ylabel('x [m]');
xlabel('Time [s]');
ylim([-0.011 0.011]);
%y = yline(0,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
x = xline(plb,'-.','color',[0.8 0.5 0.9],'LineWidth',1.2);
x2 = xline(ple,'-.','color',[0.4 0.5 0.7],'LineWidth',1.2);
legend('Observer','No observer','Reference','Packet loss start','Packet loss stop','Location','northeast');%,set(legend,'fontsize',20);
set(gca,'FontSize',20)
set(gcf, 'PaperPosition', [-0.3 +0.05 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.2 h-0.1]); %Set the paper to have width and height.
saveas(gcf, 'Packetx', 'pdf'); %Save figure

P2 = plot(NPyT,NPy,'b',out.y.Time,out.y.Data(:,2),'r--',out.y.Time,out.y.Data(:,1),'k:');
set(P2,'linewidth',lw);
set(P2(2),'linewidth',rlw);
ylabel('y [m]');
xlabel('Time [s]');
ylim([0.489 0.511]);
%y = yline(0,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
x = xline(plb,'-.','color',[0.8 0.5 0.9],'LineWidth',1.2);
x2 = xline(ple,'-.','color',[0.4 0.5 0.7],'LineWidth',1.2);
%legend('Observer','No observer','Reference','Packet loss start','Packet loss stop','Location','northeast'),set(legend,'fontsize',9.1);
%[hh,icons,plots,txt] = 
% p1 = icons(1).Position;
% icons(1).Position = [0.2 p1(2) 0];
% %icons(2).XData = [0.05 0.2];

set(gca,'FontSize',20)
set(gcf, 'PaperPosition', [-0.3 +0.05 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.2 h-0.1]); %Set the paper to have width and height.
saveas(gcf, 'Packety', 'pdf'); %Save figure


P3 = plot(NPzT,NPz,'b',out.z.Time,out.z.Data(:,2),'r--',out.z.Time,out.z.Data(:,1),'k:');
set(P3,'linewidth',lw);
set(P3(2),'linewidth',rlw);
ylabel('z [m]');
xlabel('Time [s]');
ylim([-0.411 -0.389]);
%y = yline(0,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
x = xline(plb,'-.','color',[0.8 0.5 0.9],'LineWidth',1.2);
x2 = xline(ple,'-.','color',[0.4 0.5 0.7],'LineWidth',1.2);
set(gca,'FontSize',20)
set(gcf, 'PaperPosition', [-0.3 +0.05 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.2 h-0.1]); %Set the paper to have width and height.
saveas(gcf, 'Packetz', 'pdf'); %Save figure

P4 = plot(NPphiT,NPphi,'b',out.phi.Time,out.phi.Data(:,2),'r--',out.phi.Time,out.phi.Data(:,1),'k:');
set(P4,'linewidth',lw);
set(P4(2),'linewidth',rlw);
ylabel('$\varphi$ [deg]','Interpreter','latex');
xlabel('Time [s]');
ylim([84.5 95.5]);
%y = yline(0,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
x = xline(plb,'-.','color',[0.8 0.5 0.9],'LineWidth',1.2);
x2 = xline(ple,'-.','color',[0.4 0.5 0.7],'LineWidth',1.2);
set(gca,'FontSize',20)
set(gcf, 'PaperPosition', [-0.3 +0.05 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.2 h-0.1]); %Set the paper to have width and height.
saveas(gcf, 'Packetphi', 'pdf'); %Save figure


