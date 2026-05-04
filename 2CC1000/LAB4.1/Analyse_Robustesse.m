%% ************************************************************************
%% ************************************************************************
%% ***                                                                  ***
%% ***     TD 4 - Analyse de robustesse des Systèmes multivariables     ***
%% ***                                                                  ***
%% ************************************************************************
%% ************************************************************************
%
% Septembre 2022
% Département Automatique
%

close all
clear all
global BO K1

%% Choix du point de fonctionnement et définition des modèles et du correcteur
theta1 = 500;
theta2 = -500;
[A, B, Bd, C, D] = Definition_Modele(theta1, theta2);

load controleur                        % La variable K1 contient le correcteur
[A_K1, B_K1, C_K1, D_K1] = ssdata(K1); % Matrices d'état du correcteur

%% Question 2.2
BO = ????                              % Boucle ouverte non corrigée
BO_corrigee = ????                     % Boucle ouverte corrigée
BF = ????                              % Boucle fermée
figure, step(BF), grid on              % Réponse indicielle du système
title('Réponse indicielle du système en boucle fermée')

%% Question 2.3
figure,
????, grid on;
title('Valeurs singulières de la boucle ouverte')

%% Question 2.4
S = ????
figure, sigma(S), grid on;
title('Valeurs singulières de S')

KS = ????
figure, sigma(KS), grid on
title('Valeurs singulières de KS')

% Vérification d'un équivalent
figure,
[Sig_BO, wBO] = ????
[Sig_S, wS] = ????
semilogx(wBO, 20*log10(????),'r',wBO, 20*log10(????),'r',wS, 20*log10(Sig_S(1,:)),'b--',wS, 20*log10(Sig_S(2,:)),'b--')
grid on
title('Valeurs singulières de S (bleu) et de inverses de celles de GK (rouge)'); 

%% Question 2.5
w0 = ????;
KS_w0 = ????
[U,val,V] = ????

figure,
sigma(BF), grid on;

%% Question 3.2
BO_corrigee_prime =????;
Tprime = ????
alp = hinfnorm(????)

%% Question 3.4
k_min = ????
k_max = ????
val_min = ????
val_max = ????
Nb_Tests = ????
trace_domaine(k_min, k_max, val_min, val_max, Nb_Tests);

%% Question 3.6
Sprime = ????;
alp = hinfnorm(Sprime)





