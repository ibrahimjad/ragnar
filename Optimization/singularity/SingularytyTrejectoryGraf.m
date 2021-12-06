close all
clear all

phi = deg2rad(0);
x = 0;
y = 0; 
z = -0.4; 



for i = 1:50
JacobianCond(i)=worst_pose_targetfunction([x; y; z; phi]);
end

res = 0.2/50;
for i=51:100
    x=x-res;
    z=z-res;
    JacobianCond(i)=worst_pose_targetfunction([x; y; z; phi]);
end

for i=101:150
    x=x+res;
    z=z+res;
    JacobianCond(i)=worst_pose_targetfunction([x; y; z; phi]); 
end
resPhi = deg2rad(90)/50;
for i=151:200
    phi = phi + resPhi;
    y = y + res;
    JacobianCond(i)=worst_pose_targetfunction([x; y; z; phi]); 
end

for i=201:251
    JacobianCond(i)=worst_pose_targetfunction([x; y; z; phi]);
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




