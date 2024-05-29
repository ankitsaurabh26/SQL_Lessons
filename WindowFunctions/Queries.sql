USE mydb;

-- A window function makes a calculation across multiple rows that are related to the current row. 
-- For example, a window function allows you to calculate: 7-day moving averages (i.e. average values from 7 rows before the current row)
-- WINDOW FUNCTIONS RETURN ROW BY ROW RESULTS

CREATE TABLE marks (
 student_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    branch VARCHAR(255),
    marks INTEGER
);

INSERT INTO marks (name,branch,marks)VALUES 
('Nitish','EEE',82),
('Rishabh','EEE',91),
('Anukant','EEE',69),
('Rupesh','EEE',55),
('Shubham','CSE',78),
('Ved','CSE',43),
('Deepak','CSE',98),
('Arpan','CSE',95),
('Vinay','ECE',95),
('Ankit','ECE',88),
('Anand','ECE',81),
('Rohit','ECE',95),
('Prashant','MECH',75),
('Amit','MECH',69),
('Sunny','MECH',39),
('Gautam','MECH',51);

SELECT AVG(marks) FROM marks;

--  AGGREGATE FUNCTION WITH OVER()

SELECT *, AVG(marks) OVER() AS "OVERALL_AVG_OF_ALL_MARKS" FROM marks; -- A new column gets created automatically HAVING THE AVG. STORED

SELECT *, AVG(marks) OVER(PARTITION BY branch) AS "AVG_MARKS_PER_BRANCH" FROM marks; -- PARTITION BY : USED TO CREATE THE WINDOW ON A CONDITION BASIS
-- HERE PARTITION BY WILL MAKE GROUPS ON THE BASIS OF BRANCHES (JUST LIKE GROUP BY) -> FIND AVG. OF EACH GROUP AND THEN PRINT THE RESULT IN THE NEW COLUMN CREATED

-- MORE EXAMPLES
SELECT *, MIN(marks) OVER(), MAX(marks) OVER() FROM marks; -- DATA SOMETIMES GET SORTED AS WELL WHEN WE RUN THE WINDOW FUNCTION
SELECT *, MIN(marks) OVER(PARTITION BY branch), MAX(marks) OVER() FROM marks;
SELECT *, AVG(marks) OVER() AS "Overall Avg. Marks", MIN(marks) OVER(PARTITION BY branch), MAX(marks) OVER(PARTITION BY branch) FROM marks;
SELECT MIN(marks) OVER(PARTITION BY branch), MAX(marks) OVER(PARTITION BY branch) FROM marks;

-- FIND ALL THE STUDENTS WHO HAVE MARKS HIGHER THAN THE AVG. MARKS OF THEIR RESPECTIVE BRANCH
SELECT * FROM (SELECT *, AVG(marks) OVER(PARTITION BY branch) AS "AVG_PER_BRANCH" FROM marks) T WHERE T.marks > T.AVG_PER_BRANCH;

-- RANK : GIVES RANKING IN EACH PARTITION
SELECT *, RANK() OVER(ORDER BY marks DESC) FROM marks; -- RANKING IS DONE ON TOTAL DATA NO 'PARTITION BY' IS USED
SELECT *, RANK() OVER(PARTITION BY branch ORDER BY marks DESC) FROM marks; -- RANKING HERE, IS DONE ON EACH BRANCH : SAME MARKS => BOTH WILL BE GIVEN SAME RANK

-- DENSE RANK vs RANK : observe the output tables
SELECT *,RANK() OVER(PARTITION BY branch ORDER BY marks DESC) AS "RANK_OUTPUT", DENSE_RANK() OVER(PARTITION BY branch ORDER BY marks DESC) AS "DENSE_RANK_OUTPUT" FROM marks;

-- ROW NUMBER
SELECT *, ROW_NUMBER() OVER(PARTITION BY branch) AS "ROW_NUMBER_OUTPUT" FROM marks;

-- EXAMPLE:
SELECT *, CONCAT(branch , "-" , ROW_NUMBER() OVER(PARTITION BY branch)) AS "ROW_NUM_OUTPUT" FROM marks;

-- FIND TOP 2 MOST PAYING CUSTOMERS OF EACH MONTH - ORDERS TABLE
SELECT MONTH(date), MONTHNAME(date) FROM orders;

SELECT MONTHNAME(DATE) AS "Month",User_ID,SUM(AMOUNT) AS "Total",RANK() OVER(PARTITION BY MONTHNAME(DATE) ORDER BY SUM(AMOUNT) DESC) AS "Month_Rank" FROM ORDERS GROUP BY MONTHNAME(DATE), USER_ID ORDER BY MONTHNAME(DATE) DESC;

