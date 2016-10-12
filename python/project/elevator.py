#!/usr/bin/env python
# -*- coding: utf-8 -*-

from Tkinter import *  #引入模块


root = Tk()
root.title("hello world")
root.geometry('600x400')


frm = Frame(root)
#left
frm_L = Frame(frm)
Button(frm_L, text='Restart').pack()
frm_L.pack(fill=Y,side=LEFT)



#left
frm_R = Frame(frm)
Scale(frm_R,from_=10,to=1,orient=VERTICAL).pack(fill=Y,expand=1)
frm_R.pack(fill=Y,side=RIGHT)

frm.pack(fill=Y)

root.mainloop()

