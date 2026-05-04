%% ************************************************************************
%% ************************************************************************
%% ***                                                                  ***
%% *** Travail Hors Présentiel  -  Exercice sur l'analyse de            ***
%% *** robustesse pour les systèmes du TD 3 - Eolienne                  ***
%% ***                                                                  ***
%% ************************************************************************
%% ************************************************************************
%
% Octobre 2022 - Département Automatique

clear all
close all

%% Modele linéaire
%-------------------------------------------------------------------------
% coefficients des matrics A, B,C, D , Bd 
%-------------------------------------------------------------------------
taubt=0.1;  % constante de temps de l'actionneur du calage
a1 = -0.083;
a2 = -0.055;
a3 = 0;
a4 = -10;
b1=-2.55e-6;
b2=1/taubt;
bd = 0.059;
 
%  modele lineaire, representation d'Ã©tat
A = [a1 a2;a3 a4]; % modele a deux etats avec une sortie et deux commandes
B = [b1 0;0 b2];
C = [1 0];         % la sortie est la vitesse du rotor wr 
D = 0;
Bd= [bd;0];        % coeffifient sur la variation de vent
sys=ss(A,[B Bd],C,zeros(1,3)); 

%  boucle ouverte
pole_BO = pole(sys);

%% Commande LQ
%  choix des matrices de pondération
Q=[1 0; 0 1];
R=[1 0; 0 1];

%  gain de retour du LQ
K1_lq = lqr(A,B,Q,R); % calcul du gain de la commande LQ;
%  pôles de la BF
VP_BF_LQ= eig(A-B*K1_lq);
M1_lq =-1/(C*inv(A-B*K1_lq)*B(:,1)); 
N1_lq = -1/(C*inv(A-B*K1_lq)*B(:,1))*(C*inv(A-B*K1_lq)*Bd(:,1)); 

%% Observateur

% Systeme augmente en supposant que la variation de vent est une perturbation
% representation d'etat du systeme augmente
Aa = [a1 a2 bd;a3 a4 0; 0 0 0];
Ba = [b1 0;0 b2; 0 0];
Ca=[1 0 0];                    
Da = zeros(1,2);        
sys_a=ss(Aa,Ba,Ca,Da); 

% Placement de pole
Po = 3*eig(A-B*K1_lq);
La = place(A',C',Po)';   % gain de l'observateur avec une sortie mesuree
VP_Obs=eig(A-La*C);

% Estimation par Kalman
G=[Bd;0]+[1; 0.1; 1];%[1; 0; 0]; 
H=0; 
dv=0.1*randn(1,300); 
nu=0.1*randn(1,300);
RN_calc= mean(nu*nu'); 
NN_calc=mean(dv.*nu);
QN_calc=mean(dv*dv');
RN = 10*0.1;
NN = 0;
QN = 0.1;

[La,P,E]=lqe(Aa,G,Ca,QN,RN,NN);


%% Analyse correcteur
% Calcul correcteur
Ka = [K1_lq [-N1_lq; 0]]

Acor = Aa-Ba*Ka-La*Ca;
Bcor = [Ba*[M1_lq; 0] La];
Ccor = -Ka;
Dcor = [[M1_lq; 0] zeros(2,1)];
cor = ss(Acor, Bcor, Ccor, Dcor)
figure, bode(cor), grid on

% Calcul BO anaytique
ABO = [A, zeros(2,3); La*C Aa-Ba*Ka-La*Ca];
BBO = [B; zeros(3,2)];
CBO = [zeros(2,2) -Ka];
DBO = zeros(2,2);
BO_anal = -ss(ABO, BBO, CBO, DBO);
figure, bode(BO_anal)

%% BO mono
Amono = [A -B*Ka; zeros(3,2) Aa-Ba*Ka-La*Ca];
Bmono = [zeros(2,1); La];
Cmono = [C zeros(1,3)];
Dmono = 0;
BO_mono = -ss(Amono, Bmono, Cmono, Dmono)
figure, margin(BO_mono)

