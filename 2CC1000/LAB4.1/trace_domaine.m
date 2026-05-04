%% ************************************************************************
%% ************************************************************************
%% ***                                                                  ***
%% ***     TD 4 - Tracé des domaines de stabilité garantie (3.4)        ***
%% ***                                                                  ***
%% ************************************************************************
%% ************************************************************************
%
% Septembre 2022
% Département Automatique
%


function trace_domaine(k_min, k_max, val_min, val_max, Nb_Test)
global BO K1


figure,
for index = 1:Nb_Test,
%     a1 = 1 + 2*(min_k + (max_k - min_k)*rand);
%     a2 = 1 + 2*(min_k + (max_k - min_k)*rand);
    a1 = 1 + val_min + (val_max - val_min)*rand;
    a2 = 1 + val_min + (val_max - val_min)*rand;
    BO_perturbee = BO*diag([a1, a2]);
    BF_perturbee = feedback(BO_perturbee*K1, eye(2));
    valeurs_propres = eig(BF_perturbee.a);
    
    stock_a1(index) = a1;
    stock_a2(index) = a2;
    
    critere = max(real(valeurs_propres));
    crit(index) = critere;
    
    if critere < 0,
        hold on
        plot(a1, a2, '*b');
    else
        hold on
        plot(a1, a2, '*r');
    end
end

hold on,
plot([1+k_min 1+k_max], [1+k_min 1+k_min], 'k')
plot([1+k_min 1+k_max], [1+k_max 1+k_max], 'k')
plot([1+k_min 1+k_min], [1+k_min 1+k_max], 'k')
plot([1+k_max 1+k_max], [1+k_min 1+k_max], 'k')

title('Stabilité des points : bleu = stable, rouge = instable, noir = domaine garanti');
xlabel('a1')
ylabel('a2')
