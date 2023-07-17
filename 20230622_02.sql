/****************************
	SQL Injection -- (SQL 삽입 공격)
    사용자가 입력할 수 있는 영역을 활용해서
    개발자가 의도하지 않은 SQL문을 실행 하게 하는 공격 방법
*/
USE splDB;
show tables;
SELECT * FROM member_tbl;
-- id001
-- pw001
-- id001' --
SELECT * FROM member_tbl WHERE id = 'id001'; -- ' AND pw = '';
-- ' OR '1' = '1
SELECT * FROM member_tbl WHERE id = 'id001' AND pw = '' OR '1' = '1';

PREPARE
 mQuery
FROM "SELECT * FROM member_tbl WHERE id = ? AND pw = ?";

SET @id = 'id001'; -- ';
SET @pw = '' OR '1' = '1';

SELECT @id, @pw;
EXECUTE mQuery USING @id, @pw;
