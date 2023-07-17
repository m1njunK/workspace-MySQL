-- ctrl + s , 20230614.sql
/***********************************/
SELECT emp.*, dept.* FROM emp, dept 
WHERE emp.deptno = dept.deptno;

SELECT emp.*, dept.* FROM emp INNER JOIN dept 
WHERE emp.deptno = dept.deptno;

SELECT emp.*, dept.* FROM emp INNER JOIN dept 
ON emp.deptno = dept.deptno;

SELECT emp.*, dept.* FROM emp JOIN dept USING(deptno);

-- NATURAL JOIN 
-- 병합하려는 table 중에 속성이름이 같은 녀석으로 병합
-- 일치하는 column 이름이 하나 일때만 정확한 값 검색
SELECT * FROM emp NATURAL JOIN dept;

-- JOIN을 사용하여 뉴욕('NEW YORK')에서 근무하는
-- 사원의 이름(ename)과 급여(sal) 출력
SELECT deptno FROM dept WHERE loc = 'NEW YORK';
SELECT ename, sal FROM emp WHERE deptno = 10;
SELECT ename, sal FROM emp WHERE deptno = (
	SELECT deptno FROM dept WHERE loc = 'NEW YORK'
);

SELECT emp.ename, sal FROM emp NATURAL JOIN dept 
WHERE dept.loc = 'NEW YORK';

-- SCOTT이 근무하는 부서 이름 과 급여 출력
SELECT dept.dname, emp.sal FROM emp, dept 
WHERE emp.deptno = dept.deptno 
AND emp.ename = 'SCOTT';

SELECT dept.dname, emp.sal FROM 
emp JOIN dept USING(deptno)
WHERE emp.ename = 'SCOTT';

-- SELF JOIN 동일한 테이블을 병합하여 검색
-- 사원의 이름과 그 사원의 매니저 이름을 출력
SELECT * FROM emp;

SELECT A.ename, B.ename FROM emp AS A, emp AS B 
WHERE A.mgr = B.empno;

-- SELECT A.ename, B.ename FROM emp AS A NATURAL JOIN emp AS B; 
SELECT 
	A.ename AS 사원, B.ename AS 매니저 
FROM emp AS A JOIN emp AS B 
ON A.mgr = B.empno;

-- OUTER JOIN 
-- 일치하지 않는 속성의 행 정보라도 남아 있는 테이블의 값이 존재하면
-- 검색에 포함
-- 사원의 이름과 매니저 이름을 출력 하되 매니저가 아닌 사람의 목록도 같이 출력
SELECT A.ename AS 사원, B.ename AS 매니저
 FROM emp AS A RIGHT OUTER JOIN emp AS B 
ON A.mgr = B.empno ORDER BY B.ename DESC;

-- 매니저가 없는 사원의 정보도 같이 검색
-- OUTER는 생략 가능
SELECT A.ename AS 사원, B.ename AS 매니저
 FROM emp AS A LEFT OUTER JOIN emp AS B 
ON A.mgr = B.empno ORDER BY B.ename DESC;

-- emp table과 salgrade table 조인 하여
-- 각 사원의 급여 등급을 사원명, 급여, 급여등급 으로 출력
SELECT e.ename, e.sal, s.grade FROM emp e LEFT JOIN salgrade s 
ON e.sal BETWEEN s.losal AND s.hisal; 

-- 각 사원의 급여 등급을 사원명, 부서명, 급여, 급여등급으로 출력
SELECT 
	e.ename, d.dname, e.sal, s.grade 
FROM 
 -- emp e JOIN dept d USING(deptno),
 emp e NATURAL JOIN dept d JOIN salgrade s 
 ON e.sal BETWEEN s.losal AND s.hisal;

/***********************************************
	PREPARE
    Query(질의)문을 먼저 등록 시켜놓고 필요한 값을 나중에 대입하여
    실행 하는 질의문
	PREPARE 이름 FROM '질의문';
    EXECUTE prepared이름 USING '추가해야할 데이터';
*/
PREPARE mQuery FROM
 'SELECT ename, sal FROM emp ORDER BY sal LIMIT ?';
 SET @tempVal = 3;
 EXECUTE mQuery USING @tempVal;
 
 SET @val = 10;
 EXECUTE mQuery USING @val;
 
 PREPARE sQuery FROM 
 'SELECT ename,sal,deptno FROM emp WHERE deptno = ? AND sal >= ?';
 
 SET @deptno := 10;
 SET @sal := 1300;
 
 EXECUTE sQuery USING @deptno, @sal;

/*****************************************************/
-- 제약 조건
CREATE TABLE test_usertbl(
	userID char(8), -- AUTO_INCREMENT
    name VARCHAR(10) NOT NULL,
    email VARCHAR(60) NULL UNIQUE,
    birthYear INT CHECK(birthYear >= 1900 AND birthYear <= 2023),
    height INT CHECK(height > 0),
    mDate TIMESTAMP NULL DEFAULT now(),
    PRIMARY KEY(userID)
);

DESC test_usertbl;

INSERT INTO test_usertbl(userID, name, email, birthYear, height) 
VALUES('CGK','최기근','hap0p9y@nate.com',1982,190);
-- chlrlrms@gmail.com
SELECT * FROM test_usertbl;
INSERT INTO test_usertbl(userID, name, email, birthYear, height) 
VALUES('KPG','김판걸',null,2005,19);

CREATE TABLE test_prodtbl(
	code char(3),
    id char(8) NOT NULL CHECK(length(id) >= 4 AND length(id) <= 8),
    pdate TIMESTAMP NOT NULL,
    PRIMARY KEY(code,id)
);

INSERT INTO test_prodtbl VALUES('p_1','0001',now());
SELECT * FROM test_prodtbl;
INSERT INTO test_prodtbl VALUES('p_1','0002',now());
INSERT INTO test_prodtbl VALUES('p_2','0001',now());
INSERT INTO test_prodtbl VALUES('p_2','0001',now());

-- PROCEDURE, TRIGGER, VIEW 









