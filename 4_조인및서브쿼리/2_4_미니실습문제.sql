-- 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 이름과, 주민번호, 부서명, 직급 조회
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN JOB USING (JOB_CODE)
WHERE SUBSTR(EMP_NO,1,1) = 7 AND SUBSTR(EMP_NO, 8 ,1) = 2 AND EMP_NAME LIKE '전%';

-- 가장 막내의 사원 코드, 사원 명, 나이, 부서 명, 직급 명 조회
------ 연습 ----------
SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(TO_NUMBER(SUBSTR(EMP_NO,1,2)),'RR')) 만나이
FROM EMPLOYEE;

SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(TO_NUMBER(SUBSTR(EMP_NO,1,2)),'RR'))) 최소만나이
FROM EMPLOYEE;
------- 실전 ---------
SELECT EMP_ID, EMP_NAME, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(TO_NUMBER(SUBSTR(EMP_NO,1,2)),'RR')) + 1 나이,
        DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN JOB USING(JOB_CODE)
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(TO_NUMBER(SUBSTR(EMP_NO,1,2)),'RR')) + 1
        = (SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(TO_NUMBER(SUBSTR(EMP_NO,1,2)) ,'RR')) + 1) 
                FROM EMPLOYEE);

-- 이름에 ‘형’이 들어가는 사원의 사원 코드, 사원 명, 직급 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE)
WHERE EMP_NAME LIKE '%형%';

-- 부서 코드가 D5이거나 D6인 사원의 사원 명, 직급, 부서 코드, 부서 명 조회
SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE IN ('D5', 'D6');

-- 보너스를 받는 사원의 사원 명, 보너스, 부서 명, 지역 명 조회
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;

-- 사원 명, 직급, 부서 명, 지역 명 조회
SELECT EMP_NAME, JOB_CODE, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- 한국이나 일본에서 근무 중인 사원의 사원 명, 부서 명, 지역 명, 국가 명 조회
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
    JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_CODE = 'KO' OR NATIONAL_CODE = 'JP';

-- 한 사원과 같은 부서에서 일하는 사원의 이름 조회 ------- ** 어려웠음 **
SELECT E.EMP_NAME, E.DEPT_CODE, M.EMP_NAME
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.DEPT_CODE = M.DEPT_CODE
        AND E.EMP_NAME != M.EMP_NAME
ORDER BY 1;       

SELECT D.EMP_NAME, E.DEPT_CODE, E.EMP_NAME
FROM EMPLOYEE E
    JOIN EMPLOYEE D ON(E.DEPT_CODE = D.DEPT_CODE)
WHERE E.EMP_NAME != D.EMP_NAME
ORDER BY 1;

-- 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 이름, 직급, 급여 조회 (NVL 이용)
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE BONUS IS NULL AND  JOB_CODE IN('J4','J7');
-- WHERE NVL(BONUS, 0) = 0 AND JOB_CODE IN ('J4', 'J7');

-- 직원 테이블에서 보너스 포함한 연봉이 높은 5명의
-- 사번, 이름, 부서명, 직급명, 입사일을 조회하세요
WITH SAL AS
(SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN JOB USING(JOB_CODE)
ORDER BY SALARY*(1+NVL(BONUS,0))*12 DESC)

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, ROWNUM 순위
FROM SAL
WHERE ROWNUM <=5;

-- 부서별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명과, 부서별 급여 합계 조회
----------- 연습 ---------------
-- 부서별 급여 합계
SELECT SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 전체 급여 총 함의 20%
SELECT SUM(SALARY) * 0.2
FROM EMPLOYEE;

-- 1) having 사용
------------- 실제 --------------- 
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (SELECT SUM(SALARY) * 0.2 FROM EMPLOYEE);

-- 2) 인라인 뷰 사용
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE;

SELECT DEPT_TITLE, 총합
FROM (SELECT DEPT_TITLE, SUM(SALARY) 총합
        FROM EMPLOYEE
            LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        GROUP BY DEPT_TITLE)
WHERE 총합 > (SELECT SUM(SALARY) * 0.2 FROM EMPLOYEE);

-- 3) WITH 사용--
WITH SAL AS
(SELECT DEPT_TITLE, SUM(SALARY) 총합
 FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 GROUP BY DEPT_TITLE)
 
SELECT DEPT_TITLE, 총합
FROM SAL
WHERE 총합 > (SELECT SUM(SALARY) * 0.2 FROM EMPLOYEE);