/* Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are
specified.
Create tables for the following schema listed below by properly specifying the primary keys and
foreign keys.
Enter at least five tuples for each relation.
Order processing database

Customer (Cust#:int, cname: string, city: string)
Order (order#:int, odate: date, cust#: int, order-amt: int)
Order-item (order#:int, Item#: int, qty: int)
Item (item#:int, unitprice: int)
Shipment (order#:int, warehouse#: int, ship-date: date)
Warehouse (warehouse#:int, city: string)

1. List the Order# and Ship_date for all orders shipped from Warehouse# "W2".
2. List the Warehouse information from which the Customer named "Kumar" was supplied his
orders. Produce a listing of Order#, Warehouse#.
3. Produce a listing: Cname, #ofOrders, Avg_Order_Amt, where the middle column is the total
number of orders by the customer and the last column is the average order amount for that
customer. (Use aggregate functions)
4. Delete all orders for customer named "Kumar".
5. Find the item with the maximum unit price.
6. A trigger that updates order_amout based on quantity and unitprice of order_item
7. Create a view to display orderID and shipment date of all orders shipped from a warehouse
*/

CREATE DATABASE ORDERPROCESSING;
USE ORDERPROCESSING;

CREATE TABLE CUSTOMER(
cust_id int primary key,
cname varchar(35) not null,
city varchar(35) not null
);

CREATE TABLE ORDERS(
order_id int primary key,
odate date not null,
cust_id int not null,
order_amt int not null,
foreign key (cust_id) references CUSTOMER(cust_id) on delete cascade
);

CREATE TABLE ITEM(
item_id int primary key,
unitprice int not null
);

CREATE TABLE ORDER_ITEM(
order_id int not null,
item_id int not null,
qty int not null,
foreign key (order_id) references ORDERS(order_id) on delete cascade,
foreign key (item_id) references ITEM(item_id) on delete cascade
);
 
CREATE TABLE WAREHOUSE(
warehouse_id int primary key,
city varchar(15) not null
);

CREATE TABLE SHIPMENT(
order_id int not null,
warehouse_id int not null,
ship_date date not null,
foreign key (order_id) references ORDERS(order_id) on delete cascade,
foreign key (warehouse_id) references WAREHOUSE(warehouse_id) on delete cascade
);

INSERT INTO CUSTOMER VALUES
(1,'Sia','Mysuru'),
(2,'Mia','Bengaluru'),
(3,'Pia','Mumbai'),
(4,'Kumar','Delhi'),
(5,'Tia','Chennai');

INSERT INTO ORDERS VALUES
(1001, "2020-01-14", 1, 2000),
(1002, "2021-04-13", 2, 500),
(1003, "2019-10-02", 3, 2500),
(1004, "2019-05-12", 5, 1000),
(1005, "2020-12-23", 4, 1200),
(1006, "2021-12-12", 3, 5000);

INSERT INTO ITEM VALUES
(10001, 400),
(10002, 200),
(10003, 1000),
(10004, 100),
(10005, 500);

INSERT INTO ORDER_ITEM VALUES 
(1001, 10001, 5),
(1002, 10005, 1),
(1003, 10005, 5),
(1004, 10003, 1),
(1005, 10004, 12);

INSERT INTO WAREHOUSE VALUES
(501, "Mysuru"),
(502, "Bengaluru"),
(503, "Mumbai"),
(504, "Dehli"),
(505, "Chennai");

INSERT INTO SHIPMENT VALUES
(1001, 501, "2020-01-16"),
(1002, 502, "2021-04-14"),
(1003, 502, "2019-10-07"),
(1004, 504, "2019-05-16"),
(1005, 505, "2020-12-23");

SELECT * FROM CUSTOMER;
/*+---------+-------+-----------+
| cust_id | cname | city      |
+---------+-------+-----------+
|       1 | Sia   | Mysuru    |
|       2 | Mia   | Bengaluru |
|       3 | Pia   | Mumbai    |
|       4 | Kumar | Delhi     |
|       5 | Tia   | Chennai   |
+---------+-------+-----------+
5 rows in set (0.00 sec)
*/

