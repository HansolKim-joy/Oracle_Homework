-- 1. ������а�(�а��ڵ� 002) �л����� �й��� �̸�, ���� �⵵�� ���� �⵵�� ���� ������ ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
-- (��, ����� "�й�", "�̸�", "���г⵵"�� ǥ�õǵ��� �Ѵ�.)
SELECT STUDENT_NO �й�, STUDENT_NAME �̸�, ENTRANCE_DATE ���г⵵
FROM TB_STUDENT
WHERE DEPARTMENT_NO = 002
ORDER BY ENTRANCE_DATE;

-- 2.�� ������б��� ���� �� �̸��� �� ���ڰ� �ƴ� ������ �� �� �ִٰ� �Ѵ�. �� ������ �̸��� �ֹι�ȣ���� ȭ�鿡 ����ϴ� SQL ������ �ۼ��غ���.
--  (* �̶� �ùٸ��� �ۼ��� SQL������ ��� ���� ����� �ٸ��� ���� �� �ִ�. ������ �������� �����غ� ��)
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';

-- 3. �� ������б��� ���� �������� �̸��� ���̸� ����ϴ� SQL ������ �ۼ��Ͻÿ�. ��, �̶� ���̰� ���� ������� ���� ��� ������ ȭ�鿡 ��µǰ� ����ÿ�.
--  (��, ���� �� 2000�� ���� ����ڴ� ������ ��� ����� "�����̸�", "����"�� �Ѵ�. ���̴� '��'���� ����Ѵ�.)
SELECT PROFESSOR_NAME �����̸�, EXTRACT(YEAR FROM SYSDATE) - TO_NUMBER(CONCAT(19, SUBSTR(PROFESSOR_SSN,1,2))) ����
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN,8,1) = 1
ORDER BY EXTRACT(YEAR FROM SYSDATE) - TO_NUMBER(CONCAT(19, SUBSTR(PROFESSOR_SSN,1,2)));

-- 4. �������� �̸� �� ���� ������ �̸��� ����ϴ� SQL ������ �ۼ��Ͻÿ�. ��� ����� "�̸�"�� �������� �Ѵ�.
-- (���� 2���� ������ ���ٰ� �����Ͻÿ�)
SELECT SUBSTR(PROFESSOR_NAME,2,2) �̸�
FROM TB_PROFESSOR;

-- 5. �� ������б��� ����� �����ڸ� ���Ϸ��� �Ѵ�. ��� ã�Ƴ� ���ΰ�? �̶�, 19�쿡 �����ϸ� ����� ���� ���� ������ �����Ѵ�.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM (TO_DATE(TO_CHAR(SUBSTR(STUDENT_SSN,1,2)),'RRRR'))) > 19; 

-- 6. 2020�� ũ���������� ���� �����ΰ�?
SELECT TO_CHAR(TO_DATE(201225,'RRMMDD'),'DAY')
FROM DUAL;

