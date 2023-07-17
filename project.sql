CREATE schema project;
USE project;
CREATE table ClientsTable(
	
    Id varchar(10) not null primary key,
    Pw varchar(10) not null,
    Nick varchar(10),
    Wins int,
    Loses int,
    cNum int not null
);