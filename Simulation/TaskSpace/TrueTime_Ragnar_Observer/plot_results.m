clear all
clf

f = figure;
load('result_plots.mat','-mat')
w = 12; h=4; lw = 2.2; rlw = 0.9;
JN = [-0.20938225, -0.23075509, -0.0066385861, 0.0018545359, -0.044730209, 0.040108118
-0.10107797,  0.12024544,    0.10008853, -0.092520614,   0.87582034, -0.24672376
 -0.2010277,  0.20910422,   0.079599813, -0.072758771,   0.21543337, -0.38709117
0.061111646, -0.10516286,    0.80279105,  -0.78924007,   -12.634661,   6.4044305];
res = [deg2rad(360)/1024 deg2rad(360)/1024 deg2rad(360)/1024 deg2rad(360)/1024 (1*10^-2)/1024 (1*10^-2)/1024]';
TSRes = norm(JN*res);

P1 = plot(ans.Time,ans.Data(:,1),'k:',ans.Time,ans.Data(:,2),'b',ans.Time,ans.Data(:,4),'r');

set(P1,'linewidth',lw);
set(P1(3),'linewidth',rlw);
ylabel('x [Meters]');
ylim([-0.011 0.013]);
legend('Reference',"No network",'Network','Location','southwest','AutoUpdate','off');
%plotFeasiblePositions(0,TSRes);

C = f.Children;
uistack([C(2)], "top")
%y = yline(0,'color',[0.5 0.5 0.5],'LineWidth',0.8);
%C = get(gca,'Children');
%set(gca,'Children',flipud(C))%[C(14) C(15) C(16) C(1) C(2) C(3) C(4) C(5) C(6) C(7) C(8) C(9) C(10) C(11) C(12) C(13)])

set(gcf, 'PaperPosition', [-0.22 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resultx', 'pdf'); %Save figure
hold off

P2 = plot(ans.Time,ans.Data(:,5),'k:', ans.Time,ans.Data(:,6),'b',ans.Time,ans.Data(:,8),'r');
set(P2,'linewidth',lw);
set(P2(3),'linewidth',rlw);
ylabel('y [Meters]');
ylim([0.489 0.511]);
%plotFeasiblePositions(0.5,TSRes);
%y = yline(0.5,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
set(gcf, 'PaperPosition', [-0.23 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resulty', 'pdf'); %Save figure

P3 = plot(ans.Time,ans.Data(:,9),'k:', ans.Time,ans.Data(:,10),'b',ans.Time,ans.Data(:,12),'r');
set(P3,'linewidth',lw);
set(P3(3),'linewidth',rlw);
ylabel('z [Meters]');
ylim([-0.412 -0.388]);
%plotFeasiblePositions(-0.4,TSRes);
%y = yline(-0.4,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
set(gcf, 'PaperPosition', [-0.23 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resultz', 'pdf'); %Save figure

P4 = plot(ans.Time,ans.Data(:,13),'k:', ans.Time,ans.Data(:,14),'b',ans.Time,ans.Data(:,16),'r');
set(P4,'linewidth',lw);
set(P4(3),'linewidth',rlw);
xlabel('Time [Seconds]');
ylabel('$\varphi$ [Degrees]','Interpreter','latex');
ylim([89.4 90.6]);
%plotFeasiblePositions(90,rad2deg(TSRes));
%y = yline(90,'-.','color',[0.5 0.5 0.5],'LineWidth',1.2);
set(gcf, 'PaperPosition', [-0.23 0.03 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resultphi', 'pdf'); %Save figure


function [output] = plotFeasiblePositions(operatingPoint,TSRes)
stepsCount = round(operatingPoint / TSRes);
feasOP = stepsCount * TSRes; % The feasible pos, closest to OP
    for i = 1:13
        lines(i) = feasOP + (TSRes*(i-7));
        yline(lines(i),'color',[0.5 0.5 0.5],'LineWidth',0.8);
    end
end