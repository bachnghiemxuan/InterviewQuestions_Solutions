from typing import no_type_check


import numpy as np 
def P_river_cal(A):
    B = np.array(A)
    P = 0
    for i in range(B.shape[0]):
        for j in range(B.shape[1]):
            if B[i,j] == 1:
                P += 4
                if i >0 and B[i-1, j] == 1:
                    P -= 2
                if j>0 and B[i, j-1] == 1:
                    P -= 2
    return P


C = np.array([[1,0,1], [1,1,1], [1,1,1]])
print(P_river_cal(C))
