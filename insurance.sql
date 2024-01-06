CREATE DATABASE INSURANCE;
USE INSURANCE;

CREATE TABLE PERSON(
driver_id varchar(15) primary key,
name varchar(35) not null,
address varchar(35) not null
);

CREATE TABLE CAR(
regno varchar(15) primary key,
model varchar(30) not null,
year int not null
);

CREATE TABLE ACCIDENT(
report_number int primary key,
acc_date date not null,
location varchar(40) not null
);

CREATE TABLE OWNS(
driver_id varchar(15) not null,
regno varchar(15) not null,
foreign key (driver_id) references PERSON(driver_id) on delete cascade,
foreign key (regno) references CAR(regno) on delete cascade
);

CREATE TABLE PARTICIPATED(
driver_id varchar(15) not null,
regno varchar(15) not null,
report_number int not null,
damage_amount int not null,
foreign key (driver_id) references PERSON(driver_id) on delete cascade,
foreign key (regno) references CAR(regno) on delete cascade,
foreign key (report_number) references ACCIDENT(report_number) on delete cascade
);

INSERT INTO PERSON VALUES
("01AB11", "Smith", "Mysore"),
("01AB12", "Suresh", "Bengaluru"),
("01AB13", "Ramesh", "Chikkamagaluru"),
("01AB14", "Viraj", "Tumakuru"),
("01AB15", "Soumya", "Mandya");

INSERT INTO CAR VALUES
('KA09MC5656', 'MAZDA', 2021),
("KA09MA1111", 'HARRIER',2019),
('KA09MA1234', 'NEXON' , 2020),
('KA09MB1212', 'MERCEDES', 2020),
('KA09MD3434', 'BMW', 2018);

INSERT INTO ACCIDENT VALUES
(1021, '2021-01-01', 'Mysuru'),
(1022, '2021-02-01', 'Bengaluru'),
(1023, '2021-03-01', 'Mumbai'),
(1024, '2022-01-01', 'Chennai'),
(1025, '2023-01-01','Bengaluru');

INSERT INTO OWNS VALUES 
("01AB11", "KA09MC5656"),
("01AB11", "KA09MA1111"),
("01AB13", "KA09MA1234"),
("01AB14", "KA09MB1212"),
("01AB15", "KA09MD3434");

INSERT INTO PARTICIPATED VALUES
("01AB11", "KA09MC5656", 1021, 30000),
("01AB11", "KA09MA1111", 1022, 40000),
("01AB13", "KA09MA1234", 1023, 50000),
("01AB14", "KA09MB1212", 1024, 60000),
("01AB15", "KA09MD3434", 1025, 700000);


SELECT *FROM PERSON;
SELECT *FROM CAR;
SELECT *FROM ACCIDENT;
SELECT *FROM OWNS;
SELECT *FROM PARTICIPATED;
