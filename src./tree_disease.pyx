import numpy as np
cimport numpy as np
cimport cython
import matplotlib.pyplot as plt
import random 
import matplotlib.animation as animation
import time
from libc.stdlib cimport rand, srand, RAND_MAX
from libc.math cimport sqrt, pow
from libc.time cimport time

cdef int N = 200
cdef double beta = 0.2
cdef int T = 12
cdef double gamma = 0.8
cdef np.ndarray infected_grid = np.zeros(shape = (N,N), dtype = np.intc)
Dv = [[0,1], [0,-1], [-1,0], [1,0]]

srand(time(NULL))

cdef double random_num():
    return rand()/(RAND_MAX + 1)

# Initialise random grid.
@cython.boundscheck(False)
@cython.wraparound(False)
def random_grid(double gamma):
    cdef int i, j
    cdef np.ndarray grid = np.zeros(shape = (N, N), dtype = np.intc)
    for i in range(N):
        for j in range(N):
            if random_num() < gamma:
                grid[i, j] = 1
    # Initalise infected grid
    grid[100, 100] = 2
    infected_grid[100, 100] = 2
    cdef int[:, ::1] grid_view = grid
    return grid_view

# Function to process one iteration.
@cython.boundscheck(False)
@cython.wraparound(False)
def Tree(int frame_num, img, int[:, ::1] grid, int[:, ::1] infected_grid):
    cdef np.ndarray tmp = np.zeros(shape = (N,N), dtype = np.intc)
    cdef int[:, ::1] tmp_view = tmp
    cdef int i, j, dx, dy
    # Von Neuman n'hood.
    # For loop to update grid.
    for i in range(N):
        for j in range(N):
            # Check if the cell is infected.
            if grid[i, j] == 2:
                for dv in Dv:
                    dx, dy = i + dv[0], j + dv[1]
                    if (dx >= 0 and dy >= 0 and dx < N and dy < N) and (grid[dx, dy] == 1) and (random_num() < beta):
                        tmp_view[dx, dy] = 2
                        infected_grid[dx, dy] = 1
                tmp_view[i, j] = grid[i, j]
            else:
                if tmp_view[i, j] != 2:
                    tmp_view[i, j] = grid[i, j]
    # For loops to update infected grid.
    for i in range(N):
        for j in range(N):
            if infected_grid[i, j] == T:
                tmp_view[i, j] = 0
            elif infected_grid[i, j] >= 1 and infected_grid[i, j] < T:
                infected_grid[i, j] += 1
    img.set_data(tmp_view)
    grid[:] = tmp_view[:]
    return img

def main():
    # Initialise the grid and infected grid.
    cdef int[:,::1] grid = random_grid(gamma)
    infected = np.zeros(shape = (N, N), dtype = np.intc)
    fig, ax = plt.subplots()
    ax.set_yticklabels([])
    ax.set_xticklabels([])
    img = ax.imshow(grid, interpolation = 'nearest')
    ani = animation.FuncAnimation(fig, Tree, fargs = (img, grid, infected ), frames = 10, interval = 50, save_count = 50)
    plt.show()

if __name__ == '__main__':
    main()
