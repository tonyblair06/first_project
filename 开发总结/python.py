



#exit， quit无法退出 while 、 for循环    
import sys
def fun():
    count = 1
    while(True):
        count = count + 1
        print(count)
        if count > 3:
            exit         #此语句无效
            #exit()    与sys.exit(n) 一致
            quit         #此语句无效
            #quit()    与sys.exit(n) 一致
        print('mid')
    print('end')

fun()

#break退出 while 、 for循环
import sys
def fun():
    count = 1
    while(True):
        count = count + 1
        print(count)
        if count > 3:
            break
        print('mid')
    print('end')

fun()


#sys.exit(n)   正常直接退出整个程序, 可捕捉异常 
#os._exit(n)   正常直接退出整个程序, 不会抛出异常

import sys,os,traceback
def fun():
    try:
        count = 1
        while(True):
            count = count + 1
            print(count)
            if count > 3:
                os._exit(0)
                #sys.exit(0)
            print('mid')
        print('end')
    except:
        print('except')
fun()



#不捕捉系统退出异常
import sys,os,traceback
def fun():
    try:
        count = 1
        while(True):
            count = count + 1
            print(count)
            if count > 3:
                #os._exit(6)
                sys.exit(1)
            print('mid')
        print('end')
    except SystemExit:
        pass
    except:
        print('except')
        traceback.print_exc()
fun()



#None值的判断
A=None
B=None
A=B #True

1>B #True

0>B #True

-1>B #True



#引用，拷贝，深拷贝

#引用
import copy

a=[1,2,['x','y']]

b=a

a[2][0] = 'XO'
a[1] = 3

print(str(id(a)) + ': ')
print(a)
print(str(id(b)) + ': ')
print(b)

输出：
38444168: 
[1, 3, ['XO', 'y']]
38444168: 
[1, 3, ['XO', 'y']]



#浅拷贝
import copy

a=[1,2,['x','y']]

b=a[:]
#b=copy.copy(a)     一样的效果

a[2][0] = 'XO'
a[1] = 3

print(str(id(a)) + ': ')
print(a)
print(str(id(b)) + ': ')
print(b)

输出:
38509704: 
[1, 3, ['XO', 'y']]
38530248: 
[1, 2, ['XO', 'y']]



#深拷贝
import copy

a=[1,2,['x','y']]

#b=a[:]
b=copy.deepcopy(a)

a[2][0] = 'XO'

print(str(id(a)) + ': ')
print(a)
print(str(id(b)) + ': ')
print(b)

输出:
38378632: 
[1, 2, ['XO', 'y']]
38399176: 
[1, 2, ['x', 'y']]



#zip
v_str = [1,2,3,0,42,5,6,56]

for i in zip(range(1,len(v_str)), v_str):
    print i

    

#LIST\TUPLE相加    
 a = ('a') + ('b')
print a

a = ('a',) + ('b',)
print a

a = ['a'] + ['b']
print a

a = ['a',] + ['b',]
print a
    
输出：

ab
('a', 'b')
['a', 'b']
['a', 'b']


 
#调用oracle

import cx_Oracle                                          #引用模块cx_Oracle

conn=cx_Oracle.connect('tony/123@localhost/ORCLTONY')    #连接数据库
c=conn.cursor()                                           #获取cursor

blog_list.
x=c.execute('insert into t_test values (:1)',[str(type(blog_list))]) 

conn.commit()
#y=x.fetchall()
c.close()                                                 #关闭cursor
conn.close()                                              #关闭连接
#print(y)

    
    
 
 #django 步骤
 
#1.创建项目
 python C:\Python27\Scripts\django-admin.py startproject myWebSite
 
#2.创建应用    
 python manage.py startapp blog
 
#3初始化admin后台数据库   settings.py
 DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.oracle',
        'NAME': 'ORCLTONY',
        'USER': 'tony',
        'PASSWORD': '123',
        'HOST': '127.0.0.1',
        'PORT': '1521',
    }
}
 
#4设置admin应用    settings.py
 INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'blog',
]


#5启动django容器
python manage.py runserver

#6设计model     models.py
from django.db import models
from django.contrib import admin

# Create your models here.
class BlogsPost(models.Model):
    title = models.CharField(max_length = 150)
    body = models.TextField()
    timestamp = models.DateTimeField()

admin.site.register(BlogsPost)

 
 #7再次初始化数据库
 python manage.py makemigrations blog
 python manage.py migrate --run-syncdb
  
#8创建超级用户
python manage.py createsuperuser --username=admin --email=joe@example.com  



