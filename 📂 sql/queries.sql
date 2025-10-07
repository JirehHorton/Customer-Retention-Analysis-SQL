      -- QUERY #1 New Customers Per Month --

SELECT DATE_FORMAT(first_order, "%Y-%m") AS first_month,
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
ORDER BY first_month DESC
; 

       -- QUERY #2 Repeat Customer %  --

SELECT ROUND((COUNT(*) *100.0/ (SELECT COUNT(DISTINCT customer_unique_id) FROM orders)),2)
	AS repeat_customer_percentage
FROM (
	SELECT customer_unique_id, COUNT(order_id) AS count_oi FROM orders
	GROUP BY customer_unique_id) AS customer_orders
WHERE count_oi >= 2
;

		-- QUERY #3 Cohort Analysis  --
SELECT cohort_month, COUNT(DISTINCT customer_unique_id) AS returning_customers
FROM (
    SELECT 
        c.customer_unique_id,
        DATE_FORMAT(f.cohort_date, '%Y-%m') AS cohort_month,
        DATE_FORMAT(o.order_delivered_customer_date, '%Y-%m') AS order_month
    FROM customers c
    JOIN orders o 
      ON c.customer_unique_id = o.customer_unique_id
    JOIN (
        SELECT customer_unique_id, MIN(order_delivered_customer_date) AS cohort_date
        FROM orders
        WHERE order_status = 'delivered'
        GROUP BY customer_unique_id
    ) f
      ON c.customer_unique_id = f.customer_unique_id
    WHERE o.order_status = 'delivered'
) AS sub
WHERE order_month > cohort_month
GROUP BY cohort_month
ORDER BY cohort_month DESC
;

		-- QUERY #4 Average Orders Per Customer  --
SELECT ROUND(AVG(order_count),2) AS order_average
FROM (
	SELECT c.customer_unique_id, COUNT(o.order_status) AS order_count
	FROM customers c
	JOIN orders o 
	ON c.customer_unique_id = o.customer_unique_id
	GROUP BY c.customer_unique_id
    ) AS sub
;

		-- QUERY #5 Top 10 Customers by Spending  --
SELECT  MIN(c.customer_name) AS customer_name,
		o.customer_unique_id, 
		COUNT(DISTINCT o.order_id) AS total_orders,
		SUM(oi.price) + SUM(oi.freight_value) AS total_spending 
FROM order_items oi
JOIN orders o 
ON oi.order_id = o.order_id
JOIN customers c
ON c.customer_unique_id = o.customer_unique_id
GROUP BY c.customer_unique_id
ORDER BY total_spending DESC 						--can be interchanged with total_orders to see TOP 10 Order Counts
LIMIT 10
;


