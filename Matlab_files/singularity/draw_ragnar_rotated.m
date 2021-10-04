function draw_ragnar_rotated(thetas,params,pose_n, h_all)
% create function handles for rotations 
    Rx = @(angle) ([1 0 0; 0, cos(angle) -sin(angle); 0, sin(angle) cos(angle)]); 
    Ry = @(angle) ([cos(angle) 0 sin(angle); 0 1 0; -sin(angle) 0 cos(angle)]); 
    Rz = @(angle) ([cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1]); 
    pose_n = pose_n(:);
    X = pose_n(1:3);
    P = X; 
    phi = pose_n(4);
    u_i = [1 0 0]';
    u_j = [0 1 0]';
    u_k = [0 0 1]';
    u_j_ = [u_j u_j -u_j -u_j];
    hold off ; 
    clf
    for i=1:4
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% the i-th leg parameters
        leg = params(i, :);
        a = leg(1); b = leg(2); % base platform
        alpha = leg(3); beta = leg(4); l = leg(5); % inner link
        L = leg(6); % outer link length
        rx = leg(7);
        ry = leg(8);
        rz = leg(9);
        h_d = leg(10);
        r_a = [rx; ry; rz];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   position vectors in xyz
        A = [a; b; 0]; % point A
        R1 = Rz(alpha) * Ry(beta) * Rz(thetas(i));
        S1 = R1 * (l*u_i);
        B = A+S1;
        
        w_a = 2.5e-2; 
        z_1 = Rz(alpha) * Ry(beta) * (w_a*u_k);
        
        prox_dist_1 = B + z_1; 
        prox_dist_2 = B - z_1; 
        
        %%%%% MODIFICATIONS FOR ROTATING PLATFORM 
        % P1 = P + h_d * Rx(phi) * u_j; %  r_all(:,i);
        % P2 = P + h_d * Rx(phi) * (-u_j);
        % P_points = [P1 P1 P2 P2];
        % for i=1:4
        %     C(:,i) = P_points(:,i) + r_all(:,i); 
        % end 
       
        C = P + Rx(phi) * h_all(:,i) + r_a;
        dist_plat_1 = C + z_1;
        dist_plat_2 = C - z_1;
        
        A_(:,i) = A; 
        C_(:,i) = C; 
        B_(:,i) = B;
        P_x(:,i) = C - r_a; 
        % plot the proximal arm 
        
        plot3([A(1) B(1)],[A(2) B(2)],[A(3) B(3)],'b','LineWidth',4);
        hold on;
        f_text = sprintf('%d',i);
        text(a,b,0.1,f_text);
        daspect([1 1 1]);
        % plot distal arm 
        plot3([B(1) C(1)],[B(2) C(2)],[B(3) C(3)],'k','LineWidth',2);
        % plot distal arm detailed 
        plot3([prox_dist_1(1) prox_dist_2(1)],[prox_dist_1(2) prox_dist_2(2)], ...
            [prox_dist_1(3) prox_dist_2(3)],'k','LineWidth',1.5);
        plot3([dist_plat_1(1) dist_plat_2(1)],[dist_plat_1(2) dist_plat_2(2)], ...
            [dist_plat_1(3) dist_plat_2(3)],'k','LineWidth',1.5);
        plot3([prox_dist_1(1) dist_plat_1(1)],[prox_dist_1(2) dist_plat_1(2)], ...
            [prox_dist_1(3) dist_plat_1(3)],'k','LineWidth',1.5);
        plot3([prox_dist_2(1) dist_plat_2(1)],[prox_dist_2(2) dist_plat_2(2)], ...
            [prox_dist_2(3) dist_plat_2(3)],'k','LineWidth',1.5);
        
        % plot vector from P point to attachment point
        % This will be ploted at the end 
        % plot3([P_x(1,i) C(1)],[P_x(2,i) C(2)],[P_x(3,i) C(3)],'r','LineWidth',2);
        
        % test plot with cylinders 
        % create cylinder for proximal link 
        rad_prox = 2.5e-2; 
        [Xp, Yp, Zp] = cylinder(rad_prox);
        Zp = l*Zp; % specify the length of cylinder
        Xp = Xp; % move the origin of proximal 
        Yp = Yp; % move the origin of proximal 
        % rotate to match the axis 
        % reshape all to column vector
        Xpc = reshape(Xp,[],1);
        Ypc = reshape(Yp,[],1);
        Zpc = reshape(Zp,[],1);
        [n,~]=size(Xpc);
        for ij=1:n
            xyz = [Xpc(ij);Ypc(ij);Zpc(ij)];
            xyzp = Rz(alpha)*Ry(beta)*Rz(thetas(i))*Ry(deg2rad(90))*xyz;
            Xpp(ij) = xyzp(1);
            Ypp(ij) = xyzp(2);
            Zpp(ij) = xyzp(3);
        end
        % reshape back 
        Xpn = reshape(Xpp,2,[]);
        Ypn = reshape(Ypp,2,[]);
        Zpn = reshape(Zpp,2,[]);
        Xpn = Xpn + a;
        Ypn = Ypn + b;
        surf(Xpn,Ypn,Zpn,'FaceColor','y', 'FaceAlpha',1.0, 'EdgeColor','k');
        
    end
    % Plot the base rotation 
    plot3([P_x(1,1) P_x(1,3)],[P_x(2,1) P_x(2,3)],[P_x(3,1) P_x(3,3)],'c', 'LineWidth',2)
    diameter_end = 64.34e-3; 
    height_end = 25e-3;
    
    
    % Plot one side of the base 
    %plot3([C_(1,1) C_(1,2)],[C_(2,1) C_(2,2)],[C_(3,1) C_(3,2)],'b', 'LineWidth',2)
    % Plot the other side 
    %plot3([C_(1,3) C_(1,4)],[C_(2,3) C_(2,4)],[C_(3,3) C_(3,4)],'b', 'LineWidth',2)
    
    % Plot the moving base to not look rotated 
    C_1_mid_z = (C_(3,1) + C_(3,2))/2;
    C_2_mid_z = (C_(3,3) + C_(3,4))/2;
    
    plot3([C_(1,1) C_(1,2)],[C_(2,1) C_(2,2)],[C_1_mid_z C_1_mid_z],'b', 'LineWidth',3)
    plot3([C_(1,3) C_(1,4)],[C_(2,3) C_(2,4)],[C_2_mid_z C_2_mid_z],'b', 'LineWidth',3)
    
    % Plot from Px1 and Px2 to attachment points not rotated 
    plot3([P_x(1,1) C_(1,1)],[P_x(2,1) C_(2,1)],[P_x(3,1) C_1_mid_z],'r','LineWidth',2);
    plot3([P_x(1,2) C_(1,2)],[P_x(2,2) C_(2,2)],[P_x(3,2) C_1_mid_z],'r','LineWidth',2);
    plot3([P_x(1,3) C_(1,3)],[P_x(2,3) C_(2,3)],[P_x(3,3) C_2_mid_z],'r','LineWidth',2);
    plot3([P_x(1,4) C_(1,4)],[P_x(2,4) C_(2,4)],[P_x(3,4) C_2_mid_z],'r','LineWidth',2);
    
    % Plot the fixed base 
    % plot3([A_(1,1) A_(1,2)],[A_(2,1) A_(2,2)],[A_(3,1) A_(3,2)],'k', 'LineWidth',2)
    plot3([A_(1,2) A_(1,3)],[A_(2,2) A_(2,3)],[A_(3,2) A_(3,3)],'k', 'LineWidth',2)
    % plot3([A_(1,3) A_(1,4)],[A_(2,3) A_(2,4)],[A_(3,3) A_(3,4)],'k', 'LineWidth',2)
    plot3([A_(1,4) A_(1,1)],[A_(2,4) A_(2,1)],[A_(3,4) A_(3,1)],'k', 'LineWidth',2)
    
    rad_prox = 5e-2; 
    [Xp, Yp, Zp] = cylinder(rad_prox);
    Zp = 2*a*Zp; % specify the length of cylinder
    % rotate to match the x axis 
    % reshape all to column vector
    Xpc = reshape(Xp,[],1);
    Ypc = reshape(Yp,[],1);
    Zpc = reshape(Zp,[],1);
    [n,~]=size(Xpc);
    for ij=1:n
        xyz = [Xpc(ij);Ypc(ij);Zpc(ij)];
        xyzp = Ry(deg2rad(90))*xyz;
        Xpp(ij) = xyzp(1);
        Ypp(ij) = xyzp(2);
        Zpp(ij) = xyzp(3);
    end
    % reshape back 
    Xpn = reshape(Xpp,2,[]);
    Ypn = reshape(Ypp,2,[]);
    Zpn = reshape(Zpp,2,[]);
    Xpn = Xpn - a;
    % Ypn = Ypn + b;
    surf(Xpn,Ypn,Zpn,'FaceColor','w', 'FaceAlpha',0.5, 'EdgeColor','k');

    axis([-0.8 0.8 -0.8 0.8 -0.8 0.3])
    view(60,15)
    
    % plot the global frame 
    plot3([0 0.2], [0 0], [0 0],'r','LineWidth',3); % x is red 
    plot3([0 0], [0 0.2], [0 0],'g','LineWidth',3); % y is green 
    plot3([0 0], [0 0], [0 0.2],'b','LineWidth',3); % y is green 
    %      left line,    ,right line,
    pose_str1 = sprintf('%1.4f m', pose_n(1));
    pose_str2 = sprintf('%1.4f m', pose_n(2));
    pose_str3 = sprintf('%1.4f m', pose_n(3));
    pose_str4 = sprintf('%1.4f degrees in x', rad2deg(pose_n(4)));
    grid on 
    grid minor 
    sttr = {'x axis red','y axis green', 'z axis blue', 'Position',pose_str1, ...
        pose_str2, pose_str3, pose_str4};
    annotation('textbox',[.2 .3 .4 .5],'String',sttr,'FitBoxToText','on')
    %%% end function 
    
    
end