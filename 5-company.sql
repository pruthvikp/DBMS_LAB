/* Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are
specified.
Create tables for the following schema listed below by properly specifying the primary keys and
foreign keys.
Enter at least five tuples for each relation.

Company Database:
EMPLOYEE (SSN, Name, Address, Sex, Salary, SuperSSN, DNo)
DEPARTMENT (DNo, DName, MgrSSN, MgrStartDate)
DLOCATION (DNo,DLoc)
PROJECT (PNo, PName, PLocation, DNo)
WORKS_ON (SSN, PNo, Hours)
1. Make a list of all project numbers for projects that involve an employee whose last name
is ‘Scott’, either as a worker or as a manager of the department that controls the project.
2. Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10
percent raise.
3. Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the
maximum salary, the minimum salary, and the average salary in this department
4. Retrieve the name of each employee who works on all the projects controlled by
department number 5 (use NOT EXISTS operator).
5. For each department that has more than five employees, retrieve the department
number and the number of its employees who are making more than Rs. 6,00,000.
6. Create a view that shows name, dept name and location of all employees.
7. Create a trigger that prevents a project from being deleted if it is currently being worked
by any employee.
*/

DROP DATABASE IF EXISTS COMPANY;

CREATE DATABASE COMPANY;
USE COMPANY;

CREATE TABLE EMPLOYEE(
SSN varchar(10) primary key,
name varchar(30) not null,
address varchar(50) not null,
sex varchar(10) not null,
salary int not null,
superSSN varchar(10),
dno int not null,
foreign key (superSSN) references EMPLOYEE(SSN) on delete set null
);

CREATE TABLE DEPARTMENT(
dno int primary key,
dname varchar(20) not null,
mgrSSN varchar(10) not null,
mgr_startdate date not null,
foreign key (mgrSSN) references EMPLOYEE(SSN) on delete cascade
);

CREATE TABLE DLOCATION(
dno int not null,
dloc varchar(30) not null,
foreign key (dno) references DEPARTMENT(dno) on delete cascade
);

CREATE TABLE PROJECT(
pno int primary key,
pname varchar(30) not null,
plocation varchar(30) not null,
dno int not null,
foreign key (dno) references DEPARTMENT(dno) on delete cascade
);

CREATE TABLE WORKS_ON(
SSN varchar(10) not null,
pno int not null,
hours int not null default 0,
foreign key (SSN) references EMPLOYEE(SSN) on delete cascade,
foreign key (pno) references PROJECT(pno) on delete cascade
);

INSERT INTO EMPLOYEE VALUES
('01AB123', 'Indra', 'Indranagar', 'Male', 400000, '01AB123', 1),
('01AB124', 'Varuna', 'Banshankari','Male', 500000, '01AB123', 1),
('01AB125', 'Agni', 'Hebbal', 'Male', 600000, '01AB123', 2),
('01AB126', 'Vaayu', 'Vijaynagar', 'Male', 700000, '01AB126', 3),
('01AB127', 'Scott', 'Kuvempunagar', 'Male', 800000, '01AB126', 4);

INSERT INTO DEPARTMENT VALUES
(1, 'Accounts', '01AB123', '2021-01-01'),
(2, 'Water Resources', '01AB124', '2021-02-02'),
(3, 'Production', '01AB125','2021-03-03'),
(4, 'Quality Assessment', '01AB126', '2022-01-01'),
(5, 'Human Resources', '01AB127', '2022-02-02');

INSERT INTO DLOCATION VALUES
(1, 'Bengaluru'),
(2, 'Pune'),
(3, 'Chennai'),
(4, 'Bengaluru'),
(5, 'Mysuru');

INSERT INTO PROJECT VALUES
(501, 'Market Evaluation', 'Dodballapura', 1),
(502, 'IOT', 'Andheri', 2),
(503, 'Product Optimization', 'Chennai', 2),
(504, 'Yeild Increase', 'Yelahanka', 4),
(505, 'Product Refinement', 'Kuvempunagar, Mysuru', 5);

