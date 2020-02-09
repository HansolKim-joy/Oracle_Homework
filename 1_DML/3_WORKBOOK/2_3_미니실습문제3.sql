-- 1. �л��̸��� �ּ����� ǥ���Ͻÿ�. ��, ��� ����� "�л� �̸�", "�ּ���"�� �ϰ�, ������ �̸����� �������� ǥ���ϵ��� �Ѵ�.
SELECT STUDENT_NAME "�л� �̸�", STUDENT_ADDRESS "�ּ���"
FROM TB_STUDENT
ORDER BY STUDENT_NAME;

-- 2. ���� ���� �л����� �̸��� �ֹι�ȣ�� ���̰� ���� ������� ȭ�鿡 ����Ͻÿ�.
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY STUDENT_SSN DESC;

-- 3. �ּ����� �������� ��⵵�� �л��� �� 1990��� �й��� ���� �л����� �̸��� �й�, �ּҸ� �̸��� ������������ ȭ�鿡 ����Ͻÿ�.
-- ��, ���������� "�л��̸�", "�й�", "������ �ּ�"�� ��µǵ��� �Ѵ�.
SELECT STUDENT_NAME �л��̸�, STUDENT_NO �й�, STUDENT_ADDRESS "������ �ּ�"
FROM TB_STUDENT
WHERE (STUDENT_ADDRESS LIKE '%������%' OR STUDENT_ADDRESS LIKE '%��⵵%')
        AND SUBSTR(STUDENT_NO,1,2) BETWEEN '90' AND '99'
ORDER BY STUDENT_NAME;

-- 4. ���� ���а� ���� �� ���� ���̰� ���� ������� �̸��� Ȯ���� �� �ִ� SQL������ �ۼ��Ͻÿ�.
--  (���а��� '�а��ڵ�'�� �а� ���̺�(TB_DEPARTMENT)�� ��ȸ�ؼ� ã�� ������ ����.)
SELECT DEPARTMENT_NO
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME = '���а�';

SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '���а�'
ORDER BY PROFESSOR_SSN;

-- 5. 2004�� 2�б⿡ 'C3118100' ������ ������ �л����� ������ ��ȸ�Ϸ��� �Ѵ�.
--  ������ ���� �л����� ǥ���ϰ�, ������ ������ �й��� ���� �л����� ǥ���ϴ� ������ �ۼ��غ��ÿ�.
SELECT STUDENT_NO, TO_CHAR(POINT, '9.99') "POINT"
FROM TB_GRADE
WHERE TERM_NO = '200402' AND CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO;

-- 6. �л� ��ȣ, �л� �̸�, �а� �̸��� �л� �̸����� �������� �����Ͽ� ����ϴ� SQL���� �ۼ��Ͻÿ�.
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME;

-- 7. �� ������б��� ���� �̸��� ������ �а� �̸��� ����ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);

-- 8. ���� ���� �̸��� ã������ �Ѵ�. ���� �̸��� ���� �̸��� ����ϴ� SQL���� �ۼ��Ͻÿ�.
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
    JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
    JOIN TB_PROFESSOR USING (PROFESSOR_NO);

-- 9. 8���� ��� �� '�ι���ȸ' �迭�� ���� ������ ���� �̸��� ã������ �Ѵ�. �̿� �ش��ϴ� ���� �̸��� ���� �̸��� ����ϴ� SQL���� �ۼ��Ͻÿ�.
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
    JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
    JOIN TB_PROFESSOR USING (PROFESSOR_NO)
WHERE CATEGORY LIKE '%�ι���ȸ%';

-- 10. '�����а�' �л����� ������ ���Ϸ��� �Ѵ�. �����а� �л����� "�й�", "�л� �̸�", "��ü ����"�� ����ϴ� SQL�� �ۼ��Ͻÿ�.
--  (��, ������ �Ҽ��� 1�ڸ������� �ݿø��Ͽ� ǥ���Ѵ�.)
SELECT STUDENT_NO �й�, STUDENT_NAME "�л� �̸�", ROUND(AVG(POINT),1) "��ü ����"
FROM TB_GRADE
    JOIN TB_STUDENT USING (STUDENT_NO)
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '�����а�'
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY STUDENT_NO;

