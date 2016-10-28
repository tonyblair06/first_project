



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


    