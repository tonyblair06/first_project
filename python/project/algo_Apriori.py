#!/usr/bin/env python
# -*- coding: utf-8 -*-

import copy

#变量声明
samplesList = [
    ['A','B','E'],
    ['B','D'],
    ['B','C'],
    ['A','B','D'],
    ['A','C'],
    ['B','C'],
    ['A','C'],
    ['A','B','C','E'],
    ['A','B','C']
]     #样本

frequentList = [['A','B','C','D','E']]  #每层的频繁集
minSupportCount = 2 #最小支持度
minconfidenceCoe = 0.6  #最小置信度
supportCountDict = {}  #用于保存各层的支持度
confidenceCoeDict = {}  #用于保存置信度

out_count=0
#循环查找频繁集
while(True):
    #计算每层候选集的支持度
    temp_frequentList = copy.deepcopy(frequentList[out_count])
    for singleSet in temp_frequentList:
        count=0
        for sample in samplesList:
            if set(list(sample)).issuperset(set(list(singleSet))):
                count = count + 1

        #依据最小支持度选出频繁集
        if count < minSupportCount:
            frequentList[out_count].remove(singleSet)
        else:
            supportCountDict[singleSet] = count

    #刷新下一次的候选集
    temp_frequentList = frequentList[out_count]
    lenlist=len(temp_frequentList)
    if lenlist == 0:
        break

    tempSingleSet = set([])
    for i in range(0, lenlist):
        for k in range(i+1, lenlist):
            first = set(temp_frequentList[i])
            second = set(temp_frequentList[k])
            if len(first & second) == out_count:
                temp = list(first | second)
                temp.sort()
                temp = ''.join(temp)
                tempSingleSet.add(temp)
    frequentList.append(list(tempSingleSet))

    out_count = out_count + 1

#循环计算置信度
lenlist = len(frequentList)
for best_set in frequentList[lenlist-2]:
    best_set_support_count = supportCountDict[best_set]
    for i_list in frequentList[:lenlist-2]:
        for sample in i_list:
            if set(list(best_set)).issuperset(set(list(sample))):
                confidenceCoeDict[sample + ' of ' + best_set] = best_set_support_count * 1.0 / supportCountDict[sample]

#输出强规则
print(confidenceCoeDict)