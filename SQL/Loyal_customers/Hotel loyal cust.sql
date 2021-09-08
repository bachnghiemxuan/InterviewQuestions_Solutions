DROP TABLE customer_transaction
CREATE TABLE customer_transaction (
customer_id			INT,			--id of the customer
hotel_id			INT,			--unique id for hotel
transaction_id		INT,			--id of the given transaction
first_night			VARCHAR(50),	--first night of the stay, column format is "YYYY-mm-dd" 
number_of_nights	INT,			--# of nights the customer stayed in hotel
total_spend			INT,			--total spend for transaction, in USD
is_member			BIT				--indicates if the customer is a member of our points system (1 = True, 0 = FALSE
)
INSERT INTO customer_transaction VALUES 
(1, 1, 1, '2017-10-20', 2, 100, 1),
(1, 1, 5, '2017-10-19', 2, 100, 1),
(1, 3, 6, '2017-10-15', 2, 100, 1),
(2, 3, 2, '2017-09-15', 5, 500, 1),
(3, 1, 3, '2017-09-15', 5, 500, 1),
(4, 3, 4, '2017-09-15', 5, 500, 1)
;

-------------SOLUTION------------------

--Customer who have >2 stays at any hotel location
SELECT customer_id 
FROM(
	SELECT customer_id, hotel_id, COUNT(transaction_id) as NoStays
	FROM customer_transaction
	WHERE is_member = 1
	GROUP BY customer_id,hotel_id
	)CTE 
WHERE NoStays > 2;

-- Customer who have stayed at 3 different locations
SELECT *
FROM(
	SELECT customer_id, COUNT(hotel_id) as NoHotels
	FROM(
		SELECT DISTINCT customer_id, hotel_id
		FROM customer_transaction
		WHERE is_member = 1) A 
	GROUP BY customer_id) B
WHERE NoHotels >=3

---Create a CTE that help calculate loyal spend percent
WITH CTE AS(
SELECT DISTINCT -- SELECT DISTINCT because I want that the result has 1 value
----Total spend where customer_id is in 2 tables above-----
	(SELECT SUM(total_spend) 
	FROM customer_transaction 
	WHERE customer_id IN   (SELECT customer_id 
								FROM(
								SELECT customer_id, hotel_id, COUNT(transaction_id) as NoStays
								FROM customer_transaction
								WHERE is_member = 1
								GROUP BY customer_id,hotel_id)CTE 
							WHERE NoStays > 2)
	OR customer_id IN (SELECT customer_id
						FROM(
							SELECT customer_id, COUNT(hotel_id) as NoHotels
							FROM(
								SELECT DISTINCT customer_id, hotel_id
								FROM customer_transaction
								WHERE is_member = 1) A 
							GROUP BY customer_id) B
						WHERE NoHotels >=3)
--------------------Done----------------------	

--Named this sum------
	) loyal_spend,
----total spend of whole table-----
	SUM(total_spend) OVER() overall_spend
FROM customer_transaction
)
SELECT loyal_spend/overall_spend AS loyal_over_total
FROM CTE