# Les fleuristes


## Membres du groupe

Marin DAGRON / Philippine GABALDA / Corentin VENET / Théo SAUR / Martin RIBAUT / Elie EL MAZRAANI


## Organisation au sein du groupe

Répartition du travail entre les membres du groupe et chaque membre a une branche et commit ses programmes dans sa branche. On ne commit dans le main que les programmes qui fonctionnement parfaitement et qui constituent notre code final. On ne merge pas les branches individuelles dans le main pour ne pas surcharger le main de programmes qui ne fonctionnement pas et pour cependant conserver toutes les tentatives.


## Description

Déterfleur : démineur avec interface graphique différente de l'originale, dans laquelle il s'agit de récupérer toutes les fleurs en évitant les fleurs fanées


## Règle du jeu 

Le joueur choisit un niveau de difficulté afin de jouer sur une grille plus ou moins grande, contenant plus ou moins de fleurs fanées. Le joueur doit alors cliquer sur des cases pour récolter des fleurs et former son bouquet. Si le joueur clique sur une case contenant une fleur, celle-ci affiche une case comportant un chiffre qui correspond au nombre de cases contenant des fleurs fanées et entourant cette fleur (il y en a 8 au maximum (haut, bas, gauche, droites, diagonales)). Toutes les cases évidentes contenant une fleur à proximité de cette fleur vont également être révélées. Si le joueur clique sur une case correspondant à une fleur fanée, toutes les fleurs fanées de la grille sont dévoilées et le jeu est perdu. En revanche, si le joueur devine la position d’une fleur fanée, il peut marquer la case d’un râteau en faisant un clic droit. Si le joueur parvient à récolter toutes les fleurs de la grille sans tomber sur une fleur fanée, le jeu s’arrête et c’est gagné. Le but est de gagner le plus rapidement possible ! 


## Conseils utilisateur

  ~ Pour lancer le jeu avec l'interface python, le joueur doit ouvrir le fichier _3_affichage_python.py et lancer le programme. Le joueur peut alors intéragir par l'intermédiaire d'un terminal pour jouer au Déterfleur.

  ~ Pour lancer le jeu avec l'interface graphique, le joueur doit ouvrir le fichier _4_interface_graphique.py et lancer le programme. Une fenêtre s’ouvre et propose trois niveaux croissants de difficulté. Le joueur choisit le niveau en cliquant sur l’un des trois boutons. La partie est alors lancée. A la fin de la partie, le joueur peut quitter le jeu ou recommencer une partie, en changeant ou non de niveau. Un score en bas à droite indique au joueur le nombre de fleurs ramassées sur le nombre de fleurs à trouver.


## Niveaux 

### Niveau 1 : Jardin de mamie
  ~ terrain : 9 * 9
  
  ~ nombre de fleurs fanées : 11
  
  ~ nombre de fleurs à récupérer : 70

### Niveau 2 : Champ du voisin
  ~ terrain : 16 * 16
  
  ~ nombre de fleurs fanées : 46
  
  ~ nombre de fleurs à récupérer : 210

### Niveau 3 : Jardins de Versailles
  ~ terrain : 22 * 22
  
  ~ nombre de fleurs fanées : 94
  
  ~ nombre de fleurs à récupérer : 390


