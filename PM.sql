show databases;
use sqldb;
show tables;

SELECT * FROM userTbl;
SELECT * FROM employees.titles;

CREATE USER 'staff'@'10.100.205.175' IDENTIFIED BY '1234';
GRANT SELECT, UPDATE, INSERT, DELETE ON sqlDB.* TO staff@'10.100.205.175';

CREATE DATABASE testDB;
