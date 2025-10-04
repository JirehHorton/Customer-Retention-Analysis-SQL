# Olist E-Commerce SQL Project
<img width="1400" height="400" alt="image" src="https://github.com/user-attachments/assets/202c3dd2-74e4-436a-8c24-8083542994a1" />

## Table of Contents
- [Project Overview](#project-overview)
- [Business Analysis Questions](#Business-Analysis-Questions)
- [Sample Data Preview w/ ERD Diagram](#Sample-Data-Preview-w-ERD-Diagram)
- [Queries](#Queries)
- [Key Takeaways w/ Business Insights](#Key-Takeaways-w-Business-Insights)
- [Technologies Used](#technologies-used)
- [License](#license)
- [Author Info](#author-info)


---
## Project Overview
This project demonstrates my ability to work with realistic e-commerce datasets using SQL. I built a relational database from multiple tables—including customers, orders, products, and order_items—and performed data cleaning, transformation, and analysis to answer business questions.

__Key highlights__:
- Designed primary and foreign key relationships across multiple tables.
- Populated tables with realistic data (full dataset ~78,000 rows).
- Created sample subsets (~500–600 rows) for GitHub-friendly sharing.
- Explored insights such as customer ordering patterns, product sales, and inventory metrics.

This project showcases skills in SQL, database design, and data manipulation—all directly applicable to business analytics and data engineering roles.
Portfolio project using the Olist e-commerce dataset with SQL &amp; analysis.

Note: 
This repo contains only a *sample dataset* (~500-600 rows) for demonstration purposes and the full dataset was used during analysis to generate insights.
The full Olist dataset (~600k+ rows) can be downloaded from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

---
## Business Analysis Questions
This analysis was driven by the following business questions:

- #1. __📈 New Customers per Month__ - How many new customers are acquired each month?
- #2. __🔁 Repeat Customers__ - What percentage of customers make repeat purchases?
- #3. __📊 Cohort Analysis__ - For each month, how many customers return in subsequent months?
- #4. __📦 Average Orders per Customer__ - How many orders does an average customer place?
- #5. __💰 Top Customers__ - Who are the customers with the highest number of orders or total spend?

These questions guided the data analysis and helped identify actionable insights for the e-commerce business.

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

<img width="600" height="400" alt="O_LIST ERD DIAGRAM" src="https://github.com/user-attachments/assets/95898861-559f-44f0-ad34-ec1f46c0da99" />

---

## Queries 
<details> <summary><strong>Query 1: New Customers Per Month</strong></summary>
	
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

<img width="255" height="402" alt="NEW CUSTOMERS PER MONTH" src="https://github.com/user-attachments/assets/be01972e-f750-499e-949a-6a38a87d2824" />


**Insight:**

- NEED TO UPDATE THIS 

**Business Implication:**

- Helps guide marketing campaigns and allocate resources effectively.

</details> <details> <summary><strong>Query 2: Repeat Customers</strong></summary>

```sql
SELECT ROUND((COUNT(*) *100.0/ (SELECT COUNT(DISTINCT customer_id) FROM orders)),2)
	AS repeat_customer_percentage
FROM (
	SELECT customer_id, COUNT(order_id) AS count_oi FROM ORDERS
	GROUP BY customer_id) AS customer_orders
WHERE count_oi >= 2
;
```

<img width="207" height="50" alt="REPEAT CUSTOMER %" src="https://github.com/user-attachments/assets/91ebf279-8155-4211-87c2-23e95b5b10d8" />

**Insight:**
In this dataset, no customers placed more than one order. This indicates that:
- The dataset may only include each customer’s first order, or
- Repeat purchase behavior was not captured in the sample.

**Business Implication:**

Potential opportunities to implement loyalty programs or marketing campaigns to repeat customers to encourage repeat purchases
  
</details>

---

## Key Takeaways w/ Business Insights 

chessees
---

## Technologies Used
- Data Analysis: MySQL
- Data Visualization: Tableau
- Random Name Generation: Python(faker)
- Data Source: Brazilian E-Commerce Public Dataset by Olist

---
## License
- This project is for educational and portfolio purposes only and is not licensed for commercial use. The data used in this project is public E-Commerce Data.

---
## Author Info
- Portfolio project by Jireh Horton
- @LinkedIn - [@jirehhorton](https://www.linkedin.com/in/jirehhorton/)


[Back To The Top](#Olist-E-Commerce-SQL-Project)
