
----ʵ��ORACLE ROWNUM ����
SELECT @RN := @RN + 1 AS RN, A.*
  FROM TEST.TEST_ZHONGJING A, (SELECT @RN := 0 AS RN) B


----