import numpy as np
from _1_initialisation_jeu import *
from _2_action_joueur import *
from codecarbon import EmissionsTracker
from playsound import playsound

# tracker = EmissionsTracker()
# debut de la mesure de la consommation d'energie
# tracker.start()


def is_game_over(grid_game, x, y, protection):
    # fonction qui renvoit un booléen : True si le jeu est fini, False si le jeu continue

    # x est l'abscisse et y l'ordonnée de la case que le joueur veut dévoiler
    # test s'il y a une bombe
    if grid_game[y][x] == 20 and protection == "n":
        return True
    return False


def is_game_win(niveau, nb_fleurs_recup):
    # selon le niveau, le nombre de fleurs à récupérer n'est pas le même
    if niveau == 1:
        nb_fleurs_a_recuperer = 70
    elif niveau == 2:
        nb_fleurs_a_recuperer = 210
    else:
        nb_fleurs_a_recuperer = 390

    # si toutes les fleurs ont été récupérées, le jeu est gagné, sinon ce n'est pas gagné
    if nb_fleurs_recup/nb_fleurs_a_recuperer >= 1.0:
        return True
    else:
        return False


def score(grid_affichage, taille_grille):
    c = 0
    for i in range(taille_grille):
        for j in range(taille_grille):
            if grid_affichage[i][j] == 1:
                c += 1
    return c


def affichage_grille(grid_game, grid_affichage, grille_rateaux):
    a = "\n    "

    # affiche les nombres en abscisse
    for k in range(1, len(grid_game) + 1):
        if len(str(k)) == 1:
            a = a + "   " + str(k) + "  "
        else:
            a = a + "  " + str(k) + "  "

    a = a + "\n    " + len(grid_game) * " =====" + "\n"

    # on parcourt tous les éléments de la grille
    for i in range(len(grid_game)):

        # affiche les nombres en ordonnée
        if len(str(i+1)) == 1:
            a = a + " " + str(i+1) + "  |"
        else:
            a = a + str(i+1) + "  |"

        for j in range(len(grid_game)):
            if grille_rateaux[i][j] == 1:
                # si la case veut être protégée par le joueur, on affiche R pour signifier la présence d'un rateau
                a = a + "  " + "R" + "  |"
            elif grid_affichage[i][j] == 0:
                # si la case ne doit pas être dévoilée, on ne la dévoile pas
                a = a + "     |"
            elif len(str(grid_game[i][j])) == 2:
                # si la case que le joueur veut dévoiler est une fleur fanée, on affiche F
                a = a + "  " + "F" + "  |"
            else:
                # si la case que le joueur veut dévoiler est un numéro, on l'affiche
                a = a + "  " + str(grid_game[i][j]) + "  |"

        a = a + "\n    " + len(grid_game) * " =====" + "\n"
    return a


