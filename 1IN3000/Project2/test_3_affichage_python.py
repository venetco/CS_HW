import pytest
from _3_affichage_python import *
def test_is_game_over():
    assert is_game_over([[0,  0,  0,  1, 20,  1,  1,  2, 20],
                         [0,  0,  0,  1,  1,  1,  2, 20,  3],
                         [0,  0,  0,  1,  2,  2,  3, 20,  2],
                         [0,  0,  1,  2, 20, 20,  2,  1,  1],
                         [0,  0,  1, 20,  4,  3,  3,  2,  2],
                         [0,  1,  2,  2,  2, 20,  2, 20, 20],
                         [0,  1, 20,  1,  1,  1,  2,  2,  2],
                         [0,  1,  1,  1,  0,  0,  0,  0,  0],
                         [0,  0,  0,  0,  0,  0,  0,  0,  0]], 4, 0, 'o') == False
    assert is_game_over([[0,  0,  0,  1, 20,  1,  1,  2, 20],
                         [0,  0,  0,  1,  1,  1,  2, 20,  3],
                         [0,  0,  0,  1,  2,  2,  3, 20,  2],
                         [0,  0,  1,  2, 20, 20,  2,  1,  1],
                         [0,  0,  1, 20,  4,  3,  3,  2,  2],
                         [0,  1,  2,  2,  2, 20,  2, 20, 20],
                         [0,  1, 20,  1,  1,  1,  2,  2,  2],
                         [0,  1,  1,  1,  0,  0,  0,  0,  0],
                         [0,  0,  0,  0,  0,  0,  0,  0,  0]], 4, 0, 'n') == True
    assert is_game_over([[0,  0,  0,  1, 20,  1,  1,  2, 20],
                         [0,  0,  0,  1,  1,  1,  2, 20,  3],
                         [0,  0,  0,  1,  2,  2,  3, 20,  2],
                         [0,  0,  1,  2, 20, 20,  2,  1,  1],
                         [0,  0,  1, 20,  4,  3,  3,  2,  2],
                         [0,  1,  2,  2,  2, 20,  2, 20, 20],
                         [0,  1, 20,  1,  1,  1,  2,  2,  2],
                         [0,  1,  1,  1,  0,  0,  0,  0,  0],
                         [0,  0,  0,  0,  0,  0,  0,  0,  0]], 1, 5, 'n') == False


def test_is_game_win():
    assert is_game_win(1, 69) == False
    assert is_game_win(1, 70) == True
    assert is_game_win(2, 112) == False
    assert is_game_win(2, 210) == True
    assert is_game_win(3, 286) == False
    assert is_game_win(3, 390) == True


def test_score():
    assert score([[0, 0, 0, 1, 0, 1, 1, 1, 0],
                  [0, 0, 0, 1, 1, 1, 1, 0, 1],
                  [0, 0, 0, 1, 1, 1, 1, 0, 1],
                  [0, 0, 1, 1, 0, 0, 1, 1, 1],
                  [0, 0, 1, 0, 1, 1, 1, 1, 1],
                  [0, 1, 1, 1, 1, 0, 1, 0, 0],
                  [0, 1, 0, 1, 1, 1, 1, 1, 1],
                  [0, 1, 1, 1, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0, 0]], 9) == 40
    assert score(np.zeros((22, 22), int), 22) == 0


# pas de fonction test pour la fonction affichage_grille car vérification de affichage_grille avec des print dans python car
# format str en sortie

# pas de test pour la fonction game_python car fonction intéractive