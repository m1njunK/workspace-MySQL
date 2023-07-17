-- 한줄 주석
/*
	DATABASE TABLE 에 정의 데이터를 조작하는 조작어(DML)
    SELECT 검색 질의로 따로 빼기도 함.
    - 테이블에 저장된 실제 데이터를 조작(추가,수정,삭제)
    INSERT UPDATE DELETE

*/

-- 특정 테이블의 정보를 검색-추출 하는 명령어 SELECT
use employees; -- 사원 정보를 저장하는 DataBase
show tables;
-- titles table의 모든 속성과 행 정보를 검색
-- SELECT 검색할 속성 FROM table명;
SELECT * FROM titles;

DESC titles;

-- 사원 테이블의 구조
DESC employees;

SELECT first_name, last_name FROM employees;

-- emp 테이블의 회원 정보들 중에 사원 이름, 성별을 검색
SELECT first_name AS '이름', last_name AS '성', gender AS '성별' FROM employees;

use sqlDB;
show tables;
DESC usertbl;

-- userTbl에 등록된 회원 이름 검색
SELECT name AS '이름' FROM userTbl;

-- userTbl 테이블 에서
-- mDate, name userId 열을 순서대로 검색
DESC userTbl;
SELECT mDate, name, userID From userTbl;

-- sqlDB의 userTbl 테이블에서
-- userID는 아이디로 name은 이름으로 mDate는 가입일로
-- 별칭을 사용하여 검색

SELECT userID AS '아이디', name "이름", mDate AS 가입일 FROM userTbl;

-- table에 행의 값을 삽입하는 INSERT 문
-- 행의 데이터를 추가하는 거기 때문에 필수 값 전체가 필요

SELECT * FROM buytbl;

-- userTbl에 회원 정보 추가
-- INSERT INTO `table명` VALUES(속성값,속성값...);
-- INSERT INTO usertbl VALUES('KMJ','김민준',1996,'부산',010,64491630,180,20230607);
INSERT INTO usertbl VALUES('HGD','홍길동',1000,'한양','010','00000000',176,20130505);
DESC userTbl;
SELECT * FROM usertbl;

DESC buytbl;
-- 홍길동 구매 목록 추가
INSERT INTO buytbl VALUES(null,'HGD','컴퓨터',null,500,2);
SELECT * FROM buytbl;
INSERT INTO buytbl(userid,prodname,price,amount) VALUES('HGD','세탁기',1000,5);

-- num field의 기본 키 값이 중복됨으로 오류 발생
INSERT INTO buytbl VALUES(1,"KBS","티셔츠","의류",30,1);

-- 키가 중복이 되면 현재 INSERT 문을 실행하지 않고 무시한다.
INSERT IGNORE INTO buytbl VALUES(1,"KBS","티셔츠","의류",30,1);

SELECT * FROM buyTbl;
-- REPLACE INTO
-- 키가 중복이 되면 기존데이터를 삭제하고 새로운 데이터 추가
-- 키가 중복 되지 않으면 새로운 행을 추가
REPLACE INTO buytbl VALUES(1,"KBS","티셔츠","의류",30,1);

-- SELECT * FROM buyTbl WHERE userid = 'KBS';

-- 다중행 삽입
INSERT INTO buytbl(userId,prodname,groupname,price,amount)
VALUES
	('KBS','티셔츠','의류',30,3),
    ('KBS','모니터','전자',150,1);

/*
	테이블의 특정 행의 속성(열) 값을 변경(수정)
    UPDATE 문
    UPDATE `table명` SET `수정할 속성이름` = 변경할 값
    WHERE `수정할 행 구분 열이름` = 수정할 행 구분 열럼 값
*/

-- buyTbl 테이블의 모니터 가격을 250로 변경
SELECT * FROM buytbl;
UPDATE buytbl SET price = 250 WHERE prodname = '모니터';

/*

	TCL(Transaction Control Language)
    - 논리 적인 작업 단위를 묶어서 DML에 의해 조작된 결과를 작업단위(Transaction) 별로 제어하는 명령어
    - commit; 현 Session에서 실행된 작업을 적용
    - rollback; 현 Session에서 실행된 작업을 이전 commit; 시점으로 돌림

*/

SELECT @@autocommit;
-- 자동 commit 설정 정보
-- 1 : autocommit;
-- 0 : 자동으로 commit 설정 해제;

-- auto commit 설정 변경

SET @@autocommit := 0; -- 0 or 1

-- test용 sample table 생성
-- table 복제
-- buytbl table의 열 속성과 행정보를 이용하여 새로운 테이블 생성
CREATE TABLE buytbl2(SELECT * FROM buytbl);

SELECT * FROM buytbl2;

-- buytbl2 테이블의 모든행의 price 속성값을 0으로 수정
UPDATE  buytbl2 SET price = 0;
rollback;

-- 기존에 상품 가격을 전부 50씩 증가
UPDATE buytbl2 SET price = price + 50;
SELECT * FROM buytbl2;
commit; -- transacation 종료
-- 새로운 작업 transcation 생성
rollback;

UPDATE buytbl2 SET price = price + 100;

-- DML(SELECT INSERT UPDATE DELETE)를 제외한
-- DDL DCL은 단일 transcation 수행
-- 명령문이 수행되면 자동으로 commit; 되므로
-- transcation 작업 수행 시 조심

Create TABLE buytbl3(
	SELECT * FROM buytbl
);

SELECT * FROM buytbl3;

-- buytbl3 의 상품 중 '청바지'의 가격을 60으로 변경하고 판매개수를 5로 변경
UPDATE buytbl3 SET price = 60, amount = 5 WHERE prodname = '청바지';

SELECT * FROM buytbl3;