INSERT INTO WORKS_ON VALUES
('01AB123', 501, 6),
('01AB124', 502, 7),
('01AB125', 503, 8),
('01AB126', 503, 8),
('01AB127', 504, 6);

ALTER TABLE EMPLOYEE ADD CONSTRAINT FOREIGN KEY (dno) REFERENCES DEPARTMENT(dno) ON DELETE CASCADE;

SELECT *FROM EMPLOYEE;
/*
+---------+--------+--------------+------+--------+----------+-----+
| SSN     | name   | address      | sex  | salary | superSSN | dno |
+---------+--------+--------------+------+--------+----------+-----+
| 01AB123 | Indra  | Indranagar   | Male | 400000 | 01AB123  |   1 |
| 01AB124 | Varuna | Banshankari  | Male | 500000 | 01AB123  |   1 |
| 01AB125 | Agni   | Hebbal       | Male | 600000 | 01AB123  |   2 |
| 01AB126 | Vaayu  | Vijaynagar   | Male | 700000 | 01AB126  |   3 |
| 01AB127 | Scott  | Kuvempunagar | Male | 800000 | 01AB126  |   4 |
+---------+--------+--------------+------+--------+----------+-----+
5 rows in set (0.00 sec)
*/

SELECT *FROM DEPARTMENT;
/*
+-----+--------------------+---------+---------------+
| dno | dname              | mgrSSN  | mgr_startdate |
+-----+--------------------+---------+---------------+
|   1 | Accounts           | 01AB123 | 2021-01-01    |
|   2 | Water Resources    | 01AB124 | 2021-02-02    |
|   3 | Production         | 01AB125 | 2021-03-03    |
|   4 | Quality Assessment | 01AB126 | 2022-01-01    |
|   5 | Human Resources    | 01AB127 | 2022-02-02    |
+-----+--------------------+---------+---------------+
5 rows in set (0.01 sec)
*/

SELECT *FROM DLOCATION;
/*
+-----+-----------+
| dno | dloc      |
+-----+-----------+
|   1 | Bengaluru |
|   2 | Pune      |
|   3 | Chennai   |
|   4 | Bengaluru |
|   5 | Mysuru    |
+-----+-----------+
5 rows in set (0.00 sec)
*/

SELECT *FROM PROJECT;
/*
+-----+----------------------+----------------------+-----+
| pno | pname                | plocation            | dno |
+-----+----------------------+----------------------+-----+
| 501 | Market Evaluation    | Dodballapura         |   1 |
| 502 | IOT                  | Andheri              |   2 |
| 503 | Product Optimization | Chennai              |   2 |
| 504 | Yeild Increase       | Yelahanka            |   4 |
| 505 | Product Refinement   | Kuvempunagar, Mysuru |   5 |
+-----+----------------------+----------------------+-----+
5 rows in set (0.00 sec)
*/

SELECT * FROM WORKS_ON;
/*
+---------+-----+-------+
| SSN     | pno | hours |
+---------+-----+-------+
| 01AB123 | 501 |     6 |
| 01AB124 | 502 |     7 |
| 01AB125 | 503 |     8 |
| 01AB126 | 503 |     8 |
| 01AB127 | 504 |     6 |
+---------+-----+-------+
5 rows in set (0.00 sec)
*/

-- Make a list of all project numbers for projects that involve an employee whose last name
-- is ‘Scott’, either as a worker or as a manager of the department that controls the project.
SELECT w.pno,p.pname 
FROM WORKS_ON w, PROJECT p, EMPLOYEE e 
WHERE w.pno=p.pno AND e.SSN=w.SSN AND e.name LIKE '%scott%';
/*
+-----+----------------+
| pno | pname          |
+-----+----------------+
| 504 | Yeild Increase |
+-----+----------------+
1 row in set (0.00 sec)
*/

-- Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise.
SELECT name,salary as old_salary,salary*1.1 as new_salary, pname  
FROM EMPLOYEE e, PROJECT p, WORKS_ON w 
WHERE pname='IOT' AND p.pno=w.pno AND w.SSN=e.SSN;
/*
+--------+------------+------------+-------+
| name   | old_salary | new_salary | pname |
+--------+------------+------------+-------+
| Varuna |     500000 |   550000.0 | IOT   |
+--------+------------+------------+-------+
1 row in set (0.00 sec)
*/

-- Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the
-- maximum salary, the minimum salary, and the average salary in this department
SELECT SUM(salary),MAX(salary),MIN(salary),AVG(salary)  
FROM EMPLOYEE e, DEPARTMENT d 
WHERE d.dname='Accounts' AND d.dno=e.dno;
/*
+-------------+-------------+-------------+-------------+
| SUM(salary) | MAX(salary) | MIN(salary) | AVG(salary) |
+-------------+-------------+-------------+-------------+
|      900000 |      500000 |      400000 | 450000.0000 |
+-------------+-------------+-------------+-------------+
1 row in set (0.00 sec)
*/

-- Retrieve the name of each employee who works on all the projects controlled by
-- department number 5 (use NOT EXISTS operator).
SELECT e.SSN,e.name,dname FROM EMPLOYEE e WHERE NOT EXISTS 
  (SELECT pno FROM PROJECT p WHERE p.dno=4 AND pno NOT IN
    (SELECT pno FROM WORKS_ON w WHERE w.SSN=e.SSN));
/*
+---------+-------+
| SSN     | name  |
+---------+-------+
| 01AB127 | Scott |
+---------+-------+
1 row in set (0.00 sec)
*/

-- For each department that has more than five employees, retrieve the department
-- number and the number of its employees who are making more than Rs. 6,00,000.
SELECT dname,COUNT(SSN) AS number_of_emp 
FROM EMPLOYEE e, DEPARTMENT d 
WHERE e.dno=d.dno AND salary>=400000  
GROUP BY d.dno HAVING COUNT(SSN)>1;
/*
+----------+---------------+
| dname    | number_of_emp |
+----------+---------------+
| Accounts |             2 |
+----------+---------------+
1 row in set (0.01 sec)
*/
SELECT dname,COUNT(SSN) AS number_of_emp 
FROM EMPLOYEE e, DEPARTMENT d 
WHERE e.dno=d.dno AND salary>=600000  
GROUP BY d.dno HAVING COUNT(SSN)>=1;
/*
+--------------------+---------------+
| dname              | number_of_emp |
+--------------------+---------------+
| Water Resources    |             1 |
| Production         |             1 |
| Quality Assessment |             1 |
+--------------------+---------------+
3 rows in set (0.00 sec)

*/

-- Create a view that shows name, dept name and location of all employees.
CREATE VIEW EmployeeDetails AS
SELECT name,dname,dloc
FROM EMPLOYEE e,DEPARTMENT d,DLOCATION dl
WHERE e.dno=d.dno AND d.dno=dl.dno;

SELECT *FROM  EmployeeDetails;
/*
+--------+--------------------+-----------+
| name   | dname              | dloc      |
+--------+--------------------+-----------+
| Indra  | Accounts           | Bengaluru |
| Varuna | Accounts           | Bengaluru |
| Agni   | Water Resources    | Pune      |
| Vaayu  | Production         | Chennai   |
| Scott  | Quality Assessment | Bengaluru |
+--------+--------------------+-----------+
5 rows in set (0.01 sec)
*/

-- Create a trigger that prevents a project from being deleted if it is currently being worked
-- by any employee.
CREATE TRIGGER PreventDelete 
BEFORE DELETE ON PROJECT
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT pno FROM WORKS_ON WHERE pno=old.pno) THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Project is currently in progress'; 
  END IF;
END ; $$
-- Query OK, 0 rows affected (0.04 sec)
DELIMITER ;

DELETE FROM PROJECT WHERE pno=503;
-- ERROR 1644 (45000): Project is currently in progress

