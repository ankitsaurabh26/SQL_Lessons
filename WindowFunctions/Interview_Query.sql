USE mydb;

-- STEP BY STEP BREAK DOWN

-- 1. FINDING THE LAG
SELECT *, LAG(salary,1,0) OVER(PARTITION BY name ORDER BY year) AS prev_salary FROM salary; -- LAG (scalar_expression [,offset] [,default])

-- 2. FINDING THE DIFFERENCE
WITH new_table AS (SELECT *, LAG(salary,1,0) OVER(PARTITION BY name ORDER BY year) AS prev_salary FROM salary)
SELECT *,(salary - prev_salary) AS salary_diff FROM new_table;

-- 3. FINAL ANSWER
WITH new_table AS (SELECT *, LAG(salary,1,0) OVER(PARTITION BY name ORDER BY year) AS prev_salary FROM salary)
SELECT id,name,year, SUM(salary_diff) AS EOY_difference FROM (SELECT *,(salary - prev_salary) AS salary_diff FROM new_table)S GROUP BY id,name,year;