-- 7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD')�� ���� �� �� �� �� �� ���� �ǹ��ұ�? 
--  (��, TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD')�� ���� �� �� �� �� ������ �ǹ��ұ�?)
SELECT EXTRACT(YEAR FROM TO_DATE('99/10/11','YY/MM/DD'))
FROM DUAL;
-- 2099�� 10�� 11���� �ǹ�
SELECT EXTRACT(YEAR FROM TO_DATE('49/10/11','YY/MM/DD'))
FROM DUAL;
-- 2049�� 10�� 11���� �ǹ�
-- => YY�� ��� �⵵�� ���� ����(21����) �������� �����־� 2000���� �����ϰ� �ȴ�

SELECT EXTRACT(YEAR FROM TO_DATE('99/10/11','RR/MM/DD'))
FROM DUAL;
-- 1999�� 10�� 11���� �ǹ�
SELECT EXTRACT(YEAR FROM TO_DATE('49/10/11','RR/MM/DD'))
FROM DUAL;
-- 2049�� 10�� 11���� �ǹ�
-- => RR�� 50���� �������� 50�⺸�� �̻��� ���� �� ����(20����), 50�⺸�� �̸��� ���� ���� ����(21����) �������� �����ش�.

-- 8. �� ������б��� 2000 �⵵ ���� �����ڵ��� �й��� A�� �����ϰ� �Ǿ��ִ�. 2000�⵵ ���� �й��� ���� �л����� �й��� �̸��� �����ִ� SQL ������ �ۼ��Ͻÿ�.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE 'A%';

-- 9. �й��� A517178�� �ѾƸ� �л��� ���� �� ����� ���ϴ� SQL���� �ۼ��Ͻÿ�. 
--  (��, �̶� ��� ȭ���� ����� "����"�̶�� ������ �ϰ�, ������ �ݿø��Ͽ� �Ҽ��� ���� ���ڸ������� ǥ���Ѵ�.)
SELECT ROUND(AVG(POINT),1)
FROM TB_GRADE
    JOIN TB_STUDENT USING(STUDENT_NO)
WHERE STUDENT_NO = 'A517178';

-- 10. �а��� �л����� ���Ͽ� "�а���ȣ", "�л���(��)"�� ���·� ����� ����� ������� ��µǵ��� �Ͻÿ�.
SELECT DEPARTMENT_NO �а���ȣ, COUNT(*) "�л���(��)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

-- 11. ���� ������ �������� ���� �л��� ���� �� �� ���� �Ǵ��� �˾Ƴ��� SQL���� �ۼ��Ͻÿ�.
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

-- 12. �й��� A112113�� ���� �л��� �⵵ �� ������ ���ϴ� SQL���� �ۼ��Ͻÿ�. 
-- ��, �̋� ��� ȭ���� ����� "�⵵", "�⵵ �� ����" �̶�� ������ �ϰ�, ������ �ݿø��Ͽ� �Ҽ��� ���� �� �ڸ������� ǥ���Ѵ�.
SELECT EXTRACT(YEAR FROM ENTRANCE_DATE)
FROM TB_STUDENT
WHERE STUDENT_NO = 'A112113';

SELECT MAX(TERM_NO)
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113';

-- 1) CASE WHEN ���
SELECT CASE WHEN TERM_NO LIKE '2001%' THEN 2001
            WHEN TERM_NO LIKE '2002%' THEN 2002
            WHEN TERM_NO LIKE '2003%' THEN 2003
            ELSE 2004
        END "�⵵",
        ROUND(AVG(POINT),1) "�⵵ �� ����"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY CASE WHEN TERM_NO LIKE '2001%' THEN 2001 
                WHEN TERM_NO LIKE '2002%' THEN 2002 
                WHEN TERM_NO LIKE '2003%' THEN 2003 
                ELSE 2004 
        END
ORDER BY �⵵;

-- �ٸ� ���
SELECT SUBSTR(TERM_NO,1,4) �⵵, ROUND(AVG(POINT),1) "�⵵ �� ����"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO,1,4)
ORDER BY �⵵;

-- 13. �а� �� ���л� ���� �ľ��ϰ��� �Ѵ�. �а� ��ȣ�� ���л� ���� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT DEPARTMENT_NO, COUNT(DECODE(ABSENCE_YN,'Y',1))
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

-- 14. �� ���б��� �ٴϴ� �������� �л����� �̸��� ã���� �Ѵ�. � SQL������ ����ϸ� �����ϰڴ°�?
SELECT STUDENT_NAME, COUNT(*)
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(*) > 1
ORDER BY STUDENT_NAME;

-- 15. �й��� A112113�� ���� �л��� �⵵, �б� �� ������ �⵵ �� ���� ����, �� ������ ���ϴ� SQL���� �ۼ��Ͻÿ�.
--  (��, ������ �Ҽ��� 1�ڸ������� �ݿø� �Ͽ� ǥ���Ѵ�.)
SELECT SUBSTR(TERM_NO, 1, 4) �⵵, SUBSTR(TERM_NO, 5, 2) �б�, ROUND(AVG(POINT),1) ����
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO,1,4), SUBSTR(TERM_NO, 5, 2))
ORDER BY SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5, 2);

