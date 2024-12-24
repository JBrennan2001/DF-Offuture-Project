--------------------------------------------------------------
-- Joining the customer table and the order table correctly
--------------------------------------------------------------

-- Inner join customer and order tables (25,726 entries)
SELECT 
	COUNT(*)
FROM
	offuture."order" o 
INNER JOIN offuture.customer c 
ON o.customer_id = c.customer_id_short
OR o.customer_id = c.customer_id_long;


-- 25,754 entries in order table -- 25 entries more than the joined table??
SELECT 
	COUNT(*)
FROM
	offuture."order" o;


-- There is one customer_id (SV-20935) who isn't in the customer table
SELECT 
	*
FROM
	offuture."order" o 
LEFT JOIN offuture.customer c 
ON o.customer_id = c.customer_id_short 
OR o.customer_id = c.customer_id_long 
WHERE
	customer_id_long IS NULL;


-- USE LEFT JOIN INSTEAD (now 25,754 entries)
SELECT 
	*
FROM
	offuture."order" o 
LEFT JOIN offuture.customer c 
ON o.customer_id = c.customer_id_short
OR o.customer_id = c.customer_id_long;



-------------------------------------------------------------
-- Total sales and profits
-------------------------------------------------------------

-- Total sales
SELECT
    SUM(oi.sales)
FROM
    offuture.order_item oi;



-- Total profit
SELECT
     SUM(oi.profit)
FROM
     offuture.order_item oi;


-----------------------------------------------------------
-- Checking the total profit by subcategory
-----------------------------------------------------------
SELECT 
    sub_category,
    SUM(profit) AS total_profit
FROM
    offuture.product p
INNER JOIN
    offuture.order_item oi 
ON
	oi.product_id = p.product_id 
GROUP BY 
    sub_category
ORDER BY 
    total_profit DESC;
    



-------------------------------------------------------------------
-- Exploring the effect that discounted products has on profit
-------------------------------------------------------------------

-- Profit on tables with discount: -124,530.72
SELECT
	SUM(profit)
FROM 
	offuture.product p
INNER JOIN offuture.order_item oi 
ON p.product_id = oi.product_id
INNER JOIN offuture."order" o 
ON oi.order_id = o.order_id 
WHERE
	sub_category = 'Tables'
    AND discount > 0;
	
   
-- profit on tables without discount: 60,447.17
SELECT
	SUM(profit)
FROM 
	offuture.product p
INNER JOIN offuture.order_item oi 
ON p.product_id = oi.product_id
INNER JOIN offuture."order" o 
ON oi.order_id = o.order_id 
WHERE
	sub_category = 'Tables'
    AND discount = 0;
    

-- Profit on any item with discount: -361,215.66
SELECT
	SUM(profit)
FROM 
	offuture.product p
INNER JOIN offuture.order_item oi 
ON p.product_id = oi.product_id
INNER JOIN offuture."order" o 
ON oi.order_id = o.order_id 
WHERE
	discount > 0;


-- Profit on any item without discount: 1,828,672.21
SELECT
	SUM(profit)
FROM 
	offuture.product p
INNER JOIN offuture.order_item oi 
ON p.product_id = oi.product_id
INNER JOIN offuture."order" o 
ON oi.order_id = o.order_id 
WHERE
	discount = 0;

	
-- Number of tables with discount: 653
SELECT
	SUM(quantity)
FROM 
	offuture.product p
INNER JOIN offuture.order_item oi 
ON p.product_id = oi.product_id
INNER JOIN offuture."order" o 
ON oi.order_id = o.order_id 
WHERE
	sub_category = 'Tables'
    AND discount > 0;
    

-- Number of tables without discount: 208
SELECT 
	SUM(quantity)
FROM 
	offuture.product p
INNER JOIN offuture.order_item oi 
ON p.product_id = oi.product_id
INNER JOIN offuture."order" o 
ON oi.order_id = o.order_id 
WHERE
	sub_category = 'Tables'
    AND discount = 0;
    
   
-- Number of items with discount: 21,820
SELECT
	COUNT(*)
FROM 
	offuture.product p
INNER JOIN offuture.order_item oi 
ON p.product_id = oi.product_id
INNER JOIN offuture."order" o 
ON oi.order_id = o.order_id 
WHERE
	discount > 0;
	

-- Number of items without discount: 29,470
SELECT
	COUNT(*)
FROM 
	offuture.product p
INNER JOIN offuture.order_item oi 
ON p.product_id = oi.product_id
INNER JOIN offuture."order" o 
ON oi.order_id = o.order_id 
WHERE
	discount = 0;