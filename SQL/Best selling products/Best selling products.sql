DROP TABLE all_products;
DROP TABLE orders;
--CREATE TABLE--------------

CREATE TABLE all_products(
	product_id	INT,
	product_name VARCHAR(100),
	distributor_id	INT
)
CREATE TABLE orders(
	dates DATE,
	product_id INT,
	no_units INT,
	region VARCHAR(100)
)
--INSERT VALUE-------------------
INSERT INTO all_products
VALUES
	(1, 'banh1', 1),
	(2, 'banh2', 6),
	(3, 'banh3', 14),
	(4, 'banh4', 20),
	(5, 'banh5', 15),
	(6, 'banh6', 24),
	(7, 'banh7', 13),
	(8, 'banh8', 9),
	(9, 'banh9', 6),
	(10, 'banh10', 3);

INSERT INTO orders
VALUES
	('2017-12-21', 2, 10, 'A'),
	('2017-11-21', 1, 15, 'A'),
	('2017-10-21', 3, 20, 'A'),
	('2017-10-21', 5, 25, 'A'),
	('2017-09-21', 7, 24, 'A'),
	('2017-07-21', 8, 10, 'A'),
	('2017-05-21', 9, 14, 'A'),
	('2017-06-21', 7, 16, 'A'),
	('2017-07-21', 10, 17, 'B'),
	('2017-04-21', 8, 18, 'B'),
	('2017-03-21', 4, 29, 'B'),
	('2017-02-21', 3, 28, 'B'),
	('2017-12-21', 5, 16, 'B'),
	('2017-11-21', 7, 17, 'B'),
	('2017-09-21', 8, 18, 'B'),
	('2017-07-21', 9, 14, 'B'),
	('2017-12-21', 4, 13, 'B'),
	('2017-02-21', 5, 21, 'B'),
	('2017-01-21', 1, 22, 'B'),
	('2017-08-21', 1, 20, 'B'),
	('2017-08-21', 6, 20, 'C'),
	('2017-09-21', 10, 23, 'C'),
	('2017-11-21', 10, 14, 'C'),
	('2017-10-21', 8, 17, 'C'),
	('2017-10-21', 9, 1, 'C'),
	('2017-10-21', 7, 19, 'C'),
	('2017-09-21', 5, 9, 'C'),
	('2017-08-21', 7, 10, 'C'),
	('2017-07-21', 8, 10, 'C'),
	('2017-08-21', 6, 10, 'C'),
	('2017-06-21', 7, 20, 'C'),
	('2017-05-21', 8, 15, 'C'),
	('2017-04-21', 8, 28, 'A'),
	('2017-08-21', 7, 17, 'B'),
	('2017-09-21', 6, 26, 'C');

--SOLUTION--------------------

WITH CTE as(
SELECT  region,
		product_name,
		total,
		RANK() OVER(PARTITION BY region
					ORDER BY total DESC) AS rank
FROM (
		SELECT  ord.region,
				prod.product_name,
				SUM(ord.no_units) AS total
		FROM all_products AS prod
		JOIN orders AS ord
		ON prod.product_id = ord.product_id
		WHERE CONVERT(INT,SUBSTRING(dates,6,2)) >=10
		AND CONVERT(INT,SUBSTRING(dates,6,2)) <=12
		GROUP BY prod.product_name, ord.region
		) sub
)
SELECT CTE.region, CTE.product_name, prod.distributor_id
FROM CTE 
LEFT JOIN all_products as prod
ON prod.product_name = CTE.product_name
WHERE rank <=2
ORDER BY region
