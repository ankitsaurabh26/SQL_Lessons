-- 1. INSERT 
INSERT INTO customer_details(ID,NAME,BALANCE) VALUES
(2,'Animesh',9000),
(3,'Kartik',6000),
(4,'Soumik',5000);

INSERT INTO customer_details VALUES(5,'Sen',4200);

INSERT INTO customer_details(ID,NAME) VALUES
(6,'Bob');

-- 2. UPDATE
 UPDATE customer_details SET BALANCE = 5440 WHERE ID = 6;
 
 -- UPDATE MULTIPLE ROWS
 SET SQL_SAFE_UPDATES = 0;
 UPDATE customer_details SET BALANCE = 11000;
 UPDATE customer_details SET BALANCE = BALANCE+1;

-- 3. DELETE
DELETE FROM customer_details WHERE ID = 6;
DELETE FROM customer_details; -- DELETES ALL THE DATA FROM THE TBALE

-- 4. REPLACE
REPLACE INTO customer_details (ID,NAME) VALUES (4,"Ankit"); -- REPLACE INTO customer_details (primary_key,column_name) -> other values become NULL
-- REPLACE WORKING AS INSERT
REPLACE INTO customer_details (ID,NAME) VALUES (10,"BAPPIII");
-- OTHER WAYS
REPLACE INTO customer_details SET ID = 9, NAME = "Zenitsu", BALANCE=8500;

SELECT * FROM customer_details;