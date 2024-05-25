-- 1. ADD NEW COLUMN
ALTER TABLE customer ADD interest FLOAT NOT NULL DEFAULT 0;

-- 2. MODIFY (change the datatype)
ALTER TABLE customer MODIFY interest DOUBLE NOT NULL DEFAULT 0;

-- 3. RENAME COLUMN (CHANGE COLUMN) 
ALTER TABLE customer CHANGE COLUMN interest saving_interest FLOAT NOT NULL DEFAULT 0;

-- 4. DROP COLUMN
ALTER TABLE customer DROP COLUMN saving_interest;

-- 5. RENAME THE TABLE 
ALTER TABLE customer RENAME TO customer_details;

SELECT * FROM customer;

-- DESCRIBE
DESC customer;