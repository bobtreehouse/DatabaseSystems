/*
TRIESTE_assignment_7_Dreamhome_Joins
Dr. Steven C. Lindo
NYIT – New York Institute of Technology 
CSCI 760 - Database Systems  Spring 2022 
*/

USE nyit_1289056_dreamhome;

 
/*
(INNER) JOIN (aka JOIN)
1.	List the names of all clients who have viewed a property, along with any comments supplied.

2.	Write a SQL query to list employee names (first name, last name) and their Supervisor names (first name, last name). The output header must clearly indicates who is employee and Supervisor. (refer to A_Employee table)

3.	For each branch office, list the staff numbers and names of staff who manage properties and the properties that they manage.

4.	For each branch, list the staff numbers and names of staff who manage properties, including the city in which the branch is located and the properties that the staff manage.

5.	Display the product names and the comments that customer BJ1 gave. (refer to A_Cusomters, A_Reviews, A_Products)

6.	Find the number of properties handled by each staff member, along with the branch number of the member of staff.

*/

-- 1 

USE nyit_1289056_dreamhome;
SELECT a.fName, a.lName, b.comment, b.viewDate
FROM nyit_1289056_dreamhome.client a 
JOIN nyit_1289056_dreamhome.viewing b ON a.clientNo = b.clientNo
ORDER BY b.viewDate DESC;

-- results1
'Aline', 'Steward', '', '2015-05-26'
'Aline', 'Steward', 'too small', '2015-05-24'
'Mary', 'Tregear', 'no dining room', '2015-05-14'
'Aline', 'Steward', '', '2015-04-28'
'John', 'Kay', 'too remote', '2015-04-20'


-- 2
USE nyit_1289056_dreamhome;
SELECT a.fName AS "Employee First", 
a.lName AS "Employee Last",
a.position AS "Employee Position",
b.fName AS "Supervisor First", 
b.lName AS "Supervisor Last",
b.position AS "Position"
FROM nyit_1289056_dreamhome.staff a 
JOIN nyit_1289056_dreamhome.staff b  
WHERE a.position != "Supervisor" AND b.position = "Supervisor"
ORDER BY a.lName ASC;

-- results 
-- Employee First, Employee Last, Employee Position, Supervisor First, Supervisor Last, Position
'Ann', 'Beech', 'Assistant', 'David', 'Ford', 'Supervisor'
'Susan', 'Brand', 'Manager', 'David', 'Ford', 'Supervisor'
'Mary', 'Howe', 'Assistant', 'David', 'Ford', 'Supervisor'
'Julie', 'Lee', 'Assistant', 'David', 'Ford', 'Supervisor'
'John', 'White', 'Manager', 'David', 'Ford', 'Supervisor'

-- 3
USE nyit_1289056_dreamhome;
SELECT 
a.staffNo AS "Staff No"
,a.fName AS "First Name"   
,a.lName AS "Last Name"
,b.propertyNo AS "Prop No."
,b.street AS "Prop Street"
,b.type AS "Prop Type"
,b.branchNo AS "Branch No"
FROM nyit_1289056_dreamhome.staff a 
JOIN nyit_1289056_dreamhome.propertyforrent b ON a.staffNo = b.staffNo
GROUP BY b.branchNo;

-- results 
--  Staff No, First Name, Last Name, Prop No., Prop Street, Prop Type, BRanch No
'SA9', 'Mary', 'Howe', 'PA14', '16 Holhead', 'House', 'B007'
'SG14', 'David', 'Ford', 'PG16', '5 Novar Dr', 'Flat', 'B003'
'SL41', 'Julie', 'Lee', 'PL94', '6 Argyll St', 'Flat', 'B005'

 -- 4
 USE nyit_1289056_dreamhome;
SELECT 
a.staffNo AS "Staff No"
,a.fName AS "First Name"   
,a.lName AS "Last Name"
,b.city AS "Branch City"
,c.propertyNo AS "Prop No."
,c.street AS "Prop Street"
,c.type AS "Prop Type"
FROM nyit_1289056_dreamhome.staff a 
JOIN nyit_1289056_dreamhome.branch b ON a.branchNo = b.branchNo 
JOIN nyit_1289056_dreamhome.propertyforrent c ON c.staffNo = a.staffNo
ORDER BY a.lName ASC;

