-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT 
    country 
FROM customers
ORDER BY country;

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM products
ORDER BY category, subcategory, product_name;

-- Determine the first and last order date and the total duration in months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM sales;

-- customers + sales
WITH s AS (
SELECT customer_key, SUM(sales_amount) total_purchase_made , SUM(quantity) total_quantity
FROM sales
GROUP BY customer_key
),
c AS (
SELECT *
FROM customers
)
SELECT s.customer_key, c.customer_id, c.full_name, c.country, c.marital_status, 
		c.birthdate, c.create_date, s.total_quantity quantity_purchased, s.total_purchase_made total_purchase_cost
FROM s
JOIN c
	ON 	s.customer_key = c.customer_key;
    

-- products + sales
WITH s AS (
SELECT product_key, SUM(sales_amount) total_sale , SUM(quantity) quantity_sold
FROM sales
GROUP BY product_key
),
p AS (
SELECT *
FROM products
)
SELECT s.product_key, p.product_id, p.product_name, p.category, p.subcategory, p.maintenance, 
		p.product_line, p.start_date, p.cost cost_price, s.quantity_sold, s.total_sale
FROM s
JOIN p
	ON 	s.product_key = p.product_key;   
    
    
-- products + sales + customers
WITH s AS (
SELECT *
FROM sales
),
c AS (
SELECT customer_key, customer_id, full_name, country
FROM customers
),
p AS (
SELECT product_key, product_id, category, subcategory, cost
FROM products
)
SELECT s.order_number, s.product_key, p.product_id, p.category, p.subcategory, s.customer_key, c.customer_id, 
	   c.full_name, c.country, s.order_date, s.shipping_date, s.due_date, s.price selling_price, p.cost cost_price, s.quantity, s.sales_amount total_sale
FROM s
JOIN c ON s.customer_key = c.customer_key
JOIN p ON s.product_key = p.product_key

