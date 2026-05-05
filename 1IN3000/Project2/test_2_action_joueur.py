import pytest
from _2_action_joueur import *


def test_premier_coup():
    assert premier_coup(3, 4, 1)[4, 3] == 0
    assert premier_coup(10, 0, 2)[0, 10] == 0
    assert premier_coup(14, 21, 3)[21, 14] == 0

# le test de modification_grille_affichage_binaire permet de tester également modification_grille_affichage car il utilise cette fonction


def test_modification_grille_affichage_binaire():
    # la fonction modification_grille_affichage_binaire modifie la grille donnée initialement en argument (ce qui n'est pas contraignant pour le jeu)
    grid_game1 = np.array([[0, 0, 0], [0, 1, 1], [0, 1, 20]])
    grid_affichage1 = np.array([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
    grid_affichage2 = np.array([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
    grid_affichage3 = np.array([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
    grid_affichage4 = np.array([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
    assert ((modification_grille_affichage_binaire(1, 1, grid_game1,
            grid_affichage1) == np.array([[0, 0, 0], [0, 1, 0], [0, 0, 0]])).all())
    assert ((modification_grille_affichage_binaire(0, 0, grid_game1,
            grid_affichage2) == np.array([[1, 1, 1], [1, 1, 1], [1, 1, 0]])).all())
    assert ((modification_grille_affichage_binaire(1, 0, grid_game1,
            grid_affichage3) == np.array([[1, 1, 1], [1, 1, 1], [1, 1, 0]])).all())
    assert ((modification_grille_affichage_binaire(0, 1, grid_game1,
            grid_affichage4) == np.array([[1, 1, 1], [1, 1, 1], [1, 1, 0]])).all())
    grid_game2 = np.array([[1, 1, 2, 1, 1, 0, 0, 0, 0, 0 ], [1, 20, 3, 20, 1, 0, 0, 0, 0, 0], [1, 2, 20, 2, 1, 0, 1, 2, 2, 1], [1, 2, 2, 1, 0, 0, 1, 20, 20, 1], [1, 20, 1, 0, 0, 0, 1, 2, 3, 2], [
                          1, 1, 1, 0, 0, 0, 0, 0, 1, 20], [0, 0, 0, 0, 0, 0, 1, 2, 3, 2], [0, 0, 0, 0, 0, 0, 1, 20, 20, 1], [0, 0, 1, 1, 1, 0, 1, 2, 2, 1], [0, 0, 1, 20, 1, 0, 0, 0, 0, 0]])
    grid_affichage5 = np.zeros((10, 10), int)
    grid_affichage6 = np.zeros((10, 10), int)
    grid_affichage7 = np.zeros((10, 10), int)
    grid_affichage8 = np.zeros((10, 10), int)
    test = np.array([[0, 0, 0, 0, 1, 1, 1, 1, 1, 1], [0, 0, 0, 0, 1, 1, 1, 1, 1, 1], [0, 0, 0, 1, 1, 1, 1, 1, 1, 1], [0, 0, 1, 1, 1, 1, 1, 0, 0, 0], [0, 0, 1, 1, 1, 1, 1, 1, 1, 0], [
                    1, 1, 1, 1, 1, 1, 1, 1, 1, 0], [1, 1, 1, 1, 1, 1, 1, 1, 1, 0], [1, 1, 1, 1, 1, 1, 1, 0, 0, 0], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 0, 1, 1, 1, 1, 1, 1]])
    assert ((modification_grille_affichage_binaire(
        5, 5, grid_game2, grid_affichage5) == test).all())
    assert ((modification_grille_affichage_binaire(
        9, 0, grid_game2, grid_affichage6) == test).all())
    assert ((modification_grille_affichage_binaire(
        9, 9, grid_game2, grid_affichage7) == test).all())
    test2 = np.zeros((10, 10), int)
    test2[0, 0] = 1
    assert (((modification_grille_affichage_binaire(
        0, 0, grid_game2, grid_affichage8) == test2).all()))

def test_trouve_fleurs_fanees() :
    grid_affichage1 = np.array([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
    grid_game1 = np.array([[0, 0, 0], [0, 1, 1], [0, 1, 20]])
    assert((trouve_fleurs_fanees(grid_affichage1,grid_game1)==np.array([[0, 0, 0], [0, 0, 0], [0, 0, 1]])).all())
    grid_game2 = np.array([[1, 1, 2, 1, 1, 0, 0, 0, 0, 0 ], [1, 20, 3, 20, 1, 0, 0, 0, 0, 0], [1, 2, 20, 2, 1, 0, 1, 2, 2, 1], [1, 2, 2, 1, 0, 0, 1, 20, 20, 1], [1, 20, 1, 0, 0, 0, 1, 2, 3, 2], [
                          1, 1, 1, 0, 0, 0, 0, 0, 1, 20], [0, 0, 0, 0, 0, 0, 1, 2, 3, 2], [0, 0, 0, 0, 0, 0, 1, 20, 20, 1], [0, 0, 1, 1, 1, 0, 1, 2, 2, 1], [0, 0, 1, 20, 1, 0, 0, 0, 0, 0]])
    grid_affichage2 = np.zeros((10, 10), int)
    test2=np.array([[0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], [0, 1, 0, 1, 0, 0, 0, 0, 0, 0], [0, 0, 1, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 1, 1, 0], [0, 1, 0, 0, 0, 0, 0, 0, 0, 0], [
                          0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 1, 1, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 1, 0, 0, 0, 0, 0, 0]])
    assert((trouve_fleurs_fanees(grid_affichage2,grid_game2)==test2).all())
    grid_affichage3= modification_grille_affichage_binaire(5, 5, grid_game2, grid_affichage2)
    test = np.array([[0, 0, 0, 0, 1, 1, 1, 1, 1, 1], [0, 0, 0, 0, 1, 1, 1, 1, 1, 1], [0, 0, 0, 1, 1, 1, 1, 1, 1, 1], [0, 0, 1, 1, 1, 1, 1, 0, 0, 0], [0, 0, 1, 1, 1, 1, 1, 1, 1, 0], [
                    1, 1, 1, 1, 1, 1, 1, 1, 1, 0], [1, 1, 1, 1, 1, 1, 1, 1, 1, 0], [1, 1, 1, 1, 1, 1, 1, 0, 0, 0], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 0, 1, 1, 1, 1, 1, 1]])
    test3=test2+test
    assert((trouve_fleurs_fanees(grid_affichage3,grid_game2)==test3).all())
    
