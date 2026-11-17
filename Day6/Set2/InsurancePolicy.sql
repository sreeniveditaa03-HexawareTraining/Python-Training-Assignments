
-- PART 1: CREATE DATABASE

-- PART 1: CREATE DATABASE

CREATE DATABASE IF NOT EXISTS InsuranceDB;

USE InsuranceDB;



-- PART 2: CREATE TABLES


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    date_of_birth DATE,
    city VARCHAR(50)
);

CREATE TABLE agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(100)
);

CREATE TABLE policies (
    policy_id INT PRIMARY KEY,
    policy_number VARCHAR(30) UNIQUE,
    customer_id INT,
    agent_id INT,
    product VARCHAR(50),
    premium_amount DECIMAL(12,2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

CREATE TABLE premium_payments (
    payment_id INT PRIMARY KEY,
    policy_id INT,
    amount DECIMAL(12,2),
    payment_date DATE,
    payment_status VARCHAR(20),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

CREATE TABLE claims (
    claim_id INT PRIMARY KEY,
    policy_id INT,
    claim_date DATE,
    claim_status VARCHAR(30),
    settlement_date DATE NULL,
    claim_amount DECIMAL(12,2),
    damage_category VARCHAR(50),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

-- PART 3: INSERT SAMPLE DATA


INSERT INTO customers VALUES
(1, 'Alice', '1990-05-12', 'Chennai'),
(2, 'Bob', '1985-08-20', 'Bangalore'),
(3, 'Carol', '2000-03-15', 'Mumbai'),
(4, 'David', '1975-11-10', 'Delhi'),
(5, 'Eva', '1995-06-25', 'Chennai'),
(6, 'Frank', '1965-02-18', 'Hyderabad'),
(7, 'Grace', '2003-09-05', 'Bangalore'),
(8, 'Hari', '1980-12-30', 'Mumbai');

INSERT INTO agents VALUES
(101, 'John'),
(102, 'Priya'),
(103, 'Rahul'),
(104, 'Sneha'),
(105, 'Arun');

INSERT INTO policies VALUES
(1, 'POL10001', 1, 101, 'Health', 15000, '2025-01-10',
 DATEADD(DAY, 7, CAST(GETDATE() AS DATE)), 'Active'),

(2, 'POL10002', 1, 102, 'Life', 25000, '2025-04-15',
 DATEADD(DAY, 15, CAST(GETDATE() AS DATE)), 'Active'),

(3, 'POL10003', 2, 101, 'Vehicle', 12000, '2025-06-01',
 DATEADD(DAY, 25, CAST(GETDATE() AS DATE)), 'Active'),

(4, 'POL10004', 3, 103, 'Health', 18000, '2025-08-12',
 DATEADD(DAY, 45, CAST(GETDATE() AS DATE)), 'Active'),

(5, 'POL10005', 4, 104, 'Life', 30000, '2024-02-10',
 '2027-02-10', 'Active'),

(6, 'POL10006', 5, 102, 'Vehicle', 10000, '2025-09-20',
 '2027-09-20', 'Active'),

(7, 'POL10007', 6, 105, 'Health', 22000, '2025-11-01',
 '2027-11-01', 'Active'),

(8, 'POL10008', 2, 103, 'Life', 28000, '2025-12-01',
 '2027-12-01', 'Active'),

(9, 'POL10009', 7, 104, 'Vehicle', 9000, '2026-01-15',
 '2027-01-15', 'Inactive'),

(10, 'POL10010', 8, 105, 'Health', 20000, '2026-02-01',
 '2027-02-01', 'Active');

INSERT INTO premium_payments VALUES
(501, 1, 15000, '2025-01-10', 'Paid'),
(502, 2, 25000, '2025-04-15', 'Paid'),
(503, 3, 12000, '2025-06-01', 'Paid'),
(504, 4, 18000, '2025-08-12', 'Paid'),
(505, 5, 30000, '2025-02-10', 'Paid'),
(506, 6, 10000, '2025-09-20', 'Paid'),
(507, 7, 22000, '2025-11-01', 'Paid'),
(508, 8, 28000, '2025-12-01', 'Paid'),
(509, 9, 9000, '2026-01-15', 'Paid'),
(510, 10, 20000, '2026-02-01', 'Paid');

INSERT INTO claims VALUES
(1001, 1, '2025-03-10', 'Settled', '2025-03-20', 5000, 'Accident'),
(1002, 2, '2025-05-15', 'Settled', '2025-05-25', 8000, 'Medical'),
(1003, 3, '2025-07-01', 'Approved', NULL, 6000, 'Accident'),
(1004, 4, '2025-09-10', 'Settled', '2025-09-15', 10000, 'Fire'),
(1005, 5, '2025-04-12', 'Rejected', NULL, 12000, 'Medical'),
(1006, 6, '2025-10-05', 'Settled', '2025-10-15', 4000, 'Accident'),
(1007, 7, '2025-12-10', 'Open', NULL, 7000, 'Fire'),
(1008, 8, '2026-01-05', 'Settled', '2026-01-12', 9000, 'Medical');


-- PART 4: EIGHT INSURANCE REPORTING QUERIES


-- QUERY 1: POLICIES EXPIRING IN THE NEXT 30 DAYS

SELECT
    policy_id,
    policy_number,
    product,
    end_date,
    status
FROM policies
WHERE end_date >= CAST(GETDATE() AS DATE)
  AND end_date <= DATEADD(DAY, 30, CAST(GETDATE() AS DATE))
  AND status = 'Active'
ORDER BY end_date;


-- QUERY 2: PREMIUM COLLECTED PER PRODUCT

SELECT
    p.product,
    SUM(pp.amount) AS total_premium_collected
FROM policies p
JOIN premium_payments pp
    ON p.policy_id = pp.policy_id
WHERE pp.payment_status = 'Paid'
GROUP BY p.product
ORDER BY total_premium_collected DESC;


-- QUERY 3: CUSTOMERS WITH MORE THAN ONE ACTIVE POLICY

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(p.policy_id) AS active_policy_count
FROM customers c
JOIN policies p
    ON c.customer_id = p.customer_id
WHERE p.status = 'Active'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(p.policy_id) > 1;


-- QUERY 4: CLAIM RATIO PER PRODUCT

SELECT
    p.product,
    COUNT(DISTINCT cl.claim_id) AS total_claims,
    COUNT(DISTINCT p.policy_id) AS total_policies,
    ROUND(
        COUNT(DISTINCT cl.claim_id) * 100.0 /
        NULLIF(COUNT(DISTINCT p.policy_id), 0),
        2
    ) AS claim_ratio_percentage
FROM policies p
LEFT JOIN claims cl
    ON p.policy_id = cl.policy_id
GROUP BY p.product
ORDER BY claim_ratio_percentage DESC;


-- QUERY 5: POLICIES WITHOUT CLAIMS

SELECT
    p.policy_id,
    p.policy_number,
    p.product,
    p.status
FROM policies p
LEFT JOIN claims cl
    ON p.policy_id = cl.policy_id
WHERE cl.claim_id IS NULL;


-- QUERY 6: AVERAGE PREMIUM BY CUSTOMER AGE BAND

SELECT
    CASE
        WHEN DATEDIFF(YEAR, c.date_of_birth, GETDATE())
             - CASE
                   WHEN DATEADD(
                       YEAR,
                       DATEDIFF(YEAR, c.date_of_birth, GETDATE()),
                       c.date_of_birth
                   ) > GETDATE()
                   THEN 1 ELSE 0
               END < 30 THEN 'Below 30'

        WHEN DATEDIFF(YEAR, c.date_of_birth, GETDATE())
             - CASE
                   WHEN DATEADD(
                       YEAR,
                       DATEDIFF(YEAR, c.date_of_birth, GETDATE()),
                       c.date_of_birth
                   ) > GETDATE()
                   THEN 1 ELSE 0
               END < 45 THEN '30-44'

        WHEN DATEDIFF(YEAR, c.date_of_birth, GETDATE())
             - CASE
                   WHEN DATEADD(
                       YEAR,
                       DATEDIFF(YEAR, c.date_of_birth, GETDATE()),
                       c.date_of_birth
                   ) > GETDATE()
                   THEN 1 ELSE 0
               END < 60 THEN '45-59'

        ELSE '60 and above'
    END AS age_band,

    ROUND(AVG(p.premium_amount), 2) AS average_premium

FROM customers c
JOIN policies p
    ON c.customer_id = p.customer_id
GROUP BY
    CASE
        WHEN DATEDIFF(YEAR, c.date_of_birth, GETDATE())
             - CASE
                   WHEN DATEADD(
                       YEAR,
                       DATEDIFF(YEAR, c.date_of_birth, GETDATE()),
                       c.date_of_birth
                   ) > GETDATE()
                   THEN 1 ELSE 0
               END < 30 THEN 'Below 30'

        WHEN DATEDIFF(YEAR, c.date_of_birth, GETDATE())
             - CASE
                   WHEN DATEADD(
                       YEAR,
                       DATEDIFF(YEAR, c.date_of_birth, GETDATE()),
                       c.date_of_birth
                   ) > GETDATE()
                   THEN 1 ELSE 0
               END < 45 THEN '30-44'

        WHEN DATEDIFF(YEAR, c.date_of_birth, GETDATE())
             - CASE
                   WHEN DATEADD(
                       YEAR,
                       DATEDIFF(YEAR, c.date_of_birth, GETDATE()),
                       c.date_of_birth
                   ) > GETDATE()
                   THEN 1 ELSE 0
               END < 60 THEN '45-59'

        ELSE '60 and above'
    END
ORDER BY age_band;


-- QUERY 7: MONTHLY NEW POLICIES

SELECT
    FORMAT(start_date, 'yyyy-MM') AS policy_month,
    COUNT(*) AS total_new_policies
FROM policies
GROUP BY FORMAT(start_date, 'yyyy-MM')
ORDER BY policy_month;


-- QUERY 8: TOP 5 AGENTS BY PREMIUM

SELECT TOP 5
    a.agent_id,
    a.agent_name,
    SUM(pp.amount) AS total_premium
FROM agents a
JOIN policies p
    ON a.agent_id = p.agent_id
JOIN premium_payments pp
    ON p.policy_id = pp.policy_id
WHERE pp.payment_status = 'Paid'
GROUP BY a.agent_id, a.agent_name
ORDER BY total_premium DESC;



-- PART 5: DATE, CASE AND STRING FUNCTIONS
-- POLICY AGE BANDS AND MASKED POLICY NUMBERS


SELECT
    policy_id,

    
    CONCAT(
        LEFT(policy_number, 3),
        REPLICATE('*', LEN(policy_number) - 6),
        RIGHT(policy_number, 3)
    ) AS masked_policy_number,

    start_date,

  
    DATEDIFF(DAY, start_date, GETDATE()) AS policy_age_days,


    CASE
        WHEN DATEDIFF(DAY, start_date, GETDATE()) < 365
            THEN 'Less than 1 year'
        WHEN DATEDIFF(DAY, start_date, GETDATE()) < 1095
            THEN '1-3 years'
        ELSE 'More than 3 years'
    END AS policy_age_band,


    DATEADD(YEAR, 1, start_date) AS first_anniversary

FROM policies;



-- PART 6: WHERE VS HAVING EXPLANATION



SELECT
    customer_id,
    COUNT(*) AS active_policy_count
FROM policies
WHERE status = 'Active'
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- PART 7: CLAIM SETTLEMENT TIME (SQL REFERENCE)


SELECT
    claim_id,
    DATEDIFF(DAY, claim_date, settlement_date) AS settlement_days
FROM claims
WHERE settlement_date IS NOT NULL;
