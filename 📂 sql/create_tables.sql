CREATE TABLE customers(
	customer_id VARCHAR(60),
    customer_unique_id VARCHAR(60),
    customer_name VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR (35),
	customer_state VARCHAR (3)
  );
Create TABLE orders (
	order_id VARCHAR(60) PRIMARY KEY,
	customer_id VARCHAR(60),
	order_status VARCHAR(15), 
	order_purchase_timestamp DATETIME, 
	order_approved_at DATETIME, 
	order_delivered_carrier_date DATETIME, 
	order_delivered_customer_date DATETIME, 
	order_estimated_delivery_date DATETIME,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);
CREATE INDEX purchase_date_idx
ON orders(order_purchase_timestamp)
