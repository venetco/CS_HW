% Validation du modèle dynamique du moteur (G)
% entree : tension vp
% sortie : vitesse omega
% Les données Omega_m, temps et cmd sont necessaires pour utiliser ce
% fichier
% Il faut resigner les valeurs de Kv et tau du modèle G


%------------------------------------------------------------------------
% Paramtres du modèle
%------------------------------------------------------------------------
Kv = [43]; % A completer
Taum = [0.035]; % A completer
 
 mod_G = tf(Kv,[Taum 1]);
 Omega_mod = lsim(mod_G,cmd,temps);
 
 figure(1)
 clf
 plot(temps,Omega_m,'b','LineWidth',2);
 hold on
 plot(temps,Omega_mod,'r','LineWidth',2);
 grid on
 %axis([0 3 -150 150]) % zoom sur la figure [xmin xmax ymin ymax]
 title('Reponse en vitesse du moteur')
 legend('mesure','modèle')
 xlabel('Temps (s)')
 ylabel('Vitesse (rad/s)')
 
 

 
 
 