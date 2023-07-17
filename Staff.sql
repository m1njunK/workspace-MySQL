SELECT * FROM sqldb.userTbl;

SELECT * FROM employees.titles;

-- staff유저는 권한이 업음
CREATE USER 'ceo'@'10.100.205.%' IDENTIFIED BY '1234';
