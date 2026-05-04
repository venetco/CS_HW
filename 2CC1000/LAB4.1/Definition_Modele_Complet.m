%% ************************************************************************
%% ************************************************************************
%% ***                                                                  ***
%% *** Définition du modèle de synthèse du véhicule hybride             ***
%% ***                                                                  ***
%% ************************************************************************
%% ************************************************************************
%
% Septembre 2022
% Guillaume Sandou - Département Automatique
%

function [sys3, sys7] = Definition_Modele_Complet(we1_param, we2_param)
%% Définition des modèles
load modeles

%% On garde le modèle réduit, et on ajoute la capacité.
% Ecapa_dot = -we1*Te1-we2*Te2-Ploss
% Pour cela il faut un point de fonctionnement we1_param, we2_param

% Modèle sans les perturbations
sys3_A = [[sys2.a [0;0]; zeros(1,3)]];
sys3_B = [sys2.b; -we1_param, -we2_param, 0];
sys3_C = [[sys2.c zeros(2,1)]; 0, 0, 1];
sys3_D = [sys2.d; zeros(1,3)];

sys3_C = sys3_C([1 3 2], :);  % Pour avoir le même ordre que dans l'article
sys3_D = sys3_D([1 3 2], :);

sys3 = ss(sys3_A, sys3_B, sys3_C, sys3_D);

% Modèle avec les perturbations
sys3_Bd = [[sys2_Bd [0;0]]; 0, 0, -1];
sys3_Dd = [[sys2_Dd [0;0]]; 0, 0, 0];

sys3_Dd = sys3_Dd([1 3 2], :);

sys3d = ss(sys3_A, [sys3_B, sys3_Bd], sys3_C, [sys3_D, sys3_Dd]);

%% Modèle d'ordre 6 augmenté de la variable Ecapa
sys7_A = [[sys6.a zeros(6,1); zeros(1,7)]];
sys7_B = [sys6.b; -we1_param, -we2_param, 0];
sys7_C = [[sys6.c zeros(2,1)]; zeros(1,6), 1];
sys7_D = [sys6.d; zeros(1,3)];

sys7_C = sys7_C([1 3 2], :);  % Pour avoir le même ordre que dans l'article
sys7_D = sys7_D([1 3 2], :);

sys7 = ss(sys7_A, sys7_B, sys7_C, sys7_D);

% Modèle avec les perturbations
sys7_Bd = [sys6_Bd zeros(6,1); zeros(1,2) -1];
sys7_Dd = [[sys6_Dd [0;0]]; zeros(1,3)];

sys7_Dd = sys7_Dd([1 3 2], :);

sys7d = ss(sys7_A, [sys7_B, sys7_Bd], sys7_C, [sys7_D, sys7_Dd]);