SELECT * FROM ORDERS;
/*
+----------+------------+---------+-----------+
| order_id | odate      | cust_id | order_amt |
+----------+------------+---------+-----------+
|     1001 | 2020-01-14 |       1 |      2000 |
|     1002 | 2021-04-13 |       2 |       500 |
|     1003 | 2019-10-02 |       3 |      2500 |
|     1004 | 2019-05-12 |       5 |      1000 |
|     1005 | 2020-12-23 |       4 |      1200 |
|     1006 | 2021-12-12 |       3 |      5000 |
+----------+------------+---------+-----------+
6 rows in set (0.00 sec)
*/

SELECT * FROM ITEM;
/*
+---------+-----------+
| item_id | unitprice |
+---------+-----------+
|   10001 |       400 |
|   10002 |       200 |
|   10003 |      1000 |
|   10004 |       100 |
|   10005 |       500 |
+---------+-----------+
5 rows in set (0.00 sec)
*/

SELECT * FROM ORDER_ITEM;
/*
+----------+---------+-----+
| order_id | item_id | qty |
+----------+---------+-----+
|     1001 |   10001 |   5 |
|     1002 |   10005 |   1 |
|     1003 |   10005 |   5 |
|     1004 |   10003 |   1 |
|     1005 |   10004 |  12 |
+----------+---------+-----+
5 rows in set (0.00 sec)
*/

SELECT * FROM WAREHOUSE;
/*
+--------------+-----------+
| warehouse_id | city      |
+--------------+-----------+
|          501 | Mysuru    |
|          502 | Bengaluru |
|          503 | Mumbai    |
|          504 | Dehli     |
|          505 | Chennai   |
+--------------+-----------+
5 rows in set (0.00 sec)
*/

SELECT * FROM SHIPMENT;
/*
+----------+--------------+------------+
| order_id | warehouse_id | ship_date  |
+----------+--------------+------------+
|     1001 |          501 | 2020-01-16 |
|     1002 |          502 | 2021-04-14 |
|     1003 |          502 | 2019-10-07 |
|     1004 |          504 | 2019-05-16 |
|     1005 |          505 | 2020-12-23 |
+----------+--------------+------------+
5 rows in set (0.00 sec)
*/

-- List the Order# and Ship_date for all orders shipped from Warehouse# "W2" (warehouse_id=502).
SELECT order_id,ship_date
FROM SHIPMENT
WHERE warehouse_id=502;
/*
+----------+------------+
| order_id | ship_date  |
+----------+------------+
|     1002 | 2021-04-14 |
|     1003 | 2019-10-07 |
+----------+------------+
2 rows in set (0.00 sec)
*/

-- List the Warehouse information from which the Customer named "Kumar" was supplied his
-- orders. Produce a listing of Order#, Warehouse#.
SELECT s.order_id,s.warehouse_id 
FROM SHIPMENT s,ORDERS o,CUSTOMER c
WHERE cname LIKE '%kumar%' AND c.cust_id=o.cust_id AND o.order_id=s.order_id;
/*
+----------+--------------+
| order_id | warehouse_id |
+----------+--------------+
|     1005 |          505 |
+----------+--------------+
1 row in set (0.00 sec)
*/

-- Produce a listing: Cname, #ofOrders, Avg_Order_Amt, where the middle column is the total
-- number of orders by the customer and the last column is the average order amount for that
-- customer. (Use aggregate functions)
SELECT cname,COUNT(order_id),AVG(order_amt) 
FROM CUSTOMER c,ORDERS o
WHERE c.cust_id=o.cust_id
GROUP BY cname;
/*
+-------+-----------------+----------------+
| cname | COUNT(order_id) | AVG(order_amt) |
+-------+-----------------+----------------+
| Sia   |               1 |      2000.0000 |
| Mia   |               1 |       500.0000 |
| Pia   |               2 |      3750.0000 |
| Kumar |               1 |      1200.0000 |
| Tia   |               1 |      1000.0000 |
+-------+-----------------+----------------+
5 rows in set (0.00 sec)
*/

