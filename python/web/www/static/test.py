#!/usr/bin/env python
# -*- coding: utf-8 -*-

from transwarp import db

db.connection()


import functools

def a(text):
    def b(func):
        @functools.wraps(func)
        def c(*args, **kw):
            print('begin call')
            print(text)
            func(*args, **kw)
            print('end call')
            return 0
        return c
    return b


@a('for abc')
def fun():
    print('running...')

fun()