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

function [Asynth, Bsynth, Bsynthd, Csynth, Dsynth] = Definition_Modele(we1_param, we2_param)
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

%% Modèle de synthèse pour un sous-système 2 entrées / 2 sorties
Asynth = sys3.a;

B11 = sys3_B(1,1);
B12 = sys3_B(1,2);
B13 = sys3_B(1,3);
B21 = sys3_B(2,1);
B22 = sys3_B(2,2);
B23 = sys3_B(2,3);
B31 = sys3_B(3,1);
B32 = sys3_B(3,2);

Bd11 = sys3_Bd(1,1);
Bd12 = sys3_Bd(1,2);
Bd21 = sys3_Bd(2,1);
Bd22 = sys3_Bd(2,2);

DTo1 = sys3_D(3,1);
DTo2 = sys3_D(3,2);
DTo3 = sys3_D(3,3);

Dd31 = sys3_Dd(3, 1);
Dd32 = sys3_Dd(3, 2);

Bsynth = [B11-B13*DTo1/DTo3, B12-B13*DTo2/DTo3;
          B21-B23*DTo1/DTo3, B22-B23*DTo2/DTo3;
          B31,               B32];
      
Bsynthd = [Bd11-B13*Dd31/DTo3, Bd12-B13*Dd32/DTo3, 0, B13/DTo3;
           Bd21-B23*Dd31/DTo3, Bd22-B23*Dd32/DTo3, 0, B23/DTo3;
           0,                  0,                  1, 0];
       
Csynth = sys3.c(1:2, :);

Dsynth = sys3.d(1:2, 1:2);
