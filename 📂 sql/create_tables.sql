							--  COPY AND PASTE THIS ENTIRE SCRIPT SECTION TO REPRODUCE THE DATABASE
CREATE DATABASE IF NOT EXISTS olist_db;

USE olist_db;							-- Switch to the new database

CREATE TABLE customers(                 -- Customers Table
	customer_id VARCHAR(60) PRIMARY KEY,
    customer_unique_id VARCHAR(60),
    customer_name VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR (35),
	customer_state VARCHAR (3)
  );
Create TABLE orders (                   -- Orders Table
	order_id VARCHAR(60) PRIMARY KEY,
	customer_id VARCHAR(60),
	order_status VARCHAR(20), 
	order_purchase_timestamp DATETIME, 
	order_approved_at DATETIME, 
	order_delivered_carrier_date DATETIME, 
	order_delivered_customer_date DATETIME, 
	order_estimated_delivery_date DATETIME,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

CREATE INDEX purchase_date_idx          -- INDEXED(order_purchase_timestamp)  to speed up queries by date, like “orders per month”.
ON orders(order_purchase_timestamp);

CREATE TABLE products (                 -- Products Table
    product_id VARCHAR(60) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE order_items (				 -- Order Items TABLE
    order_id VARCHAR(60),
    order_item_id INT,                  -- the item number within the order
    product_id VARCHAR(60),
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),   -- composite primary key
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
