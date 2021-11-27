function [c,ceq] = ineq(V)
%c(1) = (V(4)+0.1)-V(1); % X coordinate
c(1) = (V(5)+0.05)-V(2); % Y corrdinate
c(2) = (V(6))-V(3); % Z coordinate
ceq = [];
end
