from _1_initialisation_jeu import *
from _2_action_joueur import *
from _3_affichage_python import *
from tkinter import *
from functools import partial
import time
from image import *

##################################################### START ###################################################################
### permet d'afficher la fenêtre de départ afin de choisir le niveau ###


def start(a, root):  # détruit la fenêtre de départ et modifie la valeur du niveau (g)
    root.destroy()
    global g
    g = a


def choix_du_niveau():  # affiche la fenêtre de départ et renvoie le niveau choisi
    root = Tk()
    root.title("Déterfleur")
    niveau_1 = Button(root, text="Jardin de mamie",
                      font=("Helvetica", 20), command=partial(start, a=1, root=root), foreground="#48c072")

    niveau_2 = Button(root, text="Champ du voisin",
                      font=("Helvetica", 20), command=partial(start, a=2, root=root), foreground="#2c6fbb")

    niveau_3 = Button(root, text="Jardins de Versailles",
                      font=("Helvetica", 20), command=partial(start, a=3, root=root), foreground="#892222")
    text = Label(root, text='Choisissez votre niveau de jeu', font=(15))
    niveau_1.grid(column=0, row=1)
    niveau_2.grid(column=1, row=1)
    niveau_3.grid(column=2, row=1)
    text.grid(row=0)
    mainloop()
    return g  # niveau 1,2 ou 3


############################################## SCORE ET CHRONO ###############################################################
### renvoie "Gagné !" si le joueur a récolté toutes les fleurs non fanées sans être tombé sur une fleur fanée ###

def compteur(niveau, nb):
    if niveau == "1":
        a = 70
    elif niveau == "2":
        a = 210
    else:
        a = 390
    return str(nb) + "/" + str(a)


def stopper_chrono():
    global en_cours
    en_cours = 0


def lancer_chrono(frame_chrono, niveau, grid_affichage, taille, fleur2, root):
    # Lancer le chrono
    global depart, en_cours
    en_cours = 1
    depart = time.time()
    afficher_horloge(frame_chrono, niveau,
                     grid_affichage, taille, fleur2, root)


def afficher_horloge(frame_chrono, niveau, grid_affichage, taille, fleur2, root):
    # Afficher le chrono
    global depart, en_cours
    temps = time.time()-depart
    minutes = time.localtime(temps)[4]
    secondes = time.localtime(temps)[5]
    if en_cours:
        chrono = Label(frame_chrono, text="%i min %i sec " % (minutes, secondes), fg='black',
                       bg='white', relief='solid').place(relx=0.1, rely=0, relheight=1, relwidth=0.15)
        Label(frame_chrono, text="SCORE : " + str(compteur(str(niveau), score(grid_affichage, taille))), fg='black',
              bg='white', relief='solid', image=fleur2, compound=RIGHT).place(relx=0.70, rely=0, relheight=1, relwidth=0.25)
    root.after(1000, afficher_horloge, frame_chrono,
               niveau, grid_affichage, taille, fleur2, root)


############################################## AFFICHAGE FENETRES #############################################################
### affichage des différentes fenêtres de fin de jeu en fonction du resultat ###


def quitter(root, root2):  # si on appuie sur le bouton 'quitter' les deux fenêtres sont fermées
    root.destroy()
    root2.destroy()


# si on appuie sur le bouton 'nouvelle partie' les deux fenêtres sont fermées et le jeu est relancé
def nouvelle_partie(root, root2):
    root.destroy()
    root2.destroy()
    game_final()


def end_win(root):  # permet de faire apparaître la fenêtre de fin de jeu si le joueur a gagné, elle affiche un message et deux boutons
    root2 = Tk()
    root2.title("fin du jeu")
    # bouton pour rejouer
    bouton_nouvelle_partie = Button(root2, text="Nouvelle partie",
                                    font=("Helvetica", 15), command=partial(nouvelle_partie, root, root2), foreground="#2c6fbb", width=37, height=2)
    # bouton pour quitter le jeu
    bouton_quitter = Button(root2, text="Quitter",
                            font=("Helvetica", 15), command=partial(quitter, root, root2), foreground="#892222", width=37, height=2)
    text = Label(
        root2, text='Félicitations vous avez gagné, votre bouquet est magnifique', font=(15))
    bouton_nouvelle_partie.grid(column=0, row=1)
    bouton_quitter.grid(column=1, row=1)
    text.grid(row=0)


