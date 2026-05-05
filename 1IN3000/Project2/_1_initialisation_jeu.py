import numpy as np
import random as rd


def remplir_grille(grille, x, y):
    # Cette fonction prend en argument une grille et les coordonnées de la fleur fanée à positionner et
    # retourne la grille en plaçant un 10 au niveau de la fleur fanée et des 1 autour
    n = len(grille)
    # remplit la grille si la fleur fanée est sur le coin en haut à gauche
    if y == 0 and x == 0:
        for i in range(y, y+2):
            for j in range(x, x+2):
                grille[i][j] = int(1)
        grille[y][x] += int(9)
    # remplit la grille si la fleur fanée est sur le coin en haut à droite
    elif y == 0 and x == n-1:
        for i in range(y, y+2):
            for j in range(x-1, x+1):
                grille[i][j] = int(1)
        grille[y][x] += int(9)
    # remplit la grille si la fleur fanée est sur le coin en bas à gauche
    elif y == n-1 and x == 0:
        for i in range(y-1, y+1):
            for j in range(x, x+2):
                grille[i][j] = int(1)
        grille[y][x] += int(9)
    # remplit la grille si la fleur fanée est sur le coin en bas à droite
    elif y == n-1 and x == n-1:
        for i in range(y-1, y+1):
            for j in range(x-1, x+1):
                grille[i][j] = int(1)
        grille[y][x] += int(9)
    # remplit la grille si la fleur fanée est sur le bord du haut mais n'est pas dans un coin
    elif y == 0:
        for i in range(y, y+2):
            for j in range(x-1, x+2):
                grille[i][j] = int(1)
        grille[y][x] += int(9)
    # remplit la grille si la fleur fanée est sur le bord du bas mais n'est pas dans un coin
    elif y == n-1:
        for i in range(y-1, y+1):
            for j in range(x-1, x+2):
                grille[i][j] = int(1)
        grille[y][x] += int(9)
    # remplit la grille si la fleur fanée est sur le bord gauche mais n'est pas dans un coin
    elif x == 0:
        for i in range(y-1, y+2):
            for j in range(x, x+2):
                grille[i][j] = int(1)
        grille[y][x] += int(9)
    # remplit la grille si la fleur fanée est sur le bord droit mais n'est pas dans un coin
    elif x == n-1:
        for i in range(y-1, y+2):
            for j in range(x-1, x+1):
                grille[i][j] = int(1)
        grille[y][x] += int(9)
    # remplit la grille si la fleur fanée n'est pas sur un bord ni un coin
    else:
        for i in range(y-1, y+2):
            for j in range(x-1, x+2):
                grille[i][j] = int(1)
        grille[y][x] += int(9)
    return grille


def grille_et_fleurs(niveau):
    # prend en argument le niveau et renvoit la taille n de la grille et le nombre nb de fleurs fanées qui correspondent
    if niveau == 1:
        taille_grille = 9
        nb_fleurs_fanées = 11
    elif niveau == 2:
        taille_grille = 16
        nb_fleurs_fanées = 46
    else:
        taille_grille = 22
        nb_fleurs_fanées = 94
    return taille_grille, nb_fleurs_fanées


def init_liste_grilles(niveau):
    # Cette fonction prend en argument le niveau et elle retourne une liste de nb grilles contenant chacune une
    # fleur fanée
    taille_grille, nb_fleurs_fanées = grille_et_fleurs(niveau)
    # on initialise une liste liste_de_grilles_remplies vide de grilles et une liste fleurs_fanées de positions des fleurs fanées
    liste_de_grilles_remplies = []
    fleurs_fanées = []
    for k in range(nb_fleurs_fanées):
        # pour chaque fleur fanée on crée un nouveau tableau rempli de 0 (int pour la vérification des tests)
        grille = np.zeros((taille_grille, taille_grille), dtype=int)
        # on choisi au hasard une colonne et une ligne
        j = rd.randint(0, taille_grille-1)
        i = rd.randint(0, taille_grille-1)
        # tant qu'il y a déjà une fleur fanée à cette position, on recherche une autre position
        while [i, j] in fleurs_fanées:
            j = rd.randint(0, taille_grille-1)
            i = rd.randint(0, taille_grille-1)
        # on remplit la grille
        grille = remplir_grille(grille, i, j)
        # on rajoute la grille à la liste des grilles
        liste_de_grilles_remplies.append(grille)
        # on rajoute la position de la fleur fanée qu'on a rajouté
        fleurs_fanées.append([i, j])
    return liste_de_grilles_remplies


def somme_grille(liste_de_grilles_remplies):
    # la fonction somme_grille permet de sommer tous les tableaux qui contiennent chacun une unique fleur fanée
    # elle resort donc un tableau final où toutes les fleurs fanées sont placées (avec une valeur de 20) et où
    # les autres cases ont des chiffres de 0 à 8 qui correspondent au nombre de fleurs fanées qui les entourent

    # on initialise le nouveau tableau avec le premier tableau de la liste
    grid_game_init = liste_de_grilles_remplies[0]
    # on somme tous les tableaux de la liste
    for k in range(1, len(liste_de_grilles_remplies)):
        grid_game_init = grid_game_init + liste_de_grilles_remplies[k]
    # on parcourt tous les éléments du nouveau tableau (qui est donc la sommes des tableaux de la liste)
    a, b = np.shape(grid_game_init)
    for i in range(a):
        for j in range(b):
            # on teste s'il y a une fleur fanée (supérieur strictement à 9 car une fleur fanée a dans programme init_grid_game a une valeur de 10)
            if grid_game_init[i, j] > 9:
                # la valeur d'une fleur fanée est désormais de 20
                grid_game_init[i, j] = 20
    return grid_game_init
