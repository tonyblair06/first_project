#!/usr/bin/env python
# -*- coding: utf-8 -*-

import matplotlib.pyplot as plt

import cx_Oracle                                          #引用模块cx_Oracle
conn=cx_Oracle.connect('tony/123@ORCLTONY')    #连接数据库
curs=conn.cursor()                                           #获取cursor
exet=curs.execute('select sysdate from dual')                   #使用cursor进行各种操作
exet.fetchone()
curs.close()                                                 #关闭cursor
conn.close()                                              #关闭连接

plt.scatter([1,20,5],[1,7,16])
plt.show()