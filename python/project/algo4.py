#!/usr/bin/env python
# -*- coding: utf-8 -*-

from sklearn.decomposition import PCA
from numpy import corrcoef, genfromtxt


pca = PCA(n_components=3)
data = genfromtxt(r'd:\tony\iris.csv',delimiter=',',usecols=(0,1,2,3))
pcad = pca.fit_transform(data)


print(pcad)
print(1-sum(pca.explained_variance_ratio_))