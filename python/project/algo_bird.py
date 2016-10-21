#!/usr/bin/env python
# -*- coding: utf-8 -*-

from random import random
from math import sin, cos, fmod
import matplotlib.pyplot as pyplot

def letfly():

    #变量声明
    maxPerson = 20
    maxLoop = 10
    count = 1

    locationList = []
    last_locationList = []
    speedList = []
    valueList = []

    hisLocationList = []
    hisValueList = []

    maxPersonValueList = []
    maxGroupValue = 0
    maxGroupValueLocation = 0

    #随机种群个体，随机个体速度
    for i in range(0,maxPerson):
        locationList.append(random() * 9)
        speedList.append(random() * 6)

    valueList = [None]*maxPerson
    maxPersonValueList = [None]*maxPerson

    #开始循环搜索
    while(True):
        hisLocationList = []
        hisLocationList.extend(locationList)
        last_locationList = locationList

        for i in range(0,maxPerson):
            #搜索, 计算适应度
            temp = locationList[i]
            newValue = temp + 10 * sin(5 * temp) + 7 * cos(4 * temp)
            valueList[i] = newValue

            #更新个体最优值，种群最优值
            if newValue > maxPersonValueList[i]:
                maxPersonValueList[i] = newValue

            if newValue > maxGroupValue:
                maxGroupValue = newValue
                maxGroupValueLocation = temp

            #更新个体速度
            speedList[i] = speedList[i] + 2 * random() * (maxPersonValueList[i] - newValue) + 2 * random() * (maxGroupValue - newValue)
            #更新个体位置
            temp = locationList[i] + 1 * speedList[i]
            temp = fmod(temp, 9)
            locationList[i] = temp

        hisValueList = []
        hisValueList.extend(valueList)

        count = count + 1

        #到达循环次数，退出
        if count > maxLoop:
            # 输出种群最优值
            print(str(maxGroupValueLocation) + ': '+ str(maxGroupValue))


            x = [i / 100000.0 for i in range(0, 900000, 1)]
            y = [i + 10 * sin(5 * i) + 7 * cos(4 * i) for i in x]

            # print(x)
            # print(y)

            pyplot.plot(x, y, 'r')
            pyplot.xlim(-2, 11)
            pyplot.ylim(-20, 30)

            print(count)
            print(len(hisLocationList))
            pyplot.scatter(hisLocationList, hisValueList, c='g')
            #pyplot.scatter(last_locationList, valueList, c='g')

            pyplot.show()
            return 0

letfly()