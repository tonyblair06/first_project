



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



