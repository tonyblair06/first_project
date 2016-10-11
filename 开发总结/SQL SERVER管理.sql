
ORACLE:


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

   

修改inbound_connect_timeout


show inbound_connect_timeout

set inbound_connect_timeout 0

set save_config_on_stop on

reload


Vi sqlnet.ora

SQLNET.INBOUND_CONNECT_TIMEOUT = 0




修改listener.ora文件，加入:  

INBOUND_CONNECT_TIMEOUT_LISTENER_NAME=0


-------------------------------------------------------------------------------------------------
SQL SERVER管理：


处理LOG满的方法：
    ALTER DATABASE ODS SET RECOVERY SIMPLE WITH NO_WAIT  

    ALTER DATABASE ODS SET RECOVERY SIMPLE   --简单模式  


    DBCC SHRINKFILE (N'ODS_log' , 11, TRUNCATEONLY)  

    ALTER DATABASE ODS SET RECOVERY FULL WITH NO_WAIT  

  
    ALTER DATABASE ODS SET RECOVERY FULL  --还原为完全模式  
	
	
查看数据库文件使用情况：
SELECT a.name [文件名称]  
    ,cast(a.[size]*1.0/128 as decimal(12,1)) AS [文件设置大小(MB)]  
    ,CAST( fileproperty(s.name,'SpaceUsed')/(8*16.0) AS DECIMAL(12,1)) AS [文件所占空间(MB)]  
    ,CAST( (fileproperty(s.name,'SpaceUsed')/(8*16.0))/(s.size/(8*16.0))*100.0  AS DECIMAL(12,1)) AS [所占空间率%]  
    ,CASE WHEN A.growth =0 THEN '文件大小固定，不会增长' ELSE '文件将自动增长' end [增长模式]  
    ,CASE WHEN A.growth > 0 AND is_percent_growth = 0 THEN '增量为固定大小'  
        WHEN A.growth > 0 AND is_percent_growth = 1 THEN '增量将用整数百分比表示'  
        ELSE '文件大小固定，不会增长' END AS [增量模式]  
    ,CASE WHEN A.growth > 0 AND is_percent_growth = 0 THEN cast(cast(a.growth*1.0/128as decimal(12,0)) AS VARCHAR)+'MB'  
        WHEN A.growth > 0 AND is_percent_growth = 1 THEN cast(cast(a.growth AS decimal(12,0)) AS VARCHAR)+'%'  
        ELSE '文件大小固定，不会增长' end AS [增长值(%或MB)]  
    ,a.physical_name AS [文件所在目录]  
    ,a.type_desc AS [文件类型]  
FROM sys.database_files  a  
INNER JOIN sys.sysfiles AS s ON a.[file_id]=s.fileid  
LEFT JOIN sys.dm_db_file_space_usage b ON a.[file_id]=b.[file_id]  
ORDER BY a.[type] 



SELECT * FROM SYS.all_objects  T WHERE T.TYPE = 'U'  and UPPER(t.name) like '%PIN_INFO%' ORDER BY 1 


SELECT A.name, T.collation_name FROM SYS.all_columns T,
SYS.all_objects A 
WHERE UPPER(T.NAME) LIKE 'SOURCE_BALANCE' AND T.object_id = A.object_id
 
 
 
 

 
 DEV-DWETL-02
 mssql_dwdev


SELECT *
FROM SYS.tables A 
INNER JOIN SYS.COLUMNS B ON B.object_id = A.object_id

LEFT JOIN SYS.extended_properties C ON C.major_id = B.object_id
AND C.minor_id = B.column_id
WHERE A.NAME = 'TAB_TEST1'





create database stuDB 
on  primary  -- 默认就属于primary文件组,可省略
(
/*--数据文件的具体描述--*/
    name='stuDB_data',  -- 主数据文件的逻辑名称
    filename='D:\stuDB_data.mdf', -- 主数据文件的物理名称
    size=5mb, --主数据文件的初始大小
    maxsize=100mb, -- 主数据文件增长的最大值
    filegrowth=15%--主数据文件的增长率
)
log on
(
/*--日志文件的具体描述,各参数含义同上--*/
    name='stuDB_log',
    filename='D:\stuDB_log.ldf',
    size=2mb,
    filegrowth=1mb
)




create login tony with password='a6417982A', default_database=TESTDB


create user tony for login tony with default_schema=TESTDB


exec sp_addrolemember 'db_owner', 'tony'




SELECT M.*,
       N.COL2,
       CURRENT_TIMESTAMP AS DW_LAST_UPDATE_TIME
  INTO [ODS].[DBO].[TEM_AA_PAYMENT_SCHEDULE_DUE_TYPES]
  FROM (SELECT ID,
               SEQ1,
               SEQ2,
               SEQ3,
               DUE_TYPES,
               DUE_TYPE_AMT,
               B.COL1,
               ROW_NUMBER() OVER(PARTITION BY SEQ1, SEQ2 ORDER BY SEQ3) AS RN
          FROM (SELECT ID,
                       SEQ1,
                       SEQ2,
                       SEQ3,
                       DUE_TYPES,
                       DUE_TYPE_AMT,
                       COL1 =
                       CONVERT(XML,
                               '<root><v>' +
                               REPLACE(CONVERT(NVARCHAR(MAX), DUE_PROPS),
                                       '~',
                                       '</v><v>') + '</v></root>')
                  FROM TDI.DBO.QF_AA_PAYMENT_SCHEDULE_DUE_TYPES T) AS A
         OUTER APPLY (SELECT COL1 = C.V.value('.', 'nvarchar(120)')   --value必须小写
                       FROM A.COL1.nodes('/root/v') AS C(V)) AS B) M,  --nodes必须小写
       
       (SELECT ID,
               SEQ1,
               SEQ2,
               SEQ3,
               B.COL2,
               ROW_NUMBER() OVER(PARTITION BY SEQ1, SEQ2 ORDER BY SEQ3) AS RN
          FROM (SELECT ID,
                       SEQ1,
                       SEQ2,
                       SEQ3,
                       COL2 =
                       CONVERT(XML,
                               '<root><v>' +
                               REPLACE(CONVERT(NVARCHAR(MAX), DUE_PROP_AMT),
                                       '~',
                                       '</v><v>') + '</v></root>')
                  FROM TDI.DBO.QF_AA_PAYMENT_SCHEDULE_DUE_TYPES T) AS A
         OUTER APPLY (SELECT COL2 = C.V.value('.', 'nvarchar(120)')
                       FROM A.COL2.nodes('/root/v') AS C(V)) AS B) N
 WHERE M.SEQ1 = N.SEQ1
   AND M.SEQ2 = N.SEQ2
   AND M.SEQ3 = N.SEQ3
   AND M.RN = N.RN

	