-- results
-- Staff No, First Name, Last Name, Branch City, Prop No., Prop Street, Prop Type
'SG37', 'Ann', 'Beech', 'Glasgow', 'PG21', '18 Dale Rd', 'House'
'SG37', 'Ann', 'Beech', 'Glasgow', 'PG36', '2 Manor Rd', 'Flat'
'SG14', 'David', 'Ford', 'Glasgow', 'PG16', '5 Novar Dr', 'Flat'
'SA9', 'Mary', 'Howe', 'Aberdeen', 'PA14', '16 Holhead', 'House'
'SL41', 'Julie', 'Lee', 'London', 'PL94', '6 Argyll St', 'Flat'

-- 5
-- ** No Cust 'BJ1' so picked 'CR62'
SELECT
a.clientNo AS "Client No"
,a.comment AS "Comment" 
,a.propertyNo AS "Prop No"
,c.type AS "Prop Type"
FROM viewing a
JOIN client b ON a.clientNo = b.clientNo
JOIN propertyforrent c ON  c.propertyNo = a.propertyNo 
WHERE a.clientNo = 'CR62';

-- results 
-- Client No, Comment, Prop No, Prop Type
'CR62', 'no dining room', 'PA14', 'House'

-- 6
USE nyit_1289056_dreamhome;
SELECT 
a.staffNo AS "Staff No"
,a.fName AS "First Name"   
,a.lName AS "Last Name"
,COUNT(*) AS "No Of Props"
,b.branchNo AS "Branch No"
FROM nyit_1289056_dreamhome.staff a 
JOIN nyit_1289056_dreamhome.propertyforrent b ON a.staffNo = b.staffNo
GROUP BY a.staffNo
ORDER BY a.lName ASC; 
 
-- results 
-- Staff No, First Name, Last Name, No Of Props, Branch No
'SG37', 'Ann', 'Beech', '2', 'B003'
'SG14', 'David', 'Ford', '1', 'B003'
'SA9', 'Mary', 'Howe', '1', 'B007'
'SL41', 'Julie', 'Lee', '1', 'B005'


-- end 






/****************************
SQL to CREATE Tables 
if cloud instance is down
****************************/
CREATE DATABASE IF NOT EXISTS nyit_1289056_dreamhome;
USE nyit_1289056_dreamhome;

DROP TABLE IF EXISTS branch;

CREATE TABLE branch
(branchNo char(5) PRIMARY KEY,
 street varchar(35),
 city varchar(10),
 postcode varchar(10)
);

INSERT INTO branch VALUES('B005','22 Deer Rd','London','SW1 4EH');
INSERT INTO branch VALUES('B007','16 Argyll St', 'Aberdeen','AB2 3SU');
INSERT INTO branch VALUES('B003','163 Main St', 'Glasgow','G11 9QX');
INSERT INTO branch VALUES('B004','32 Manse Rd', 'Bristol','BS99 1NZ');
INSERT INTO branch VALUES('B002','56 Clover Dr', 'London','NW10 6EU');

DROP TABLE if EXISTS staff;

CREATE TABLE staff
(staffNo char(5) PRIMARY KEY,
 fName varchar(10),
 lName varchar(10),
 position varchar(10),
 sex char(1),
 DOB date,
 salary int,
 branchNo char(5)
);

INSERT INTO staff VALUES('SL21','John','White','Manager','M','1965-10-01',30000,'B005');
INSERT INTO staff VALUES('SG37','Ann','Beech','Assistant','F','1980-11-10',12000,'B003');
INSERT INTO staff VALUES('SG14','David','Ford','Supervisor','M','1978-03-24',18000,'B003');
INSERT INTO staff VALUES('SA9','Mary','Howe','Assistant','F','1990-02-19',9000,'B007');
INSERT INTO staff VALUES('SG5','Susan','Brand','Manager','F','1960-06-03',24000,'B003');
INSERT INTO staff VALUES('SL41','Julie','Lee','Assistant','F','1985-06-13',9000,'B005');

