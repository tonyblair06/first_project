#!/usr/bin/env python
# -*- coding: utf-8 -*-


from xlrd import open_workbook
from xlutils.copy import copy

rb = open_workbook(r'd:\test.xlsx')

wb = copy(rb)

wb.save(r'd:\test.xls')