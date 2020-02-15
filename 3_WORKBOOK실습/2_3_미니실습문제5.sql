-- 1. 과목유형 테이블(TB_CLASS_TYPE)에 아래와 같은 데이터를 입력하시오.
INSERT INTO TB_CLASS_TYPE VALUES(01, '전공필수');
INSERT INTO TB_CLASS_TYPE VALUES(02, '전공선택');
INSERT INTO TB_CLASS_TYPE VALUES(03, '교양필수');
INSERT INTO TB_CLASS_TYPE VALUES(04, '교양선택');
INSERT INTO TB_CLASS_TYPE VALUES(05, '논문지도');

SELECT * FROM TB_CLASS_TYPE;

-- 2. 춘 기술대학교 학생들의 정보가 포함되어 있는 학생일반정보 테이블을 만들고자 한다. 아래 내용을 참고하여 적적한 SQL문을 작성하시오. (서브쿼리를 이용하시오)
-- 테이블 이름 : TB_학생일반정보
-- 컬럼 : 학번, 학생이름, 주소
CREATE TABLE TB_학생일반정보
AS SELECT STUDENT_NO 학번, STUDENT_NAME 학생이름, STUDENT_ADDRESS 주소
    FROM TB_STUDENT;
    
SELECT * FROM TB_학생일반정보;

-- 3. 국어국문학과 학생들의 정보만이 포함되어 있는 학과정보 테이블을 만들고자 한다. 아래 내용을 참고하여 적절한 SQL문을 작성하시오.
--  (힌트 : 방법은 다양함, 소신껏 작성하시오)
-- 테이블 이름 : TB_국어국문학과 
-- 컬럼 : 학번, 학생이름, 출생년도 (단, 네자리 년도로 포기), 교수이름
CREATE TABLE TB_국어국문학과
AS SELECT STUDENT_NO 학번, STUDENT_NAME 학생이름,
            EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN,1,2),'RR')) 출생년도, PROFESSOR_NAME 교수이름
    FROM TB_STUDENT TS
        LEFT JOIN TB_PROFESSOR ON(COACH_PROFESSOR_NO = PROFESSOR_NO)
        LEFT JOIN TB_DEPARTMENT TD ON(TS.DEPARTMENT_NO = TD.DEPARTMENT_NO)
    WHERE DEPARTMENT_NAME = '국어국문학과';
    
SELECT * FROM TB_국어국문학과;

-- 4. 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용할 SQL문을 작성하시오. (단, 반올림을 사용하여 소수점 자리는 생기지 않도록 한다.)
SELECT DEPARTMENT_NO 학과번호, DEPARTMENT_NAME 학과명, CAPACITY 기존정원수, ROUND(CAPACITY * 1.1) 증가전원수
FROM TB_DEPARTMENT;

-- 5. 학번 A413042인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21"로 변경되었다고 한다. 주소지를 정정하기 위해 사용할 SQL문을 작성하시오.
SELECT * FROM TB_STUDENT WHERE STUDENT_NO = 'A413042';

UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE STUDENT_NO = 'A413042';

-- 6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로 결정하였다. 이 내용을 반영할 적절한 SQL 문장을 작성하시오.
--  (예. 830530-2124663  => 830503)
UPDATE TB_STUDENT
SET STUDENT_SSN = SUBSTR(STUDENT_SSN, 1, 6);

SELECT * FROM TB_STUDENT;

-- 7. 의학과 김명훈 학생은 2005년 1학기에 자신이 수강한 '피부생리학' 점수가 잘못되었다는 것을 발견하고는 정정을 요청하였다.
--  담당 교수의 확인 받은 결과 해당 과목의 학점을 3.5로 변경키로 결정되었다. 적적한 SQL문을 작성하시오.
-- 김명훈 학생의 원 점수
SELECT STUDENT_NAME, TERM_NO, DEPARTMENT_NAME, CLASS_NO, CLASS_NAME, POINT
FROM TB_STUDENT
    LEFT JOIN TB_GRADE USING(STUDENT_NO)
    LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    LEFT JOIN TB_CLASS USING(CLASS_NO)
WHERE STUDENT_NAME = '김명훈' AND DEPARTMENT_NAME = '의학과' AND CLASS_NAME = '피부생리학';

COMMIT;

-- 결과
UPDATE TB_GRADE
SET POINT = 3.5
WHERE CLASS_NO = (SELECT CLASS_NO
                  FROM TB_STUDENT
                     LEFT JOIN TB_GRADE USING(STUDENT_NO)
                     LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
                     LEFT JOIN TB_CLASS USING(CLASS_NO)
                  WHERE STUDENT_NAME = '김명훈' AND DEPARTMENT_NAME = '의학과' AND CLASS_NAME = '피부생리학')
     AND STUDENT_NO = (SELECT STUDENT_NO
                        FROM TB_STUDENT
                            LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
                        WHERE STUDENT_NAME = '김명훈' AND DEPARTMENT_NAME = '의학과');
                        
-- 8. 성적 테이블(TB_GRADE)에서 휴학생들의 성적항목을 제거하시오.
-- 연습 : 휴학생들의 학기, 학번, 학생이름, 수업번호, 성적, 휴학여부 조회
SELECT TERM_NO, STUDENT_NO, STUDENT_NAME, CLASS_NO, POINT, ABSENCE_YN
FROM TB_GRADE
    LEFT JOIN TB_STUDENT USING(STUDENT_NO)
ORDER BY ABSENCE_YN DESC;

COMMIT;

UPDATE TB_GRADE
SET POINT = NULL
WHERE STUDENT_NO IN (SELECT STUDENT_NO FROM TB_STUDENT WHERE ABSENCE_YN = 'Y');