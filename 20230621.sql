-- VIEW, INDEX, PROCEDURE, TRIGGER
/**********************
	VIEW
    가상의 테이블
    - 물리적으로 존재하지 않지만 SELECT 문을 통해 생성된
      구조와 정보를 가지고 있음
	- VIEW 사용
    CREATE VIEW AS SELECT문 - VIEW 객체 생성
***/

use sqldb;
-- emp table 구조 확인
DESC emp;

CREATE VIEW v_emp AS SELECT empno, ename FROM emp;
DESC v_emp;

SELECT * FROM v_emp;

DROP VIEW IF EXISTS v_emp;

-- SELECT 문의 결과를 이름을 가지는 뷰라는 개체로 저장 하여 생성
-- 실제 데이터를 비추는 창문에 비유
-- 검색 된 컬럼으로 데이터를 불러오기 때문에
-- 실제 저장된 테이블의 값을 보호 하는 보안 목적으로 사용
-- 사용자는 사용되고 있는 데이터가 실제 테이블인지
-- 가상의 테이블(VIEW) 인지 구별 하기 힘듦
-- 실제 테이블의 구조를 파악하기 힘들다.

CREATE OR REPLACE VIEW v_usertbl AS
SELECT userID, name FROM userTbl;

SELECT * FROM userTbl;
SELECT * FROM v_usertbl;
DESC v_usertbl;
DESC userTbl;

-- 가상테이블 에서 지정된 속성으로만 DML 사용 가능

INSERT INTO v_usertbl
VALUES('CGG','김판걸',2000,'부산',NULL,NULL,NULL,NULL);

UPDATE v_usertbl SET NAME = '김판걸'
WHERE userID = 'CGG';

SELECT * FROM v_usertbl;
SELECT * FROM usertbl;

UPDATE v_usertbl SET addr = '개성'
WHERE userid = 'CGG';

DELETE FROM v_usertbl WHERE userID = 'CGG';

CREATE OR REPLACE VIEW v_user_buy AS
SELECT * FROM usertbl AS U JOIN buytbl AS B USING(userID);

SELECT * FROM v_user_buy;

rollback;

-- INLINE VIEW
-- VIEW를 미리 정의 하지 않고 검색 쿼리 내에서 정의해서 사용하는 VIEW
-- 서브 쿼리가 FROM 절에서 사용되는 경우
-- 해당 서브 쿼리를 인라인 뷰 라고 함.
-- FROM 절에서 사용된 서브쿼리의 결과가 하나의 테이블에 대한 VIEW 처럼 사용

-- 인라인 뷰를 이용해서 부서별 평균 급여가 2500 이상인 부서의 
-- 부서 번호, 평균 급여를 출력
SELECT * FROM 
(SELECT deptno, AVG(sal) AS '평균급여' FROM emp GROUP BY deptno)
AS temp WHERE 평균급여 >= 2500;

-- 부서별 평균 급여와 급여 등급을 인라인 뷰를 이용해서 출력
SELECT * FROM salgrade;

SELECT E.deptno, E.avgSal, S.grade FROM 
(SELECT deptno, avg(sal) AS avgSal FROM emp GROUP BY deptno) 
AS E , salgrade AS S
WHERE avgSal BETWEEN S.losal AND S.hisal;

-- Question
-- 부서별 평균 급여와 급여 등급을 검색
-- 부서이름, 부서번호, 평균급여, 급여 등급 형식으로 출력

SELECT D.dname, E.deptno, E.avgSal, S.grade FROM
(SELECT deptno, avg(sal) AS 'avgSal' FROM emp GROUP BY deptno) 
E JOIN dept D USING(deptno), 
salgrade S WHERE avgSal BETWEEN S.losal AND S.hisal;

CREATE VIEW avg_group_emp AS
SELECT deptno, avg(sal) AS 'avgSal' FROM emp GROUP BY deptno;

SELECT D.dname, E.deptno, E.avgSal, S.grade FROM 
avg_group_emp E NATURAL JOIN dept D JOIN salgrade S
ON avgSal BETWEEN S.losal AND S.hisal;

