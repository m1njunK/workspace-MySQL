-- ctrl + mouse 휠로 글자 크기 조정
-- database 목록 확인

-- 실행 단축키 - ctrl - enter
show databases;

-- 사용할 데이터베이스 or schema 선택
-- 선택된 database는 schemas 목록에서 bold로 표시
-- 좌측 schemas tab에서 db이름 더블 클릭 시 동일한 명령 수행

use world;


-- DDL - 데이타 정의어
-- CREATE, ALTER, DROP
-- 규칙을 생성하는 CREATE
CREATE DATABASE sqldb;
-- 존재하지 않으면 생성 작업 수행 , 존재하면 실행하지 않음.
CREATE SCHEMA IF NOT EXISTS sqldb;

-- table 생성
-- 저장될 data 규칙 생성
CREATE TABLE sqldb.member_tbl(
	member_id VARCHAR(50) NOT NULL PRIMARY KEY,
    member_name CHAR(20) NULL,
    member_age INT(4) NULL
);

DESCRIBE member_tbl;
DESC member_tbl;

-- 잘못 생성된 table 규칙 삭제
DROP TABLE member_tbl;
-- 구조를 확인할 테이블의 db 지정
DESC sqldb.member_tbl;

-- 기본 schema를 sqlDB로 변경
use sqlDB;


-- sqldb schema에 상품 테이블 생성
-- naming 을 할때 공백이 포함되어있으면 백틱 ``으로 감싸주면 사용 가능
CREATE TABLE sqldb.`product tbl`(
    product_name VARCHAR(50),
	cost INT,
    make_date VARCHAR(20),
    amount INT NULL
);

DESC `product tbl`;

-- 현재 database에 생성된 테이블 정보 확인
SHOW TABLE STATUS; -- 상세 정보
-- SHOW TABLE -- 간편 정보

-- database 삭제
DROP DATABASE sqlDB;
DROP SCHEMA IF EXISTS sqlDB;

-- sample data load

-- 일반 데이터를 workbench에 삽입
-- 공유 폴더에 sqlDB sql 파일의 정보를 MySQL에 삽입
use sqldb;
show tables;

DESC sqldb.usertbl;
DESC sqldb.buytbl;

-- table 내부에 삽입된 데이터 정보 검색
SELECT * FROM usertbl;

SELECT * FROM buytbl;

-- usertbl table에서 사용자 이름과 가입일만 나오게 검색
-- SELECT `검색할 column 명`, `검색할 column` 명 FROM `table 이름`;
SELECT name, mdate FROM usertbl;


-- test용 database 생성
CREATE DATABASE IF NOT EXISTS testDB;

/* 범위 주석 - DATABASE : SCHEMA 동일
	CREATE SCHEMA IF NOT EXISTS testDB;
*/

use testDB;

show tables;

-- testtable 생성
-- 동일한 이름의 테이블이 존재하지 않으면 생성
CREATE TABLE IF NOT EXISTS userTbl(
	userID char(8) NOT NULL PRIMARY KEY COMMENT '사용자 구분 PK',
    name VARCHAR(10) NOT NULL COMMENT '회원 이름',
    birthyeal INT NOT NULL,
    addr char(2) NOT NULL,
    mobile1 char(3),
    mobile2 char(3),
    height smallint,
    mDate date
) comment = '테스트용 사용자 테이블';

-- SELECT * FROM testdb.usertbl;
-- INSERT INTO `testdb`.`usertbl` (`userID`, `name`, `birthyeal`, `addr`, `height`, `mDate`) VALUES ('ㅋㅋㅋ', 'ㅋㅋㅋ', 'ㅋㅋㅋ', 'ㅋㅋㅋ', '1000', '23-06-05');
-- DELETE FROM `testdb`.`usertbl` WHERE (`userID` = 'LJH');

DESCRIBE usertbl;
-- DESC == SHOW COLUMNS FROM usertbl;
show COLUMNS FROM usertbl;
-- 상세 정보 확인
SHOW FULL COLUMNS FROM usertbl;

-- prodTbl table 생성
CREATE TABLE IF NOT EXISTS prodTbl(
	num INT NOT NULL PRIMARY KEY,	-- 상품 구매 번호
    userID char(8) NOT NULL,		-- 구매 사용자 아이디	
    prodName char(6) NOT NULL,		-- 구매 상품 이름
    groupName char(4),				-- 상품 종류
    price char(5),					-- 구매 가격
    count smallint NOT NULL			-- 구매 개수
);

/*
	tinyint : 1byte
    smallint : 2byte
    mediumint : 3byte
    int : 4byte    
    bigint : 8byte
*/

DESC prodtbl;

-- CREATE로 생성된 규칙을 수정 변경 하는 ALTER
-- table 명 변경, prodTbl 의 이름을 buyTbl로 변경
ALTER TABLE prodtbl RENAME buyTbl;

SHOW TABLES;

DESC buytbl;
-- buytbl 에 있는 price column의 dataType을 INT로 변경
ALTER TABLE buytbl MODIFY price INT(4) ZEROFILL;

-- buyTbl의 num 속성을 AUTO_INCREAMENT 기능 추가
-- AUTO_INCREAMENT : Mysql에서만 존재하는 강력한 기능
-- 적용 가능한 column - PRIMARY KEY && INT(정수타입)
-- 행이 추가 될때마다 자동으로 1씩 증가하는 column 값 부여
ALTER TABLE buyTbl MODIFY num INT NOT NULL AUTO_INCREMENT;

DESC buytbl;

-- buytbl table에 count column을 amount 로 변경
ALTER TABLE buytbl CHANGE count amount SMALLINT NOT NULL;

SELECT * FROM usertbl;

-- buytbl의 userid column에 삽입되는 data는
-- usertbl의 userID에 존재하는 데이터만 가능 하도록 제약 조건 추가.

ALTER TABLE buytbl ADD CONSTRAINT fk_userID 
FOREIGN KEY(userID)
REFERENCES usertbl(userID);

SHOW INDEX FROM buytbl;