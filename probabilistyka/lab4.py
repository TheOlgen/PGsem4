import random

def x_generator():
    u = random.random()
    if u < 0.17:
        return 1
    elif u < 0.27:
        return 2
    elif u < 0.77:
        return 3
    else:
        return 4

def y_generator(x):
    u = random.random()
    if x == 1:
        return 3
    elif x == 2:
        return 1
    elif x == 3:
        if u < 0.4:
            return 3
        else:
            return 4
    else:
        if u <0.8696:
            return 1
        else:
            return 2


N = 100000

matrix = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
for i in range(N):
    x = x_generator()
    y = y_generator(x)
    matrix[x-1][y-1] += 1

# Wizualizacja
for i in range(4):
    print("\t \t", i+1,  end='')

print()
for i in range(4):
    print(i+1, "\t \t", end='')
    for j in range(4):
        print(matrix[i][j], "\t \t", end='')
    print()