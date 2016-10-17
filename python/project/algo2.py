#!/usr/bin/env python
# -*- coding: utf-8 -*-


from sklearn.cluster import KMeans
from numpy import genfromtxt, zeros
from pylab import figure, plot, hist, xlim, show, subplot

data = genfromtxt(r'd:\tony\iris.csv',delimiter=',',usecols=(0,1,2,3))
target = genfromtxt(r'd:\tony\iris.csv',delimiter=',',usecols=(4), dtype=str)

t = zeros(len(target))
t[target == 'setosa'] = 1
t[target == 'versicolor'] = 2
t[target == 'virginica'] = 3


kmeans = KMeans(n_clusters=3, init='random') # initialization
kmeans.fit(data) # actual execution
c = kmeans.predict(data)

figure()
subplot(211) # top figure with the real classes
plot(data[t==1,0],data[t==1,2],'bo')
plot(data[t==2,0],data[t==2,2],'ro')
plot(data[t==3,0],data[t==3,2],'go')
subplot(212) # bottom figure with classes assigned automatically
plot(data[c==1,0],data[c==1,2],'bo',alpha=.7)
plot(data[c==2,0],data[c==2,2],'go',alpha=.7)
plot(data[c==0,0],data[c==0,2],'mo',alpha=.7)
show()

