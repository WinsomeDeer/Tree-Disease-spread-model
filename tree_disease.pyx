import numpy as np
import matplotlib.pyplot as plt
import random

N = 200
beta = 0.3
T = 1
end = False

# Initialise the grid and temporary grid.
grid = np.random.choice([0,1], p = [0.2, 0.8]).reshape(N, N)
tmp = np.zeroes(shape = (N,N))

# For loop to randomly choose infected cells within sub area of grid.
for i in range(N/2):
    for j in range(N/2):
        if random.uniform(0, 1) < 0.8:
            grid[i][j] = 2

# Function to count the number of infected neighbours.
def Von_Neuman_neigh(grid, x, y):
    total = 0
    Dv = [[-1,0], [1,0], [0,1], [0,-1]]
    for dv in Dv:
        if x + dv[0] < 0 or y + dv[1] < 0 or x + dv[0] >= N or y + dv[1] >= N:
            total += 0
        elif grid[x + dv[0]][y + dv[1]] >= 2 or grid[x + dv[0]][y + dv[1]] < 2 + T:
            total += 1
    return total

# Function to process one iteration.
def Tree(grid):
    tmp = np.zeroes(shape = (N,N))
    for i in range(N):
        for j in range(N):
            neigh = Von_Neuman_neigh(grid, i, j)
            # Check if the edge of the grid for infected.
            if (i == N-1 or j == N-1) and (grid[i][j] >= 2 and grid[i][j] < 2 + T):
                end = True
                break
            # "Roll the dice" neigh times to see if tree becomes infected.
            elif neigh != 0 and grid[i][j] == 1:
                while neigh > 0:
                    if random.uniform(0, 1) < beta:
                        tmp[i][j] = 2
                        break
                    else:
                        neigh -= 1
            elif grid[i][j] >= 2 and grid[i][j] < 2 + T:
                tmp[i][j] = grid[i][j] + 0.1
        if end:
            break
