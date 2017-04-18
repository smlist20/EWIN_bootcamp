# -*- coding: utf-8 -*-
"""
Created on Sun Apr 10 23:37:53 2016

@author: PWOLFF
"""

from sklearn.datasets import make_blobs
X, y = make_blobs(n_samples=150, 
                  n_features=2, 
                  centers=3, 
                  cluster_std=0.5, 
                  shuffle=True, 
                  random_state=0)


import matplotlib.pyplot as plt
#%matplotlib inline
plt.scatter(X[:,0], X[:,1],  c='white', marker='o', s=50)
plt.grid()
plt.tight_layout()
#plt.savefig('./figures/spheres.png', dpi=300)
plt.show()

