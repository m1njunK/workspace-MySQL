CREATE SCHEMA IF NOT EXISTS test_db;

SELECT * FROM emp;

SELECT * FROM dept;

INSERT INTO emp VALUES (8000,'MASTER','SALESMAN',7839,'1982-06-07',1200,500,40); 
SELECT * FROM emp WHERE empno = 8000;

SELECT * FROM emp WHERE empno = 7566;

UPDATE emp SET comm = 600 WHERE empno = 7566;

DELETE FROM emp WHERE empno = 8000;
SELECT * FROM emp ORDER BY empno DESC;

SELECT @@autocommit;
SET @@autocommit = FALSE;

DELETE FROM emp;
SELECT * FROM emp;

ROLLBACK; 
SELECT * FROM emp;

SELECT deptno, count(*) AS '부서별 인원' FROM emp GROUP BY deptno WITH ROLLUP;

CREATE USER testUser@'localhost' IDENTIFIED BY '12345';
SELECT * FROM mysql.USER WHERE user = 'testUser';

GRANT SELECT, INSERT, UPDATE, DELETE ON test_db.* TO 'testUser'@'localhost';
SHOW GRANTS FOR testUser@'localhost';


DELIMITER //
	CREATE PROCEDURE test_procedure()
		BEGIN
			SELECT emp.empno, emp.ename, dept.dname FROM emp JOIN dept WHERE emp.deptno = dept.deptno AND emp.sal >= 2000 ORDER BY dname;
        END //
DELIMITER ;

call test_procedure();

DELIMITER //
	CREATE PROCEDURE test_update(IN empnum INT, deptnum INT)
		BEGIN
			UPDATE emp SET deptno = deptnum WHERE empno = empnum;
        END //
DELIMITER ;

call test_update(7369,10);

SELECT * FROM emp WHERE empno = 7369;

CREATE TABLE back_up_emp LIKE emp;

SELECT * FROM back_up_emp;

DELIMITER $$
	CREATE TRIGGER backup_trg
	AFTER DELETE 
    ON emp FOR EACH ROW
BEGIN
    INSERT INTO back_up_emp(empno,ename,job,mgr,hiredate,sal,comm,deptno)
    VALUES(OLD.empno, OLD.ename, OLD.job, OLD.mgr, OLD.hiredate, OLD.sal , OLD.comm, OLD.deptno);
END $$
DELIMITER ;

DELETE FROM emp WHERE empno = 7369;
SELECT * FROM back_up_emp;
SELECT * FROM emp;

CREATE INDEX indx_emp_ename ON emp(ename);

SHOW INDEXES FROM emp;

DROP INDEX indx_emp_ename ON test_db.emp;

SHOW INDEXES FROM emp;













