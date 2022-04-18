/*
TRIESTE_advanceSQL
Database DEsign Lab Exercise Advanced SQL Part 1
Dr. Steven C. LINdo 
NYiT – New York INstitute of Technology 
CSCi 760 - Database Systems  SprINg 2022 
*/

use nyit_classicmodels;

 /***************************************************** PART 1 ****************************************
Convert the following QUERIES to Stored Procedures:
--1
SELECT  
  SUM(p.amount), 
  c.customerName 
FROM  
  payments p 
Inner join customers c 
using(customerNumber) 
group by customerName;
*/

-- 1 
use nyit_classicmodels;

DELIMITER $$
DROP PROCEDURE IF EXISTS trieste_GetSumByCustomer;
CREATE PROCEDURE trieste_GetSumByCustomer()
BEGIN
 	SELECT 
		SUM(p.amount) AS "Total Paytments", 
		c.customerName  AS "Customer Name"
	FROM  
		payments p 
		INNER JOIN customers c 
		USING(customerNumber) 
	GROUP BY customerName;
END$$
DELIMITER ;

-- test above with 'CALL trieste_GetSumByCustomer';
CALL trieste_GetSumByCustomer();

-- 2
use nyit_classicmodels;

DELIMITER $$
DROP PROCEDURE IF EXISTS trieste_GetCALCustomers;
CREATE PROCEDURE trieste_GetCALCustomers()
BEGIN
 	SELECT lastName AS "Employee Last Name with CA Custs"
	FROM employees  
	WHERE employeeNumber IN
		(SELECT salesRepEmployeeNumber   
		FROM customers 
		WHERE state='CA');
END$$
DELIMITER ;

-- test above with 'CALL trieste_GetCALCustomers';
CALL trieste_GetCALCustomers();

-- 3
use nyit_classicmodels;

DELIMITER $$
DROP PROCEDURE IF EXISTS trieste_GetCustNameFromOrderDetails;
CREATE PROCEDURE trieste_GetCustNameFromOrderDetails()
BEGIN
 	SELECT customerName  
	FROM customers  
	WHERE customerNumber IN 
		(SELECT customerNumber 
		FROM orders WHERE 
		orderNumber IN  
			(SELECT orderNumber FROM 
			orderdetails) ); 
END$$
DELIMITER ;

-- test above with 'CALL trieste_GetCustNameFromOrderDetails';
CALL trieste_GetCustNameFromOrderDetails();

 /***************************************************** PART 2 ****************************************
Convert the following QUERIES to Stored Procedures PASSING in VARIABLES:
-- 1
select  
  SUM(p.amount), 
  c.customerName 
from  
  payments p 
inner join customers c 
using(customerNumber) 
group by customerName;
*/

use nyit_classicmodels;

DELIMITER $$
DROP PROCEDURE IF EXISTS trieste_GetSumPaymentsByCust;
CREATE PROCEDURE trieste_GetSumPaymentsByCust(
	IN custName VARCHAR(100), 
    OUT sumTotal NUMERIC(18,2))
BEGIN
	DECLARE sumPayments INT DEFAULT 0;    
    SELECT  
	SUM(p.amount) INTO sumTotal
	FROM payments p 
		INNER JOIN customers c 
		USING(customerNumber) 
	WHERE customerName = custName
    GROUP BY customerName;   
END$$
DELIMITER ;
-- test results  by passing in a customer
CALL trieste_GetSumPaymentsByCust('Signal Gift Stores', @sumTotal);
SELECT 'Signal Gift Stores' AS "Customer Name", @sumtotal AS "Sum Payments";

-- 2 Modify this SP to pass in State 
-- **result has more than 1 row so we will use a temp table** 
/*
	select lastName 
	from employees  
	where employeeNumber in 
	(select salesRepEmployeeNumber   
    from customers 
    where state='CA'); 
*/    
use nyit_classicmodels;   
DROP PROCEDURE IF EXISTS trieste_GetRepwithCustInState; 

