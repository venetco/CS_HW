%% ************************************************************************
%% ************************************************************************
%% ***                                                                  ***
%% *** Travail Hors Présentiel  -  Exercice sur l'analyse de            ***
%% *** robustesse pour les systèmes des TDs 1 - Simulation cérébrale    ***
%% ***                                                                  ***
%% ************************************************************************
%% ************************************************************************
%
% Octobre 2022 - Département Automatique

clear all
close all

%% TD1 - Stimulation cérébrale
%% Définition système numérique et vérification des performances
A = [160, -270; 210, -150];
B = [370; 0];
C = [1 0];
D = 0

K = [0.28, -0.54];
M = 0.11;

% Verification BF
BF = ss(A-B*K, B*M, C, D),
figure,
step(BF), grid on


%% Analyse de la Boucle ouverte
BO = ss(A, B, K, 0)
BO_tf = tf(BO)

eig(A)
figure, nyquist(BO), grid on;
figure, margin(BO); grid on;

%% Analyse robustesse
% Parametres pour Simulink
z1 = 40;
z2 = 50;
tau1 = 0.015;
tau2 = 0.03;
c11 = 7.356;
c12 = 8.762;
c21 = 14.4;
c22 = 8;
a = 12;
m1 = 300;
m2 = 400;
gamma1 = 16.647;
gamma2 = 4.333;
mu1 = 0.0133;
mu2 = 0.01;

Atilde = [(-1+mu1*z1*(1-z1/m1)*c11), -mu1*z1*(1-z1/m1)*c12;
          mu2*z2*(1-z2/m2)*c21, -(1+mu2*z2*(1-z2/m2)*c22)];
          
Btilde = [a*mu1*z1*(1-z1/m1); 0];

% Analyse de robustesse
[Atest, Btest, Ctest, Dtest] = linmod('Stimulation_Cerebrale_Corrige');
alp = hinfnorm(ss(Atest, Btest, Ctest, Dtest))






