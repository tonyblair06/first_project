#!/usr/bin/env python
# -*- coding: utf-8 -*-

l = ['a', 'b', 'c', [1, 2, 3]]
import copy
a = copy.copy(l)
b = copy.deepcopy(l)
a.append('e')
b.append('f')
print(a, b, l)
a[3][2] = 'x'
b[3][2] = 'y'
print(a, b, l)