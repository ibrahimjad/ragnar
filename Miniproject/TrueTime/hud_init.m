function hud_init
% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority
deadline = 10;
data = [0 0];

ttCreateTask('hud_task', deadline, 'hud_code', data);

ttAttachNetworkHandler('hud_task')