/*****************************************************
	INDEX - 색인 목록
    data를 찾기 위한(검색) column 에 부여되는 INDEX
    책의 목차 처럼 해당 column을 기준으로 정렬
    특정 테이블의 특정 컬럼(열)을 지정하여 인덱스를 생성
    지정된 인덱스가 부여된 column으로 검색하면 검색속도가 빨라진다.
    목적은 데이터의 빠른 검색
    
    PRIMARY KEY는 행을 구분하기 위한 column 이므로
    자동으로 INDEX가 생성 부여
    나머지 column이 검색 조건이 된다면 직접 인덱스를 생성 해서 사용
*/

SHOW INDEXES FROM emp;
-- CREATE INDEX 인덱스 이름 ON 테이블이름(column명);
CREATE INDEX indx_emp_sal ON emp(sal);
-- ALTER TABLE `테이블이름` ADD INDEX 인덱스이름(적용할 column 이름);
ALTER TABLE emp ADD INDEX idx_emp_sal(sal);

-- INDEX 삭제
-- DROP INDEX 인덱스 이름 ON db이름.table이름;
DROP INDEX idx_emp_sal ON sqldb.emp;
ALTER TABLE emp DROP INDEX indx_emp_sal;
SHOW INDEXES FROM emp;

use employees;
show tables;
SELECT count(*) FROM employees;
SHOW INDEXES FROM employees;

-- 성별을 기준으로 검색
DESC employees;
SELECT * FROM employees WHERE gender= 'M';
-- 30165.75
CREATE INDEX idx_emp_gender ON employees(gender);
-- 15663.45

-- 인덱스는 모든 컬럼에 생성하는 것이 좋지 않음
-- 저장공간 차지
-- 인덱스가 생성된 컬럼에 삽입 삭제 수정 작업이 일어나면
-- 인덱스 정보를 새로 생성해야 하기 때문에 성능이 저하됨
-- 검색에 자주 사용되는 컬럼에만 생성
-- 데이터 변경이 자주 일어나지 않는 테이블에 생성해 주는게 유리

/*********************************************************
	저장 프로시저(Stored Procedure)
    -- 여러개의 쿼리 혹은 동작을 프로시저라는 개체로 묶어서 저장
    -- 프로시저 이름을 통해서 작동 시키므로 내부의 쿼리를 숨길 수 있음.
    -- 작성된 procedure는 CALL 이라는 예약어를 통해서 호출(사용)
*/
use sqldb;
SELECT * FROM emp;
SELECT * FROM dept;

/****************************************************
	-- procedure 생성 방법
    DELIMITER //
    CREATE PROCEDURE 프로시저이름(매개변수...)
		BEGIN
			-- 실행할 내용
		END //
	DELIMETER ;

    -- 실행
    CALL 프로시저이름(인자값...)
*****************************************************/

DELIMITER //
	CREATE PROCEDURE readEmp()
		BEGIN
			SELECT * FROM emp;
        END //
DELIMITER ;


CALL readEmp();

-- 매개변수를 넘겨받는 프로시저
DELIMITER $$
	 CREATE PROCEDURE info_emp(IN _empno INT)
        BEGIN
			SELECT * FROM emp WHERE empno = _empno;
        END $$
DELIMITER ;

CALL info_emp(7902);

-- Question - procedure 이름은 : info_sal_oval
-- 급여를 정수로 입력받아
-- 전달된 급여 이상의 급여를 받는 사원의
-- 사원번호, 이름, 입사일, 급여 를 검색하는 프로시저 생성

DELIMITER $$
USE `testdb` $$
	CREATE PROCEDURE `info_sal_oval`(IN _sal INT)
		BEGIN
			SELECT empno,ename,hiredate,sal FROM emp WHERE _sal <= sal; 
        END $$
DELIMITER ;

CALL info_sal_oval(1500);

-- usertbl
-- 회원 이름을 입력받아서
-- 회원의 나이에 따라 1980년 이전 출생 자이면
-- 나이가 지긋하시네요
-- 1981년 이후 출생은 아직 젊으시네요
-- 라고 출력하는 프로시저 생성

USE sqldb;
desc usertbl;

DELIMITER $$
USE `sqldb` $$
	CREATE PROCEDURE `checkYear`(IN uname VARCHAR(10))
	BEGIN
		-- 정수값을 저장하는 변수 yearBirth 선언
		DECLARE yearBirth INT;
        
        SELECT birthyear INTO yearBirth FROM usertbl WHERE name = uname;
        
        -- 조건문
        IF(yearBirth >= 1981) THEN
			SELECT '아직 젊으시네요...' AS ANSWER;
        ELSE
			SELECT '나이가 지긋하시네요' AS ANSWER;
        END IF;
	END $$