SELECT CHARINDEX('-', 'W2TBJ-121603001',5) ,  CHARINDEX('-', 'W2TBJ-121603001',5) , SUBSTRING('W2TBJ-121603001', 3,   CHARINDEX('-', 'W2TBJ-121603001',3) )





WITH 
BOSSWT AS (
SELECT 'BOSS' AS COL3 
),

WT AS (
SELECT 'BOSS' AS COL3, 'A' AS COL1, '123' AS COL2 UNION ALL
SELECT 'BOSS' AS COL3,'A' AS COL1, '123' AS COL2 UNION ALL
SELECT 'BOSS' AS COL3,'A' AS COL1, '123' AS COL2 
)
SELECT A.*, B.* FROM 
BOSSWT A
INNER JOIN 
WT T
pivot(
   max(COL2)
   for COL1 in(A, B ,C)
   ) B ON A.COL3 = B.COL3


Select CONVERT(varchar(100), GETDATE(), 0)--05 16 2006 10:57AM
Select CONVERT(varchar(100), GETDATE(), 1)--05/16/06
Select CONVERT(varchar(100), GETDATE(), 2)--06.05.16
Select CONVERT(varchar(100), GETDATE(), 3)--16/05/06
Select CONVERT(varchar(100), GETDATE(), 4)--16.05.06
Select CONVERT(varchar(100), GETDATE(), 5)--16-05-06
Select CONVERT(varchar(100), GETDATE(), 6)--16 05 06
Select CONVERT(varchar(100), GETDATE(), 7)--05 16, 06
Select CONVERT(varchar(100), GETDATE(), 8)--10:57:46
Select CONVERT(varchar(100), GETDATE(), 9)--05 16 200610:57:46:827AM
Select CONVERT(varchar(100), GETDATE(), 10)--05-16-06
Select CONVERT(varchar(100), GETDATE(), 11)--06/05/16
Select CONVERT(varchar(100), GETDATE(), 12)--060516
Select CONVERT(varchar(100), GETDATE(), 13)--16 05 2006 10:57:46:937
Select CONVERT(varchar(100), GETDATE(), 14)--10:57:46:967
Select CONVERT(varchar(100), GETDATE(), 20)--2006-05-16 10:57:47
Select CONVERT(varchar(100), GETDATE(), 21)--2006-05-16 10:57:47.157
Select CONVERT(varchar(100), GETDATE(), 22)--05/16/06 10:57:47 AM
Select CONVERT(varchar(100), GETDATE(), 23)--2006-05-16
Select CONVERT(varchar(100), GETDATE(), 24)--10:57:47
Select CONVERT(varchar(100), GETDATE(), 25)--2006-05-16 10:57:47.250
Select CONVERT(varchar(100), GETDATE(), 100)--05 16 2006 10:57AM
Select CONVERT(varchar(100), GETDATE(), 101)--05/16/2006
Select CONVERT(varchar(100), GETDATE(), 102)--2006.05.16
Select CONVERT(varchar(100), GETDATE(), 103)--16/05/2006
Select CONVERT(varchar(100), GETDATE(), 104)--16.05.2006
Select CONVERT(varchar(100), GETDATE(), 105)--16-05-2006
Select CONVERT(varchar(100), GETDATE(), 106)--16 05 2006
Select CONVERT(varchar(100), GETDATE(), 107)--05 16, 2006
Select CONVERT(varchar(100), GETDATE(), 108)--10:57:49
Select CONVERT(varchar(100), GETDATE(), 109)--05 16 200610:57:49:437AM
Select CONVERT(varchar(100), GETDATE(), 110)--05-16-2006
Select CONVERT(varchar(100), GETDATE(), 111)--2006/05/16
Select CONVERT(varchar(100), GETDATE(), 112)--20060516
Select CONVERT(varchar(100), GETDATE(), 113)--16 05 2006 10:57:49:513
Select CONVERT(varchar(100), GETDATE(), 114)--10:57:49:547
Select CONVERT(varchar(100), GETDATE(), 120)--2006-05-16 10:57:49
Select CONVERT(varchar(100), GETDATE(), 121)--2006-05-16 10:57:49.700
Select CONVERT(varchar(100), GETDATE(), 126)--2006-05-16T10:57:49.827
Select CONVERT(varchar(100), GETDATE(), 130)--18 ???? ?????? 142710:57:49:907AM
Select CONVERT(varchar(100), GETDATE(), 131)--18/04/142710:57:49:920AM

   
