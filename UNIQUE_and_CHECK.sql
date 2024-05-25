CREATE TABLE customer
(
	ID INT PRIMARY KEY,
    NAME VARCHAR(255) UNIQUE,
    BALANCE INT,
    CONSTRAINT check_balance_should_be_more_than_2000 CHECK(BALANCE>2000)
);

INSERT INTO customer(ID,NAME,BALANCE) VALUES 
(1,'Amish',3000);
(2,'Sen',1000); -- Error Code: 3819. Check constraint 'check_balance_should_be_more_than_2000' is violated.
