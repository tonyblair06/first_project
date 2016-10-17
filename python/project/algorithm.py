#!/usr/bin/env python
# -*- coding: utf-8 -*-

from numpy import genfromtxt, zeros
from pylab import figure, subplot, hist, xlim, show

# read the first 4 columns
data = genfromtxt(r'd:\tony\iris.csv',delimiter=',',usecols=(0,1,2,3))
target = genfromtxt(r'd:\tony\iris.csv',delimiter=',',usecols=(4), dtype=str)

t = zeros(len(target))
t[target == 'setosa'] = 1
t[target == 'versicolor'] = 2
t[target == 'virginica'] = 3


from sklearn.naive_bayes import GaussianNB
classifier = GaussianNB()


from sklearn import cross_validation

train, test, t_train, t_test = cross_validation.train_test_split(data, t, test_size=0.5, random_state=0)

classifier.fit(train,t_train) # train


from sklearn.metrics import confusion_matrix

print confusion_matrix(classifier.predict(test),t_test)