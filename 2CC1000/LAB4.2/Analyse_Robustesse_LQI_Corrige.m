%% ************************************************************************
%% ************************************************************************
%% ***                                                                  ***
%% *** Travail Hors Présentiel  -  Exercice sur l'analyse de            ***
%% *** robustesse pour les systèmes masse ressort - TD2                 ***
%% ***                                                                  ***
%% ************************************************************************
%% ************************************************************************
%
% Octobre 2022 - Département Automatique

clear all
close all

%% Vérification des marges de stabilité
%-------------------------------------------
%  TD 2 - Commande de systèmes dynamiques
% Active control of a simple mechanic system
%-------------------------------------------

%--------------------------------------
% Définition of the open-loop system
%--------------------------------------

    % System parameters 
    K=4; m=1; D=0.1;

    % State-space representation
    A=[0 1; -K/m -D/m];
    B=[0 ; 1];
    Bp=[0 ; 1 ];
    C=[1 0];

%--------------------------------------
% LQI : Augmented model
%--------------------------------------
A_a = [A zeros(2,1)
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
    q=10; % TO BE TUNED. weighting factor on the output. 
    r=1; % weighting factor on the input. Fixed to 1. 
    QI = 10000; % TO BE TUNED. weighting factor on the integral of the tracking erro.
    Q=diag([q^2, 0, QI]);
    [K_LQI, PI]=lqr(sys_a, Q, 1);

% -------------------------
% Open-Loop
% -------------------------

K = K_LQI(1:2);
k3 = K_LQI(3);
ABO = [A zeros(2,1); -C 0];
BBO = [B; 0];
CBO = [K -k3];
DBO = 0;

BO = ss(ABO, BBO, CBO, DBO);
figure, margin(BO), grid on


%% Vérification pour des réglages aléatoires
% Question 2.3
NbTests = 100;
qlog_min = -2;
qlog_max = 5;
QIlog_min = 1;
QIlog_max = 8;

stock_deltaphi = zeros(1, NbTests);
stock_deltaG = zeros(1, NbTests);

for index = 1:NbTests,
    disp(['Test n° ' num2str(index)])
    qlog = qlog_min + (qlog_max - qlog_min)*rand;
    QIlog = QIlog_min + (QIlog_max - QIlog_min)*rand;
    
    q = 10^qlog;
    QI = 10^QIlog;
    
    Q=diag([q^2, 0, QI]);
    [K_LQI, PI]=lqr(sys_a, Q, 1);
    
    K = K_LQI(1:2);
    k3 = K_LQI(3);
    ABO = [A zeros(2,1); -C 0];
    BBO = [B; 0];
    CBO = [K -k3];
    DBO = 0;

    BO = ss(ABO, BBO, CBO, DBO);
    
    [Gm,Pm,Wcg,Wcp] = margin(BO);
    
    stock_deltaphi(index) = Pm;
    stock_deltaG(index) = 20*log10(Gm);
    
end

figure,
plot(1:NbTests, stock_deltaphi, '*'), grid on;
title('Marges de phase obtenues')

figure,
plot(1:NbTests, stock_deltaG, '*'), grid on;
title('Marges de gain obtenues')

% Question 2.4
NbTests = 30;
qlog_min = -2;
qlog_max = 5;
QIlog_min = 1;
QIlog_max = 8;

for index = 1:NbTests,
    disp(['Test n° ' num2str(index)])
    qlog = qlog_min + (qlog_max - qlog_min)*rand;
    QIlog = QIlog_min + (QIlog_max - QIlog_min)*rand;
    
    q = 10^qlog;
    QI = 10^QIlog;
    
    Q=diag([q^2, 0, QI]);
    [K_LQI, PI]=lqr(sys_a, Q, 1);
    
    K = K_LQI(1:2);
    k3 = K_LQI(3);
    ABF = [A-B*K k3*B; -C 0];
    BBF = [zeros(2,1); 1];
    CBF = [C 0];
    DBF = 0;

    BF = ss(ABF, BBF, CBF, DBF);
    
    step(BF, 6); grid on;
    hold on;
    
end

figure,
plot(1:NbTests, stock_deltaphi, '*'), grid on;
title('Marges de phase obtenues')

figure,
plot(1:NbTests, stock_deltaG, '*'), grid on;
title('Marges de gain obtenues')

    
    