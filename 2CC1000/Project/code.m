%--------------------------------------------------------------------------
% Initialisation des paramètres du PONT ROULANT
%
%--------------------------------------------------------------------------

clear    % Effade toutes les varaibles de la memoire
close all   % Fermeture de toutes les figures

g = 9.81;
Te1 = 0.100;
%A = 1;

% Gains capteurs
Ki = 5;       % V/A
Komga = 0.02; % V/(rad/s)
Kteta = 0.875;% V/rad
Kfi = 4.77;   % V/rad

% Période d'échantillonnage pour l'identification
Te = 0.002;

% Parametres moteur 
Rm = 2.25;
Lm = 0.2e-3;
f = 7.25e-5;
J = 3.9e-6;

% Caractéristiques moteur (à identifier)
Taum = 0.035 ;    % Paramètre à identifier
Kv = 43.3;       % Paramètre à identifier

% Caractéristique charge (a et l à identifier)
r = 0.022;
N = 17;
a = 0.0487 ;      % Paramètre à identifier
l = 0.2687 ;       % Paramètre à identifier

%--------------------------------------------------------------------------
% Analyse d'une commande sur un modèle simplifié (K_w)
%--------------------------------------------------------------------------


% Modèle simplifié  (A,B,C,D)
A = [0 r/N;0 -1/Taum]; % à completer
B = [0;Kv/Taum]; % à completer
C = [1 0]; % à completer
D = 0; % à completer

% Modèle augmenté  (Aa,Ba,Ca,Da)
Aa = [0 r/N 0;0 -1/Taum 0;1 0 0]; % à completer
Ba = [0;Kv/Taum;0]; % à completer
Ca = [1 0 0]; % à completer
Da = 0; % à completer

% Calcule de la commande par placement de pôles  avec "place"


ksi = 0.9;
omega0 = 3;
tm = 1;
vp = [-ksi*omega0-1i*omega0*sqrt(1-ksi^2);-ksi*omega0+1i*omega0*sqrt(1-ksi^2);-1/tm];
K_w = place(Aa,Ba,vp);



%sys_cl = ss(Aa-Ba*K_w,[0;0;-1], Ca, 0);
%disp(size(sys_cl, 1));
%t = 0:0.01:10; % Temps de simulation
%r = 0.30*ones(size(t)); % Référence d'échelon
%disp(size(t));
%disp(size(r));
%[y,t] = lsim(sys_cl,r,t);

%sys_cl2 = ss(Aa-Ba*K_w,[0;0;-1], [1 0 0;0 1 0;0 0 1], 0);
%disp(size(sys_cl2, 1));
%[w,t] = lsim(sys_cl2,r,t);
%z = - K_w .* w;

%figure;
%subplot(2,1,1)
%plot(t,y(:,1),'b');
%hold on;
%plot(t, r, 'r-');
%xlabel('temps (en s)')
%ylabel('amplitude (en cm)');
%legend('x_c','x_{ref}')
%title('Réponse à un échelon en entrée x_{ref} = 0.30 cm');
%axis([0,10,0,0.35])
%grid on;

%subplot(2,1,2)
%plot(t,z(:,2),'b');
%ylabel('u_c (en V)');
%xlabel('temps (en s)');
%grid on;


% Calcul de la réponse en boucle fermée avec le modèle de synthèse

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%
% Synthèse LQ de la commande par retour d'état sans action integrale
%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% Modèle simplifié  (A,B,C,D)
Ap = [0 r/N 0 0;0 -1/Taum 0 0;0 0 0 1;0 r/(l*N*Taum) -g/l -a/l]; % à completer
Bp = [0;Kv/Taum;0;-Kv*r/(l*N*Taum)]; % à completer
Cp = [1 0 0 0;0 0 1 0]; % à completer
Dp = 0; % à completer


% Choix des pondérations pour la synthèse LQ

Q_lq = [5000 0 0 0;0 0 0 0;0 0 1/1000 0;0 0 0 0];
R_lq = 10;
K_lq = lqr(Ap,Bp,Q_lq,R_lq);

% Calcul de la commande LQ (K_lq et M_lq) avec lqr
K_lq = lqr(Ap,Bp,Q_lq,R_lq); % à completer
M_lq = -inv(Cp(1,:)*inv(Ap-Bp*K_lq)*Bp); % à completer
K_lq
M_lq



% Calcul de la réponse en boucle fermée avec le modèle de synthèse

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%
% Synthèse LQ de la commande par retour d'état avec action integrale (LQI)
%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% Modèle augmenté  (Aa,Ba,Ca,Da)
Apa = [0 r/N 0 0 0;0 -1/Taum 0 0 0;0 0 0 1 0;0 r/(l*N*Taum) -g/l -a/l 0;1 0 0 0 0]; % à completer
Bpa = [0;Kv/Taum;0;-Kv*r/(l*N*Taum);0]; % à completer
Cpa = [1 0 0 0 0;0 0 1 0 0;0 0 0 0 1]; % à completer
Dpa = 0; % à completer

% Choix des pondérations pour la synthèse LQI

Q_lqi = [5000 0 0 0 0;0 0 0 0 0;0 0 1/1000 0 0;0 0 0 0 0;0 0 0 0 250000];
R_lqi = 10;
K_lqi = lqr(Apa,Bpa,Q_lqi,R_lqi);
K_lqi



% Calcul de la commande LQ avec lqr
K_lqi = lqr(Apa,Bpa,Q_lqi,R_lqi); % à completer

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%
% Synthèse d'un observateur
%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Pôles pour l'observateur

H = [Cp;Cp*Ap;Cp*Ap*Ap;Cp*Ap*Ap*Ap];
rank(H);


poles_system = eig(Ap-Bp*K_lq);
poles_obs = 2*[min(poles_system); 1.5*min(poles_system); 2*min(poles_system); 2.5*min(poles_system)];
poles_system
poles_obs


% Matrice des mesures
Cobs = Cp; % à completer

% Calcul du gain de l'observateur


L = place(Ap',Cp',poles_obs);
L = L'



%syst1 = ss(Apa,Bpa,K_lqi,0);
%margin(syst1)
%grid on



Aobs = [Apa zeros(5,4);zeros(4,5) Ap-L*Cp];
Bobs = [Bpa;Bp];
Kobs = [K_lqi(1:4) K_lqi(5) K_lqi(1:4)];

syst2 = ss(Aobs,Bobs,Kobs,0);
margin(syst2)
grid on



