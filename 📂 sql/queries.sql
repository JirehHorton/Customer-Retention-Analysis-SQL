      -- QUERY #1 New Customers Per Month --

SELECT DATE_FORMAT(first_order, "%Y-%c") AS first_month,
COUNT(DISTINCT customer_id) AS new_customers
FROM ( 
	SELECT c.customer_id,
		   MIN(order_delivered_customer_date) AS first_order
	FROM customers c
	JOIN orders o 
		ON c.customer_id = o.customer_id
	WHERE order_status = 'delivered'
	GROUP BY customer_id
) AS sub
GROUP BY first_month
ORDER BY MIN(first_order) DESC;

       -- QUERY #2 --
