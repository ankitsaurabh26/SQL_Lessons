CREATE DATABASE IF NOT exists temp;
SHOW DATABASES;
USE temp;

CREATE TABLE student(
id INT PRIMARY KEY,
name VARCHAR(255)
);

insert into student values(1,'Ankit');

SELECT * FROM student;

DROP database if exists temp; -- DROP THE DATABASE 