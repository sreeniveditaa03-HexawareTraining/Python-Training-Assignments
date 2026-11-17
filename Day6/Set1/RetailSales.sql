


CREATE DATABASE IF NOT EXISTS RetailSalesDB;
USE RetailSalesDB;


-- PART 1: CREATE TABLES


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- PART 2: INSERT SAMPLE DATA


INSERT INTO customers VALUES
(1, 'Alice', 'Chennai'),
(2, 'Bob', 'Chennai'),
(3, 'Carol', 'Bangalore'),
(4, 'David', 'Mumbai'),
(5, 'Eva', 'Bangalore'),
(6, 'Frank', 'Delhi'),
(7, 'Grace', 'Mumbai'),
(8, 'Hari', 'Chennai');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 50000),
(102, 'Phone', 'Electronics', 20000),
(103, 'Chair', 'Furniture', 5000),
(104, 'Desk', 'Furniture', 10000),
(105, 'Headphones', 'Accessories', 2000),
(106, 'Watch', 'Accessories', 8000),
(107, 'Tablet', 'Electronics', 15000);

INSERT INTO orders VALUES
(1001, 1, '2026-01-05'),
(1002, 1, '2026-01-20'),
(1003, 1, '2026-02-10'),
(1004, 1, '2026-03-02'),
(1005, 2, '2026-01-07'),
(1006, 2, '2026-02-15'),
(1007, 3, '2026-01-09'),
(1008, 3, '2026-03-12'),
(1009, 4, '2026-02-20'),
(1010, 5, '2026-03-15'),
(1011, 6, '2026-03-20');

INSERT INTO order_items VALUES
(1, 1001, 101, 1, 50000),
(2, 1001, 105, 2, 2000),
(3, 1002, 102, 1, 20000),
(4, 1002, 105, 1, 2000),
(5, 1003, 104, 1, 10000),
(6, 1004, 102, 1, 20000),
(7, 1004, 106, 1, 8000),
(8, 1005, 103, 2, 5000),
(9, 1006, 107, 1, 15000),
(10, 1007, 101, 1, 50000),
(11, 1008, 103, 1, 5000),
(12, 1008, 104, 1, 10000),
(13, 1009, 102, 2, 20000),
(14, 1010, 105, 3, 2000),
(15, 1011, 106, 1, 8000);

INSERT INTO payments VALUES
(5001, 1001, 54000, '2026-01-05'),
(5002, 1002, 22000, '2026-01-20'),
(5003, 1003, NULL, '2026-02-10'),
(5004, 1004, 28000, '2026-03-02'),
(5005, 1005, 10000, '2026-01-07'),
(5006, 1007, 50000, '2026-01-09'),
(5007, 1008, 15000, '2026-03-12'),
(5008, 1010, 6000, '2026-03-15'),
(5009, 1011, 8000, '2026-03-20');


-- PART 3: EIGHT RETAIL SALES REPORTING QUERIES


-- QUERY 1: TOP 5 PRODUCTS BY REVENUE

SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC, p.product_id
LIMIT 5;


-- QUERY 2: MONTH-WISE SALES

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS monthly_sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;


-- QUERY 3: CUSTOMERS WITH MORE THAN THREE ORDERS

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 3;


-- QUERY 4: AVERAGE BASKET VALUE PER CITY

SELECT
    c.city,
    ROUND(AVG(order_total), 2) AS average_basket_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_totals
ON o.order_id = order_totals.order_id
GROUP BY c.city
ORDER BY c.city;


-- QUERY 5: ORDERS WITHOUT PAYMENT (LEFT JOIN)

SELECT
    o.order_id,
    o.customer_id,
    o.order_date
FROM orders o
LEFT JOIN payments p
ON o.order_id = p.order_id
WHERE p.payment_id IS NULL;


-- QUERY 6: CUSTOMERS WITH NO ORDERS

SELECT
    c.customer_id,
    c.customer_name,
    c.city
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- QUERY 7: PRODUCT CATEGORY REVENUE SHARE

SELECT
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS category_revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price) * 100 /
        (SELECT SUM(quantity * unit_price)
         FROM order_items),
        2
    ) AS revenue_share_percentage
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;


-- QUERY 8: DAY WITH HIGHEST SALES

SELECT
    o.order_date AS sales_day,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY total_sales DESC, sales_day
LIMIT 1;


-- PART 4: STRING, DATE AND MATHEMATICAL FUNCTIONS


SELECT
    c.customer_id,
    UPPER(c.customer_name) AS customer_name,
    CONCAT(c.customer_name, ' - ', c.city) AS customer_details,
    FORMAT(SUM(oi.quantity * oi.unit_price), 2) AS formatted_amount,
    DATEDIFF(CURRENT_DATE(), o.order_date) AS days_since_order,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_amount
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date;


-- PART 5: NULL BEHAVIOUR IN AGGREGATE FUNCTIONS


SELECT
    COUNT(*) AS total_rows,
    COUNT(amount) AS non_null_amounts,
    AVG(amount) AS average_amount
FROM payments;
