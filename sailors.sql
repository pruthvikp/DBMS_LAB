-- Consider the database schemas given below.
-- Write ER diagram and schema diagram. The primary keys are underlined and the data types
-- are specified.
-- Create tables for the following schema listed below by properly specifying the primary keys
-- and foreign keys.
-- Enter at least five tuples for each relation.

-- Sailors database
-- SAILORS (sid, sname, rating, age)
-- BOAT(bid, bname, color)
-- RSERVERS (sid, bid, date)
-- 1. Find the colours of boats reserved by Albert
-- 2. Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103
-- 3. Find the names of sailors who have not reserved a boat whose name contains the string
-- “storm”. Order the names in ascending order.
-- 4. Find the names of sailors who have reserved all boats.
-- 5. Find the name and age of the oldest sailor.
-- 6. For each boat which was reserved by at least 5 sailors with age >= 40, find the boat id and
-- the average age of such sailors.
-- 7. Create a view that shows the names and colours of all the boats that have been reserved by
-- a sailor with a specific rating.
-- 8. A trigger that prevents boats from being deleted If they have active reservations

drop database SAILORS;
CREATE DATABASE SAILORS;
USE SAILORS;

CREATE TABLE SAILORS(
sid int primary key,
sname varchar(35) not null,
rating float(8) not null,
age int not null
);

CREATE TABLE BOAT(
bid int primary key,
bname varchar(35) not null,
color varchar(20) not null
);

CREATE TABLE RESERVES(
sid int not null,
bid int not null,
rdate date not null,
foreign key (sid) references SAILORS(sid) on delete cascade,
foreign key (bid) references BOAT(bid) on delete cascade
);

INSERT INTO SAILORS VALUES
(1,"Albert Ullagaddi", 9.8, 48),
(2,"Ramesh Shetty",8.0, 42),
(3,"Supriya Dodmani",7.8,40),
(4,"Storm Smith",5.2,45),
(5,"Warner Storm",6.5,52),
(6,"John Storms",8.2,56);

INSERT INTO BOAT VALUES
(101,"Vikramaditya", "Blue"),
(102,"Titanic","White"),
(103,"Vikranth","Red");

INSERT INTO RESERVES VALUES
(1,101,"2024-02-01"),
(1,102,"2024-02-02"),
(1,103,"2024-02-03"),
(2,101,"2024-02-04"),
(3,102,"2024-02-05"),
(4,103,"2024-02-06");

-- Find the colours of boats reserved by Albert
SELECT b.color 
FROM SAILORS s, BOAT b, RESERVES r
WHERE s.sid=r.sid AND b.bid=r.bid AND s.sname LIKE "%Albert%";

-- Find all sailor id's of sailors who have a rating of at lease 8 or reserved boat 103
(SELECT sid FROM SAILORS WHERE rating>=8)
UNION 
(SELECT sid FROM RESERVES WHERE bid=103);

(SELECT sid,sname FROM SAILORS WHERE rating>=8)
UNION 
(SELECT r.sid,s.sname FROM SAILORS s, BOAT b, RESERVES r WHERE  s.sid=r.sid AND b.bid=r.bid and r.bid=103);

-- Find the name of the sailors who have not reserved a boat whose name contains the string 'storm'. Order the names in ascending order.
SELECT s.sname FROM SAILORS s
WHERE s.sid NOT IN
(SELECT s1.sid FROM SAILORS s1, RESERVES r1 WHERE s1.sid=r1.sid AND s1.sname LIKE "%storm%")
AND s.sname LIKE "%storm%"
ORDER BY s.sname ASC;

-- Find the names of sailors who have reserved all boats.
SELECT sname FROM SAILORS s WHERE NOT EXISTS
(SELECT * FROM BOAT b WHERE NOT EXISTS
(SELECT * FROM RESERVES r WHERE s.sid=r.sid and b.bid=r.bid));

-- Find name and age of the oldest sailor
SELECT sname,age FROM SAILORS WHERE age IN (SELECT max(AGE) FROM SAILORS);

-- Find each boat which was reserved by atleast 2 sailors with age>=40,
--  find the boat id and the average age of such sailors.
SELECT r.bid, avg(s.age) AS average_age
FROM SAILORS s, BOAT b, RESERVES r
WHERE s.sid=r.sid AND b.bid=r.bid AND s.age>=40
GROUP BY b.bid HAVING COUNT(r.sid)>=2;

-- Create a view that shows the names and colours of all the boats that have been reserved by a sailor with a specific rating.
CREATE VIEW ReservedBoatByRating AS
SELECT s.sname AS Sailor_name, b.bname AS Boat_name, b.color AS Boat_color
FROM SAILORS s, BOAT b, RESERVES r 
WHERE s.sid=r.sid AND b.bid=r.bid AND s.rating=9.8;

SELECT *FROM ReservedBoatByRating;

SELECT s.sname AS Sailor_name, b.bname AS Boat_name, b.color AS Boat_color
FROM SAILORS s, BOAT b, RESERVES r 
WHERE s.sid=r.sid AND b.bid=r.bid AND s.rating=9.8;

-- A trigger that prevents boats from being deleted If they have active reservations
DELIMITER //
CREATE TRIGGER CheckAndDelete
BEFORE DELETE ON BOAT
FOR EACH ROW
BEGIN
	IF EXISTS (SELECT *FROM RESERVES WHERE RESERVES.bid=old.bid) THEN
		SIGNAL SQLSTATE '45000' SET message_text="Boat is reserved and hence cannot be deleted";
	END IF;
END;
// DELIMITER ;

DELETE FROM BOAT WHERE bid=103;


