import tkinter as tk


def init_2048_graphical_grid():
    root = tk.Tk()
    root.title('2048')
    newfenetre = tk.Toplevel(root, position='right')
    newfenetre.grid()
    root.mainloop()
