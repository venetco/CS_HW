%-------------------------------------------
%  TD 2 - Commande de systèmes dynamiques
% Active control of a simple mechanic system
%-------------------------------------------
clear all
%--------------------------------------
% Definition of the open-loop system
%--------------------------------------

    % System parameters 
    K=4; m=1; D=0.1;

    % State-space representation
    A=[0 1; -K/m -D/m];
    B=[0 ; 1];
    Bp=[0 ; 1 ];
    C=[1 0];
    % Open-loop system
    sys=ss(A,B,C,0); 
    % check of the controllability 
    rank(ctrb(A,B))
    % check of the observability 
    rank(obsv(A,C))
    % characteristics of the open-loop poles
     damp(eig(A))
%--------------------------------------
% LQR calculation
%--------------------------------------
% Gain matrix of the feedback

    q=1; % TO BE TUNED. weighting factor on the output. 
    r=1; % weighting factor on the input. Fixed to 1. 
    [K_LQ, P]=lqr(sys, q^2*C'*C, r^2);

    % Matrice M for the reference tracking
    M=-inv(C*inv(A-B*K_LQ)*B); 
    % Matrice N for the disturbance rejection
    N=-inv(C*inv(A-B*K_LQ)*B)*(C*inv(A-B*K_LQ)*Bp); 
    
    % characteristics of the closed-loop poles
    damp(eig(A-B*K_LQ))
%--------------------------------------
% Simulation
%--------------------------------------
% Simulation can be performed with the file "Part1_LQ.slx". 

%--------------------------------------
% LQI : Augmented model
%--------------------------------------
A_a = [A zeros(2,1);
       C 0];
B_a = [B
    0];
C_a =[C 0];
D_a = 0;
sys_a = ss(A_a, B_a, C_a, D_a);

%-----------------------------------------------------
% LQI calculation . Remark : we can use LQI of Matlab
%-----------------------------------------------------
% Gain matrix of the feedback
    q=1; % TO BE TUNED. weighting factor on the output. 
    r=1; % weighting factor on the input. Fixed to 1. 
    QI = 1; % TO BE TUNED. weighting factor on the integral of the tracking error.
    Q=diag([q^2, 0, QI]);
    [K_LQI, PI]=lqr(sys_a, Q, 1);

%--------------------------------------
% Simulation
%--------------------------------------
% Simulation can be performed with the file "Part1_LQI.slx". 
    