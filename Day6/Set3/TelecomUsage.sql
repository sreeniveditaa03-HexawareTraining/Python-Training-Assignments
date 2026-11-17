

-- PART 1: CREATE DATABASE

CREATE DATABASE IF NOT EXISTS TelecomDB;
USE TelecomDB;

-- Drop old tables to allow rerunning the script
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS call_records;
DROP TABLE IF EXISTS subscribers;
DROP TABLE IF EXISTS plans;


-- PART 2: CREATE TABLES


CREATE TABLE plans (
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(100),
    data_limit_mb DECIMAL(12,2),
    monthly_price DECIMAL(10,2)
);

CREATE TABLE subscribers (
    subscriber_id INT PRIMARY KEY,
    subscriber_name VARCHAR(100),
    circle VARCHAR(50),
    plan_id INT,
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id)
);

CREATE TABLE call_records (
    record_id INT PRIMARY KEY,
    subscriber_id INT,
    call_date DATETIME,
    call_minutes DECIMAL(10,2),
    data_mb DECIMAL(12,2),
    session_seconds INT,
    cell_tower VARCHAR(50),
    FOREIGN KEY (subscriber_id) REFERENCES subscribers(subscriber_id)
);

CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY,
    subscriber_id INT,
    invoice_number VARCHAR(30),
    invoice_date DATE,
    due_date DATE,
    amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (subscriber_id) REFERENCES subscribers(subscriber_id)
);


-- PART 3: INSERT SAMPLE DATA


INSERT INTO plans VALUES
(1, 'Basic', 2048, 299),
(2, 'Standard', 5120, 499),
(3, 'Premium', 10240, 799),
(4, 'Unlimited', 51200, 999);

INSERT INTO subscribers VALUES
(101, 'Alice', 'Chennai', 1),
(102, 'Bob', 'Chennai', 2),
(103, 'Carol', 'Bangalore', 3),
(104, 'David', 'Mumbai', 2),
(105, 'Eva', 'Delhi', 4),
(106, 'Frank', 'Bangalore', 1),
(107, 'Grace', 'Mumbai', 3),
(108, 'Hari', 'Chennai', 2),
(109, 'Isha', 'Delhi', 4),
(110, 'Jack', 'Hyderabad', 1),
(111, 'Kiran', 'Hyderabad', 3),
(112, 'Latha', 'Chennai', 2);

INSERT INTO call_records VALUES
(1, 101, '2026-10-01 09:00:00', 20, 500, 1200, 'TOWER_A'),
(2, 101, '2026-10-01 10:00:00', 15, 300, 900, 'TOWER_A'),
(3, 102, '2026-10-02 11:00:00', 30, 2000, 1800, 'TOWER_B'),
(4, 102, '2026-10-03 12:00:00', 25, 1500, 1500, 'TOWER_B'),
(5, 103, '2026-10-04 13:00:00', 45, 8000, 2700, 'TOWER_C'),
(6, 103, '2026-10-05 14:00:00', 35, 4000, 2100, 'TOWER_C'),
(7, 104, '2026-10-06 15:00:00', 10, 1000, 600, 'TOWER_A'),
(8, 104, '2026-10-07 16:00:00', 15, 1200, 900, 'TOWER_B'),
(9, 105, '2026-10-08 17:00:00', 60, 15000, 3600, 'TOWER_C'),
(10, 105, '2026-10-09 18:00:00', 40, 12000, 2400, 'TOWER_C'),
(11, 106, '2026-10-10 09:00:00', 12, 400, 720, 'TOWER_A'),
(12, 107, '2026-10-11 10:00:00', 25, 6000, 1500, 'TOWER_B'),
(13, 107, '2026-10-12 11:00:00', 20, 5000, 1200, 'TOWER_B'),
(14, 108, '2026-10-13 12:00:00', 18, 1800, 1080, 'TOWER_A'),
(15, 109, '2026-10-14 13:00:00', 55, 20000, 3300, 'TOWER_C'),
(16, 110, '2026-10-15 14:00:00', 10, 600, 600, 'TOWER_B'),
(17, 111, '2026-11-01 09:00:00', 30, 7000, 1800, 'TOWER_A'),
(18, 111, '2026-11-01 10:00:00', 20, 4000, 1200, 'TOWER_A'),
(19, 112, '2026-11-02 11:00:00', 15, 1000, 900, 'TOWER_B'),
(20, 103, '2026-11-03 12:00:00', 40, 9000, 2400, 'TOWER_C');

-- Subscriber 112 has no usage records.

INSERT INTO invoices VALUES
(1, 101, 'INV20261001', '2026-10-01', '2026-10-20', 299, 'Unpaid'),
(2, 102, 'INV20261002', '2026-10-02', '2026-10-25', 499, 'Paid'),
(3, 103, 'INV20261003', '2026-10-03', '2026-10-28', 799, 'Paid'),
(4, 104, 'INV20261004', '2026-10-04', '2026-11-10', 499, 'Unpaid'),
(5, 105, 'INV20261005', '2026-10-05', '2026-10-30', 999, 'Paid'),
(6, 106, 'INV20261006', '2026-10-06', '2026-11-15', 299, 'Unpaid'),
(7, 107, 'INV20261007', '2026-10-07', '2026-10-20', 799, 'Paid'),
(8, 108, 'INV20261008', '2026-10-08', '2026-11-20', 499, 'Unpaid'),
(9, 109, 'INV20261009', '2026-10-09', '2026-10-25', 999, 'Paid'),
(10, 110, 'INV20261010', '2026-10-10', '2026-10-20', 299, 'Unpaid'),
(11, 111, 'INV20261111', '2026-11-01', '2026-11-25', 799, 'Paid'),
(12, 112, 'INV20261112', '2026-11-02', '2026-11-30', 499, 'Paid');


