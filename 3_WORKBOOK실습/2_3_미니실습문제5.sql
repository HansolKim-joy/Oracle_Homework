-- 1. �������� ���̺�(TB_CLASS_TYPE)�� �Ʒ��� ���� �����͸� �Է��Ͻÿ�.
INSERT INTO TB_CLASS_TYPE VALUES(01, '�����ʼ�');
INSERT INTO TB_CLASS_TYPE VALUES(02, '��������');
INSERT INTO TB_CLASS_TYPE VALUES(03, '�����ʼ�');
INSERT INTO TB_CLASS_TYPE VALUES(04, '���缱��');
INSERT INTO TB_CLASS_TYPE VALUES(05, '������');

SELECT * FROM TB_CLASS_TYPE;

-- 2. �� ������б� �л����� ������ ���ԵǾ� �ִ� �л��Ϲ����� ���̺��� ������� �Ѵ�. �Ʒ� ������ �����Ͽ� ������ SQL���� �ۼ��Ͻÿ�. (���������� �̿��Ͻÿ�)
-- ���̺� �̸� : TB_�л��Ϲ�����
-- �÷� : �й�, �л��̸�, �ּ�
CREATE TABLE TB_�л��Ϲ�����
AS SELECT STUDENT_NO �й�, STUDENT_NAME �л��̸�, STUDENT_ADDRESS �ּ�
    FROM TB_STUDENT;
    
SELECT * FROM TB_�л��Ϲ�����;

-- 3. ������а� �л����� �������� ���ԵǾ� �ִ� �а����� ���̺��� ������� �Ѵ�. �Ʒ� ������ �����Ͽ� ������ SQL���� �ۼ��Ͻÿ�.
--  (��Ʈ : ����� �پ���, �ҽŲ� �ۼ��Ͻÿ�)
-- ���̺� �̸� : TB_������а� 
-- �÷� : �й�, �л��̸�, ����⵵ (��, ���ڸ� �⵵�� ����), �����̸�
CREATE TABLE TB_������а�
AS SELECT STUDENT_NO �й�, STUDENT_NAME �л��̸�,
            EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN,1,2),'RR')) ����⵵, PROFESSOR_NAME �����̸�
    FROM TB_STUDENT TS
        LEFT JOIN TB_PROFESSOR ON(COACH_PROFESSOR_NO = PROFESSOR_NO)
        LEFT JOIN TB_DEPARTMENT TD ON(TS.DEPARTMENT_NO = TD.DEPARTMENT_NO)
    WHERE DEPARTMENT_NAME = '������а�';
    
SELECT * FROM TB_������а�;

-- 4. �� �а����� ������ 10% ������Ű�� �Ǿ���. �̿� ����� SQL���� �ۼ��Ͻÿ�. (��, �ݿø��� ����Ͽ� �Ҽ��� �ڸ��� ������ �ʵ��� �Ѵ�.)
SELECT DEPARTMENT_NO �а���ȣ, DEPARTMENT_NAME �а���, CAPACITY ����������, ROUND(CAPACITY * 1.1) ����������
FROM TB_DEPARTMENT;

-- 5. �й� A413042�� �ڰǿ� �л��� �ּҰ� "����� ���α� ���ε� 181-21"�� ����Ǿ��ٰ� �Ѵ�. �ּ����� �����ϱ� ���� ����� SQL���� �ۼ��Ͻÿ�.
SELECT * FROM TB_STUDENT WHERE STUDENT_NO = 'A413042';

UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '����� ���α� ���ε� 181-21'
WHERE STUDENT_NO = 'A413042';

-- 6. �ֹε�Ϲ�ȣ ��ȣ���� ���� �л����� ���̺��� �ֹι�ȣ ���ڸ��� �������� �ʱ�� �����Ͽ���. �� ������ �ݿ��� ������ SQL ������ �ۼ��Ͻÿ�.
--  (��. 830530-2124663  => 830503)
UPDATE TB_STUDENT
SET STUDENT_SSN = SUBSTR(STUDENT_SSN, 1, 6);

SELECT * FROM TB_STUDENT;

-- 7. ���а� ����� �л��� 2005�� 1�б⿡ �ڽ��� ������ '�Ǻλ�����' ������ �߸��Ǿ��ٴ� ���� �߰��ϰ�� ������ ��û�Ͽ���.
--  ��� ������ Ȯ�� ���� ��� �ش� ������ ������ 3.5�� ����Ű�� �����Ǿ���. ������ SQL���� �ۼ��Ͻÿ�.
-- ����� �л��� �� ����
SELECT STUDENT_NAME, TERM_NO, DEPARTMENT_NAME, CLASS_NO, CLASS_NAME, POINT
FROM TB_STUDENT
    LEFT JOIN TB_GRADE USING(STUDENT_NO)
    LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    LEFT JOIN TB_CLASS USING(CLASS_NO)
WHERE STUDENT_NAME = '�����' AND DEPARTMENT_NAME = '���а�' AND CLASS_NAME = '�Ǻλ�����';

COMMIT;

-- ���
UPDATE TB_GRADE
SET POINT = 3.5
WHERE CLASS_NO = (SELECT CLASS_NO
                  FROM TB_STUDENT
                     LEFT JOIN TB_GRADE USING(STUDENT_NO)
                     LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
                     LEFT JOIN TB_CLASS USING(CLASS_NO)
                  WHERE STUDENT_NAME = '�����' AND DEPARTMENT_NAME = '���а�' AND CLASS_NAME = '�Ǻλ�����')
     AND STUDENT_NO = (SELECT STUDENT_NO
                        FROM TB_STUDENT
                            LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
                        WHERE STUDENT_NAME = '�����' AND DEPARTMENT_NAME = '���а�');
                        
-- 8. ���� ���̺�(TB_GRADE)���� ���л����� �����׸��� �����Ͻÿ�.
-- ���� : ���л����� �б�, �й�, �л��̸�, ������ȣ, ����, ���п��� ��ȸ
SELECT TERM_NO, STUDENT_NO, STUDENT_NAME, CLASS_NO, POINT, ABSENCE_YN
FROM TB_GRADE
    LEFT JOIN TB_STUDENT USING(STUDENT_NO)
ORDER BY ABSENCE_YN DESC;

COMMIT;

UPDATE TB_GRADE
SET POINT = NULL
WHERE STUDENT_NO IN (SELECT STUDENT_NO FROM TB_STUDENT WHERE ABSENCE_YN = 'Y');