## Vocabulaire

  ~ grid_game = grille de jeu : tableau array avec le placement des fleurs fanées et des chiffres
  
  ~ grid_affichage = grille d'affichage : tableau array avec les chiffres suivants : 
  
    ~ 0 correspond à une case non dévoilée (image de fleur)

    ~ 1 correspond à une case dévoilée (image de l'élément de la grille de jeu)


## Plan d'action
## 1• initialisation du jeu

création de la grille, placement des fleurs fanées et des chiffres

  ~ remplir_grille (grille, x, y)

    ~ dans un tableau initialement vide, place aléatoirement une fleur fanée (codée par le nombre 10) en faissant attention à ne jamais avoir 2 fleurs fanées avec les mêmes coordonées. Entoure la fleur fanée d'entiers 1

    ~ entrée : grille_vide (array de int) , abscissse_fleur_fanee (int) , ordonnee_fleur_fanée (int)

    ~ sortie : grille_remplie (array de int)

  ~ grille_et_fleurs (niveau) 

    ~ permet d'obtenir la taille de la grille et le nombre de fleurs fanées à placer en fonction du niveau

    ~ entrée : niveau (int)

    ~ sortie : taille_grille (int) , nb_fleurs_fanées (int)

  ~ init_liste_grilles (niveau)

    ~ crée autant de tableaux (array) que de fleurs fanées correspondant au niveau demandé (grâce à la fonction grille_et_fleurs et ressort la liste des tableaux obtenus avec la fonction fill_grid

    ~ entrée : niveau (int)

    ~ sortie : liste_de_grilles_remplies (liste de array)
    
  ~ somme_grilles (liste_de_grilles_remplies)

    ~ réalise la somme des tableaux obtenus avec la fonction init_grid_game. Ressort un tableau avec la valeur 20 s'il y a une fleur fanée à cette case et le nombre de fleurs fanées qui entoure cette case s'il n'y a pas de fleur fanée à cet endroit

    ~ entrée : liste_de_grilles_remplies (liste de array)

    ~ sortie : grille_debut_jeu (array de int)

conclusion : il suffit de lancer la fonction somme_grilles(init_liste_grilles(niveau_souhaité)) avec niveau souhaité dans {1, 2, 3}

## 2• action du joueur

création de la grille de jeu en fonction de la première case choisie par le joueur

  ~ premier_coup (x, y, niveau)

    ~ renvoie la grille initialisée de telle sorte que le premier coup du joueur corresponde à une case où il n'y a pas de fleur fanée autour

    ~ entrée : abscisse_case_cliquée (int) , ordonnée_case_cliquée (int) , niveau (int)

    ~ sortie : grille_debut_jeu (array de int)


modification de la grille d'affichage en fonction du choix de case du joueur

  ~ modification_grille_affichage (x, y, grid_game, grid_affichage)

    ~ modifie la grille d'affichage de manière récursive en mettant des nombres strictements supérieurs à 0 à l'endroit des cases qu'il faut afficher

    ~ entrée : abscisse_case_cliquée (int) , ordonnée_case_cliquée (int) , grille_jeu (array de int) , grille_affichage (array de int)

    ~ sortie : grille_affichage_modifiee (array de int)

  ~ modification_grille_affichage_binaire (x, y, grid_game, grid_affichage)

    ~ à partir de la grille d'affichage obtenue avec la fonction modification_grille_affichage, revoit une grille d'affichage composée uniquement de 0 et 1 correspondant aux cases à dévoiler et celle à maintenir cachées

    ~ entrée : abscisse_case_cliquée (int) , ordonnée_case_cliquée (int) , grille_jeu (array de int) , grille_affichage (array de int)

    ~ sortie: grille_affichage_modifiee_binaire (array de int)

modification de la grille d'affichage lorsque le joueur perd en voulant ramasser une fleur fanée

  ~ trouve_fleurs_fanees (grid_affichage, grid_game)

    ~ révèle toutes les fleurs fanées à la fin de la partie

    ~ entrée : grille_affichage (array de int) , grille_jeu (array de int)

    ~ sortie : grille_affichage_modifiee (array de int)


## 3• interface python

  ~ is_game_over (grid_game, x, y, protection)

    ~ test pour savoir si le jeu est fini ou s'il se poursuit après une action du joueur

    ~ entrée : grille_jeu (array de int) , abscisse_case_cliquée (int) , ordonnée_case_cliquée (int)

    ~ sortie : réponse (booléen)

  ~ is_game_win (niveau, nb_fleurs_recup)

    ~ test pour savoir si le jeu est gagné

    ~ entrée : niveau (int) , nb_fleurs_recup (int)

    ~ sortie : réponse (bolléen)
  
  ~ score (grid_affichage, taille_grille)

    ~ renvoie le nombre de fleurs ramassées

    ~ entrée : grille_affichage (array de int) , taille_grille (int)

    ~ sortie : nb_fleurs_ramassées (int)

  ~ affichage_grille (grid_game, grid_affichage, grille_rateaux)

    ~ affiche la grille sur python à tout moment du jeu en fonction de la grille de jeu, de la grille des cases à dévoiler et la grille des cases à protéger. Il suffit de print cette fonction dans python pour l'afficher

    ~ entrée : grille_jeu (array de int) , grille_affichage (array de int) , grille_rateaux (array de int)

    ~ sortie : grille_prete_a_etre_affichee (str)
  
  ~ game_python () : fonction qui utilise toutes les fonctions crées précédemment pour mettre en place le jeu sur python de manière interactive avec le joueur. Il suffit de lancer cette fonction sur python puis de jouer de manière interactive


## 4• interface graphique 

Start 

  ~ start (a, root) : détruit la fenêtre de départ et modifie la valeur du niveau


  ~ choix_du_niveau () : affiche la fenêtre de départ et renvoie le niveau choisi


Score et chrono

  ~ compteur (niveau, nb) : renvoie le score en cours sur le total (sous forme d'une chaine de caractères)

  ~ stopper_chrono () : arrête le chrono

  ~ lancer_chrono (frame_chrono, niveau, grid_affichage, taille, fleur2, root) : lance le chrono

  ~ afficher_horloge (frame_chrono, niveau, grid_affichage, taille, fleur2, root) : affiche le chrono


Affichage fenêtres

  ~ quitter (root, root2) : si on appuie sur le bouton 'quitter' les deux fenêtres sont fermées

  ~ nouvelle_partie (root, root2) : si on appuie sur le bouton 'nouvelle partie' les deux fenêtres sont fermées et le jeu est relancé

  ~ end_win (root) : permet de faire apparaître la fenêtre de fin de jeu si le joueur a gagné, elle affiche un message et deux boutons (nouvelle partie ou quitter le jeu)

  ~ end_lose(root) : permet de faire apparaître la fenêtre de fin de jeu si le joueur a perdu, elle affiche un message et deux boutons (nouvelle partie ou quitter le jeu)


Affichage grille et boutons

  ~ on_enter (e) : permet changer la couleur d'un bouton lorsque le joueur a sa souris dessus

  ~ on_leave (e) : permet de rendre sa couleur d'origine au bouton lorsque la souris du joueur quitte le bouton

  ~ AfficheRateau (ref, fleur2, Rateau2) : permet de faire apparaitre ou disparaitre un rateau sur un bouton si le joueur fait un clic droit

  ~ change_grille (ref, taille, grid_affichage, grid_game, root, niveau) : pemet de modifier la grille en fonction du bouton sur lequel le joueur appuie

  ~ init_grille (taille, background, grid_game, fleurfanee2) : affiche la grille de jeu sur la fenêtre de jeu

  ~ liste_bouton(taille, fleur2, grid_affichage, grid_game, Rateau2, root, niveau) : crée tous les boutons et les range dans une liste

  ~ place_bouton(taille, grid_affichage) : affiche ou non les boutons sur la fenêtre de jeu qui vont donc cacher ou non la grille de jeu

  ~ bouton_disable(taille, grid_affichage) : place des boutons désactivés (pour la fin de la partie)


Mise en place du jeu

  ~ game_final() : fonction qui utilise toutes les fonctions crées précédemment pour mettre en place le jeu avec l'interface graphique. Il suffit de lancer cette fonction sur python puis de jouer sur l'interface.