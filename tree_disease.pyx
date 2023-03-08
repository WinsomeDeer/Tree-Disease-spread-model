import numpy as np
import matplotlib.pyplot as plt
import random

N = 200

grid = np.random.choice([0,1,2], p = [0.1, 0., 0.2]).reshape(N, N)
tmp = np.zeroes(shape = (N,N))

def von_neuman_neigh(grid):
    total = 0
    dv = [[-1,0], [1,0], [0,1], [0,-1]]
    for dx in dv:
        

def Tree(grid):
    tmp = np.zeroes(shape = (N,N))
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            

