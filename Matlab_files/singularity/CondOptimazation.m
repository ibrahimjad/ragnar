% cvx_begin
% variables v5x v5y v5z v6x v6y v6z
% 
% miminize(CondMountValFunction(v5x,v5y,v5z,v6x,v6y,v6z))
% 
% subject to
%     -0.1 <= v5x
%     v5x <= 0.1
% 
%     -0.1 <= v5y
%     v5y <= 0.1
% 
%     -0.1 <= v5z
%     v5z <= 0
%    
%     -0.1 <= v6x
%     v6x <= 0.1
% 
%     -0.1 <= v6y
%     v6y <= 0.1
% 
%      -0.1 <= v6z
%     v6z <= 0
% cvx_end

%CondMountValFunction(1,1,1,1,1,1)