#!/usr/bin/env python
# -*- coding: utf-8 -*-


from numpy import corrcoef, genfromtxt
from pylab import pcolor, colorbar, xticks, yticks, show
import numpy


data = genfromtxt(r'd:\tony\iris.csv',delimiter=',',usecols=(0,1,2,3))
corr = corrcoef(data.T) # .T gives the transpose

print(data.T)
print('--------------')
print(corr)

pcolor(corr)
colorbar() # add

# arranging the names of the variables on the axis
xticks(numpy.arange(0.5,4.5),['sepal length',  'sepal width', 'petal length', 'petal width'],rotation=0)
yticks(numpy.arange(0.5,4.5),['sepal length',  'sepal width', 'petal length', 'petal width'],rotation=0)
show()