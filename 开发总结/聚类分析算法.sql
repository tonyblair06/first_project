
CREATE TABLE T_K_MEANS (
ID NUMBER,
COL_X NUMBER,
COL_Y NUMBER,
FLAG VARCHAR2(3)
);

--DROP TABLE T_K_MEANS_LOG;
CREATE TABLE T_K_MEANS_LOG (
BATCH_NO NUMBER,
COMMENTS VARCHAR2(4000),
ID NUMBER,
COL_X NUMBER,
COL_Y NUMBER,
FLAG VARCHAR2(3),
SEQ NUMBER
);


CREATE OR REPLACE TYPE TYPE_RECORD_K_MEANS IS OBJECT (
ID NUMBER,
COL_X NUMBER,
COL_Y NUMBER,
FLAG VARCHAR2(3)
);
CREATE OR REPLACE TYPE TYPE_TABLE_K_MEANS IS TABLE OF TYPE_RECORD_K_MEANS;

CREATE SEQUENCE SEQ_TONY;  






CREATE OR REPLACE PACKAGE PKG_ZHONGJING_TEST IS
   
  V_TOTAL_POINIT NUMBER := 100;
  V_MAX_POSITION NUMBER := 1000;
  
  V_TYPE_T_K_MEANS TYPE_TABLE_K_MEANS := TYPE_TABLE_K_MEANS();

  PROCEDURE CALC_NEW_CENTER(I_FLAG  IN NUMBER,
                            O_ID    OUT NUMBER,
                            O_COL_X OUT NUMBER,
                            O_COL_Y OUT NUMBER);
  PROCEDURE K_MEANS(I_CENTER_A IN NUMBER, I_CENTER_B IN NUMBER);
END;




