



#exit�� quit�޷��˳� while �� forѭ��    
import sys
def fun():
    count = 1
    while(True):
        count = count + 1
        print(count)
        if count > 3:
            exit         #�������Ч
            #exit()    ��sys.exit(n) һ��
            quit         #�������Ч
            #quit()    ��sys.exit(n) һ��
        print('mid')
    print('end')

fun()

#break�˳� while �� forѭ��
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


#sys.exit(n)   ����ֱ���˳���������, �ɲ�׽�쳣 
#os._exit(n)   ����ֱ���˳���������, �����׳��쳣

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



#����׽ϵͳ�˳��쳣
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



#Noneֵ���ж�
A=None
B=None
A=B #True

1>B #True

0>B #True

-1>B #True



#���ã����������

#����
import copy

a=[1,2,['x','y']]

b=a

a[2][0] = 'XO'
a[1] = 3

print(str(id(a)) + ': ')
print(a)
print(str(id(b)) + ': ')
print(b)

�����
38444168: 
[1, 3, ['XO', 'y']]
38444168: 
[1, 3, ['XO', 'y']]



#ǳ����
import copy

a=[1,2,['x','y']]

b=a[:]
#b=copy.copy(a)     һ����Ч��

a[2][0] = 'XO'
a[1] = 3

print(str(id(a)) + ': ')
print(a)
print(str(id(b)) + ': ')
print(b)

���:
38509704: 
[1, 3, ['XO', 'y']]
38530248: 
[1, 2, ['XO', 'y']]



#���
import copy

a=[1,2,['x','y']]

#b=a[:]
b=copy.deepcopy(a)

a[2][0] = 'XO'

print(str(id(a)) + ': ')
print(a)
print(str(id(b)) + ': ')
print(b)

���:
38378632: 
[1, 2, ['XO', 'y']]
38399176: 
[1, 2, ['x', 'y']]



#zip
v_str = [1,2,3,0,42,5,6,56]

for i in zip(range(1,len(v_str)), v_str):
    print i

    

#LIST\TUPLE���    
 a = ('a') + ('b')
print a

a = ('a',) + ('b',)
print a

a = ['a'] + ['b']
print a

a = ['a',] + ['b',]
print a
    
�����

ab
('a', 'b')
['a', 'b']
['a', 'b']


    