def end_lose(root):  # permet de faire apparaître la fenêtre de fin de jeu si le joueur a perdu, elle affiche un message et deux boutons
    root2 = Tk()
    root2.title("fin du jeu")
    # bouton pour rejouer
    bouton_nouvelle_partie = Button(root2, text="Nouvelle partie",
                                    font=("Helvetica", 15), command=partial(nouvelle_partie, root, root2), foreground="#2c6fbb", width=25, height=2)
    # bouton pour quitter le jeu
    bouton_quitter = Button(root2, text="Quitter",
                            font=("Helvetica", 15), command=partial(quitter, root, root2), foreground="#892222", width=25, height=2)
    text = Label(
        root2, text='Vous avez perdu, votre bouquet est fané', font=(15))
    bouton_nouvelle_partie.grid(column=0, row=1)
    bouton_quitter.grid(column=1, row=1)
    text.grid(row=0)


########################################### AFFICHAGE GRILLE ET BOUTONS #######################################################
### affichage de la grille de jeu et par dessus les boutons qui cachent ou non la grille de jeu ###


def on_enter(e):  # permet changer la couleur d'un bouton lorsque le joueur a sa souris dessus
    e.widget['background'] = '#4FC031'


def on_leave(e):  # permet de rendre sa couleur d'origine au bouton lorsque la souris du joueur quitte le bouton
    e.widget['background'] = "green"


# permet de faire apparaitre ou disparaitre un rateau sur un bouton si le joueur fait un clic droit
def AfficheRateau(ref, fleur2, Rateau2):
    b = Boutons[ref]
    if b.cget("text") == " ":
        b.config(image=fleur2, text="")
    else:
        b.config(image=Rateau2, text=" ")


# pemet de modifier la grille en fonction du bouton sur lequel le joueur appuie
def change_grille(ref, taille, grid_affichage, grid_game, root, niveau):
    x = ref % taille  # les coordonnées du bouton dans la grille du jeu
    y = ref//taille
    if grid_game[y, x] == 20:  # si le joueur cueille une fleur fanée
        # toutes fleurs fanées apparaissent
        a = trouve_fleurs_fanees(grid_affichage, grid_game)
        # le joueur ne peut plus cliquer sur les boutons
        bouton_disable(taille, grid_affichage)
        stopper_chrono()
        end_lose(root)  # on affiche la fenêtre de fin de jeu
    else:
        grid_affichage = modification_grille_affichage_binaire(
            x, y, grid_game, grid_affichage)
        # si le joueur à cueilli toutes les fleurs et donc fini le jeu
        if is_game_win(niveau, score(grid_affichage, taille)):
            # toutes fleurs fanées apparaissent
            a = trouve_fleurs_fanees(grid_affichage, grid_game)
            # le joueur ne peut plus cliquer sur les boutons
            bouton_disable(taille, grid_affichage)
            stopper_chrono()
            end_win(root)  # on affiche la fenêtre de fin de jeu
        else:  # sinon le jeu continue et on replace les boutons en enlevant ceux qui doivent disparaitre
            place_bouton(taille, grid_affichage)


