USE mydb;

-- 1. SCALAR SUBQUERIES 

-- FIND THE MOVIE WITH HIGHEST PROFIT
SELECT * FROM mydb.movies WHERE (gross - budget) = (SELECT MAX(gross - budget) FROM mydb.movies);

-- FIND HOW MANY MOVIES HAVE A RATING > THE AVG. OF ALL THE MOVIES RATINGS (FIND THE COUNT OF ABOVE AVG. MOVIES)
SELECT COUNT(*) FROM movies WHERE score > (SELECT AVG(score) FROM movies);

-- FIND THE HIGHEST RATED MOVIE IN 2000
SELECT * FROM movies WHERE year =2000 AND score = (SELECT MAX(score) FROM movies WHERE year = 2000);

-- FIND THE HIGHEST RATED MOVIE AMONG ALL MOVIES WHOSE NUMBER OF VOTES ARE > THE DATASET AVG. VOTES
SELECT * FROM movies WHERE score = (SELECT MAX(score) FROM movies WHERE votes>(SELECT AVG(votes) FROM movies));

-- 2. ROW SUBQUERIES

-- FIND ALL USERS WHO NEVER ORDERED
SELECT * FROM users WHERE user_id NOT IN (SELECT DISTINCT user_id FROM orders);

-- FIND ALL MOVIES MADE BY TOP 3 DIRECTORS (IN TERMS OF GROSS INCOME)
WITH top_directors AS (SELECT director FROM movies GROUP BY director ORDER BY SUM(gross) DESC LIMIT 3)
SELECT * FROM movies WHERE director IN (SELECT * FROM top_directors);

-- FIND ALL THE MOVIES OF ALL THOSE ACTORS WHOSE FILMOGRAPHY RATING > 8.5 (TAKE 25,000 VOTES AS CUTOFF)
SELECT * FROM movies WHERE star IN (SELECT star FROM movies WHERE votes > 25000 GROUP BY star HAVING AVG(score) > 8.5);

-- MORE EFFECIENT WAY
SELECT m.*
FROM movies m
JOIN (
    SELECT star
    FROM movies
    WHERE votes > 25000
    GROUP BY star
    HAVING AVG(score) > 8.5
) high_rated_stars
ON m.star = high_rated_stars.star;

-- 3. TABLE SUBQUERIES

-- FIND THE MOST PROFITABLE MOVIE OF EACH YEAR
SELECT * FROM movies WHERE (year, gross - budget) IN (SELECT year, MAX(gross - budget) FROM movies GROUP BY year);

-- FIND THE HIGHEST RATED MOVIE OF EACH GENRE VOTES CUTOFF OF 25,000
SELECT * FROM movies WHERE (genre, score) IN (SELECT genre, MAX(score) FROM movies WHERE votes>25000 GROUP BY genre);

-- EFFICIENT WAY TO WRITE THE ABOVE
WITH max_scores AS (
    SELECT genre, MAX(score) AS max_score
    FROM movies
    WHERE votes > 25000
    GROUP BY genre
)
SELECT m.*
FROM movies m
JOIN max_scores ms ON m.genre = ms.genre AND m.score = ms.max_score;


-- 4. CORRELATED SUBQUERIES

-- Question: FIND ALL THE MOVIES THAT HAVE A RATING HIGHER THAN THE AVERAGE RATING OF THE MOVIES IN THE SAME GENRE
-- STEP 1: SELECT * FROM movies WHERE score > AVG(genre);
-- STEP 2: SELECT AVG(score) FROM movies WHERE genre = ?
SELECT * FROM movies M1 WHERE score > (SELECT AVG(score) FROM movies M2 WHERE M1.genre = M2.genre);
 
 -- FIND THE FAVOURITE FOOD OF EACH CUSTOMER
 WITH fav_food AS (
 SELECT T1.user_id, name,f_name,COUNT(*) AS 'frequency' FROM users T1 
 JOIN orders T2 ON T1.user_id = T2.user_id 
 JOIN order_details T3 ON T2.order_id = T3.order_id
 JOIN food T4 ON T3.f_id = T4.f_id 
 GROUP BY T1.user_id,name,f_name)

SELECT * FROM fav_food F1 WHERE frequency = (SELECT MAX(frequency) FROM fav_food F2 WHERE F1.user_id = F2.user_id);
 
-- SUBQUERY USAGES WITH SELECT
 
-- GET THE PERCENTAGE OF VOTES FOR EACH MOVIE COMPARED TO TOTAL NO. OF VOTES
SELECT name,(votes/(SELECT SUM(votes)FROM movies))*100 AS '% of Votes' FROM movies;
 
-- DISPLAY ALL MOVIES NAMES, GENRE, SCORE AND AVG(SCORE) OF GENRE
SELECT name, genre, score, (SELECT AVG(score) FROM movies M2 WHERE M2.genre = M1.genre) AS "Avg. Score" FROM movies M1;

-- SUBQUERY WITH FROM 

-- DISPLAY AVG. RATING OF ALL THE RESTAURANTS
SELECT r_name,avg_rating FROM (SELECT r_id, AVG(restaurant_rating) AS "avg_rating" FROM orders GROUP BY r_id) T1 JOIN restaurants T2 ON T1.r_id = T2.r_id;

-- SUBQUERY WITH INSERT

-- POPULATE AN ALREADY CREATED LOYAL_CUSTOMERS TABLE WITH RECORDS OF ONLY THOSE CUSTOMERS WHO HAVE ORDERED FOOD MORE THAN 3 TIMES
CREATE TABLE loyal_users
(
	user_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR (255),
    money INT
);

INSERT INTO loyal_users(user_id, name)
SELECT T1.user_id, name FROM orders T1 JOIN users T2 ON T1.user_id = T2.user_id GROUP BY user_id,name HAVING COUNT(*)>3;

-- SUBQUERY WITH UPDATE

-- POPULATE THE MONEY COLUMN OF LOYAL_USERS TABLE USING THE ORDERS TABLE. PROVIDE 10% APP MONEY TO ALL CUSTOMERS BASED ON THEIR ORDER VALUE
SET SQL_SAFE_UPDATES = 0;
UPDATE loyal_users
SET money = (
    SELECT SUM(o.amount) * 0.1
    FROM orders o
    WHERE o.user_id = loyal_users.user_id
    GROUP BY o.user_id
);

-- SUBQUERY WITH DELETE

-- DELETE ALL THE CUSTOMERS RECORD WHO HAVE NEVER ORDERED
DELETE FROM users
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM orders);

SET SQL_SAFE_UPDATES = 1;