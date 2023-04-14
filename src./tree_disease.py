import numpy as np
import matplotlib.pyplot as plt
import random 
import matplotlib.animation as animation
import time

N = 200
beta = 0.2
T = 12
gamma = 0.8
infected_grid = np.zeros(shape = (N,N))

# Initialise random grid.
def random_grid(gamma):
    grid = np.random.choice([0, 1, 2], N*N, p = [1 - gamma, gamma, 0]).reshape(N, N)
    # Initalise infected grid
    grid[25][25] = 2
    infected_grid[25][25] = 2
    return grid

# Function to process one iteration.
def Tree(frame_num, img, grid, infected_grid):
    tmp = np.zeros(shape = (N,N))
    # Von Neuman n'hood.
    Dv = [[0,1], [0,-1], [-1,0], [1,0]]
    # For loop to update grid.
    for i in range(N):
        for j in range(N):
            # Check if the cell is infected.
            if grid[i][j] == 2:
                for dv in Dv:
                    dx, dy = i + dv[0], j + dv[1]
                    if (dx >= 0 and dy >= 0 and dx < N and dy < N) and (grid[dx][dy] == 1) and (np.random.uniform(0,1) < beta):
                        tmp[dx][dy] = 2
                        infected_grid[dx][dy] = 1
                tmp[i][j] = grid[i][j]
            else:
                if tmp[i][j] != 2:
                    tmp[i][j] = grid[i][j]
    # For loops to update infected grid.
    for i in range(N):
        for j in range(N):
            if infected_grid[i][j] == T:
                tmp[i][j] = 0
            elif infected_grid[i][j] >= 1 and infected_grid[i][j] < T:
                infected_grid[i][j] += 1
    time.sleep(0.1)
    img.set_data(tmp)
    grid[:] = tmp[:]
    return img

def main():
    # Initialise the grid and infected grid.
    grid = random_grid(gamma)
    infected = np.zeros(shape = (N, N))
    grid.astype('float64')
    fig, ax = plt.subplots()
    ax.set_yticklabels([])
    ax.set_xticklabels([])
    img = ax.imshow(grid, interpolation = 'nearest')
    ani = animation.FuncAnimation(fig, Tree, fargs = (img, grid, infected ), frames = 10, interval = 50, save_count = 50)
    plt.show()

if __name__ == '__main__':
    main()
