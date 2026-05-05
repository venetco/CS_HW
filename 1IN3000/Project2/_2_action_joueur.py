from _1_initialisation_jeu import *


def premier_coup(x, y, niveau):
    # fonction qui renvoie la grille initialisée de telle sorte que le premier coup du joueur corresponde à une case où il n'y a pas de fleur fanée autour

    # initialise une grille
    grid_game = somme_grille(init_liste_grilles(niveau))

    # s'il y a une fleur fanée à la case de départ choisie par le joueur, on initialise une autre grille jusqu'à ce que le premier coup du joueur cooresponde à une case où il n'y a pas de fleur fanée autour
    while grid_game[y][x] != 0:
        grid_game = somme_grille(init_liste_grilles(niveau))
    return grid_game


def modification_grille_affichage(x, y, grid_game, grid_affichage):
    # cette fonction dévoile tout les cases à dévoiler avec une méthode de proche en proche (récursif)

    l = len(grid_game)
    # on commence par vérifier si on est encore dans la grille de jeu
    if x >= l or y >= l or x < 0 or y < 0:
        # si ce n'est pas le cas, on renvoit grid_affichage sans la modifier
        return (grid_affichage)
    # si c'est le cas, on regarde si la case est dévoilée ou non
    elif grid_affichage[y, x] >= 1:
        # si elle est déjà devoilée, on n'a pas besoin de faire de modifications
        return (grid_affichage)
    else:
        if grid_game[y, x] != 0:
            # si la case contient un indice (le nb de fleurs fanées autour), on la dévoile et on ne modifie pas l'affichage des cases autour
            grid_affichage[y, x] = 1
            return (grid_affichage)
        else:
            # si la case est vide, on la dévoile
            grid_affichage[y, x] = 1
            # on regarde si on doit également modifier les 8 cases autour de celle ci = fonctionnement récursif
            return (modification_grille_affichage(x+1, y, grid_game, grid_affichage) + modification_grille_affichage(x, y+1, grid_game, grid_affichage) + modification_grille_affichage(x-1, y, grid_game, grid_affichage) + modification_grille_affichage(x, y-1, grid_game, grid_affichage) + modification_grille_affichage(x+1, y+1, grid_game, grid_affichage) + modification_grille_affichage(x-1, y-1, grid_game, grid_affichage) + modification_grille_affichage(x+1, y-1, grid_game, grid_affichage) + modification_grille_affichage(x-1, y+1, grid_game, grid_affichage))


def modification_grille_affichage_binaire(x, y, grid_game, grid_affichage):
    # comme avec la fontion modification_grille_affichage on somme les grilles d'affichage, les cases affichées sont codées par un nombre supérieur à 0, or on souhaite revenir à un code binaire de 0 et de 1 pour la grille d'affichage

    # on modifie la grille d'affichage avec la fonction précédente
    modification_grille_affichage(x, y, grid_game, grid_affichage)
    l = len(grid_game)
    # on parcourt la grille d'affichage
    for i in range(l):
        for j in range(l):
            if grid_affichage[i, j] > 0:
                # on donne la valeur 1 à toutes les cases qui sont codées par un nombre strictement supérieur à 0 (cases dévoilées)
                grid_affichage[i, j] = 1
    return (grid_affichage)


def trouve_fleurs_fanees(grid_affichage, grid_game):
    # modifie la grille d'affichage pour révéler toutes les fleurs fanées à la fin de la partie

    l = len(grid_affichage)
    for i in range(l):
        for j in range(l):
            if grid_game[i, j] == 20:  # si c'est une bombe
                grid_affichage[i, j] = 1  # on l'affiche
    return (grid_affichage)
