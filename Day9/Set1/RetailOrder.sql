
-- ============================================
-- DAY 9: RETAIL ORDER FULFILMENT
-- MYSQL 8.0
-- ============================================

CREATE DATABASE IF NOT EXISTS RetailFulfilmentDB;
USE RetailFulfilmentDB;

-- ============================================
-- TABLE CREATION
-- ============================================

DROP VIEW IF EXISTS vw_order_summary;
DROP VIEW IF EXISTS vw_low_stock;
DROP VIEW IF EXISTS vw_pending_orders;
DROP VIEW IF EXISTS vw_customer_orders;

DROP TABLE IF EXISTS follow_up;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    supplier_name VARCHAR(100),
    stock_qty INT NOT NULL,
    reorder_level INT NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE follow_up (
    followup_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    followup_date DATETIME NOT NULL,
    note VARCHAR(255),
    followup_type VARCHAR(50) NOT NULL,
    UNIQUE KEY unique_order_followup (order_id, followup_type),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ============================================
-- SAMPLE DATA
-- ============================================

INSERT INTO customers (customer_name, email) VALUES
('Arun', 'arun@gmail.com'),
('Rahul', 'rahul@gmail.com'),
('Kumar', 'kumar@gmail.com');

INSERT INTO products
(product_name, unit_price, cost_price, supplier_name,
 stock_qty, reorder_level)
VALUES
('Laptop', 50000, 40000, 'Dell Suppliers', 20, 5),
('Mouse', 500, 250, 'Tech Suppliers', 4, 10),
('Keyboard', 1200, 800, 'ABC Suppliers', 15, 5),
('Monitor', 12000, 9000, 'Screen Suppliers', 3, 5);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, NOW() - INTERVAL 5 DAY, 'Pending'),
(2, NOW() - INTERVAL 1 DAY, 'Pending'),
(3, NOW() - INTERVAL 6 DAY, 'Shipped');

INSERT INTO order_items
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 50000),
(2, 2, 2, 500),
(3, 3, 1, 1200);

-- ============================================
-- TASK 1: VIEWS
-- ============================================

-- View hiding cost price and supplier columns

CREATE VIEW vw_order_summary AS
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    o.status,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY
    o.order_id, c.customer_name,
    o.order_date, o.status;

SELECT * FROM vw_order_summary;

-- Low stock view

CREATE VIEW vw_low_stock AS
SELECT
    product_id,
    product_name,
    stock_qty,
    reorder_level
FROM products
WHERE stock_qty <= reorder_level;

SELECT * FROM vw_low_stock;

-- Updatable view with CHECK OPTION

CREATE VIEW vw_pending_orders AS
SELECT
    order_id,
    customer_id,
    order_date,
    status
FROM orders
WHERE status = 'Pending'
WITH CASCADED CHECK OPTION;

SELECT * FROM vw_pending_orders;

-- Demonstration: This update is allowed
UPDATE vw_pending_orders
SET order_date = NOW()
WHERE order_id = 1;

-- This would be rejected because it violates CHECK OPTION:
-- UPDATE vw_pending_orders
-- SET status = 'Shipped'
-- WHERE order_id = 1;


-- ============================================
-- TASK 2: STORED PROCEDURE
-- ============================================

DELIMITER //

CREATE PROCEDURE usp_PlaceOrder(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    OUT p_order_number INT
)
BEGIN
    DECLARE v_stock INT DEFAULT NULL;
    DECLARE v_price DECIMAL(10,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET p_order_number = NULL;

    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;

    START TRANSACTION;

    SELECT stock_qty, unit_price
    INTO v_stock, v_price
    FROM products
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product does not exist';
    END IF;

    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock';
    END IF;

    INSERT INTO orders (customer_id, order_date, status)
    VALUES (p_customer_id, NOW(), 'Pending');

    SET p_order_number = LAST_INSERT_ID();

    INSERT INTO order_items
    (order_id, product_id, quantity, unit_price)
    VALUES
    (p_order_number, p_product_id, p_quantity, v_price);

    UPDATE products
    SET stock_qty = stock_qty - p_quantity
    WHERE product_id = p_product_id;

    COMMIT;

END //

DELIMITER ;

-- Execute procedure

CALL usp_PlaceOrder(1, 1, 2, @new_order_number);

SELECT @new_order_number AS Generated_Order_Number;


-- ============================================
-- TASK 3: SCALAR FUNCTION
-- ============================================

DELIMITER //

CREATE FUNCTION fn_OrderTotalWithTax(
    p_order_id INT
)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(12,2);

    SELECT COALESCE(SUM(quantity * unit_price), 0)
    INTO v_total
    FROM order_items
    WHERE order_id = p_order_id;

    RETURN v_total * 1.18;
END //

DELIMITER ;

-- Execute scalar function

SELECT
    order_id,
    fn_OrderTotalWithTax(order_id) AS Total_With_Tax
FROM orders;


-- MySQL alternative to an inline table-valued function:
-- MySQL does not support user-defined table-valued functions.
-- A parameterized query can instead be represented by a view.

CREATE VIEW vw_customer_orders AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_name,
    o.order_date,
    o.status,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY
    o.order_id, o.customer_id,
    c.customer_name, o.order_date, o.status;

-- Get orders belonging to customer 1

SELECT *
FROM vw_customer_orders
WHERE customer_id = 1;


-- Stored procedure alternative for parameterized results

DELIMITER //

CREATE PROCEDURE usp_GetCustomerOrders(
    IN p_customer_id INT
)
BEGIN
    SELECT *
    FROM vw_customer_orders
    WHERE customer_id = p_customer_id;
END //

DELIMITER ;

CALL usp_GetCustomerOrders(1);


-- ============================================
-- TASK 4: CURSOR-BASED PROCEDURE
-- ============================================

DELIMITER //

CREATE PROCEDURE usp_FollowUpCursor()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_order_id INT;

    DECLARE order_cursor CURSOR FOR
        SELECT order_id
        FROM orders
        WHERE status = 'Pending'
        AND order_date < NOW() - INTERVAL 3 DAY;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = 1;

    OPEN order_cursor;

    read_loop: LOOP

        FETCH order_cursor INTO v_order_id;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        INSERT IGNORE INTO follow_up
        (order_id, followup_date, note, followup_type)
        VALUES
        (
            v_order_id,
            NOW(),
            'Order pending for more than three days',
            'Delayed Order'
        );

    END LOOP;

    CLOSE order_cursor;

END //

DELIMITER ;

-- Execute cursor procedure

CALL usp_FollowUpCursor();

SELECT * FROM follow_up;


-- ============================================
-- SET-BASED ALTERNATIVE
-- ============================================

-- Performs the same operation without a cursor.

INSERT IGNORE INTO follow_up
(order_id, followup_date, note, followup_type)
SELECT
    order_id,
    NOW(),
    'Order pending for more than three days',
    'Delayed Order'
FROM orders
WHERE status = 'Pending'
AND order_date < NOW() - INTERVAL 3 DAY;

SELECT * FROM follow_up;


-- ============================================
-- FINAL VERIFICATION
-- ============================================

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM vw_order_summary;
SELECT * FROM vw_low_stock;
SELECT * FROM vw_pending_orders;
SELECT * FROM vw_customer_orders;
SELECT * FROM follow_up;