def game_python():

    # demande à l'utilisateur à quel niveau il veut jouer
    niveau = int(input(
        "Choississez votre niveau : Jardin de mamie (1) , Champ du voisin (2) , Jardins de Versailles (3) : "))

    # vérification que le niveau donné cooresponde aux choix possibles sinon on redemande jusqu'à que ce soit le cas
    while niveau not in {1, 2, 3}:
        niveau = int(input(
            "Vous vous êtes trompés, choississez votre niveau : Jardin de mamie (1) , Champ du voisin (2) , Jardins de Versailles (3) : "))

    taille_grille, nb_fleurs_fanées = grille_et_fleurs(niveau)

    # on initialise une grille de 0 grille_rateaux qui comporte des 1 si l'utilisateur souhaite mettre un rateau à ces positions
    grille_rateaux = np.zeros((taille_grille, taille_grille), int)

    # on initialise une grille de jeu sans importance
    grid_game = np.zeros((taille_grille, taille_grille), int)

    # on initialise une grille d'affichage où toutes les cases sont cachées
    grid_affichage = np.zeros((taille_grille, taille_grille), int)

    # on initialise le caractère protection comme étant une demande de dévoiler la case
    protection = 'n'

    # on joue un son qui représente le début de la partie
    playsound("debut_son.mp3")

    # on affiche la grille de départ où toutes les cases sont cachées
    print(affichage_grille(grid_game, grid_affichage, grille_rateaux))

    # le joueur rentre les coordonnées de la case sur laquelle il veut cliquer et on vérifie qu'elle correspondent à une case de la grille de jeu
    x = int(input("Abscisse de la case à dévoiler : ")) - 1
    while x not in [k for k in range(taille_grille)]:
        x = int(input("Vous vous êtes trompé, abscisse de la case à dévoiler : ")) - 1
    y = int(input("Ordonnée de la case à dévoiler : ")) - 1
    while y not in [k for k in range(taille_grille)]:
        y = int(input("Vous vous êtes trompé, ordonnée de la case à dévoiler : ")) - 1

    # on définit la grille de jeu comme étant une grille où la case de départ choisie par l'utilisateur est une case vide
    grid_game = premier_coup(x, y, niveau)

    # on modifie la grille d'affichage pour dévoiler de proche en proche les cases qui doivent l'être
    grid_affichage = modification_grille_affichage_binaire(
        x, y, grid_game, grid_affichage)

    # on affiche la nouvelle grille modifiée après le premier choix de l'utilisateur
    print(affichage_grille(grid_game, grid_affichage, grille_rateaux))

    # on teste que le joueur n'a pas voulu révéler une case fleur fanée et qu'il n'a pas encore récupéré toutes les fleurs non fanées
    while not is_game_over(grid_game, x, y, protection) and not is_game_win(niveau, score(grid_affichage, taille_grille)):

        # le joueur rentre les coordonnées de la case sur laquelle il souhaite réaliser une action et on vérifie qu'elle correspondent à une case de la grille de jeu
        x = int(input("Abscisse de la case à dévoiler : ")) - 1
        while x not in [k for k in range(taille_grille)]:
            x = int(
                input("Vous vous êtes trompé, abscisse de la case à dévoiler : ")) - 1
        y = int(input("Ordonnée de la case à dévoiler : ")) - 1
        while y not in [k for k in range(taille_grille)]:
            y = int(
                input("Vous vous êtes trompé, ordonnée de la case à dévoiler : ")) - 1

        # on demande à l'utilisateur s'il souhaite protéger cette case (mettre un rateau) ou la révéler et on vérifie que la réponse corresponde à une des 2 possibilités
        protection = input(
            "Voulez-vous mettre/enlever un râteau ? (o pour oui et n pour non) : ")
        while protection not in {'o', 'n'}:
            protection = input(
                "Vous vous êtes trompé, voulez-vous mettre/enlever un râteau ? (o pour oui et n pour non) : ")

        if protection == "o":
            if grille_rateaux[y][x] == 0:
                # le joueur souhaite protéger la case donc on place un rateau à cette position
                grille_rateaux[y][x] = 1
            else:
                # le joueur veut enlever le rateau de la case sur laquelle il a cliqué
                grille_rateaux[y][x] = 0
        else:
            # si le joueur veut révéler une case, on modifie la grille d'affichage en fonction de la case à révéler choisie par le joueur
            grid_affichage = modification_grille_affichage_binaire(
                x, y, grid_game, grid_affichage)

        # on affiche la nouvelle grille modifiée
        print(affichage_grille(grid_game, grid_affichage, grille_rateaux))

    # lorsqu'on sort de la boucle précédente, on teste si toutes les fleurs ont été ramassées
    if is_game_win(niveau, score(grid_affichage, taille_grille)):
        # si c'est le cas le joueur à gagné
        print("Bravo vous avez gagné", playsound("victoire_son.mp3"))
    else:
        # sinon, le joueur a perdu et on affiche la grille avec la position des fleurs fanées
        print(affichage_grille(grid_game, trouve_fleurs_fanees(
            grid_affichage, grid_game), grille_rateaux))
        print("Dommage, vous avez perdu", playsound("defaite_son.mp3"))


if __name__ == '__main__':
    game_python()

# arret de la mesure de la consommation d'energie
# tracker.stop()