-- 11.�й��� A313047�� �л��� �б��� ������ �ʰ� �ִ�. ���� �������� ������ �����ϱ� ���� �а� �̸�, �л� �̸��� ���� ���� �̸��� �ʿ��ϴ�.
--  �̶� ����� SQL���� �ۼ��Ͻÿ�. ��, �������� "�а��̸�", "�л��̸�", "���������̸�"���� ��µǵ��� �Ѵ�.
SELECT DEPARTMENT_NAME �а��̸�, STUDENT_NAME �л��̸�, PROFESSOR_NAME ���������̸�
FROM TB_DEPARTMENT
    JOIN TB_STUDENT S USING (DEPARTMENT_NO)
    JOIN TB_PROFESSOR ON (S.COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE STUDENT_NO = 'A313047';

-- 12. 2007�⵵�� '�ΰ������' ������ ������ �л��� ã�� �л��̸��� �����б⸦ ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT STUDENT_NAME, TERM_NO
FROM TB_STUDENT
    JOIN TB_GRADE USING(STUDENT_NO)
    JOIN TB_CLASS USING(CLASS_NO)
WHERE SUBSTR(TERM_NO,3,2) = '07' AND CLASS_NAME = '�ΰ������'
ORDER BY STUDENT_NAME;

-- 13. ��ü�� �迭 ���� �� ���� ��米���� �� �� �������� ���� ������ ã�� �� ���� �̸��� �а� �̸��� ����ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
    LEFT JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
    LEFT JOIN TB_CLASS_PROFESSOR USING (CLASS_NO)
WHERE CATEGORY = '��ü��' AND PROFESSOR_NO IS NULL
ORDER BY 1;

-- 14. �� ������б� ���ݾƾ��а� �л����� ���������� �Խ��ϰ��� �Ѵ�. 
-- �л��̸��� �������� �̸��� ã�� ���� ���� ������ ���� �л��� ��� "�������� ������"���� ǥ���ϵ��� �ϴ� SQL������ �ۼ��Ͻÿ�.
-- ��, �������� "�л��̸�", "��������"�� ǥ���ϸ� ���й� �л��� ���� ǥ�õǵ��� �Ѵ�.
SELECT STUDENT_NAME �л��̸�, NVL(PROFESSOR_NAME,'�������� ������') ��������
FROM TB_STUDENT
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    LEFT JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE DEPARTMENT_NAME = '���ݾƾ��а�'
ORDER BY STUDENT_NO;

-- 15. ���л��� �ƴ� �л� �� ������ 4.0 �̻��� �л��� ã�� �� �л��� �й�, �̸�, �а� �̸�, ������ ����ϴ� SQL���� �ۼ��Ͻÿ�. 
SELECT STUDENT_NO, STUDENT_NAME, AVG(POINT)
FROM TB_GRADE
    JOIN TB_STUDENT USING(STUDENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME
HAVING AVG(POINT) >= 4.0
ORDER BY 1;

-- 16. ȯ�������а� ����������� ���� �� ������ �ľ��� �� �ִ� SQL���� �ۼ��Ͻÿ�. 
SELECT CLASS_NO, CLASS_NAME, ROUND(AVG(POINT),6) "AVG(POINT)"
FROM TB_CLASS
    JOIN TB_GRADE USING (CLASS_NO)
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE CLASS_TYPE LIKE '%����%' AND DEPARTMENT_NAME = 'ȯ�������а�'
GROUP BY CLASS_NO, CLASS_NAME
ORDER BY 1;

-- 17. �� ������б��� �ٴϰ� �ִ� �ְ��� �л��� ���� �� �л����� �̸��� �ּҸ� ����ϴ� SQL���� �ۼ��Ͻÿ�.
SELECT STUDENT_NAME, STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO
                        FROM TB_STUDENT
                        WHERE STUDENT_NAME = '�ְ���');

-- 18. ������а����� �� ������ ���� ���� �л��� �̸��� �й��� ǥ���ϴ� SQL���� �ۼ��Ͻÿ�.
-- ���� : ������а����� ����� ���� ������ ������ �ϱ�
SELECT DEPARTMENT_NAME, STUDENT_NAME, AVG(POINT)
FROM TB_GRADE
    JOIN TB_STUDENT USING (STUDENT_NO)
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '������а�'
GROUP BY DEPARTMENT_NAME, STUDENT_NAME 
ORDER BY 3 DESC;

-- ���� : ������а����� ����� ���� ���� �л� �Ѹ� ������ �ϱ�
WITH FUNC AS
(SELECT DEPARTMENT_NAME, STUDENT_NAME, AVG(POINT)
FROM TB_GRADE
    JOIN TB_STUDENT USING (STUDENT_NO)
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '������а�'
GROUP BY DEPARTMENT_NAME, STUDENT_NAME 
ORDER BY 3 DESC)

SELECT DEPARTMENT_NAME, STUDENT_NAME
FROM FUNC
WHERE ROWNUM<2;

-- 19. �� ������б��� "ȯ�������а�"�� ���� ���� �迭 �а����� �а� �� �������� ������ �ľ��ϱ� ���� ������ SQL���� ã�Ƴ��ÿ�.
-- ��, �������� "�迭 �а���", "��������"���� ǥ�õǵ��� �ϰ�, ������ �Ҽ��� �� �ڸ������� �ݿø��Ͽ� ǥ�õǵ��� �Ѵ�.

------------- ���� -----------------
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME = 'ȯ�������а�';

SELECT DISTINCT CLASS_TYPE
FROM TB_CLASS;

------------- ���� ------------------
SELECT DEPARTMENT_NAME "�迭 �а���", ROUND(AVG(POINT),1) "��������"
FROM TB_CLASS
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    JOIN TB_GRADE USING(CLASS_NO)
WHERE CATEGORY = (SELECT CATEGORY
                    FROM TB_DEPARTMENT
                    WHERE DEPARTMENT_NAME = 'ȯ�������а�')
        AND CLASS_TYPE LIKE '%����%'
GROUP BY DEPARTMENT_NAME
ORDER BY 1;