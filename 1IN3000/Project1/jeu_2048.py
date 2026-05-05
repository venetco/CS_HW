import random

# crée une nouvelle grille vide


def create_grid(n):
    game_grid = []
    for i in range(0, n):
        l = []
        for j in range(0, n):
            l.append(0)
        game_grid.append(l)
    return game_grid

# ajoute une nouvelle tuile avec la probabilité correspondante


def grid_add_new_tile_at_position(grille, a, b):
    grille[a][b] = get_value_new_tile()
    return grille

# ressort la liste des valeurs sur la grille en lisant ligne par ligne


def get_all_tiles(grille):
    liste = []
    for i in range(len(grille)):
        for j in range(len(grille[i])):
            insert = grille[i][j]
            if insert == ' ':
                liste.append(0)
            else:
                liste.append(insert)
    return liste

# fonction pour le respect de la probabilité


def get_value_new_tile():
    # on prend un nombre au hasard entre 0 et 1 que l'on nomme a
    a = random.random()
    # pour respecter la probabilité correspondante, on return 2 si a>0.1 et 4 sinon
    if a > 0.1:
        return 2
    else:
        return 4

# donne les coordonnées des emplacements de la grille où il n'y a rien


def get_empty_tiles_positions(grille):
    l = []
    for i in range(len(grille)):
        for j in range(len(grille[i])):
            a = grille[i][j]
            if a == 0 or a == ' ':
                l.append((i, j))
    return l


def get_new_position(grille):
    # on récupère la liste des positions des 0
    positions = get_empty_tiles_positions(grille)
    random_index = random.randint(0, len(positions)-1)
    return positions[random_index][0], positions[random_index][1]


def grid_get_value(grille, x, y):
    a = grille[x][y]
    if a == ' ':
        return 0
    else:
        return a


def grid_add_new_tile(grille):
    positions = get_empty_tiles_positions(grille)
    random_index = random.randint(0, len(positions)-1)
    grille = grid_add_new_tile_at_position(
        grille, positions[random_index][0], positions[random_index][1])
    return grille


def init_game(n):
    grid = create_grid(n)
    grid = grid_add_new_tile(grid)
    grid = grid_add_new_tile(grid)
    return grid


def grid_to_string(grid, n):
    a = n * " =====" + "\n"
    for i in range(len(grid)):
        a = a + "|"
        for j in range(len(grid[0])):
            if grid[i][j] == ' ':
                a = a + "     |"
            else:
                c = grid[i][j]
                if len(str(c)) == 2:
                    a = a + "  " + str(grid[i][j]) + " |"
                elif len(str(c)) == 3:
                    a = a + " " + str(grid[i][j]) + " |"
                elif len(str(c)) == 4:
                    a = a + " " + str(grid[i][j]) + "|"
                elif len(str(c)) == 1:
                    a = a + "  " + str(grid[i][j]) + "  |"
                elif len(str(c)) == 5:
                    a = a + str(grid[i][j]) + "|"
        a = a + "\n" + n * " =====" + "\n"
    return a


THEMES = {"0": {"name": "Default", 0: "", 2: "2", 4: "4", 8: "8", 16: "16", 32: "32", 64: "64", 128: "128", 256: "256", 512: "512", 1024: "1024", 2048: "2048", 4096: "4096", 8192: "8192"}, "1": {"name": "Chemistry", 0: "", 2: "H", 4: "He", 8: "Li", 16: "Be",
                                                                                                                                                                                                   32: "B", 64: "C", 128: "N", 256: "O", 512: "F", 1024: "Ne", 2048: "Na", 4096: "Mg", 8192: "Al"}, "2": {"name": "Alphabet", 0: "", 2: "A", 4: "B", 8: "C", 16: "D", 32: "E", 64: "F", 128: "G", 256: "H", 512: "I", 1024: "J", 2048: "K", 4096: "L", 8192: "M"}}


def long_value_with_theme(grid, THEME):
    m = 0
    for k in grid:
        for i in k:
            a = len(THEME[int(i)])
            if a > m:
                m = a
    return m


def grid_to_string_with_size_and_theme(grid, theme, n):
    a = ' '
    for j in range(n):
        for k in range(n):
            a += '  === '
        a += '\n '
        for i in range(n):
            if grid[j][i] == 0 or grid[j][i] == ' ':
                a += '|  '+' '+'  '
            else:
                w = theme[grid[j][i]]

                b = len(w)
                if b == 1:
                    a += '|  '+w + '  '
                elif b == 2:
                    a += '|  '+w + ' '
                elif b == 3:
                    a += '| '+w + ' '
                elif b == 4:
                    a += '| '+w + ''
                elif b == 5:
                    a += '|'+w + ''
        a += '|'
        a += '\n '
    for k in range(n):
        a += '  === '
    return a


