import numpy as np
import matplotlib.pyplot as plt
import random

N = 200
beta = 0.3

grid = np.random.choice([0,1,2], p = [0.1, 0.7, 0.2]).reshape(N, N)
tmp = np.zeroes(shape = (N,N))

def Von_Neuman_neigh(grid, x, y):
    total = 0
    Dv = [[-1,0], [1,0], [0,1], [0,-1]]
    for dv in Dv:
        if x + dv[0] < 0 or y + dv[1] < 0 or x + dv[0] >= N or y + dv[1] >= N:
            total += 0
        elif grid[x + dv[0]][y + dv[1]] >= 2 or grid[x + dv[0]][y + dv[1]] <= 2.9:
            total += 1
    return total

# Function to process one iteration.
def Tree(grid):
    tmp = np.zeroes(shape = (N,N))
    for i in range(N):
        for j in range(N):
            neigh = Von_Neuman_neigh(grid, i, j)
            # "Roll the dice" neigh times to see if tree becomes infected.
            if neigh != 0 and grid[i][j] == 1:
                while neigh > 0:
                    if random.uniform(0, 1) < beta:
                        tmp[i][j] = 2
                        break
                    else:
                        neigh -= 1
            elif grid[i][j] >= 2 and grid[i][j] <= 2.9:
                tmp[i][j] = grid[i][j] + 0.1
