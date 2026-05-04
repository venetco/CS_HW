% TD3 eolienne

clear all

% Modele linéaire
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% Partie 1: 
% modèle linéaire  2 états et 2 commandes et une sortie mesurée
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
 
%  modÃ¨le linÃ©aire, reprÃ©sentation d'Ã©tat
A = [a1 a2;a3 a4]; % modÃ¨le Ã  deux Ã©tats avec une sortie et deux commandes
B = [b1 0;0 b2];
C = [1 0];         % la sortie est la vitesse du rotor wr 
D = 0;
Bd= [bd;0];        % coeffifient sur la variation de vent
sys=ss(A,[B Bd],C,zeros(1,3)); 