def read_player_command():
    move = input(
        "Entrez votre commande (q (gauche), d (droite), z (haut), s (bas)):")
    while move not in ['q', 's', 'd', 'z']:
        print("Coup non valide")
        move = input(
            "Entrez votre commande (q (gauche), d (droite), z (haut), s (bas)):")
    return move


def read_size_grid():
    taille = input("Choisissez la taille de la grille (longueur):")
    return int(taille)


def read_theme_grid():
    theme = input(
        "Choisissez le thème de la grille (0 (Défaut), 1 (Tableau périodique), 2 (Alphabet):")
    return theme


def move_row_left(ligne):
    c = 0
    b = ligne.copy()
    for i in range(1, len(b)):
        if b[i] != 0:
            a = b[i]
            k = i-1
            while k > -1 and b[k] == 0:
                k -= 1
            if k <= -1:
                b[0] = a
                c = 0
            else:
                if b[k] == a and c == 0:
                    b[k] = 2*a
                    b[k+1] = 0
                    c = 1
                else:
                    b[k+1] = a
                    c = 0
            if i != k+1:
                b[i] = 0
    return (b)


def move_row_right(row):
    row_inv = list(reversed(row))
    l = move_row_left(row_inv)
    c = list(reversed(l))
    return c


def move_grid(grid, direction):
    new_grid = []
    if direction == "q":
        for i in range(len(grid)):
            new_grid.append(move_row_left(grid[i]))
        return new_grid
    elif direction == "d":
        for i in range(len(grid)):
            new_grid.append(move_row_right(grid[i]))
        return new_grid
    else:
        grid_inter = []
        grid_inter_2 = []
        for i in range(len(grid)):
            colonne = []
            for j in range(len(grid)):
                colonne.append(grid[j][i])
            grid_inter.append(colonne)
        if direction == "z":
            for i in range(len(grid)):
                grid_inter_2.append(move_row_left(grid_inter[i]))
            for j in range(len(grid)):
                ligne = []
                for k in range(len(grid)):
                    ligne.append(grid_inter_2[k][j])
                new_grid.append(ligne)
            return new_grid
        elif direction == "s":
            for i in range(len(grid)):
                grid_inter_2.append(move_row_right(grid_inter[i]))
            for j in range(len(grid)):
                ligne = []
                for k in range(len(grid)):
                    ligne.append(grid_inter_2[k][j])
                new_grid.append(ligne)
            return new_grid


def is_grid_full(grid):
    for i in range(len(grid)):
        for j in range(len(grid[i])):
            if grid[i][j] == 0 or grid[i][j] == ' ':
                return False
    return True


def identique_grille(grid1, grid2):
    if len(grid1) != len(grid2):
        return False
    for i in range(len(grid1)):
        if len(grid1[i]) != len(grid2[i]):
            return False
        for j in range(len(grid1[i])):
            if grid1[i][j] != 0 and grid1[i][j] != ' ' and grid1[i][j] != grid2[i][j]:
                return False
            elif grid1[i][j] == 0 or grid1[i][j] == ' ':
                if grid2[i][j] != 0 and grid2[i][j] != ' ':
                    return False
    return True


def move_possible(grid):
    return [not identique_grille(grid, move_grid(grid, 'q')), not identique_grille(grid, move_grid(grid, 'd')), not identique_grille(grid, move_grid(grid, 'z')), not identique_grille(grid, move_grid(grid, 's'))]


def is_game_over(grid):
    if not is_grid_full(grid):
        return False
    test = move_possible(grid)
    for k in range(len(test)):
        if test[k]:
            return False
    return True


def get_grid_tile_max(grid):
    max = 0
    for i in range(len(grid)):
        for j in range(len(grid[i])):
            if grid[i][j] > max:
                max = grid[i][j]
    return max


def is_game_win(grid):
    if get_grid_tile_max(grid) >= 2048:
        print('Vous avez gagné !')
    else:
        print('Vous avez perdu :(')


def random_play():
    grid = init_game(4)
    print(grid)
    while is_game_over(grid) == False:
        aleatoire = random.randint(1, 4)
        if aleatoire == 1:
            grid = move_grid(grid, 'q')
        elif aleatoire == 2:
            grid = move_grid(grid, 's')
        elif aleatoire == 3:
            grid = move_grid(grid, 'd')
        elif aleatoire == 4:
            grid = move_grid(grid, 'z')
        grid = grid_add_new_tile(grid)

        print(grid)
        print(is_game_win(grid))
    return ('--END--')


def game_play():
    tail = read_size_grid()
    theme = read_theme_grid()
    print('--START--')
    grid = init_game(tail)
    print(grid_to_string_with_size_and_theme(grid, THEMES[theme], int(tail)))
    while is_game_over(grid) == False:
        direction = read_player_command()
        att = move_grid(grid, direction)
        if att != grid:
            att = grid_add_new_tile(att)
        grid = att

        print(grid_to_string_with_size_and_theme(
            grid, THEMES[theme], int(tail)))
    print(is_game_win(grid))
    return ('--END--')