SELECT * FROM 
(
	SELECT MONTHNAME(DATE) AS "Month",User_ID,SUM(AMOUNT) AS "Total",RANK() OVER(PARTITION BY MONTHNAME(DATE) ORDER BY SUM(AMOUNT) DESC) AS "Month_Rank" 
    FROM ORDERS GROUP BY MONTHNAME(DATE), USER_ID ORDER BY MONTHNAME(DATE) DESC
) T 
WHERE T.Month_Rank < 3 ORDER BY month DESC, Month_Rank ASC;

-- FIRST_VALUE/LAST_VALUE/NTH_VALUE -> must ORDER BY first then only it will work

SELECT *, FIRST_VALUE(name) OVER(ORDER BY marks DESC) AS "Top_Baccha" FROM marks;
SELECT *, LAST_VALUE(name) OVER(ORDER BY marks DESC) AS "Bekuff_Baccha" FROM marks; -- ISSUE => WILL NOT GIVE THE EXPECTED RESULT, AS BY DEFAULT FRAME IS SET TO "ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW"

-- FRAME : A FRAME IN A WINDOW FUNCTION IS A SUBSET OF ROWS, WITHIN THE PARTITION, THAT DETERMINES THE SCOPE OF THE WINDOW FUNCTION EXECUTION/CALCULATION.
-- FRAME IS DEFINED USING A COMBINATION OF TWO CLAUSES IN THE WINDOW FUNCTION => ROWS AND BETWEEN
-- ROWS clause specifies how many rows should be included in the frame relative to the current row
-- ROWS 3 PRECEDING means that the frame includes the current row and the three rows that precede it in the partition

-- Explaination:
 -- ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING => The frame includes the current row and the row immediately before and after it.
 -- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING => Frame includes all rows in the partition
 -- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW => Frames include all rows from the beginning of the partition up to and including the current row. => BY DEFAULT THE FRAME IS SET TO THIS ONE
 -- ROWS BETWEEN 3 PRECEDING AND 2 FOLLOWING => Frames include the current row and the three rows before it and two rows after it.
 
 SELECT *, LAST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC
								 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Bekuff_Baccha" FROM marks; 
SELECT *, FIRST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC
								 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Tejja_ka_Naati" FROM marks;
                                 
SELECT *, FIRST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC) AS "Tejja_ka_Naati", LAST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Bekuff_Baccha" FROM marks;

-- NTH VALUE
SELECT *, NTH_VALUE(name,2) OVER(PARTITION BY branch ORDER BY marks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Second Topper" FROM marks;

SELECT * FROM (SELECT *, FIRST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC) AS "Topper_Name",
 FIRST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC) AS "Topper_Marks" FROM marks) T WHERE T.name = T.Topper_Name AND T.marks = T.Topper_Marks ;

SELECT name,branch,marks FROM (SELECT *, FIRST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC) AS "Topper_Name",
 FIRST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC) AS "Topper_Marks" FROM marks) T WHERE T.name = T.Topper_Name AND T.marks = T.Topper_Marks ;
 
-- LAST WAALA BACCHA
SELECT * FROM (SELECT *, LAST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Last_Name",
 LAST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Last_Marks" FROM marks) T WHERE T.name = T.Last_Name AND T.marks = T.Last_Marks ;
 
SELECT * FROM (SELECT *, LAST_VALUE(name) OVER W AS "Last_Name", LAST_VALUE(marks) OVER W AS "Last_Marks" FROM marks
					WINDOW W AS (PARTITION BY branch ORDER BY marks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
			   ) T WHERE T.name = T.Last_Name AND T.marks = T.Last_Marks;

-- LEAD and LAG
SELECT *, LAG(marks) OVER(ORDER BY student_id) FROM marks; -- SEE THE OUTPUT FOR BETTER UNDERSTANDING

SELECT *, LEAD(marks) OVER(ORDER BY student_id) FROM marks; 

SELECT *, LEAD(marks) OVER(PARTITION BY branch ORDER BY student_id),
LAG(marks) OVER(PARTITION BY branch ORDER BY student_id) FROM marks; 

-- FIND THE MoM revenue Growth from Orders
SELECT 
    MONTHNAME(date) AS month, 
    SUM(amount) AS total_amount, 
    ((SUM(amount)-LAG(SUM(amount)) OVER(ORDER BY MONTH(date)))/LAG(SUM(amount)) OVER(ORDER BY MONTH(date)))*100 AS 'MoM Growth'
FROM orders
GROUP BY MONTH(date), MONTHNAME(date)
ORDER BY MONTH(date) ASC;