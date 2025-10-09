# 🛍️ 💵 Customer Retention Insights  – Olist E-Commerce DB 
## _Turning First-Time Buyers into Loyal Customers Through Cohort & Retention Analysis_

## Project Overview 🎯 
_Analyze customer behavior and retention using the Olist E-Commerce database with SQL. This project demonstrates building relational databases, cleaning and transforming data, and answering key business questions on customer growth and loyalty. This project also showcases SQL, database design, data analysis, and business analytics skills, providing actionable insights for business strategy._

__Key highlights:__

- Built relational tables (customers, orders, products, order_items) with primary and foreign key relationships.
- Populated realistic data (full dataset ~78,000 rows) and created GitHub-friendly samples (~500–600 rows).
- Tracked new and repeat customers, cohort retention trends, average orders per customer, and top customers by spending & orders.
- Explored insights into ordering patterns, product sales, and inventory metrics.


Note: This repo contains only a sample dataset (~500–600 rows) for demonstration purposes and a larger sample(~78,000 rows) was used for this project analysis. The full Olist dataset (~600k+ rows) is available on [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

<img width="1100" height="325" alt="image" src="https://github.com/user-attachments/assets/202c3dd2-74e4-436a-8c24-8083542994a1" />

## Table of Contents
- [Project Overview](#project-overview-🎯)
- [Business Analysis Questions](#Business-Analysis-Questions)
- [Queries](#Queries)
- [Key Takeaways w/ Business Insights](#Key-Takeaways-w-Business-Insights)
- [Sample Data Preview w/ ERD Diagram](#Sample-Data-Preview-w-ERD-Diagram)
- [Technologies Used](#technologies-used)
- [License](#license)
- [Author Info](#author-info)

---
## Business Analysis Questions
This analysis was driven by the following business questions:

- #1. 📈 _**New Customers per Month**_ - How many new customers are acquired each month?
- #2. 🔁 _**Repeat Customers**_ - What percentage of customers make repeat purchases?
- #3. 📊 _**Cohort Analysis**_ - For each month, how many customers return in subsequent months?
- #4. 📦 _**Average Orders per Customer**_ - How many orders does an average customer place?
- #5. 💰 _**Top Customers**_ - Who are the customers with the highest number of orders or total spend?

These questions guided the data analysis and helped identify actionable insights for the e-commerce business.

---
## Queries 
<details> <summary><strong>📈 Query 1: New Customers Per Month</strong></summary>
	
```sql
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
ORDER BY first_month DESC; 
```

**Insight & Business Implication:**

- 💡 _New customer acquisition grew steadily through 2017 and peaked in mid-2018, likely driven by effective campaigns; the late decline may reflect data cutoff rather than performance, highlighting strong underlying momentum._

New Customers Per Month 
---
<img width="255" height="402" alt="NEW CUSTOMERS PER MONTH" src="https://github.com/user-attachments/assets/be01972e-f750-499e-949a-6a38a87d2824" />


</details> <details> <summary><strong>🔁 Query 2: Repeat Customers</strong></summary>

```sql
SELECT ROUND((COUNT(*) *100.0/ (SELECT COUNT(DISTINCT customer_unique_id) FROM orders)),2)
	AS repeat_customer_percentage
FROM (
	SELECT customer_unique_id, COUNT(order_id) AS count_oi FROM orders
	GROUP BY customer_unique_id) AS customer_orders
WHERE count_oi >= 2;
```
**Insight & Business Implication:**

- 💡 _Only 5.59% of customers made repeat purchases, indicating low retention, a vast majority are one-time buyers and highlighting the need for stronger post-purchase engagement to boost customer loyalty and lifetime value._

Repeat Customer (%)
---
<img width="210" height="41" alt="REPEAT CUSTOMER %" src="https://github.com/user-attachments/assets/07125ea9-5d10-4698-8b6f-56d5220b15e8" />
  
</details>

</details> <details> <summary><strong>📊 Query 3: Cohort Analysis</strong></summary>
	
```sql
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
ORDER BY cohort_month DESC;
```
**Insight & Business Implication:**

- 💡 _Cohorts from 2017 show consistent repeat activity (≈30–40 returning customers), while newer 2018 cohorts appear lower—likely due to limited observation time—indicating stable historical retention but incomplete recent data._

Returning Customers By Cohort Month
---
<img width="279" height="328" alt="CUSTOMER COHORT ANALYSIS" src="https://github.com/user-attachments/assets/5a716478-16af-4d1c-8b0f-384088b42480" />
	
</details>

</details> <details> <summary><strong>📦 Query 4: Average Orders Per Customer</strong></summary>
	
```sql
SELECT ROUND(AVG(order_count),2) AS order_average
FROM (
	SELECT c.customer_unique_id, COUNT(o.order_status) AS order_count
	FROM customers c
	JOIN orders o 
	ON c.customer_unique_id = o.customer_unique_id
	GROUP BY c.customer_unique_id
    ) AS sub;
```
**Insight & Business Implication:**

- 💡 _Customers order just once on average (1.08), highlighting low repeat behavior and a clear opportunity to grow lifetime value through retention strategies like targeted promotions or loyalty programs._

Average Orders Per Customer
---
<img width="146" height="48" alt="AVERAGE ORDERS PER CUSTOMER" src="https://github.com/user-attachments/assets/817bab88-d7b9-4da6-bd3b-b0799b3b215d" />

</details>

</details> <details> <summary><strong>💰 Query 5: Top 10 Customers By Total Spending/Order Count </strong></summary>
	
```sql
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
LIMIT 10;
```
**Insight & Business Implication:**

- 💡 _High spenders buy big once, frequent buyers buy smaller often—opportunities to drive loyalty, repeat purchases, and order value via upsells and targeted promotions._

TOP 10 CUSTOMERS BY TOTAL SPENDING
---
<img width="558" height="181" alt="TOP 10 CUSTOMERS BY TOTAL SPENDING" src="https://github.com/user-attachments/assets/2396fef1-5dcf-4082-a607-f7f2afeaf5e6" />

TOP 10 CUSTOMERS BY ORDER COUNT
---
<img width="538" height="176" alt="TOP 10 CUSTOMERS BY ORDER COUNT" src="https://github.com/user-attachments/assets/0b8f7393-2996-4537-b10a-73dd9c9c3a7e" />

</details>

---
## Key Takeaways w/ Business Insights 

- 📈 Customer acquisition grew steadily through 2017, peaking in mid-2018, showing strong marketing performance.

- 🔁 Repeat purchases are very low (5.59%), revealing a clear retention gap.

- 📊 Cohort analysis shows stable repeat activity among early customers, while new cohorts need early engagement.

- 📦 Average orders per customer is just 1.08, highlighting opportunities to increase lifetime value through promotions and loyalty programs.

- 💰 Top customers either make one large purchase or frequent smaller ones—both groups offer chances to boost repeat purchases and order value via upsells, loyalty initiatives, and targeted offers.

---
## Sample Data Preview w/ ERD Diagram

<details> <summary>👤 <b>Customers Sample</b></summary>
	
| customer_id | customer_unique_id | city           | state |
| ----------- | ------------------ | -------------- | ----- |
| c001        | u001               | São Paulo      | SP    |
| c002        | u002               | Rio de Janeiro | RJ    |
| c003        | u003               | Belo Horizonte | MG    |

</details>

<details> <summary>🧾 <b>Orders Sample</b></summary>
	
| order_id | customer_id | order_status | order_purchase_timestamp |
| -------- | ----------- | ------------ | ------------------------ |
| o001     | c001        | delivered    | 2017-10-02 10:56:33      |
| o002     | c002        | shipped      | 2017-10-03 13:22:11      |
| o003     | c003        | delivered    | 2017-10-04 16:40:57      |

</details>

<details> <summary>📦 <b>Products Sample</b></summary>

| product_id | product_category | weight_grams | price  |
| ---------- | ---------------- | ------------ | ------ |
| p001       | electronics      | 1500         | 199.90 |
| p002       | furniture        | 4500         | 329.00 |
| p003       | toys             | 800          | 59.90  |

</details>

<details> <summary>🛒 <b>Order Items Sample</b></summary>

| order_item_id | order_id | product_id | price  | freight_value |
| ------------- | -------- | ---------- | ------ | ------------- |
| 1             | o001     | p001       | 199.90 | 20.00         |
| 2             | o002     | p002       | 329.00 | 35.00         |
| 3             | o003     | p003       | 59.90  | 10.00         |

</details>

To make the project GitHub-friendly, I created small subsets of the full dataset that are accessible ([here](https://github.com/JirehHorton/olist_project/tree/dcb8af4a4409156f6a013edc40643252729e2446/data)).

- customers: ~150 rows
- orders: ~150 rows
- products: ~150 rows
- order_items: ~150 rows

These subsets were randomly sampled from the project analysis dataset(~78,000 rows) to preserve the structure and relationships between tables while keeping file sizes manageable.
 
## ERD Diagram & Database Schema

- Customers → Orders → Order_Items → Products
- Schema: customers(PK) → orders(PK, FK→customers) → order_items(PK, FK→orders/products) ← products(PK)
- Orders table retains original customer_id for reference, but customer_unique_id was used as 
the true key for customer-level analysis

ERD Diagram
---
<img width="600" height="400" alt="O_LIST ERD DIAGRAM" src="https://github.com/user-attachments/assets/95898861-559f-44f0-ad34-ec1f46c0da99" />

---

## Technologies Used
- Data Analysis: MySQL
- Data Visualization: Tableau
- Random Name Generation: Python(faker)
- Data Source: Brazilian E-Commerce Public Dataset by Olist

---
## License
- This project is for educational and portfolio purposes only and is not licensed for commercial use. The data used in this project is public Olist E-Commerce Data.

---
## Author Info
- Portfolio project by Jireh Horton
- @LinkedIn - [@jirehhorton](https://www.linkedin.com/in/jirehhorton/)


[Back To The Top](#Olist-E-Commerce-SQL-Project)
