#!/usr/bin/env python
# -*- coding: utf-8 -*-

from Tkinter import *
import matplotlib.pyplot as plt
import cx_Oracle


class Application(Frame):
    v_count = 1

    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.pack()
        self.createWidgets()

    def show_pic(self):
        conn = cx_Oracle.connect('tony/123@ORCLTONY')
        curs = conn.cursor()

        exet = curs.execute('SELECT T.ID, T.COL_X, T.COL_Y, T.FLAG FROM T_K_MEANS_LOG T WHERE T.COMMENTS = \''+str(self.v_count)+'\'')
        result = exet.fetchall()

        curs.close()


        print(result)
        v_count = len(result)
        if v_count > 0:
            plt.cla()
        for i in range(0, v_count):
            if result[i][3] >= '1':
                v_marker = 'o'
                v_color = 'red'
                if result[i][3] == '1':
                    v_size = 200
                    v_marker = 'h'

                else:
                    v_size = 80
            else:
                v_marker = 'o'
                v_color = 'yellow'
                if result[i][3] == '0':
                    v_size = 200
                    v_marker = '*'
                else:
                    v_size = 80
            plt.scatter(result[i][1], result[i][2], s=v_size, marker=v_marker, c=v_color)
        self.v_count=self.v_count+1
        print(str(self.v_count))
        plt.show()
    def reset(self):
        self.v_count=1

    def createWidgets(self):
        self.restartButton = Button(self, text='Restart', command=self.reset)
        self.restartButton.pack()
        self.refreshButton = Button(self, text='Refresh', command=self.show_pic)
        self.refreshButton.pack()

app = Application()
app.mainloop()

