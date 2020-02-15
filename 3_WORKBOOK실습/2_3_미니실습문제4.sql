-- 1. �迭 ������ ������ ī�װ� ���̺��� ������� �Ѵ�. ������ ���� ���̺��� �ۼ��Ͻÿ�.
-- ���̺� �̸� : TB_CATEGORY 
-- �÷� : NAME, VARCHAR2(10) // USE_YN, CHAR(1), �⺻���� Y�� ������
CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);

-- 2. ���� ������ ������ ���̺��� ������� �Ѵ�. ������ ���� ���̺��� �ۼ��Ͻÿ�.
-- ���̺� �̸� : TB_CLASS_TYPE
-- �÷� : NO, VARCHAR2(5), PRIMARY KEY // NAME, VARCHAR2(10)
CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10)
);

-- 3. TB_CATEGORY ���̺��� NAME �÷��� PRIMARY KEY�� �����Ͻÿ�.
--  (KEY �̸��� �������� �ʾƵ� ������. ���� KEY �̸� �����ϰ��� �Ѵٸ� �̸��� ������ �˾Ƽ� ������ �̸��� ����Ѵ�.)
ALTER TABLE TB_CATEGORY ADD CONSTRAINT TC_NAME_PK PRIMARY KEY(NAME);

-- 4. TB_CLASS_TYPE ���̺��� NAME �÷��� NULL���� ���� �ʵ��� �Ӽ��� �����Ͻÿ�. 
ALTER TABLE TB_CLASS_TYPE MODIFY NAME CONSTRAINT TCT_NAME_NN NOT NULL;

-- 5. �� ���̺��� �÷� ���� NO�� ���� ���� Ÿ���� �����ϸ鼭 ũ�⸦ 10����, �÷� ���� NAME�� ���� ���������� ���� Ÿ���� �����ϸ鼭 ũ�� 20���� �����Ͻÿ�.
ALTER TABLE TB_CATEGORY
MODIFY NAME VARCHAR2(20);

ALTER TABLE TB_CLASS_TYPE
MODIFY NAME VARCHAR2(20);

ALTER TABLE TB_CLASS_TYPE
MODIFY NO VARCHAR2(10);

-- 6. �� ���̺��� NO �÷��� NAME �÷��� �̸��� �� �� TB_ �� ������ ���̺� �̸� �տ� ���� ���·� �����Ѵ�. (ex. CATEGORY_NAME)
ALTER TABLE TB_CATEGORY
RENAME COLUMN NAME TO CATEGORY_NAME;

ALTER TABLE TB_CATEGORY
RENAME COLUMN USE_YN TO CATEGORY_USE_YN;

ALTER TABLE TB_CLASS_TYPE
RENAME COLUMN NO TO CLASS_TYPE_NO;

ALTER TABLE TB_CLASS_TYPE
RENAME COLUMN NAME TO CLASS_TYPE_NAME;

-- 7. TB_CATEGORY ���̺�� TB_CLASS_TYPE ���̺��� PRIMARY KEY �̸��� ������ ���� �����Ͻÿ�.
-- PRIMARY KEY�� �̸��� "PK_ + �÷��̸�"���� �����Ͻÿ�.  (ex. PK_CATEGORY_NAME)
ALTER TABLE TB_CATEGORY
RENAME CONSTRAINT TC_NAME_PK TO PK_CATEGORY_NAME;

ALTER TABLE TB_CLASS_TYPE
RENAME CONSTRAINT SYS_C007181 TO PK_CLASS_TYPE_NO;

-- 8. ������ ���� INSERT���� �����Ѵ�.
INSERT INTO TB_CATEGORY VALUES('����', 'Y');
INSERT INTO TB_CATEGORY VALUES('�ڿ�����', 'Y');
INSERT INTO TB_CATEGORY VALUES('����', 'Y');
INSERT INTO TB_CATEGORY VALUES('��ü��', 'Y');
INSERT INTO TB_CATEGORY VALUES('�ι���ȸ', DEFAULT);
COMMIT;

-- 9. TB_DEPARTMENT�� CATEGORY �÷��� TB_CATEGORY���̺��� CATEGORY_NAME �÷��� �θ� ������ �����ϵ��� FOREIGN KEY�� �����Ͻÿ�.
-- �� �� KEY �̸��� FK_���̺��̸�_�÷��̸����� �����Ѵ�. (ex. FK_DEPARTMENT_CATEGORY)
ALTER TABLE TB_DEPARTMENT ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY(CATEGORY) REFERENCES TB_CATEGORY(CATEGORY_NAME);

-- 10. �� ������б� �л����� �������� ���ԵǾ� �ִ� �л��Ϲ����� VIEW�� ������� �Ѵ�. �Ʒ� ������ �����Ͽ� ������ SQL���� �ۼ��Ͻÿ�. 
-- �� �̸� : VW_�л��Ϲ�����
-- �÷� : �й�, �л��̸�, �ּ�

GRANT CREATE VIEW TO WB;

