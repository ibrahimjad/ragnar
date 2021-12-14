close all
clear all


phi([1:50]) = deg2rad(0);
x([1:50]) = 0;
y([1:50]) = 0; 
z([1:50]) = -0.4; 



for i = 1:50
JacobianCond(i)=worst_pose_targetfunction([x(i); y(i); z(i); phi(i)]);
end

res = 0.2/50;
for i=51:100
    x(i)=x(i-1)-res;
    z(i)=z(i-1)-res;
    y(i)=y(i-1);
    phi(i)=phi(i-1);
    JacobianCond(i)=worst_pose_targetfunction([x(i); y(i); z(i); phi(i)]);
end

for i=101:150
    x(i)=x(i-1)+res;
    z(i)=z(i-1)+res;
    y(i)=y(i-1);
    phi(i)=phi(i-1);
    JacobianCond(i)=worst_pose_targetfunction([x(i); y(i); z(i); phi(i)]); 
end
resPhi = deg2rad(90)/50;
for i=151:200
    x(i)=x(i-1);
    z(i)=z(i-1);
    y(i)=y(i-1)+res;
    phi(i)=phi(i-1) + resPhi;
    JacobianCond(i)=worst_pose_targetfunction([x(i); y(i); z(i); phi(i)]); 
end

for i=201:251
    x(i)=x(i-1);
    z(i)=z(i-1);
    y(i)=y(i-1);
    phi(i)=phi(i-1);
    JacobianCond(i)=worst_pose_targetfunction([x(i); y(i); z(i); phi(i)]);
end

%%
w = 12; h=4; lw = 1.5;
figure(1)
P1 = plot(0:2.5/250:2.50,JacobianCond);
set(P1,'linewidth',lw);
ylabel('condition number []');
xlabel('Time [sec]');
title('Condition number for jacobian')
set(gcf, 'PaperPosition', [-1 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.8 h]); %Set the paper to have width and height.
saveas(gcf, 'SigularatyCondCheck', 'pdf'); %Save figure


figure(2)
P2 = plot(0:2.5/250:2.50,x);
set(P2,'linewidth',lw);
ylabel('x [meters]');
xlabel('Time [sec]');
%title('Condition number for jacobian')
set(gcf, 'PaperPosition', [-1 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.8 h]); %Set the paper to have width and height.
saveas(gcf, 'SigularatyCondCheckX', 'pdf'); %Save figure

figure(3)
P3 = plot(0:2.5/250:2.50,y);
set(P3,'linewidth',lw);
xlabel('Time [sec]');
ylabel('y [meters]');
%title('Condition number for jacobian')
set(gcf, 'PaperPosition', [-1 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.8 h]); %Set the paper to have width and height.
saveas(gcf, 'SigularatyCondCheckY', 'pdf'); %Save figure

figure(4)
P4 = plot(0:2.5/250:2.50,z);
set(P4,'linewidth',lw);
xlabel('Time [sec]');
ylabel('z [meters]');
%title('Condition number for jacobian')
set(gcf, 'PaperPosition', [-1 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.8 h]); %Set the paper to have width and height.
saveas(gcf, 'SigularatyCondCheckZ', 'pdf'); %Save figure

figure(5)
P5 = plot(0:2.5/250:2.50,phi);
set(P5,'linewidth',lw);
xlabel('Time [sec]');
ylabel('$\varphi$ [Degrees]','Interpreter','latex');
%title('Condition number for jacobian')
set(gcf, 'PaperPosition', [-1 0.01 w h]); %Position plot at left hand corner with width and height.
set(gcf, 'PaperSize', [w-1.8 h]); %Set the paper to have width and height.
saveas(gcf, 'SigularatyCondCheckPhi', 'pdf'); %Save figure