-- Delete all orders for customer named "Kumar".
DELETE FROM ORDERS 
WHERE cust_id=(SELECT cust_id FROM CUSTOMER WHERE cname LIKE "%kumar%");
-- Query OK, 1 row affected (0.04 sec)
SELECT * FROM ORDERS;
/*
+----------+------------+---------+-----------+
| order_id | odate      | cust_id | order_amt |
+----------+------------+---------+-----------+
|     1001 | 2020-01-14 |       1 |      2000 |
|     1002 | 2021-04-13 |       2 |       500 |
|     1003 | 2019-10-02 |       3 |      2500 |
|     1004 | 2019-05-12 |       5 |      1000 |
|     1006 | 2021-12-12 |       3 |      5000 |
+----------+------------+---------+-----------+
5 rows in set (0.00 sec)
*/

-- Find the item with the maximum unit price.
SELECT MAX(unitprice) FROM ITEM;
/*
+----------------+
| MAX(unitprice) |
+----------------+
|           1000 |
+----------------+
1 row in set (0.00 sec)
*/
SELECT * FROM ITEM 
WHERE unitprice=(SELECT MAX(unitprice) FROM ITEM);
/*
+---------+-----------+
| item_id | unitprice |
+---------+-----------+
|   10003 |      1000 |
+---------+-----------+
1 row in set (0.00 sec)
*/
SELECT item_id,unitprice AS max_unitprice 
FROM ITEM 
WHERE unitprice=(SELECT MAX(unitprice) FROM ITEM);
/*
+---------+---------------+
| item_id | max_unitprice |
+---------+---------------+
|   10003 |          1000 |
+---------+---------------+
1 row in set (0.00 sec)
*/

-- A trigger that updates order_amout based on quantity and unitprice of order_item
DELIMITER $$
CREATE TRIGGER UpdateOrderAmount
AFTER INSERT ON ORDER_ITEM
FOR EACH ROW
BEGIN
UPDATE ORDERS SET order_amt=(new.qty*(SELECT DISTINCT unitprice FROM ITEM NATURAL JOIN ORDER_ITEM WHERE item_id=new.item_id)) WHERE ORDERS.order_id=NEW.order_id;
END; $$
-- Query OK, 0 rows affected (0.06 sec)
DELIMITER ;

INSERT INTO ORDERS VALUES
(1007,'2022-01-01',5,1300);
-- Query OK, 1 row affected (0.06 sec)

INSERT INTO ORDER_ITEM VALUES
(1007,10005, 3);
-- Query OK, 1 row affected (0.06 sec)

SELECT *FROM ORDERS;
/*
+----------+------------+---------+-----------+
| order_id | odate      | cust_id | order_amt |
+----------+------------+---------+-----------+
|     1001 | 2020-01-14 |       1 |      2000 |
|     1002 | 2021-04-13 |       2 |       500 |
|     1003 | 2019-10-02 |       3 |      2500 |
|     1004 | 2019-05-12 |       5 |      1000 |
|     1006 | 2021-12-12 |       3 |      5000 |
|     1007 | 2022-01-01 |       5 |      1500 |
+----------+------------+---------+-----------+
6 rows in set (0.00 sec)
*/


-- Create a view to display orderID and shipment date of all orders shipped from a warehouse
CREATE VIEW OrderInfoOfWarehouse AS
SELECT order_id,ship_date
FROM SHIPMENT
WHERE warehouse_id=502;
-- Query OK, 0 rows affected (0.06 sec)
SELECT * FROM OrderInfoOfWarehouse;
/*
+----------+------------+
| order_id | ship_date  |
+----------+------------+
|     1002 | 2021-04-14 |
|     1003 | 2019-10-07 |
+----------+------------+
2 rows in set (0.00 sec)
*/
