USE mydb;

-- CROSS JOIN
SELECT * FROM mydb.users AS T1 CROSS JOIN mydb.groups AS T2;

-- INNER JOIN
SELECT T1.*,T2.* FROM mydb.membership AS T1 INNER JOIN mydb.users AS T2 ON T1.user_id=T2.user_id;

-- LEFT JOIN
SELECT * FROM mydb.membership T1 LEFT JOIN mydb.users T2 ON T1.user_id=T2.user_id;

-- RIGHT JOIN
SELECT * FROM mydb.membership T1 RIGHT JOIN mydb.users T2 ON T1.user_id=T2.user_id;

-- INTERSECT
SELECT * FROM mydb.person1 INNER JOIN mydb.person2 USING (id);
-- USING: When we use this clause, that particular column_name should be present in both the TABLES. SELECT will automatically JOIN the TABLES.

-- FULL OUTER JOIN 
SELECT * FROM mydb.membership T1 LEFT JOIN mydb.users T2 ON T1.user_id=T2.user_id
UNION
SELECT * FROM mydb.membership T1 RIGHT JOIN mydb.users T2 ON T1.user_id=T2.user_id;

-- SELF JOIN
SELECT U1.*, U2.name AS emergency_contact_person FROM mydb.users1 AS U1 INNER JOIN mydb.users1 AS U2 ON U1.user_id = U2.emergency_contact;

-- JOINING ON MORE THAN ONE COLUMN
SELECT * FROM mydb.students S1 INNER JOIN mydb.class C1 ON S1.class_id=C1.class_id AND S1.enrollment_year = C1.class_year;

-- JOINING MORE THAN TWO TABLES
SELECT * FROM mydb.order_details T1 JOIN mydb.orders T2 ON T1.order_id = T2.order_id JOIN mydb.users T3 ON T2.user_id = T3.user_id; -- AS NAME WAS NOT IN T1 AND T2 SO WE MERGED T3

-- Question 1:
SELECT D1.order_id,D2.vertical FROM mydb.order_details D1 JOIN mydb.category D2 ON D1.category_id = D2.category_id;

-- Question 2:
SELECT * FROM mydb.orders T1 JOIN mydb.users T2 ON T1.user_id = T2.user_id WHERE T2.city = 'Pune' AND T2.name = 'Sarita';

-- FIND ALL THE PROFITABLE ORDERS
SELECT T1.order_id, SUM(T2.profit) FROM mydb.orders T1 JOIN mydb.order_details T2 ON T1.order_id = T2.order_id GROUP BY T1.order_id HAVING SUM(T2.profit)>0 ORDER BY SUM(T2.profit) DESC;

-- FIND THE CUSTOMER WHO HAS PLACED MAXIMUM NO. OF ORDERS
SELECT name, COUNT(*) AS 'NUM_ORDERS' FROM mydb.orders T1 JOIN mydb.users T2 ON T1.user_id = T2.user_id GROUP BY T2.name ORDER BY NUM_ORDERS DESC LIMIT 1;

-- WHICH ARE THE 5 MOST PROFITABLE STATES
SELECT state,SUM(profit) FROM mydb.order_details T1 JOIN mydb.orders T2 ON T1.order_id = T2.order_id JOIN mydb.users T3 ON T3.user_id = T2.user_id GROUP BY state ORDER BY SUM(profit) DESC LIMIT 5;
