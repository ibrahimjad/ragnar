clear all
close all
%% Full order observer controller MIMO.
% J = [ -0.20692744238625918480350970935772, -0.23282465150808832388798617301067, -0.0018037394338624440108555852751087, -0.0027237770654514239686242003705982, -0.046616676828534540626855364172696, -0.0043748266894397930680961665394113;
%  -0.09440614997175165108304277955125,  0.10209781154318461836545535862476,   0.078089231278121947994100512042756,  -0.072098953728305185208200060909319,    0.7805471762235340934000536416031,  -0.040288946639337048302070978576621;
%  -0.21627192163420201278899880299186,  0.22559725618732246493193350428491,   0.059792826385790176857266488243252,  -0.053883416061764900301277363243659,   0.23621817697563653972723486143913,   -0.18405060743418255596581026724899;
% -0.041545569051812333499312072499567,  0.11163173537246140150506802982555,     0.9660893787883126728554260627726,   -0.93960574614494256095106946083486,   -11.307111158243912352730846661859,     4.4612301412348968719237050190032];

A = zeros(8,8); A(1,5) = 1; A(2,6) = 1; A(3,7) = 1; A(4,8) = 1;
B = [zeros(8,4)];B(8,4) = 2180; B(7,3) = 1/1.28; B(6,2) = 1/1.28; B(5,1) = 1/1.28; % B = [0;1/M]
C = zeros(4,8); C(1,1) = 1; C(2,2) = 1; C(3,3) = 1; C(4,4) = 1;
D = zeros(4,6);

Desired_poles = [-6:1/7:-5];
Desired_zeroes = [-8:1/7:-7];
Desired_poles_obs = [-18:1/7:-17];

F_mimo=-place(A,B,Desired_poles) % State feedback

L_mimo=-place(A',C',Desired_poles_obs)'; % Observer

Ak_mimo = A+B*F_mimo+L_mimo*C;
sys_k_mimo=ss(Ak_mimo,L_mimo,-F_mimo,0);

sys_mimo=ss(A,B,C,0);

CL_mimo = feedback(sys_mimo,sys_k_mimo,1);

CLpoles_Mimo=pole(CL_mimo);

% Find N and M
L = L_mimo;
F = F_mimo;
Aza = A+B*F+L*C;
Cza = -F;


M_tilde=-place(Aza',Cza',Desired_zeroes)'

Acl = [A B*F;-L*C Aza]
B_tilde_cl = [B;M_tilde]
Ccl = [C zeros(4,8)]
N = -(Ccl*Acl^-1*B_tilde_cl)^-1
M = M_tilde*N

Bcl = [B*N;M]
final_sys = ss(Acl,Bcl,Ccl,0);


%% Comparing plots
figure(1)
subplot(2,2,1)
bode(CL_mimo(1,1))
hold on
bode(final_sys(1,1))
hold off

subplot(2,2,2)
bode(CL_mimo(2,2))
hold on
bode(final_sys(2,2))
hold off

subplot(2,2,3)
bode(CL_mimo(3,3))
hold on
bode(final_sys(3,3))
hold off

subplot(2,2,4)
bode(CL_mimo(4,4))
hold on
bode(final_sys(4,4))
hold off


figure(2)
pzmap(CL_mimo(1,1))
hold on
pzmap(final_sys(1,1))
hold off
%margin(CL_mimo(1,1))

%% Ragnar in Joint space
J = [ -0.20692744238625918480350970935772, -0.23282465150808832388798617301067, -0.0018037394338624440108555852751087, -0.0027237770654514239686242003705982, -0.046616676828534540626855364172696, -0.0043748266894397930680961665394113;
 -0.09440614997175165108304277955125,  0.10209781154318461836545535862476,   0.078089231278121947994100512042756,  -0.072098953728305185208200060909319,    0.7805471762235340934000536416031,  -0.040288946639337048302070978576621;
 -0.21627192163420201278899880299186,  0.22559725618732246493193350428491,   0.059792826385790176857266488243252,  -0.053883416061764900301277363243659,   0.23621817697563653972723486143913,   -0.18405060743418255596581026724899;
-0.041545569051812333499312072499567,  0.11163173537246140150506802982555,     0.9660893787883126728554260627726,   -0.93960574614494256095106946083486,   -11.307111158243912352730846661859,     4.4612301412348968719237050190032];
Ar = zeros(8,8); Ar(1,5) = 1; Ar(2,6) = 1; Ar(3,7) = 1; Ar(4,8) = 1;
BScal = [zeros(8,8)];
BScal(8,8) = 2180;
BScal(7,7) = 1/1.28;
BScal(6,6) = 1/1.28;
BScal(5,5) = 1/1.28;
Br = BScal*[zeros(4,6);pinv(J')];
Cr = zeros(4,8); Cr(1,1) = 1; Cr(2,2) = 1; Cr(3,3) = 1; Cr(4,4) = 1;
Cr = J'*Cr
Dr = zeros(4,6);

Ragnar_JS=ss(Ar,Br,Cr,0);

%step(Ragnar_JS)