/*
	table에 삽입되어 있는 행의 정보를 삭제하는 DELETE문    
	DELETE FROM `삭제작업을 진행할 table`
    OPTIONAL
    WHERE 삭제할 행의 컬럽 = `비교할 값`
*/

DELETE FROM buytbl2; -- 전체 삭제
SELECT * FROM buytbl2;
rollback;

DELETE FROM buytbl2 WHERE userid = 'BBK';

/*
	저장된 데이터(table)에서 필요한 정보를 추출
    SELECT ~ FROM ~ WHERE 조건절
*/
-- usertbl table에 저장된 사용자 중에 이름이 '김경호'인 사용자의 정보 검색

SELECT * FROM usertbl WHERE name = '김경호';

-- userTbl 에서 1970년 이후에 출생하고 키가 182 이상인 사람의 아이디와 이름을 검색

SELECT userID,name,birthyear,height FROM usertbl WHERE birthyear >= 1970 and height >= 182;

-- userTbl 에서 1970년 이후에 출생 했거나 키가 182 이상인 사람의 정보를 검색
SELECT userID,name,birthyear,height FROM usertbl WHERE birthyear >= 1970 or height >= 182;

-- userTbl에서 키가 180 이상, 183 이하인 사람을 검색
SELECT * FROM usertbl WHERE height >= 180 and height <= 183;

-- BTWEEN AND 절 - 범위 검색
SELECT * FROM usertbl WHERE height BETWEEN 180 AND 183;
-- SELECT * FROM usertbl WHERE addr = '경남' or addr = '전남' or addr = '경북';
SELECT * FROM usertbl WHERE addr in('경남','전남','경북');

-- userTbl 에서 1970년대 생의 정보를 검색
SELECT * FROM usertbl WHERE birthyear BETWEEN 1970 AND 1979;

-- WHERE LIKE 절 : 특정 글자 또는 문자가 포함되어 있는 패턴을 만족하는 다수의 정보를 검색
-- % : 글자 수 상관없이(없거나 많거나)
-- _ : 한개의 문자(한자리)

SELECT * FROM usertbl WHERE birthyear LIKE '197_';

-- userTbl에서 성이 '김' 씨인 모든 사용자 정보 검색
SELECT * FROM usertbl WHERE name LIKE '김%';

-- userTbl 테이블에서 등록된 사용자 이름에 '수' 가 포함이된 사용자 검색
SELECT * FROM usertbl WHERE name LIKE '%수%';

-- userID가 'HGD' 인 사용자의 회원 가입일
SELECT mDATE FROM usertbl WHERE userID = 'HGD';

-- 2013년 이전에 가입한 사용자
SELECT * FROM userTbl WHERE mDATE < '2013-01-01';

-- Null 값 비교
-- usertbl에서 mobile1 핸드폰 번호가 없는 사용자 목록 검색
SELECT * FROM usertbl WHERE mobile1 = null;
SELECT * FROM usertbl WHERE mobile1 IS null;
UPDATE userTbl SET mobile1 = '' WHERE userID = 'SSK';
SELECT * FROM userTbl WHERE mobile1 = '';

-- 거주지(주소 : addr)가 서울이 아닌 사람 검색
SELECT * FROM userTbl WHERE addr != '서울';
SELECT * FROM userTbl WHERE NOT addr = '서울';
SELECT * FROM userTbl WHERE addr <> '서울'; -- NOT == <> == !=

-- 전화번호 시작(mobile1) 이 016,018,019인 사람 검색
SELECT * FROM userTbl WHERE mobile1 IN('016','018','019');
-- 전화번호 시작(mobile1) 이 016,018,019 아닌 사람 검색
SELECT * FROM userTbl WHERE NOT mobile1 IN('016','018','019');

SELECT * FROM userTbl WHERE height > (SELECT height FROM usertbl WHERE name ='김경호');

-- 정렬, 검색된 행의 정보를 정렬해주는 명령어
-- ORDER BY 절
-- ORDER BY 검색 기준 열 이름 ASC / DESC;
-- 거주지 지역 별로 정렬
SELECT * FROM userTbl ORDER BY addr ASC;
SELECT * FROM userTbl ORDER BY addr DESC;

-- 가장 최근에 가입한 순서대로 정렬
SELECT * FROM userTbl ORDER BY mdate DESC;
-- 먼저 가입한 순서대로 정렬 - 정렬은 기본이 ASC(오름차순), 생략하면 ASC
SELECT * FROM userTbl ORDER BY mdate;

-- 거주지역 순으로 정렬하고 동일 지역이면 나이순으로 정렬
SELECT * FROM userTbl ORDER BY addr, birthyear DESC;

-- 키가 175가 넘는 사용자의 거주지역이 어디인지 검색
SELECT addr FROM usertbl WHERE height > 175 ORDER BY height; 
-- DISTINCT 검색 결과내에 중복 데이터 제거
-- 중복 제거 시 검색 결과에 포함된 column을 제외한 속성을 사용할 수 없음
SELECT distinct addr,height FROM userTbl WHERE height >= 175 ORDER BY height;

-- 검색 결과내에서 제공되는 결과의 개수를 제한하는 LIMIT 문
-- LIMIT 절은 MySQL에서만 제공되는 강력한 기능
-- userTbl에서 가장 최근에 가입한 사용자 5명의 정보를 검색
SELECT * FROM userTbl ORDER BY mdate DESC;

SELECT * FROM userTbl -- ORDER BY mDate DESC LIMIT 5,5;
-- 검색 결과내에 정렬된 목록에서 0에서 부터 시작하는 인덱스 번호를 기준으로
-- LIMIT 시작인덱스, 개수;
ORDER BY mDate DESC LIMIT 5 OFFSET 7;
-- LIMIT 개수 OFFSET 시작인덱스;