DELIMITER ;

SELECT * FROM usertbl;
CALL checkYear('김범수');

-- 반복문
-- procedure roof
-- 구구단의 단수를 입력받아 해당 단수를 출력하고
-- table에 문자열로 저장
CREATE TABLE temp_tbl(
	txt TEXT -- TEXT는 대용량의 문자열
);

DELIMITER $$
	CREATE PROCEDURE whileTest(IN num INT)
	BEGIN
		DECLARE str VARCHAR(100); -- 각 단을 문자열로 저장
        DECLARE i INT;			  -- 1~9까지 구구단 변화되는 값
        SET str ='';
        SET i = 1;
        WHILE(i < 10) DO	-- WHILE(탈출 조건) DO -- 실행
			-- 반복 수행 작업
            SET str = concat(str,' ',num,'X',i,'=',num*i);
            INSERT INTO temp_tbl VALUES(str);
            SELECT str AS RESULT;	-- 문자열 출력
            SET i = i + 1;
        END WHILE; -- WHILE 종료
	END $$
DELIMITER ;

CALL whileTest(5);

SELECT * FROM temp_tbl;

CREATE TABLE member_tbl(
	num INT PRIMARY KEY AUTO_INCREMENT,		-- 회원번호
    id VARCHAR(100) UNIQUE,					-- 사용자 id
    pw VARCHAR(100) NOT NULL,				-- 사용자 비밀번호
	name VARCHAR(10),						-- 이름
    regdate TIMESTAMP DEFAULT now()			-- 회원 등록일
);

INSERT INTO member_tbl(id,pw,name)
VALUES('id001','pw001','최기근');

INSERT INTO member_tbl(id,pw,name)
VALUES(null,'pw002','김판걸');
-- 가장 최근에 생성된 AUTO_INCREMENT PRIMARY KEY 값 반환
SELECT LAST_INSERT_ID();

UPDATE member_tbl SET id = 'id002'
WHERE num = LAST_INSERT_ID();

SELECT * FROM member_tbl;

-- 매개변수로 id , pw 넘겨받아서
-- 아이디와 패스워드가 일치하는 사용자가 존재하면 true
-- 존재하지 않으면 false 전달

DELIMITER $$
CREATE PROCEDURE loginCheck(
	IN _id VARCHAR(50),
    IN _PW VARCHAR(50),
	OUT answer BOOLEAN
)
BEGIN
	-- 검색 결과를 문자열로 저장할 변수
    DECLARE result VARCHAR(50);
	SET RESULT = (
		SELECT id FROM member_tbl
        WHERE id = _id AND pw = _PW
    );

	IF(result IS NOT NULL) THEN
		SELECT TRUE INTO answer;
    ELSE 
		SELECT FALSE INTO answer;
	END IF;
END $$
DELIMITER ;

CALL loginCheck('id001','pw001',@answer);
-- 0 false , 1 true
SELECT @answer FROM DUAL;
CALL loginCheck('id005','pw005',@answer);
SELECT @answer;

SHOW PROCEDURE STATUS;
SHOW PROCEDURE STATUS WHERE db = 'sqldb';

-- PROCEDURE 삭제
DROP PROCEDURE `whileTest`;

/**************************************************
	저장 함수(Stored Functions)
    사용자가 정의하여 사용하는 함수
    저장 프로시저와 유사하나 결과값을 반환한다는 개념이 틀림

	SELECT INTO 와 같이 집한된 결과를 반환
    DELIMITER $$
		CREATE FUNCTION 함수이름(매개변수...)
        RETURNS 반환타입
        BEGIN
			--	실행 내용 작성
            RETURN 결과값;
        END $$
    DELIMITER ;
*/

-- 함수 생성 가능 여부 확인
SHOW GLOBAL VARIABLES LIKE 'log_bin_trust_function_creators';
-- 1 : ON(true), 0 : OFF(false)
SET GLOBAL log_bin_trust_function_creators = 1;


DELIMITER $$
	CREATE FUNCTION sumFunc(value1 INT, value2 INT)
    RETURNS INT
    BEGIN
		RETURN value1 + value2;
    END $$
