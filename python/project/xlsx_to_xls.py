#!/usr/bin/env python
# -*- coding: utf-8 -*-


import win32com.client as win32
import os

xlApp = win32.Dispatch('Excel.Application')

dir = r'D:\temp'

for filename in os.listdir(dir.decode('utf-8')):
    if filename.split('.')[-1] == 'xlsx':
        try:
            xlBook = xlApp.Workbooks.Open(dir + '\\' + filename)
            xlBook.SaveAs(dir + '\\' + filename[:-1], FileFormat = 56)
            xlBook.Close(SaveChanges=0)
        except SystemExit:
            pass
        except:
            print('Error')

xlApp.Application.Quit()