CREATE OR REPLACE VIEW VW_�л��Ϲ�����
AS SELECT STUDENT_NO �й�, STUDENT_NAME �л��̸�, STUDENT_ADDRESS �ּ�
    FROM TB_STUDENT;

SELECT * FROM VW_�л��Ϲ�����;

-- 11. �� ������б��� 1�⿡ �� ���� �а����� �л��� ���������� ���� ����� �����Ѵ�. 
-- �̸� ���� ����� �л��̸�, ��米���̸����� �����Ǿ� �ִ� VIEW�� ����ÿ�. �̶� ���� ������ ���� �л��� ���� �� ������ ����Ͻÿ�. 
--  (��, �� VIEW�� �ܼ� SELECT���� �� ��� �а����� ���ĵǾ� ȭ�鿡 �������� ����ÿ�.)
-- �� �̸� : VW_�������
-- �÷� : �л��̸�, �а��̸�, ���������̸�
CREATE OR REPLACE VIEW VW_�������
AS SELECT STUDENT_NAME �л��̸�, DEPARTMENT_NAME �а��̸�, PROFESSOR_NAME ���������̸�
    FROM TB_STUDENT TS
        LEFT JOIN TB_DEPARTMENT TD ON (TS.DEPARTMENT_NO = TD.DEPARTMENT_NO)
        LEFT JOIN TB_PROFESSOR TP ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
    ORDER BY TS.DEPARTMENT_NO;

-- 12. ��� �а��� �а��� �л� ���� Ȯ���� �� �ֵ��� ������ VIEW�� �ۼ��غ���.
-- �� �̸� : VW_�а����л���
-- �÷� : DEPARTMENT_NAME, STUDENT_COUNT;
CREATE OR REPLACE VIEW VW_�а����л���
AS SELECT DEPARTMENT_NAME, COUNT(*) "STUDENT_COUNT"
    FROM TB_STUDENT
        LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    GROUP BY DEPARTMENT_NAME;
    
SELECT * FROM VW_�а����л���;

-- 13. ������ ������ �л��Ϲ����� VIEW�� ���ؼ� �й��� A213046�� �л��� �̸��� ���� �̸����� �����ϴ� SQL������ �ۼ��Ͻÿ�.
SELECT * 
FROM VW_�л��Ϲ�����
WHERE �й� = 'A213046';

UPDATE VW_�л��Ϲ�����
SET �л��̸� = '���Ѽ�'
WHERE �й� = 'A213046';

-- 14. 13�������� ���� VIEW�� ���ؼ� �����Ͱ� ����� �� �ִ� ��Ȳ�� �������� VIEW�� ��� �����ؾ� �ϴ��� �ۼ��Ͻÿ�.
-- 1) WITH CHECK OPTION �ɼ� ����
--      : �ɼ��� ������ �÷��� ���� ���� �Ұ����ϰ� ��         => �л��̸� �÷��� ����, �� �÷��� ���� ���� ������ ���� �� ����
-- 2) WITH READ ONLY �ɼ� ����
--      : �信 ���� ��ȸ�� �����ϰ� ����, ����, ���� ���� �Ұ����ϰ� ��
CREATE OR REPLACE VIEW VW_�л��Ϲ�����
AS SELECT STUDENT_NO �й�, STUDENT_NAME �л��̸�, STUDENT_ADDRESS �ּ�
    FROM TB_STUDENT
    WITH READ ONLY;

UPDATE VW_�л��Ϲ�����
SET �л��̸� = '���Ѽ�'
WHERE �й� = 'A213046';
-- ORA-42399: cannot perform a DML operation on a read-only view
-- �����͸� �����ϴ� ������ ���� ��Ȳ�� ���� �� ����

-- 15. �� ������б��� �ų� ������û �Ⱓ�� �Ǹ� Ư�� �α� ����鿡 ���� ��û�� ���� ������ �ǰ� �ִ�.
-- �ֱ� 3�� �������� �����ο��� ���� ���Ҵ� 3 ������ ã�� ������ �ۼ��غ��ÿ�.
-- INLINE VIEW ����
SELECT CLASS_NO, CLASS_NAME, COUNT(STUDENT_NO)
FROM TB_GRADE
    LEFT JOIN TB_CLASS USING(CLASS_NO)
WHERE SUBSTR(TERM_NO, 1, 4) >= 2005
GROUP BY CLASS_NO, CLASS_NAME
ORDER BY 3 DESC;

-- ����
SELECT �����ȣ, �����̸�, "������������(��)"
FROM (SELECT CLASS_NO �����ȣ, CLASS_NAME �����̸�, COUNT(STUDENT_NO) "������������(��)"
        FROM TB_GRADE
            LEFT JOIN TB_CLASS USING(CLASS_NO)
        WHERE SUBSTR(TERM_NO, 1, 4) >= 2005
        GROUP BY CLASS_NO, CLASS_NAME
        ORDER BY "������������(��)" DESC)
WHERE ROWNUM <= 3;