# coding=utf-8

from django.shortcuts import render
from blog.models import BlogsPost
from django.shortcuts import render_to_response


# Create your views here.
def index(request):
    blog_list = BlogsPost.objects.all()
    blog_list.

    import cx_Oracle  # 引用模块cx_Oracle

    conn = cx_Oracle.connect('tony/123@localhost/ORCLTONY')  # 连接数据库
    c = conn.cursor()  # 获取cursor

    blog_list.
    x = c.execute('insert into t_test values (:1)', [str(type(blog_list))])

    conn.commit()
    # y=x.fetchall()
    c.close()  # 关闭cursor
    conn.close()  # 关闭连接
    # print(y)


    return render_to_response('index.html', {'blog_list': blog_list})