-- PART 4: EIGHT REPORTING QUERIES


-- QUERY 1: TOTAL CALL MINUTES PER PLAN

SELECT
    p.plan_name,
    ROUND(SUM(cr.call_minutes), 2) AS total_call_minutes
FROM plans p
JOIN subscribers s
    ON p.plan_id = s.plan_id
JOIN call_records cr
    ON s.subscriber_id = cr.subscriber_id
GROUP BY p.plan_id, p.plan_name
ORDER BY total_call_minutes DESC;


-- QUERY 2: SUBSCRIBERS EXCEEDING THEIR DATA LIMIT

SELECT
    s.subscriber_id,
    s.subscriber_name,
    p.plan_name,
    p.data_limit_mb,
    SUM(cr.data_mb) AS total_data_used_mb
FROM subscribers s
JOIN plans p
    ON s.plan_id = p.plan_id
JOIN call_records cr
    ON s.subscriber_id = cr.subscriber_id
GROUP BY
    s.subscriber_id,
    s.subscriber_name,
    p.plan_name,
    p.data_limit_mb
HAVING SUM(cr.data_mb) > p.data_limit_mb;


-- QUERY 3: MONTH-WISE REVENUE

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS revenue_month,
    ROUND(SUM(amount), 2) AS monthly_revenue
FROM invoices
WHERE payment_status = 'Paid'
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY revenue_month;


-- QUERY 4: INVOICES OVERDUE BY MORE THAN 15 DAYS

SELECT
    invoice_id,
    invoice_number,
    subscriber_id,
    amount,
    due_date,
    DATEDIFF(CURDATE(), due_date) AS overdue_days
FROM invoices
WHERE payment_status = 'Unpaid'
  AND due_date < DATE_SUB(CURDATE(), INTERVAL 15 DAY)
ORDER BY overdue_days DESC;


-- QUERY 5: SUBSCRIBERS WITH NO USAGE

SELECT
    s.subscriber_id,
    s.subscriber_name,
    s.circle
FROM subscribers s
LEFT JOIN call_records cr
    ON s.subscriber_id = cr.subscriber_id
WHERE cr.record_id IS NULL;


-- QUERY 6: AVERAGE REVENUE PER USER (ARPU) BY CIRCLE

SELECT
    s.circle,
    ROUND(
        SUM(
            CASE
                WHEN i.payment_status = 'Paid' THEN i.amount
                ELSE 0
            END
        ) / COUNT(DISTINCT s.subscriber_id),
        2
    ) AS arpu
FROM subscribers s
LEFT JOIN invoices i
    ON s.subscriber_id = i.subscriber_id
GROUP BY s.circle
ORDER BY arpu DESC;


-- QUERY 7: PLAN POPULARITY

SELECT
    p.plan_name,
    COUNT(s.subscriber_id) AS total_subscribers
FROM plans p
LEFT JOIN subscribers s
    ON p.plan_id = s.plan_id
GROUP BY p.plan_id, p.plan_name
ORDER BY total_subscribers DESC;


-- QUERY 8: TOP 10 DATA CONSUMERS

SELECT
    s.subscriber_id,
    s.subscriber_name,
    ROUND(SUM(cr.data_mb), 2) AS total_data_used_mb
FROM subscribers s
JOIN call_records cr
    ON s.subscriber_id = cr.subscriber_id
GROUP BY s.subscriber_id, s.subscriber_name
ORDER BY total_data_used_mb DESC
LIMIT 10;



-- PART 5: STRING AND DATE FUNCTIONS


SELECT
    invoice_id,

    -- Format invoice number
    CONCAT(
        UPPER(LEFT(invoice_number, 3)),
        '-',
        SUBSTRING(invoice_number, 4, 6),
        '-',
        RIGHT(invoice_number, 2)
    ) AS formatted_invoice_number,

    invoice_date,
    due_date,

    -- Calculate days remaining or overdue
    DATEDIFF(due_date, CURDATE()) AS days_until_due,

    -- Due date status using CASE
    CASE
        WHEN payment_status = 'Paid' THEN 'Paid'
        WHEN due_date < CURDATE() THEN 'Overdue'
        WHEN due_date = CURDATE() THEN 'Due Today'
        ELSE 'Upcoming'
    END AS due_date_status

FROM invoices;



-- PART 6: NULL EFFECT ON SUM AND AVG




SELECT
    s.subscriber_id,
    s.subscriber_name,
    COUNT(cr.record_id) AS usage_rows,
    SUM(cr.data_mb) AS total_data,
    AVG(cr.data_mb) AS average_data
FROM subscribers s
LEFT JOIN call_records cr
    ON s.subscriber_id = cr.subscriber_id
GROUP BY s.subscriber_id, s.subscriber_name
ORDER BY s.subscriber_id;
