import numpy as np
import matplotlib.pyplot as plt
import random 
import matplotlib.animation as animation
import time
N = 100
beta = 0.1
T = 1

def Infect(M):
    for i in range(N):
        for j in range(N):
            if np.random.uniform(0,1) < 0.99:
                M[i][j] = 2

# Function to count the number of infected neighbours.
def Von_Neuman_neigh(M, x, y):
    total = 0
    Dv = [[-1,0], [1,0], [0,1], [0,-1]]
    for dv in Dv:
        dx = x + dv[0]
        dy = y + dv[1]
        if (dx >= 0 and dy >= 0 and dx < N and dy < N) and (M[dx][dy] >= 2 and M[dx][dy] < 2 + T):
            total += 1
    return total

# Function to process one iteration.
def Tree(frame_num, img, grid):
    tmp = np.zeros(shape = (N,N))
    start = time.time()
    for i in range(N):
        for j in range(N):
            neigh = Von_Neuman_neigh(grid, i, j)
            # "Roll the dice" neigh times to see if tree becomes infected.
            if neigh != 0 and grid[i][j] == 1:
                while neigh > 0 and tmp[i][j] < 2:
                    if random.uniform(0, 1) < beta:
                        tmp[i][j] = 2
                    neigh -= 1
            elif grid[i][j] >= 2 and grid[i][j] < 2 + T:
                tmp[i][j] = grid[i][j] + 0.1
    end = time.time()
    print(end - start)
    img.set_data(tmp)
    grid = tmp
    return img

def main():
    # Initialise the grid.
    grid = np.random.choice([0,1], N*N, p = [0, 1]).reshape(N, N)
    grid.astype('float64')
    Infect(grid)
    fig, ax = plt.subplots()
    ax.set_yticklabels([])
    ax.set_xticklabels([])
    img = ax.imshow(grid, interpolation = 'nearest')
    ani = animation.FuncAnimation(fig, Tree, fargs = (img, grid ), frames = 10, interval = 50, save_count = 50)
    plt.show()

if __name__ == '__main__':
    main()