CREATE OR REPLACE PACKAGE BODY PKG_ZHONGJING_TEST IS

  PROCEDURE RANDOM_POINTS AS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_K_MEANS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_K_MEANS_LOG';
    INSERT INTO T_K_MEANS
      SELECT ROWNUM,
             FLOOR(DBMS_RANDOM.VALUE(0, V_MAX_POSITION)),
             FLOOR(DBMS_RANDOM.VALUE(0, V_MAX_POSITION)),
             ''
        FROM DUAL
      CONNECT BY LEVEL <= V_TOTAL_POINIT; 
  END;

  PROCEDURE CALC_NEW_CENTER(I_FLAG  IN NUMBER,
                            O_ID    OUT NUMBER,
                            O_COL_X OUT NUMBER,
                            O_COL_Y OUT NUMBER) AS
    V_DISTANCE                NUMBER;
    V_DISTANCE_MIN            NUMBER;
    V_ROWS                    NUMBER;
    V_ID                      NUMBER;
    V_X                       NUMBER;
    V_Y                       NUMBER;
    V_TYPE_T_K_MEANS_ONE_SIDE TYPE_TABLE_K_MEANS := TYPE_TABLE_K_MEANS();
  BEGIN
  
    SELECT TYPE_RECORD_K_MEANS(ID, COL_X, COL_Y, FLAG)
      BULK COLLECT
      INTO V_TYPE_T_K_MEANS_ONE_SIDE
      FROM TABLE(V_TYPE_T_K_MEANS)
     WHERE FLAG LIKE I_FLAG || '%';
  
    V_ROWS := V_TYPE_T_K_MEANS_ONE_SIDE.COUNT;
  
    FOR I IN 1 .. V_ROWS LOOP
      V_ID       := V_TYPE_T_K_MEANS_ONE_SIDE(I).ID;
      V_X        := V_TYPE_T_K_MEANS_ONE_SIDE(I).COL_X;
      V_Y        := V_TYPE_T_K_MEANS_ONE_SIDE(I).COL_Y;
      V_DISTANCE := 0;
    
      FOR K IN 1 .. V_ROWS LOOP
        V_DISTANCE := V_DISTANCE +
                      POWER((V_TYPE_T_K_MEANS_ONE_SIDE(K).COL_X - V_X), 2) +
                      POWER((V_TYPE_T_K_MEANS_ONE_SIDE(K).COL_Y - V_Y), 2);
      
      END LOOP;
    
      IF V_DISTANCE <= NVL(V_DISTANCE_MIN, V_DISTANCE) THEN
        O_ID           := V_ID;
        O_COL_X        := V_X;
        O_COL_Y        := V_Y;
        V_DISTANCE_MIN := V_DISTANCE;
      END IF;
    
    END LOOP;
  
  END;

  PROCEDURE K_MEANS(I_CENTER_A IN NUMBER, I_CENTER_B IN NUMBER) AS
    ORG_A_ID      NUMBER;
    ORG_A_X       NUMBER;
    ORG_A_Y       NUMBER;
    NEW_A_ID      NUMBER;
    NEW_A_X       NUMBER;
    NEW_A_Y       NUMBER;
    ORG_B_ID      NUMBER;
    ORG_B_X       NUMBER;
    ORG_B_Y       NUMBER;
    NEW_B_ID      NUMBER;
    NEW_B_X       NUMBER;
    NEW_B_Y       NUMBER;
    V_ROWS        NUMBER;
    V_DISTANCE_A  NUMBER;
    V_DISTANCE_B  NUMBER;
    V_SIDE_CHOOSE CHAR(1) := '0';
    V_COUNT       NUMBER := 1;
    V_BATCH       NUMBER := SEQ_TONY.NEXTVAL;
  BEGIN
    RANDOM_POINTS();
    
    SELECT TYPE_RECORD_K_MEANS(ID, COL_X, COL_Y, FLAG)
      BULK COLLECT
      INTO V_TYPE_T_K_MEANS
      FROM T_K_MEANS;
  
    --���ȡ2������Ϊ��ʼ���ĵ�
    ORG_A_ID := NVL(I_CENTER_A, CEIL(DBMS_RANDOM.VALUE(0, V_TOTAL_POINIT)));
    ORG_A_X  := V_TYPE_T_K_MEANS(ORG_A_ID).COL_X;
    ORG_A_Y  := V_TYPE_T_K_MEANS(ORG_A_ID).COL_Y;
    LOOP
      ORG_B_ID := NVL(I_CENTER_B, CEIL(DBMS_RANDOM.VALUE(0, V_TOTAL_POINIT)));
      ORG_B_X  := V_TYPE_T_K_MEANS(ORG_B_ID).COL_X;
      ORG_B_Y  := V_TYPE_T_K_MEANS(ORG_B_ID).COL_Y;
      EXIT WHEN ORG_A_ID <> ORG_B_ID;
    END LOOP;
  
    NEW_A_ID := ORG_A_ID;
    NEW_A_X  := ORG_A_X;
    NEW_A_Y  := ORG_A_Y;
    NEW_B_ID := ORG_B_ID;
    NEW_B_X  := ORG_B_X;
    NEW_B_Y  := ORG_B_Y;
  
    --DELETE FROM T_K_MEANS_LOG;
    INSERT INTO T_K_MEANS_LOG
      (BATCH_NO, COMMENTS, SEQ)
    VALUES
      (V_BATCH,
       '--------��ʼ����---------' || NEW_A_ID || ',' || NEW_B_ID,
       SEQ_TONY.NEXTVAL);
    COMMIT;
  
    --ѭ��ǰ������׼��
    V_ROWS := V_TYPE_T_K_MEANS.COUNT;
    V_TYPE_T_K_MEANS(NEW_A_ID).FLAG := '0';
    V_TYPE_T_K_MEANS(NEW_B_ID).FLAG := '1';
  
    <<LB_LOOP>>
    LOOP
      --����ճ��, ����  
      FOR I IN 1 .. V_ROWS LOOP
        IF V_TYPE_T_K_MEANS(I)
         .ID <> ORG_A_ID AND V_TYPE_T_K_MEANS(I).ID <> ORG_B_ID THEN
          V_DISTANCE_A := POWER((V_TYPE_T_K_MEANS(I).COL_X - NEW_A_X), 2) +
                          POWER((V_TYPE_T_K_MEANS(I).COL_Y - NEW_A_Y), 2);
          V_DISTANCE_B := POWER((V_TYPE_T_K_MEANS(I).COL_X - NEW_B_X), 2) +
                          POWER((V_TYPE_T_K_MEANS(I).COL_Y - NEW_B_Y), 2);
        
          IF V_DISTANCE_A < V_DISTANCE_B THEN
            V_TYPE_T_K_MEANS(I).FLAG := '00';
          ELSIF V_DISTANCE_A > V_DISTANCE_B THEN
            V_TYPE_T_K_MEANS(I).FLAG := '11';
          ELSE
            --�����൱�� ƽ��
            V_TYPE_T_K_MEANS(I).FLAG := V_SIDE_CHOOSE || V_SIDE_CHOOSE;
            V_SIDE_CHOOSE := TO_CHAR(MOD(TO_NUMBER(V_SIDE_CHOOSE) + 1, 2));
          END IF;
        END IF;
      END LOOP;
    
      INSERT INTO T_K_MEANS_LOG
        SELECT V_BATCH, V_COUNT, T.*, SEQ_TONY.NEXTVAL
          FROM TABLE(V_TYPE_T_K_MEANS) T;
    
      --ճ�������¼������ĵ�
      CALC_NEW_CENTER('0', NEW_A_ID, NEW_A_X, NEW_A_Y);
      CALC_NEW_CENTER('1', NEW_B_ID, NEW_B_X, NEW_B_Y);
    
      INSERT INTO T_K_MEANS_LOG
        (BATCH_NO, COMMENTS, SEQ)
      VALUES
        (V_BATCH,
         '--------������---------' || NEW_A_ID || ',' || NEW_B_ID,
         SEQ_TONY.NEXTVAL);
      COMMIT;
    
      --���¼�������ĵ���ԭ���ĵ����, ������, �����
      IF ORG_A_ID = NEW_A_ID AND ORG_B_ID = NEW_B_ID THEN
        DBMS_OUTPUT.PUT_LINE(ORG_A_ID || ',' || ORG_B_ID);
        DBMS_OUTPUT.PUT_LINE(NEW_A_ID || ',' || NEW_B_ID);
        DBMS_OUTPUT.PUT_LINE((V_COUNT-1)/2);
        EXIT;
      END IF;
    
      --ѭ��ĩβ�����ݸ���
      V_TYPE_T_K_MEANS(NEW_A_ID).FLAG := '0';
      V_TYPE_T_K_MEANS(NEW_B_ID).FLAG := '1';
      ORG_A_ID := NEW_A_ID;
      ORG_B_ID := NEW_B_ID;
      V_COUNT := V_COUNT + 1;


      INSERT INTO T_K_MEANS_LOG
        SELECT V_BATCH, V_COUNT, T.*, SEQ_TONY.NEXTVAL
          FROM TABLE(V_TYPE_T_K_MEANS) T;
      V_COUNT := V_COUNT + 1;
          
    END LOOP;
  
    MERGE INTO T_K_MEANS MI
    USING (SELECT * FROM TABLE(V_TYPE_T_K_MEANS)) T
    ON (MI.ID = T.ID)
    WHEN MATCHED THEN
      UPDATE SET MI.FLAG = T.FLAG;
    COMMIT;
  
  END;
END;