DROP TABLE IF EXISTS privateOwner;
CREATE TABLE privateOwner
(ownerNo char(5) PRIMARY KEY,
 fName varchar(10),
 lName varchar(10),
 address varchar(50),
 telNo char(15),
 email varchar(50),
 password varchar(40)
);

INSERT INTO privateOwner VALUES('CO46','Joe','Keogh','2 Fergus Dr. Aberdeen AB2 ','01224-861212', 'jkeogh@lhh.com', null);
INSERT INTO privateOwner VALUES('CO87','Carol','Farrel','6 Achray St. Glasgow G32 9DX','0141-357-7419', 'cfarrel@gmail.com', null);
INSERT INTO privateOwner VALUES('CO40','Tina','Murphy','63 Well St. Glasgow G42','0141-943-1728', 'tinam@hotmail.com', null);
INSERT INTO privateOwner VALUES('CO93','Tony','Shaw','12 Park Pl. Glasgow G4 0QR','0141-225-7025', 'tony.shaw@ark.com', null);

DROP TABLE IF EXISTS propertyForRent;
CREATE TABLE propertyForRent
(propertyNo char(5) PRIMARY KEY,
 street varchar(35),
 city varchar(10),
 postcode varchar(10),
 type varchar(10),
 rooms smallint,
 rent int,
 ownerNo char(5) not null,
 staffNo char(5),
 branchNo char(5)
);

INSERT INTO propertyForRent VALUES('PA14','16 Holhead','Aberdeen','AB7 5SU','House',6,650,'CO46','SA9','B007');
INSERT INTO propertyForRent VALUES('PL94','6 Argyll St','London','NW2','Flat',4,400,'CO87','SL41','B005' );
INSERT INTO propertyForRent VALUES('PG4','6 Lawrence St','Glasgow','G11 9QX','Flat',3,350,'CO40', NULL, 'B003');
INSERT INTO propertyForRent VALUES('PG36','2 Manor Rd','Glasgow','G32 4QX','Flat',3,375,'CO93','SG37','B003' );
INSERT INTO propertyForRent VALUES('PG21','18 Dale Rd','Glasgow','G12','House',5,600,'CO87','SG37','B003');
INSERT INTO propertyForRent VALUES('PG16','5 Novar Dr','Glasgow','G12 9AX','Flat',4,450,'CO93','SG14','B003' );

DROP TABLE IF EXISTS client;
CREATE TABLE client
(clientNo char(5) PRIMARY KEY,
 fName varchar(10),
 lName varchar(10),
 telNo char(15),
 prefType varchar(10),
 maxRent int,
 email varchar(50)
);

INSERT INTO client VALUES('CR76','John','Kay','0171-774-5632','Flat',425, 'john.kay@gmail.com');
INSERT INTO client VALUES('CR56','Aline','Steward','0141-848-1825','Flat',350, 'astewart@hotmail.com');
INSERT INTO client VALUES('CR74','Mike','Ritchie','01475-943-1728','House',750, 'mritchie@yahoo.co.uk');
INSERT INTO client VALUES('CR62','Mary','Tregear','01224-196720','Flat',600, 'maryt@hotmail.co.uk');

DROP TABLE IF EXISTS viewing;
CREATE TABLE  viewing
(clientNo char(5) not null,
 propertyNo char(5) not null,
 viewDate date,
 comment varchar(15)
);
INSERT INTO viewing VALUES('CR56','PA14','2015-05-24','too small');
INSERT INTO viewing VALUES('CR76','PG4','2015-04-20','too remote');
INSERT INTO viewing VALUES('CR56','PG4','2015-05-26','');
INSERT INTO viewing VALUES('CR62','PA14','2015-05-14','no dining room');
INSERT INTO viewing VALUES('CR56','PG36','2015-04-28','');

DROP TABLE IF EXISTS registration;
CREATE TABLE registration
(clientNo char(5) not null,
 branchNo char(5) not null,
 staffNo char(5) not null,
 dateJoined date
);

INSERT INTO registration VALUES('CR76','B005','SL41','2015-01-13');
INSERT INTO registration VALUES('CR56','B003','SG37','2014-04-13');
INSERT INTO registration VALUES('CR74','B003','SG37','2013-11-16');
INSERT INTO registration VALUES('CR62','B007','SA9','2014-03-07');
