%-------------------------------------------
%  TD 2 - Commande de systèmes dynamiques
% Active control of a simple mechanic system
%-------------------------------------------
%--------------------------------------
% definition of the perturbation
%--------------------------------------

    load('seisme.mat'); % Seism signal
    figure(1);
    plot(seisme.time, seisme.signals.values); grid;
    xlabel('Time (s)');
    ylabel('Perturbation (m/s^2)');
    
%--------------------------------------
% Definition of the open-loop system
%--------------------------------------

    % System parameters 
   K0=4; m0=1; D0=0.1;
   K1=4; m1=1; D1=0.1;

   M_bar=diag([m0; m1]);
   D_bar=[D0+D1 -D1 ; -D1 D1];
   K_bar=[K0+K1 -K1 ; -K1 K1];
   Eu=[1; 0];
   Eg=[1 ;1]

    % State-space representation
    A=[zeros(2) eye(2)
        -inv(M_bar)*K_bar -inv(M_bar)*D_bar];
    B=[zeros(2,1)
        Eu];
    Bp=[zeros(2,1)
       Eg];
    
     C=[1 0 0 0]; % x0 is the output
    % Open-loop system
    sys=ss(A,B,C,zeros(1,1)); 
    
    % System analysis
    
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
    Q = 10*eye(4);% TO BE TUNED. weigthing factor on x0. 
    r=1; % weigthing factor on the input. Fixed to 1. 

    K_LQ=lqr(sys, Q, r^2);

 % Matrice M for the reference tracking
    M=-inv(C*inv(A-B*K_LQ)*B);     
    % characteristics of the closed-loop poles
    damp(eig(A-B*K_LQ))
%--------------------------------------
% Simulation
%--------------------------------------
% Simulation can be performed with the file "Part2_LQ.slx". 