DELIMITER $$
CREATE PROCEDURE trieste_GetRepwithCustInState(
	IN findState CHAR(2) 
)
BEGIN	
	DECLARE repName VARCHAR(100) DEFAULT "";
	CREATE TEMPORARY TABLE RepTable (findState CHAR(2), repName varchar(100));
	INSERT INTO RepTable (
	SELECT  findState,  lastName 
	FROM employees  
	WHERE employeeNumber IN 
		(SELECT salesRepEmployeeNumber   
		FROM customers 
		WHERE state = findState));  
    SELECT * from RepTable;
    -- stored procedure will handle dropping the temp table as well;
	DROP TABLE IF EXISTS RepTable;
END$$
DELIMITER ;

-- test with 'CA' ; we are expecting 2 rows ; "Jennings" and "Thomson" ; 
-- hence cannot fit two results in a variable so need table ! 
call trieste_GetRepwithCustInState('CA');

-- 3 Modify this stored procedure to take IN customerNumber. 

use nyit_classicmodels;   
DROP PROCEDURE IF EXISTS trieste_GetCustNameFromOrderNum;
DELIMITER $$
CREATE PROCEDURE trieste_GetCustNameFromOrderNum( 
	IN f_customerNumber INT, 
    OUT custName VARCHAR(100)
)
BEGIN
 	SELECT customerName  
	FROM (
    SELECT * FROM customers  
	WHERE customerNumber IN 
		(SELECT customerNumber 
		FROM orders WHERE 
		orderNumber IN  
			(SELECT orderNumber FROM 
			orderdetails))) AS custNameTable WHERE customerNumber = f_customerNumber ;
END$$
DELIMITER ;

-- test above with 'CALL trieste_GetCustNameFromOrderNum(496)';
CALL trieste_GetCustNameFromOrderNum('496',@custName);
 
 
 /***************************************************** PART 3 ****************************************
 Modify the Stored Procedure above to do the following  
 Consider the following STORED PROCEDURE LEAVE key word  
 
CREATE PROCEDURE lindo_LeaveDemo(OUT result VARCHAR(100)) 
BEGIN 
    DECLARE counter INT DEFAULT 1; 
    DECLARE times INT; 
    -- generate a random integer between 4 and 10 
    SET times  = FLOOR(RAND()*(10-4+1)+4); 
    SET result = ''; 
    disp: LOOP 
        -- concatenate counters into the result 
        SET result = concat(result,counter,','); 
         
        -- exit the loop if counter equals times 
        IF counter = times THEN 
            LEAVE disp;  
        END IF; 
        SET counter = counter + 1; 
    END LOOP; 
END$$ 
 
DELIMITER ; 
 
--Run this Stored procedure with the following statement 

CALL lindo_LeaveDemo(@result); 
SELECT @result; 

modify with:
1. Add an IN parameter called guess 
2. Generate random number between 1 and 20 
3. Call the stored procedure with your guess, for example: 
 
CALL lindo_LeaveDemo(5, @result); 
SELECT @result; 
 
Run it several times to see that it is working as expected.   
 */ 
 

DROP PROCEDURE IF EXISTS  trieste_LeaveDemo;
DELIMITER $$ 
CREATE PROCEDURE trieste_LeaveDemo( 
	IN guess INT, 
	OUT result VARCHAR(100)
)
BEGIN 
    DECLARE counter INT DEFAULT 1; 
    DECLARE times INT; 
	-- rand num between 1 and 20 
	SET times = FLOOR(RAND()*(20-1+1))+1;
    SET result = '|'; 
    disp: LOOP 
        -- concatenate counters into the result 
        SET result = concat(result,counter,'|'); 
        -- exit the loop if counter equals times 
        IF counter = times THEN 
            LEAVE disp;  
        END IF; 
        SET counter = counter + 1; 
    END LOOP; 
END$$ 
DELIMITER ; 
 