DELIMITER ;

SELECT sumFunc(100,300) FROM DUAL;
-- 출생년도를 입력받아 현재 나이를 반환
DELIMITER //
	CREATE FUNCTION getAge(yearBirth INT)
		RETURNS INT
		BEGIN
			DECLARE age INT;
            SET age = year(curdate()) - yearBirth;
			RETURN age;
		END //
DELIMITER ;

SELECT getAge(1996);

SELECT getAge(1990) INTO @age1990;
SELECT @age1990;

SELECT userID, name, birthYear, getAge(birthYear) AS '나이' 
FROM userTbl;
-- 현재 database에 저장된 저장 함수 검색
SHOW FUNCTION STATUS WHERE db = 'sqldb';

-- FUNCTION 삭제
DROP FUNCTION sumFunc;

/******************************************************************
	TRIGGER - 트리거
    특정 테이블에 INSERT, UPDATE, DELETE 같은 변경 작업이
    수행되었을 때를 전후로 하여 등록된 Query 문을 자동으로 수행하도록
	작성된 프로그램.
    한번 지정해놓으면 호출해서 사용하는 것이 아닌 데이터베이스에 의해서
    자동으로 호출되는 것이 특징.
    DML의 transcation과 주기를 같이 한다.
	
    DELIMITER $$
		CREATE TRIGGER trigger_name
			{BEFORE | AFTER}
			{INSERT | UPDATE | DELETE}
            ON table_name FOR EACH ROW
            BEGIN 
				-- 트리거에 실행될 내용
            END $$
    DELIMITER ;
*/

DELIMITER //
	CREATE TRIGGER test_trg 	-- 트리거 이름
	AFTER INSERT 				-- 삽입 이후에 실행
    ON member_tbl FOR EACH ROW  -- 트리거가 수행될 테이블 지정
BEGIN
	SET @result = 'member insert';
END //
DELIMITER ;

SET @result = '';
SELECT @result;
INSERT INTO member_tbl(id,pw,name)
VALUES('id1005','pw005','이이인');
SELECT @result;
UPDATE member_tbl SET name = '이윤서'
WHERE id = 'id1005';
-- member_tbl과 구조만 동일 테이블 생성
CREATE TABLE back_member_tbl LIKE member_tbl;
DESC back_member_tbl;

-- member_tbl 에서 회원정보가 삭제 되고 난 후 
-- back_member_tbl에 삭제된 회원 정보 저장

DELIMITER $$
	CREATE TRIGGER backup_trg
	AFTER DELETE 
    ON member_tbl FOR EACH ROW
BEGIN
	-- OLD UPDATE DELETE - 변경된 기존 정보
	-- NEW UPDATE INSERT - 새롭게 추가된 정보
    INSERT INTO back_member_tbl(num,id,pw,name,regdate)
    VALUES(OLD.num, OLD.id, OLD.pw, OLD.name, OLD.regdate);
END $$
DELIMITER ;

SELECT * FROM back_member_tbl;
SELECT * FROM member_tbl;
rollback;
DELETE FROM member_tbl WHERE num = 3;

commit;

SELECT * FROM member_tbl;
SELECT YEAR(now());
SELECT MONTH(now());
SELECT DAY(now()); 

DESC usertbl;

DELIMITER //
	CREATE TRIGGER before_usertbl
    BEFORE INSERT
    ON usertbl FOR EACH ROW
BEGIN
	-- OLD UPDATE DELETE - 변경된 기존 정보
	-- NEW UPDATE INSERT - 새롭게 추가된 정보
    IF NEW.birthyear < 1900 THEN
		SET NEW.birthyear = 0;
	ELSEIF NEW.birthyear > year(now()) THEN
		SET NEW.birthYear = Year(now());
    END IF;
END //
DELIMITER ;

DESC usertbl;
INSERT INTO usertbl
VALUES('LJH','이진횽',1880,'개성',null,null,158,curdate());
SELECT * FROM usertbl WHERE userID = 'LJH';

INSERT INTO usertbl
VALUES('KSY','김선영',2440,'LA',null,null,158,curdate());
SELECT * FROM usertbl WHERE userID = 'KSY';

INSERT INTO usertbl
VALUES('LI','이인',2000,'홍콩',null,null,158,curdate());
SELECT * FROM usertbl WHERE userID = 'LI';