# affiche la grille de jeu sur la fenêtre de jeu
def init_grille(taille, background, grid_game, fleurfanee2):
    global frame
    frame = []
    for i in range(taille):
        for j in range(taille):
            f = Frame(background, bg="#BEF574", height=750 //
                      taille, width=750//taille)
            frame.append(f)
            f.place(x=j*750//taille, y=i*750//taille)
            if grid_game[i][j] == 20:  # si c'est une fleur fanée
                lab = Label(f, image=fleurfanee2, bg="#BEF574")
                lab.place(x=375//taille, y=375//taille, anchor=CENTER)
            elif grid_game[i][j] != 0:  # si c'est un indice
                lab = Label(f, text=str(grid_game[i][j]), font=(
                    "Arial", 20, "bold"), bg="#BEF574")
                lab.place(x=375//taille, y=375/taille, anchor=CENTER)


# crée tous les boutons et les range dans une liste
def liste_bouton(taille, fleur2, grid_affichage, grid_game, Rateau2, root, niveau):
    global Boutons
    Boutons = []
    a = 0
    for i in range(taille):
        for j in range(taille):
            f = frame[i*taille+j]
            Boutons.append(Button(f, height=2*750//taille,
                           width=2*750//taille, bg="green", image=fleur2))
            Boutons[a].bind("<Button-1>", lambda i, ref=a: change_grille(ref,
                            taille, grid_affichage, grid_game, root, niveau))
            Boutons[a].bind("<Button-3>", lambda i,
                            ref=a: AfficheRateau(ref, fleur2, Rateau2),)
            Boutons[a].bind("<Enter>", on_enter)
            Boutons[a].bind("<Leave>", on_leave)
            a += 1


# affiche ou non les boutons sur la fenêtre de jeu qui vont donc cacher ou non la grille de jeu
def place_bouton(taille, grid_affichage):
    for i in range(taille):
        for j in range(taille):
            # tous les boutons sont enlevés pour être remis juste après au besoin
            Boutons[i*taille+j].place_forget()
            if grid_affichage[i, j] == 0:  # si le bouton doit être affiché
                Boutons[i*taille+j].place(x=375//taille,
                                          y=375//taille, anchor=CENTER)


# Place des boutons désactivés (pour la fin de la partie)
def bouton_disable(taille, grid_affichage):
    for i in range(taille):
        for j in range(taille):
            # tous les boutons sont enlevés pour être remis juste après au besoin
            Boutons[i*taille+j].place_forget()
            if grid_affichage[i, j] == 0:  # si le bouton doit être affiché
                # les fonctions des boutons sont désactivées
                Boutons[i*taille+j].unbind("<Button-3>")
                Boutons[i*taille+j].unbind("<Button-1>")
                Boutons[i*taille+j].place(x=375//taille,
                                          y=375//taille, anchor=CENTER)


################################################ MISE EN PLACE DU JEU ########################################################
### lancement du jeu avec interactions ###


def game_final():
    niveau = choix_du_niveau()  # on choisie le niveau
    # le jeu s'initialise
    # on initialise la grille de jeu au hasard
    grid_game = somme_grille(init_liste_grilles(niveau))
    # on recupère la taille de grille pour avoir à la recalculer à chaque foix que l'on en a besoin
    taille = len(grid_game)
    # on initialise la grille d'affichage où tout est caché
    grid_affichage = np.zeros((taille, taille), int)

    # l'affichage s'initialise
    root = Tk()
    root.title("Déterfleur")
    root.geometry("750x800")
    background = Frame(root, bg="#BEF574", height=800, width=750)
    fleur = PhotoImage(file='image/Fleur2.png')
    fleurfanee = PhotoImage(file='image/FleurFanée.png')
    fleurfanee2 = fleurfanee.subsample(taille, taille)
    fleur2 = fleur.subsample(taille, taille)
    fleur3=fleur.subsample(16,16)
    Rateau = PhotoImage(file="image/image_rateau.png")
    Rateau2 = Rateau.subsample(taille, taille)
    background.grid()
    frame_chrono = Frame(background, bg='firebrick')
    frame_chrono.place(relx=0, rely=1-1/16, relheight=1/16, relwidth=1)

    init_grille(taille, background, grid_game, fleurfanee2)
    liste_bouton(taille, fleur2, grid_affichage, grid_game, Rateau2, root, niveau)
    place_bouton(taille, grid_affichage)
    lancer_chrono(frame_chrono, niveau, grid_affichage, taille, fleur3, root)

    # le jeu est lancé et le joueur va pouvoir interagir avec lui
    root.mainloop()


game_final()
