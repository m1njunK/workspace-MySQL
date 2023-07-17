-- ctrl + s , 202230613.sql
/*********************************************
	MySQL 변수 초기화 및 사용
	SET 명령어를 통해 변수 선언
	변수 선언과 동시에 값이 초기화 되어야 함
    -- MySQL 변수는 값이 대입될 때 타입이 결정 되므로
    선언과 동시에 초기화가 되어야 함.
    변수 이름 과 db table등의 식별자와 구분하기 위해서
    변수 이름앞에 @기호를 부여하여 표시
    @ 하나는 사용자 변수, @@ 두개는 시스템 변수
    변수의 값 대입 연산자는	=,	:=	두가지 키워드를 사용
    
*/

SET @myVal1 = 10;
-- SET @myVal2;

SELECT @myVal1 FROM DUAL;

SET @myVal2 = 3;
SET @myVal3 := 3.141592;
SET @myVal4 := '이름 ->';
SET @myVal5 := '문자열';

SELECT @myVal2 + @myVal3 FROM DUAL;		-- 3 + 3.141592
SELECT @myVal5 + @myVal2;				-- 문자열(0) + 3
SELECT @myVal4 + @myVal5;				-- 0 + 0

SELECT @myVal4 , name FROM userTbl WHERE height > 180;

SELECT '32강' + '16강';
SELECT '32강' + '강16';
SELECT @myVal4 + @myVal2;

SELECT concat(@myVal4,@myVal2);
/*********************************************************/
-- MySQL 내장 함수
-- 특정 기능을 수행 할 수 있도록 MySQL에서 미리 만들어 놓은 함수

-- 현재 데이터 베이스와 연결되어 작업을 수행하는 계정
SELECT current_user() FROM DUAL;
SELECT user() FROM DUAL;

-- 문자열 관련된 함수
SELECT 'Welcome to MySQL',
upper('Welcome to MySQL'),		-- 대문자
lower('Welcome to MySQL');		-- 소문자
-- 문자열 길이 - byte 단위
SELECT length('MySQL') , length('마이에스큐엘');

SET @temp = 'Welcom to MySQL';

-- 문자열 추출
-- (문자열, 시작위치, 개수)
SELECT substr(@temp,4,3);
-- 뒤에서 부터
SELECT substr(@temp,-5,5);

USE TESTDB;
--  사원 테이블 검색
SELECT * FROM emp;

-- 사원의 정보를 사원번호, 사원명, 입사년도, 입사 월 로 검색

SELECT empno, ename, substr(hiredate,1,4) AS '입사년',
substr(hiredate,6,2) AS '입사월' FROM emp;

-- 특정 문자의 위치
SELECT instr('WELCOME TO MYSQL','O');
SELECT instr('welcome TO mySQL','O');
SELECT instr('이것이MYSQL이다','이다');


-- 문자열에 공백을 제거 하는 함수 - trim();
SELECT '          MySQL';
SELECT ltrim('         MySQL');
SELECT rtrim('         MySQL          ');

SELECT trim('a' FROM 'aaaaaaaaaaMYSQLalaaa');
SELECT trim(' ' FROM '          MYSQL      ');

-- concat  문자열을 넘겨받은 매개변수들을 묶어서 새로운 문자열 생성

SELECT concat(ename,'은 ',sal,'를 받습니다.') FROM emp
ORDER BY sal DESC;

-- 날짜 시간 관련 함수

-- 현재 날짜와 시간에 대해 알려주는 함수
SELECT
	sysdate(),		-- 년원일 시분초, 함수가 호출 되는 시점의 시간
    now(),			-- 년월일 시분초, 쿼리가 호출 되는 시점의 시간
	curdate(),		-- 날짜 년월일
    curtime(),		-- 시간 시분초
    current_timestamp()		-- 년월일 시분초
FROM DUAL;

SELECT now(), SLEEP(2), now();
SELECT sysdate(), SLEEP(2), sysdate();

-- 특정 기간에 따른 시간 정보 확인
SELECT sysdate() FROM DUAL;

-- 오늘 시간을 기준으로 어제 와 내일 시간 을 계산
-- year, month, day, hour, minute, second
SELECT sysdate() - INTERVAL 1 day AS 어제,
	   sysdate() AS 오늘,
	   sysdate() + INTERVAL 1 day AS 내일;
       
-- 한달전
SELECT sysdate() - INTERVAL 1 month;
-- 1년 전
SELECT sysdate() - INTERVAL 1 year;

-- 날짜 계산 함수
-- date_add(기준시간, 계산시간) , 기준 시간에서 계산시간을 더한시간
SELECT now(),date_add(now(),INTERVAL 1 MINUTE) AS '1분후';

-- date_sub(기준시간, 계산시간) , 기준 시간에서 계산시간을 뺀 시간
SELECT now(),date_sub(now(),INTERVAL 1 MINUTE) AS '1분전';
SELECT now(),date_sub(now(),INTERVAL -1 MINUTE) AS '1분후';

-- 두 시간 사이의 간격(차이)를 계산
-- timestampdiff

SELECT empno, ename, hiredate, now(), timestampdiff(year,hiredate, now()) FROM emp;
SELECT timestampdiff(day,now(),'2023-07-14');

-- 날짜를 형식에 맞는 문자열로 반환하는 함수
-- date_format(기준시간,pattern)
/*
	%Y 4자리 년도		%y 2자리 년도
	%m 숫자 월(2자리)  %c 월(1자리)
	%M 긴 월(영문)		%m 짧은 월(영문)
    %d 일자(두자리)		%e 일자(한자리)
    %W (요일 이름 영문) %a (짧은 영문 요일)
    %I 시간(12)		%H 시간(24)
    %i 분			%S 초
    %r %I%I:%i%i:%S%S AM, PM
    %T %I%I:%i%i:%S%S
*/

SELECT now(), date_format(now(), '%Y/%m/%d');
SELECT now(), date_format(now(), '%Y/%m/%d %T');

/********************************************************
	JOIN - 동일한 또는 서로다른 테이블의 정보를 합쳐서 
		   원하는 정보를 검색하는 것
*/

-- cross join
SELECT * FROM emp, dept;
SELECT count(*) FROM emp;	-- 14
SELECT count(*) FROM dept;	--  4
SELECT count(*) FROM emp,dept; -- 56

DESC emp;
DESC dept;


-- INNER JOIN - 일반적으로 가장 많이 사용되는 형태
-- 기준 테이블과 JOIN 테이블 모두 데이터가 존재해야 조회.
-- cross join과 동일한 형태
SELECT * FROM dept;

SELECT * FROM emp INNER JOIN dept
WHERE emp.deptno = dept.deptno;


