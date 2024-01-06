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
(0001,'Sia','Mysuru'),
(0002,'Mia','Bengaluru'),
(0003,'Pia','Mumbai'),
(0004,'Kumar','Delhi'),
(0005,'Tia','Chennai');

INSERT INTO ORDERS VALUES
(1001, "2020-01-14", 0001, 2000),
(1002, "2021-04-13", 0002, 500),
(1003, "2019-10-02", 0003, 2500),
(1004, "2019-05-12", 0005, 1000),
(1005, "2020-12-23", 0004, 1200);

INSERT INTO ITEM VALUES
(0001, 400),
(0002, 200),
(0003, 1000),
(0004, 100),
(0005, 500);

INSERT INTO WAREHOUSE VALUES
(501, "Mysuru"),
(502, "Bengaluru"),
(503, "Mumbai"),
(504, "Dehli"),
(505, "Chennai");

INSERT INTO ORDER_ITEM VALUES 
(1001, 0001, 5),
(1002, 0005, 1),
(1003, 0005, 5),
(1004, 0003, 1),
(1005, 0004, 12);

INSERT INTO SHIPMENT VALUES
(1001, 0002, "2020-01-16"),
(1002, 0001, "2021-04-14"),
(1003, 0004, "2019-10-07"),
(1004, 0003, "2019-05-16"),
(1005, 0005, "2020-12-23");
