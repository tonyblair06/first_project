#!/usr/bin/env python
# -*- coding: utf-8 -*-

import threading, logging


class _LasyConnection(object):
    """
    惰性连接对象
    仅当需要cursor对象时，才连接数据库，获取连接
    """
    def __init__(self):
        self.connection = None
    def cursor(self):
        if self.connection is None:
            _connection = engine.connect()
            logging.info('[CONNECTION] [OPEN] connection <%s>...' % hex(id(self.connection)))
            self.connection = _connection
        return self.connection.cursor()
    def commit(self):
        self.connection.commit()
    def rollback(self):
        self.connection.rollback()
    def cleanup(self):
        if self.connection:
            _connection = self.connection
            self.connection = None
            logging.info('[CONNECTION] [CLOSE] connection <%s>...' % hex(id(self.connection)))
            _connection.close()


class _Engine(object):
    def __int__(self, connect):
        self._connect = connect
    def connect(self):
        return self._connect()

engine = None

class _Dbcontext(threading.local):
    def __init__(self):
        self.connection = None
        self.transcations = 0

    def is_init(self):
        return self.connection is not None

    def init(self):
        self.connection = _LasyConnection()
        self.transcations = 0

    def cleanup(self):
        self.connection.clearup()
        self.transcations = None

    def cursor(self):
        return self.connection.cursor()

_Db_context = _Dbcontext()



