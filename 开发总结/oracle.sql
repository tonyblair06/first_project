锁表查询：


SELECT SESS.SID,
       SESS.SERIAL#,
       LO.ORACLE_USERNAME,
       LO.OS_USER_NAME,
       AO.OBJECT_NAME,
       LO.LOCKED_MODE
  FROM V$LOCKED_OBJECT LO, DBA_OBJECTS AO, V$SESSION SESS
 WHERE AO.OBJECT_ID = LO.OBJECT_ID
   AND LO.SESSION_ID = SESS.SID;



----乐观锁

乐观锁（ Optimistic Locking ） 相对悲观锁而言，乐观锁假设认为数据一般情况下不会造成冲突，所以在数据进行提交更新的时候，才会正式对数据的冲突与否进行检测，如果发现冲突了，则让返回用户错误的信息，让用户决定如何去做。那么我们如何实现乐观锁呢，一般来说有以下2种方式：
1.使用数据版本（Version）记录机制实现，这是乐观锁最常用的一种实现方式。何谓数据版本？即为数据增加一个版本标识，一般是通过为数据库表增加一个数字类型的 “version” 字段来实现。当读取数据时，将version字段的值一同读出，数据每更新一次，对此version值加一。当我们提交更新的时候，判断数据库表对应记录的当前版本信息与第一次取出来的version值进行比对，如果数据库表当前版本号与第一次取出来的version值相等，则予以更新，否则认为是过期数据。用下面的一张图来说明：


如上图所示，如果更新操作顺序执行，则数据的版本（version）依次递增，不会产生冲突。但是如果发生有不同的业务操作对同一版本的数据进行修改，那么，先提交的操作（图中B）会把数据version更新为2，当A在B之后提交更新时发现数据的version已经被修改了，那么A的更新操作会失败。
2.乐观锁定的第二种实现方式和第一种差不多，同样是在需要乐观锁控制的table中增加一个字段，名称无所谓，字段类型使用时间戳（timestamp）, 和上面的version类似，也是在更新提交的时候检查当前数据库中数据的时间戳和自己更新前取到的时间戳进行对比，如果一致则OK，否则就是版本冲突。




--随机去10条记录

SELECT * FROM 
(SELECT DBMS_RANDOM.value(),T.* FROM MOBILEAPP2.APP_USER T ORDER BY DBMS_RANDOM.RANDOM()
)
 WHERE ROWNUM <= 10



 
--UTL_HTTP
DECLARE
  REQ     UTL_HTTP.REQ;
  RESP    UTL_HTTP.RESP;
  V_TEXT  VARCHAR2(4000);
  VAL     VARCHAR2(32767);
  V_COUNT NUMBER := 0;
BEGIN
  --here you can insert other code even procedure or funciton
  --my codeing is etl monitor
  V_TEXT := '9'; --this is the etl monitor procedure
  IF V_TEXT IS NOT NULL THEN
    REQ  := UTL_HTTP.BEGIN_REQUEST('http://www.163.com');
    RESP := UTL_HTTP.GET_RESPONSE(REQ);
  
    LOOP
      UTL_HTTP.READ_LINE(RESP, VAL, TRUE);
      EXIT WHEN VAL IS NULL OR V_COUNT >= 100;
      DBMS_OUTPUT.PUT_LINE(VAL);
      V_COUNT := V_COUNT + 1;
    END LOOP;
  
    UTL_HTTP.END_RESPONSE(RESP);
  END IF;

EXCEPTION
  WHEN UTL_HTTP.END_OF_BODY THEN
    UTL_HTTP.END_RESPONSE(RESP);
END;




--透明网关连接mysql sqlserver
1、配置ODBC
    
      mysql要先装MYSQL ODBC驱动
      
      linux: vi /etc/odbc.ini
            
            Description = MySQL test database
            Trace = On
            TraceFile = stderr
            Driver = ODBCSQLSERVERDW          //数据源名称
            SERVER = localhost
            USER = root
            PASSWORD = mysql
            PORT = 3306
            DATABASE = test
            socket = /tmp/mysql.sock

2、增加网关的initsqlserverdw.ora
    
      HS_FDS_CONNECT_INFO = ODBCSQLSERVERDW //此值必须等于ODBC中配置的数据源名称
      HS_FDS_TRACE_LEVEL = OFF


3、监听添加增加的实例

    SID_LIST_LISTENER =
      (SID_LIST =
        (SID_DESC =
          (SID_NAME = CLRExtProc)
          (ORACLE_HOME = D:\app\JingZhong\product\11.2.0\dbhome_1)
          (PROGRAM = extproc)
          (ENVS = "EXTPROC_DLLS=ONLY:D:\app\JingZhong\product\11.2.0\dbhome_1\bin\oraclr11.dll")
        )
        (SID_DESC =
          (SID_NAME = xedk)
          (ORACLE_HOME = D:\app\JingZhong\product\11.2.0\dbhome_1)
          (PROGRAM = dg4odbc)
        )
        (SID_DESC =
          (SID_NAME = sqlserverdw)       //此值必须等于initsqlserverdw.ora中的sqlserverdw
          (ORACLE_HOME = D:\app\JingZhong\product\11.2.0\dbhome_1)
          (PROGRAM = dg4odbc)
        )
      )

4、添加实例的TNS

        TOSQLSERVER =
          (DESCRIPTION =
            (ADDRESS = (PROTOCOL = TCP)(HOST = QF-JINGZHONG-01.quark.com)(PORT = 1521))
            (CONNECT_DATA =
              (SERVICE_NAME = sqlserverdw)  //此值必须等于上面的SID_NAME
            )
            (HS = OK)
          ) 

5、增加DBLINK

        create database link XEDK_MYSQL
          connect to "xedk" identified by "admin"
          using 'TOSQLSERVER';


6、加后缀访问
    
    MYSQL        select * from 用户名.表名@DBLINK
    
    sqlserver：  select * from 域名.表名@DBLINK
    



