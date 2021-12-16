clear all
clf

f = figure;
ref = load('result_plots.mat','-mat')
nores = load('network_nores.mat','-mat')
res = load('network_res.mat','-mat')

w = 12; h=4; lw = 1.5; rlw = 1.5;
JN = [-0.20938225, -0.23075509, -0.0066385861, 0.0018545359, -0.044730209, 0.040108118
-0.10107797,  0.12024544,    0.10008853, -0.092520614,   0.87582034, -0.24672376
 -0.2010277,  0.20910422,   0.079599813, -0.072758771,   0.21543337, -0.38709117
0.061111646, -0.10516286,    0.80279105,  -0.78924007,   -12.634661,   6.4044305];
resolution = [deg2rad(360)/1024 deg2rad(360)/1024 deg2rad(360)/1024 deg2rad(360)/1024 (1*10^-2)/1024 (1*10^-2)/1024]';
TSRes = norm(JN*resolution);

P1 = plot(ref.ans.Time,ref.ans.Data(:,1),'k:',nores.ans.Time,nores.ans.Data(:,1),'b',res.ans.Time,res.ans.Data(:,1),'r');

set(P1,'linewidth',lw);
set(P1(3),'linewidth',rlw);
ylabel('x [Meters]');
ylim([-0.011 0.013]);
legend('Reference',"No resolution",'With resolution','Location','southwest','AutoUpdate','off');
plotFeasiblePositions(0,TSRes);

C = f.Children;
uistack([C(2)], "top")

set(gcf, 'PaperPosition', [-0.22 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resultx_res', 'pdf'); %Save figure
hold off

P2 = plot(ref.ans.Time,ref.ans.Data(:,5),'k:',nores.ans.Time,nores.ans.Data(:,2),'b',res.ans.Time,res.ans.Data(:,2),'r');
set(P2,'linewidth',lw);
set(P2(3),'linewidth',rlw);
ylabel('y [Meters]');
ylim([0.488 0.512]);
plotFeasiblePositions(0.5,TSRes);

set(gcf, 'PaperPosition', [-0.23 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resulty_res', 'pdf'); %Save figure

P3 = plot(ref.ans.Time,ref.ans.Data(:,9),'k:',nores.ans.Time,nores.ans.Data(:,3),'b',res.ans.Time,res.ans.Data(:,3),'r');
set(P3,'linewidth',lw);
set(P3(3),'linewidth',rlw);
ylabel('z [Meters]');
ylim([-0.412 -0.388]);
plotFeasiblePositions(-0.4,TSRes);

set(gcf, 'PaperPosition', [-0.23 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resultz_res', 'pdf'); %Save figure

P4 = plot(ref.ans.Time,ref.ans.Data(:,13),'k:',nores.ans.Time,rad2deg(nores.ans.Data(:,4)),'b',res.ans.Time,rad2deg(res.ans.Data(:,4)),'r');
hold on
set(P4,'linewidth',lw);
set(P4(3),'linewidth',rlw);
xlabel('Time [Seconds]');
ylabel('$\varphi$ [Degrees]','Interpreter','latex');
ylim([89.4 90.6]);

plotFeasiblePositions(90,rad2deg(TSRes));

set(gcf, 'PaperPosition', [-0.23 0.03 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.23 h-0.25]); %Set the paper to have width and height.
saveas(gcf, 'resultphi_res', 'pdf'); %Save figure


function [output] = plotFeasiblePositions(operatingPoint,TSRes)
stepsCount = round(operatingPoint / TSRes);
feasOP = stepsCount * TSRes; % The feasible pos, closest to OP
    for i = 1:13
        lines(i) = feasOP + (TSRes*(i-7));
        yline(lines(i),'color',[0.5 0.5 0.5],'LineWidth',0.8);
    end
end