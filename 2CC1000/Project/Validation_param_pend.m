% Validation du modèle du pendule
% entree : Condition initial phi
% sortie : Evolution de l'angle phi
% Les données Phi, temps sont necessaires pour utiliser ce fichier
% Il faut resigner les valeurs de a et l du modèle par répresentation
% d'etat


%------------------------------------------------------------------------
% Paramtres du modèle
%------------------------------------------------------------------------
a = [0.488]; % A completer
l = [0.2687]; % A completer
Phi0 = [0.08]; % A completer (valeur initial de Phi en rad)
r = 0.022;
N = 17;

% x1 = phi, x2 = phi_dot
A_pend = [0 1;-9.81/l -a/l]; % A completer
B_pend = [0;0];
C_pend = [1 0];
D_pend = 0;
mod_pend = ss(A_pend,B_pend,C_pend,D_pend);
Phi_mod = initial(mod_pend,[Phi0;0],temps);

temps_Phi0 = 0; % Intant de temps pour la condition initiale sur Phi.
index_Phi0 = temps>temps_Phi0;

figure(2)
clf
plot(temps(5000:end)-10,Phi(5000:end),'b','LineWidth',2);
hold on
plot(temps,Phi_mod,'r','LineWidth',2);
grid on
 %axis([0 3 -150 150]) % zoom sur la figure [xmin xmax ymin ymax]
title('Evolution anple phi pendule')
legend('mesure','modèle')
xlabel('Temps (s)')
ylabel('Angme phi (rad)')
 
 
test=temps(index_Phi0)-temps_Phi0;
 
 