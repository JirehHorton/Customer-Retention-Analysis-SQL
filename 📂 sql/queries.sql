      -- QUERY #1 New Customers Per Month --

SELECT DATE_FORMAT(first_order, "%Y-%c") AS first_month,
COUNT(DISTINCT customer_unique_id) AS new_customers
FROM ( 
	SELECT c.customer_unique_id,
		   MIN(order_delivered_customer_date) AS first_order
	FROM customers c
	JOIN orders o
		ON c.customer_unique_id = o.customer_unique_id
	WHERE order_status = 'delivered'
	GROUP BY customer_unique_id
) AS sub
GROUP BY first_month
ORDER BY first_month DESC; 

       -- QUERY #2 Repeat Customer %  --

SELECT ROUND((COUNT(*) *100.0/ (SELECT COUNT(DISTINCT customer_unique_id) FROM orders)),2)
	AS repeat_customer_percentage
FROM (
	SELECT customer_unique_id, COUNT(order_id) AS count_oi FROM orders
	GROUP BY customer_unique_id) AS customer_orders
WHERE count_oi >= 2
;
