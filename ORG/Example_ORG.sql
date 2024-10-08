create database if not exists ORG;
# show databases; 
use ORG;

create table Worker(
WORKER_ID INT NOT NULL PRIMARY KEY auto_increment,
FIRST_NAME CHAR(25),
LAST_NAME CHAR(25),
SALARY INT(15),
JOINING_DATE DATETIME,
DEPARTMENT CHAR(25)
);

INSERT INTO Worker(WORKER_ID,FIRST_NAME,LAST_NAME,SALARY,JOINING_DATE,DEPARTMENT) VALUES
(001,'Hansika','Arora',100000,'13-02-20 09.00.00','HR'),
(002,'Geeta','Verma',400000,'13-02-20 09.00.00','Admin'),
(003,'Ramesh','Malhotra',500000,'13-02-20 09.00.00','HR'),
(004,'David','Dhawan',300000,'13-02-20 09.00.00','Admin'),
(005,'Shruti','Singh',700000,'13-02-20 09.00.00','Account'),
(006,'Anamika','Sen',900000,'13-02-20 09.00.00','Account'),
(007,'Satish','Nigam',200000,'13-02-20 09.00.00','HR'),
(008,'Vipul','Chauhan',230000,'13-02-20 09.00.00','Admin');

CREATE TABLE Bonus
(
	WORKER_REF_ID INT,
    BONUS_AMOUNT INT(10),
    BONUS_DATE DATETIME,
    FOREIGN KEY(WORKER_REF_ID)
    REFERENCES Worker(WORKER_ID) ON DELETE CASCADE
);

INSERT INTO Bonus(WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
(001,3000,'16-01-20'),
(002,7000,'16-01-20'),
(003,1500,'16-01-20'),
(001,1000,'16-01-20'),
(002,5000,'16-01-20');

CREATE TABLE Title
(
	WORKER_REF_ID INT,
    WORKER_TITLE CHAR(25),
    AFFECTED_FROM DATETIME,
    FOREIGN KEY (WORKER_REF_ID) REFERENCES Worker(WORKER_ID)
    ON DELETE CASCADE
);

INSERT INTO Title(WORKER_REF_ID,WORKER_TITLE,AFFECTED_FROM) VALUES
(001, 'Manager', '2016-02-20 00:00:00'),
(002, 'Assistant Manager', '2016-02-20 00:00:00'),
(008, 'Executive', '2016-02-20 00:00:00'),
(005, 'Senior Manager', '2016-02-20 00:00:00'),
(004, 'Manager', '2016-02-20 00:00:00'),
(006, 'Lead', '2016-02-20 00:00:00'),
(003, 'Lead', '2016-02-20 00:00:00'),