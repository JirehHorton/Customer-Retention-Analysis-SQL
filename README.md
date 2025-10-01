# Olist E-Commerce SQL Project
<img width="1400" height="400" alt="image" src="https://github.com/user-attachments/assets/202c3dd2-74e4-436a-8c24-8083542994a1" />

## Table of Contents
- [Project Overview](#project-overview)
- [Business Analysis Questions](#Business-Analysis-Questions)
- [Queries](#Queries)
- [Key Takeaways/Business Insights](#Key-Takeaways-/-Business-Insights)
- [Technologies Used](#technologies-used)
- [License](#license)
- [Author Info](#author-info)


---
## Project Overview
This project demonstrates my ability to work with realistic e-commerce datasets using SQL. I built a relational database from multiple tables—including customers, orders, products, and order_items—and performed data cleaning, transformation, and analysis to answer business questions.

Key highlights:
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
-The project was driven by the following business questions:
	- 1. How many new customers are acquired each month?
	- 2. What percentage of customers make repeat purchases?
	- 3. Which products generate the most revenue?
	- 4. How does delivery time vary by region or product category?
	- 5. What are the trends in order volume over time?

These questions guided the data analysis and helped identify actionable insights for the e-commerce business.

---
## DATABASE ERD DIAGRAM

- Customers → Orders → Order_Items → Products
- Schema: customers(PK) → orders(PK, FK→customers) → order_items(PK, FK→orders/products) ← products(PK)

<img width="950" height="650" alt="O_LIST ERD DIAGRAM" src="https://github.com/user-attachments/assets/95898861-559f-44f0-ad34-ec1f46c0da99" />

---

## Queries 
<details> <summary><strong>Query 1: New Customers Per Month</strong></summary>
	
```sql
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
```
<img width="260" height="408" alt="NEW CUSTOMERS PER MONTH SS" src="https://github.com/user-attachments/assets/dc3f1a8b-7835-4a0f-b8be-34aba19fafdb" />

**Insight:**

- Customer acquisition grew rapidly from 2016 through mid-2018, peaking at over 1,200 new customers in August 2018. However, after this peak, new customer counts collapsed to nearly zero by October 2018, which reflects either the end of the dataset collection period or a major change in customer acquisition strategy.

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

Potential opportunities to implement loyalty programs or marketing campaigns to repeat customers
  
</details>

---

## Key Takeaways/Business Insights

---

## Technologies Used
- Data Analysis: MySQL
- Data Visualization: Tableau
- Random Name Generation: Python(faker)
- Data Source: Brazilian E-Commerce Public Dataset by Olist

---
## Sample Data for GitHub
To make the project GitHub-friendly, I created smaller subsets of the full dataset that are accessible ([here](https://github.com/JirehHorton/olist_project/tree/dcb8af4a4409156f6a013edc40643252729e2446/data)).

- customers: ~150 rows
- orders: ~150 rows
- products: ~150 rows
- order_items: ~150 rows

These subsets were randomly sampled from the full dataset (~78,000 rows) to preserve the structure and relationships between tables while keeping file sizes manageable.

---
## License
- This project is for educational and portfolio purposes only and is not licensed for commercial use. The data used in this project is public E-Commerce Data.

---
## Author Info
- Portfolio project by Jireh Horton
- @LinkedIn - [@jirehhorton](https://www.linkedin.com/in/jirehhorton/)


[Back To The Top](#Olist-E-Commerce-SQL-Project)
