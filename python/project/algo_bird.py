#!/usr/bin/env python
# -*- coding: utf-8 -*-

from random import random
from math import sin, cos, fmod



def letfly():

    #变量声明
    maxPerson = 20
    maxLoop = 20
    count = 1

    locationList = []
    speedList = []
    valueList = []

    maxPersonValueList = []
    maxGroupValue = 0
    maxGroupValueLocation = 0

    #随机种群个体，随机个体速度
    for i in range(0,maxPerson):
        locationList.append(random() * 9)
        speedList.append(random() * 6)
        valueList.append(0)
        maxPersonValueList.append(0)

    #开始循环搜索
    while(True):
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

        count = count + 1

        #到达循环次数，退出
        if count > maxLoop:
            # 输出种群最优值
            print(str(maxGroupValueLocation) + ': '+ str(maxGroupValue))
            return 0

letfly()