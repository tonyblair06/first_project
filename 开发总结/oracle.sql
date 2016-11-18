�����ѯ��


SELECT SESS.SID,
       SESS.SERIAL#,
       LO.ORACLE_USERNAME,
       LO.OS_USER_NAME,
       AO.OBJECT_NAME,
       LO.LOCKED_MODE
  FROM V$LOCKED_OBJECT LO, DBA_OBJECTS AO, V$SESSION SESS
 WHERE AO.OBJECT_ID = LO.OBJECT_ID
   AND LO.SESSION_ID = SESS.SID;



----�ֹ���

�ֹ����� Optimistic Locking �� ��Ա��������ԣ��ֹ���������Ϊ����һ������²�����ɳ�ͻ�����������ݽ����ύ���µ�ʱ�򣬲Ż���ʽ�����ݵĳ�ͻ�����м�⣬������ֳ�ͻ�ˣ����÷����û��������Ϣ�����û��������ȥ������ô�������ʵ���ֹ����أ�һ����˵������2�ַ�ʽ��
1.ʹ�����ݰ汾��Version����¼����ʵ�֣������ֹ�����õ�һ��ʵ�ַ�ʽ����ν���ݰ汾����Ϊ��������һ���汾��ʶ��һ����ͨ��Ϊ���ݿ������һ���������͵� ��version�� �ֶ���ʵ�֡�����ȡ����ʱ����version�ֶε�ֵһͬ����������ÿ����һ�Σ��Դ�versionֵ��һ���������ύ���µ�ʱ���ж����ݿ���Ӧ��¼�ĵ�ǰ�汾��Ϣ���һ��ȡ������versionֵ���бȶԣ�������ݿ��ǰ�汾�����һ��ȡ������versionֵ��ȣ������Ը��£�������Ϊ�ǹ������ݡ��������һ��ͼ��˵����


����ͼ��ʾ��������²���˳��ִ�У������ݵİ汾��version�����ε��������������ͻ��������������в�ͬ��ҵ�������ͬһ�汾�����ݽ����޸ģ���ô�����ύ�Ĳ�����ͼ��B���������version����Ϊ2����A��B֮���ύ����ʱ�������ݵ�version�Ѿ����޸��ˣ���ôA�ĸ��²�����ʧ�ܡ�
2.�ֹ������ĵڶ���ʵ�ַ�ʽ�͵�һ�ֲ�࣬ͬ��������Ҫ�ֹ������Ƶ�table������һ���ֶΣ���������ν���ֶ�����ʹ��ʱ�����timestamp��, �������version���ƣ�Ҳ���ڸ����ύ��ʱ���鵱ǰ���ݿ������ݵ�ʱ������Լ�����ǰȡ����ʱ������жԱȣ����һ����OK��������ǰ汾��ͻ��




--���ȥ10����¼

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




--͸����������mysql sqlserver
1������ODBC
    
      mysqlҪ��װMYSQL ODBC����
      
      linux: vi /etc/odbc.ini
            
            Description = MySQL test database
            Trace = On
            TraceFile = stderr
            Driver = ODBCSQLSERVERDW          //����Դ����
            SERVER = localhost
            USER = root
            PASSWORD = mysql
            PORT = 3306
            DATABASE = test
            socket = /tmp/mysql.sock

2���������ص�initsqlserverdw.ora
    
      HS_FDS_CONNECT_INFO = ODBCSQLSERVERDW //��ֵ�������ODBC�����õ�����Դ����
      HS_FDS_TRACE_LEVEL = OFF


3������������ӵ�ʵ��

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
          (SID_NAME = sqlserverdw)       //��ֵ�������initsqlserverdw.ora�е�sqlserverdw
          (ORACLE_HOME = D:\app\JingZhong\product\11.2.0\dbhome_1)
          (PROGRAM = dg4odbc)
        )
      )

4�����ʵ����TNS

        TOSQLSERVER =
          (DESCRIPTION =
            (ADDRESS = (PROTOCOL = TCP)(HOST = QF-JINGZHONG-01.quark.com)(PORT = 1521))
            (CONNECT_DATA =
              (SERVICE_NAME = sqlserverdw)  //��ֵ������������SID_NAME
            )
            (HS = OK)
          ) 

5������DBLINK

        create database link XEDK_MYSQL
          connect to "xedk" identified by "admin"
          using 'TOSQLSERVER';


6���Ӻ�׺����
    
    MYSQL        select * from �û���.����@DBLINK
    
    sqlserver��  select * from ����.����@DBLINK
    



