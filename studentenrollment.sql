/* Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are
specified.
Create tables for the following schema listed below by properly specifying the primary keys and
foreign keys.
Enter at least five tuples for each relation.

Student enrollment in courses and books adopted for each course
STUDENT (regno: string, name: string, major: string, bdate: date)
COURSE (course#:int, cname: string, dept: string)
ENROLL(regno:string, course#: int,sem: int,marks: int)
BOOK-ADOPTION (course#:int, sem: int, book-ISBN: int)
TEXT (book-ISBN: int, book-title: string, publisher: string,author: string)
1. Demonstrate how you add a new text book to the database and make this book be
adopted by some department.
2. Produce a list of text books (include Course #, Book-ISBN, Book-title) in the alphabetical
order for courses offered by the ‘CS’ department that use more than two books.
3. List any department that has all its adopted books published by a specific publisher.
4. List the students who have scored maximum marks in ‘DBMS’ course.
5. Create a view to display all the courses opted by a student along with marks obtained.
6. Create a trigger that prevents a student from enrolling in a course if the marks
prerequisite is less than 40.
*/

DROP DATABASE STUDENTENROLLMENT;

CREATE DATABASE STUDENTENROLLMENT;
USE STUDENTENROLLMENT;

CREATE TABLE STUDENT(
regno varchar(15) primary key,
name varchar(35) not null,
major varchar(25) not null,
bdate date not null);

CREATE TABLE COURSE(
course_id int primary key,
cname varchar(25) not null,
dept varchar(25) not null);

CREATE TABLE ENROLL(
regno varchar(15) not null,
course_id int not null,
sem int not null,
marks int not null,
foreign key (regno) references STUDENT(regno) on delete cascade,
foreign key (course_id) references COURSE(course_id) on delete cascade
);

CREATE TABLE TEXT(
book_ISBN int primary key,
book_title varchar(35) not null,
publisher varchar(35) not null,
author varchar(35) not null
); 

CREATE TABLE BOOK_ADOPTION(
course_id int not null,
sem int not null,
book_ISBN int not null,
foreign key (course_id) references COURSE(course_id) on delete cascade,
foreign key (book_ISBN) references TEXT(book_ISBN) on delete cascade
);

INSERT INTO STUDENT VALUES
('CA210792','Kousalya', 'Computer Science', '2003-04-16'),
('CA210793','Supraja', 'Literature', '2003-04-17'),
('CA210794','Rama', 'Philosophy', '2003-04-18'),
('CA210795','Poorva', 'Electronics', '2003-04-19'),
('CA210796','Sandhya', 'Computer Science', '2003-04-20');

INSERT INTO COURSE VALUES
(1, 'DBMS','CS'),
(2, 'Halegannada','Humanities'),
(3, 'Indian Philosophy', 'Humanities'),
(4, 'Sensors and Actuators', 'EC'),
(5, 'Artificial Intelligence', 'CS');

INSERT INTO ENROLL VALUES
('CA210792', 1, 5, 98),
('CA210793', 2, 3, 92),
('CA210794', 3, 5, 75),
('CA210795', 4, 5, 79),
('CA210796', 5, 5, 82),
('CA210796', 2, 5, 80);

INSERT INTO TEXT VALUES
(53671, 'DBMS Made Simple', 'Hema Publications', 'Nargis'),
(53672, 'Savi Kannada','Rekha Publishers', 'Sharmila Tagore'),
(53673, 'The Great Indian Philosophy','Jaya Publications', 'Amrish Puri'),
(53674, 'Electronics Guide','Sushma Publishers', 'Rajesh Khanna'),
(53675, 'Networking Made Easy','Nirma Printing House', 'Raj Kapoor');

INSERT INTO BOOK_ADOPTION VALUES
(1, 5, 53671),
(2, 3, 53672),
(3, 5, 53673),
(4, 5, 53674),
(5, 5, 53675);

SELECT * FROM STUDENT;
SELECT * FROM COURSE;
SELECT * FROM ENROLL;
SELECT * FROM TEXT;
SELECT * FROM BOOK_ADOPTION;

-- Demonstrate how you add a new text book to the database and make this book be adopted by some department

INSERT INTO TEXT VALUES
(53676, 'Computer Networks','Nirma Printing House', 'Dharmendra');

INSERT INTO BOOK_ADOPTION VALUES
(5, 5, 53676);
 
SELECT * FROM TEXT;

SELECT * FROM BOOK_ADOPTION;

-- Produce a list of text books (include Course #, Book-ISBN, Book-title) in the alphabetical 
-- order for courses offered by the ‘CS’ department that use more than two books. 

SELECT b.course_id, b.book_ISBN, t.book_title
FROM BOOK_ADOPTION b, TEXT t, COURSE c
WHERE dept='CS' AND c.course_id=b.course_id AND b.book_ISBN=t.book_ISBN 
AND (SELECT COUNT(b.book_ISBN) FROM BOOK_ADOPTION b,COURSE c WHERE b.course_id=c.course_id)>=2 
ORDER BY t.book_title;

-- List any department that has all its adopted books published by a specific publisher. 

SELECT c.dept
FROM COURSE c, BOOK_ADOPTION b, TEXT t 
WHERE b.book_ISBN = t.book_ISBN AND b.course_id = c.course_id AND t.publisher = 'Sushma Publishers';

-- List the students who have scored maximum marks in ‘DBMS’ course
SELECT name 
FROM STUDENT s,COURSE c,ENROLL e
WHERE s.regno=e.regno AND c.course_id=e.course_id
AND e.marks=(SELECT MAX(e.marks) FROM ENROLL e, COURSE c WHERE c.course_id=e.course_id AND cname='DBMS');

-- Create a view to display all the courses opted by a student along with marks obtained.
CREATE VIEW CoursesAndMarks AS
SELECT cname, marks
FROM COURSE c, ENROLL e, STUDENT s
WHERE e.regno=s.regno AND e.course_id=c.course_id AND s.regno='CA210796';
SELECT * FROM CoursesAndMarks;