-- Run this Stored procedure with the following statement 
CALL trieste_LeaveDemo(2, @result); 
SELECT @result; 
 
 /***************************************************** PART 4 ****************************************
 Write a STORED PROCEDURE to do the following
 The President of this company pays sales bonus to each of his employees at a standard 15% 
rate.  But for the top employee for each year she/he pays them and extra $2,500. 
 
Your manager comes to you and said can you please write a two (2) stored procedure  
1. That would create the full report for your manager with all employees and bonus 
amounts for each year.  The report should look similar to the following table: 

Employee_Num Employee_LastName Bonus_2003 Bonus_2004 Bonus_2005 
     
2. That would take as the IN parameter the employee number and return a single report 
for that employee only.  In this case it would return only 1 tuple (or row of results) 
 */
 
 -- let's check the data first 
WITH CTE AS (
SELECT 
        e.employeeNumber AS "Employee_Num", 
        e.lastName AS "Employee_LastName",
        YEAR(paymentDate) AS "Year",
		SUM(p.amount) AS "Total Sales",
        SUM(p.amount) * 0.15 AS "Bonus"
	FROM  
		payments p 
		JOIN customers c ON c.customerNumber = p.customerNumber
        JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
	WHERE YEAR(paymentDate) IN (2003, 2004, 2005)
	GROUP BY e.employeeNumber, YEAR(paymentDate)
    ORDER BY YEAR(paymentDate) DESC, SUM(p.amount) DESC
) SELECT * FROM CTE 

-- step 2 
use nyit_classicmodels; 
DROP PROCEDURE IF EXISTS trieste_GetBonus; 
DELIMITER $$
CREATE PROCEDURE trieste_GetBonus()
BEGIN
CREATE TEMPORARY TABLE BonusTable (Employee_Num INT, Employee_LastName varchar(100), Bonus_2003 NUMERIC(18,2), Bonus_2004 NUMERIC(18,2), Bonus_2005 NUMERIC(18,2));	
INSERT INTO BonusTable
WITH CTE AS (
SELECT 
        e.employeeNumber AS "Employee_Num", 
        e.lastName AS "Employee_LastName",
        YEAR(paymentDate) AS "Sales_Year",
		SUM(p.amount) AS "Total_Sales",
        SUM(p.amount) * 0.15 AS "Bonus"
	FROM  
		payments p 
		JOIN customers c ON c.customerNumber = p.customerNumber
        JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
	WHERE YEAR(paymentDate) IN (2003, 2004, 2005)
	GROUP BY e.employeeNumber, YEAR(paymentDate)
    ORDER BY YEAR(paymentDate) DESC, SUM(p.amount) DESC
),
CTE2 AS (
SELECT Employee_Num, Employee_LastName, Sales_Year, Total_Sales, Bonus,
CASE Sales_Year 
	WHEN 2003 THEN Bonus ELSE 0 END AS "Bonus_2003",
CASE Sales_Year 
	WHEN 2004 THEN Bonus ELSE 0 END AS "Bonus_2004",
CASE Sales_Year 
	WHEN 2005 THEN Bonus ELSE 0 END AS "Bonus_2005"
FROM CTE 
GROUP BY 
Employee_Num, Employee_LastName, Bonus_2003, Bonus_2004, Bonus_2005 
) SELECT Employee_Num, Employee_LastName, Bonus_2003, Bonus_2004, Bonus_2005 
	FROM CTE2;
SELECT * 
FROM BonusTable;
DROP TABLE IF EXISTS BonusTable;
END$$
DELIMITER ;
-- test 
call trieste_GetBonus;

-- part 2 
WITH CTE AS (
SELECT 
        e.employeeNumber AS "Employee_Num", 
        e.lastName AS "Employee_LastName",
        YEAR(paymentDate) AS "Sales_Year",
		SUM(p.amount) AS "Total Sales",
        SUM(p.amount) * 0.15 AS "Bonus"
	FROM  
		payments p 
		JOIN customers c ON c.customerNumber = p.customerNumber
        JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
	WHERE YEAR(paymentDate) IN (2003, 2004, 2005)
	GROUP BY e.employeeNumber, YEAR(paymentDate)
    ORDER BY YEAR(paymentDate) DESC, SUM(p.amount) DESC
),
CTE2 AS (
SELECT *
FROM CTE
WHERE Employee_Num = 1612 AND Sales_Year = 2004
) SELECT * FROM CTE2
 
 
 -- end work Robert Trieste  