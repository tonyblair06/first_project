



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



