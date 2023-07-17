
-- name 속성의 값이 '김경호' 인 사용자의 키 검색
SELECT height FROM sqldb.userTbl WHERE name = '김경호';

USE sqldb;

-- height 키가 김경호 보다 크거나 같은 사용자 검색
SELECT * FROM userTbl WHERE height >= 177;

-- sub query OR 부 질의
SELECT * FROM userTbl WHERE height >= (
	SELECT height FROM sqldb.userTbl WHERE name = '김경호'
);

-- userTbl에서 주소가 ‘경남’인 사람의 키보다 크거나 같은 사람을 검색하세요.
-- 경남에 사는 사람의 키 정보 검색
SELECT height FROM userTbl WHERE addr = '경남';
SELECT name, height, addr FROM userTbl 
WHERE height >= 170 OR height >= 173;

-- userTbl에서 경남에사는 사람 보다 키가 크거나 같은 모든 사람 검색
SELECT name, height, addr FROM userTbl 
WHERE height >= ANY(
	SELECT height FROM userTbl WHERE addr = '경남'
);

-- userTbl 에서 경남에 사는 사람 과 키가 같은 사용자 정보 검색
SELECT name , height , addr FROM userTbl 
-- WHERE height = 170 OR height = 173;
-- WHERE height in(170,173);
WHERE height in(
	SELECT height FROM userTbl WHERE addr = '경남'
);

-- GROUP BY HAVING 절과 집계 함수
-- 검색된 결과를 지정한 열로 묶어주는 GROUP BY 절
-- buyTbl에서 사용자 마다 구매한 개수를 검색
SELECT * FROM buyTbl;
-- buyTbl의 속성들 중에 amount 속성의 전체 합계
SELECT sum(amount) AS '구매개수' FROM buyTbl;

SELECT userID, sum(amount) AS '구매개수' FROM buyTbl GROUP BY userID;

-- count() table에 존재하는 행의 개수를 검색
-- count(열이름) 해당 속성에 유효한 값을 가진 행의 개수를 반환
-- count(열이름) WHERE - 조건에 만족하는 행의 개수를 반환
SELECT * FROM userTbl;
-- 하나라도 유효한 데이터를 가지고 있는 모든 행
SELECT count(*) FROM userTbl;

SELECT count(mobile1) FROM userTbl;

SELECT count(*) FROM userTbl 
WHERE mobile1 is NOT NULL;

SELECT addr FROM userTbl ORDER BY addr DESC;

SELECT count(DISTINCT addr) FROM userTbl;

-- min() , max() - 동일 속성에 저장된 최소값과 최대값을 검색
-- userTbl에서 키가 가장 작은사람  
SELECT min(height) FROM userTbl;
-- userTbl에서 키가 가장 큰사람
SELECT max(height) FROM userTbl;
SELECT min(height), max(height) FROM userTbl;

-- userTbl에서 키가 가장 작은 사람과 키가 가장 큰사람의 이름과 키 검색
SELECT name, height FROM userTbl 
-- WHERE height = 166 OR height = 190;
WHERE height = (SELECT min(height) FROM userTbl)
OR 
height = (SELECT max(height) FROM userTbl);

SELECT name, height FROM userTbl 
WHERE height IN(
	(SELECT max(height) FROM userTbl),
    (SELECT min(height) FROM userTbl)
);

-- buyTbl에 등록된 상품들 중에 가장 가격이 낮은 상품과
-- 가장 가격이 높은 상품의 이름(prodName)과 가격(price) 검색
SELECT * FROM buyTbl;

-- GROUP BY 변경 전으로... 
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT prodName,price FROM sqldb.buyTbl 
WHERE price IN(
	(SELECT min(price) FROM sqldb.buytbl),
    (SELECT max(price) FROM sqldb.buytbl)
) GROUP BY prodName, price;

DESC buyTbl;
SELECT * FROM buyTbl;

-- 전체 판매 금액
SELECT sum(price * amount) FROM buyTbl;
SELECT * FROM buyTbl;

-- 그룹별 판매 합계
SELECT groupName, sum(price * amount) FROM buyTbl 
GROUP BY groupName; 

-- avg(열이름) 평균
-- 구매 고객의 평균 키 출력
SELECT avg(height) FROM userTbl;

-- 지역 별 평균키 를 역순으로 정렬 하여 출력
SELECT addr, avg(height) AS '평균키' FROM userTbl 
GROUP BY addr ORDER BY 평균키 DESC;

-- 실수 값을 소수점 첫째 자리에서 반올림 ROUND()
SELECT addr, ROUND(avg(height)) AS '키' FROM userTbl
GROUP BY addr;

-- 올림 CEIL()
-- 내장 함수를 사용하여 결과를 바로 확인할 수 있게 해주는 
-- 가상의 테이블 DUAL
SELECT CEIL(192.166) FROM DUAL;

-- 내림 FLOOR()
SELECT FLOOR(192.166);

-- WITH ROLLUP
-- 그룹별로 합계를 구할 때 GROUP BY
-- 항목별 합계에 전체 합계를 검색해주는 키워드
-- 지역별 평균키에 전체 평균키를 검색
SELECT addr, avg(height) AS '평균키' FROM userTbl
GROUP BY addr WITH ROLLUP;

-- GROUP BY ~ HAVING  절
-- 총 구매 금액이 1000이상인 사람만 아이디로 그룹화하여 아이디와 총 구매액 검색
SELECT userID, sum(price * amount) FROM buyTbl 
GROUP BY userID HAVING sum(price * amount) >= 1000;

SELECT userID, sum(price * amount) AS '구매금액' FROM buyTbl
GROUP BY userID HAVING 구매금액 >= 1000 
ORDER BY 구매금액 ASC; 

SELECT sum(price * amount) FROM buyTbl WHERE userID = 'JYP';
-- userID가 JYP인 회원보다 총 구매금액이 높은 회원의 userID와 구매금액 검색
SELECT userID, sum(price * amount) AS '구매금액' FROM buyTbl 
GROUP BY userId HAVING 구매금액 > (
	SELECT sum(price * amount) FROM buyTbl WHERE userID = 'JYP'
);

-- 총 주문횟수가 3번 이상인 회원의 userId와 구매횟수 검색
SELECT userid, count(*) AS '주문횟수' FROM buytbl 
GROUP BY userid HAVING 주문횟수 >= 3;

/**********************************************
	임시 테이블을 생성하여 기존 테이블의 정보를 검색해 저장
    INSERT INTO ~ SELECT ~
*/
DESC userTbl;

CREATE TABLE temp_user_tbl(
	userID char(8) PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    mDate date
);

DESC temp_user_tbl;
SELECT * FROM temp_user_tbl;

INSERT INTO temp_user_tbl 
SELECT userID, name, mDate FROM userTbl;

SELECT * FROM temp_user_tbl;

CREATE TABLE buytbl4(
	SELECT * FROM buyTbl
);

DESC buytbl4;
SELECT * FROM buyTbl4;

CREATE TABLE buyTbl5(
	SELECT userID FROM buyTbl
);

SELECT * FROM buytbl5;

-- 테이블의 구조만 복사하여 새로운 테이블 생성
CREATE TABLE buyTbl6(
	SELECT * FROM buyTbl WHERE 1 = 0
);

SELECT * FROM buyTbl6;

CREATE TABLE buytbl7 LIKE buyTbl;
SELECT * FROM buyTbl7;












