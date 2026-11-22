
-- ==================================================
-- DAY 9 - SET 2: INSURANCE PREMIUM PROCESSING
-- MYSQL 8.0
-- ==================================================

CREATE DATABASE IF NOT EXISTS InsurancePremiumDB;
USE InsurancePremiumDB;

-- ==================================================
-- 1. DROP OLD OBJECTS
-- ==================================================

DROP VIEW IF EXISTS vw_policy_due;
DROP VIEW IF EXISTS vw_agent_renewal_quotes;

DROP PROCEDURE IF EXISTS usp_RenewPolicy;
DROP PROCEDURE IF EXISTS usp_GetAgentRenewalQuotes;
DROP PROCEDURE IF EXISTS usp_LapsePoliciesCursor;

DROP FUNCTION IF EXISTS fn_PremiumWithNoClaimDiscount;

DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS policies;
DROP TABLE IF EXISTS customers;


-- ==================================================
-- 2. CREATE TABLES
-- ==================================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    address VARCHAR(200),
    national_id VARCHAR(30)
);

CREATE TABLE policies (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_number VARCHAR(30) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    agent_id INT NOT NULL,
    premium DECIMAL(12,2) NOT NULL,
    sum_insured DECIMAL(12,2),
    premium_due_date DATE NOT NULL,
    status VARCHAR(30) DEFAULT 'Active',
    no_claim_years INT DEFAULT 0,
    payment_token VARCHAR(100),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE claims (
    claim_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_id INT NOT NULL,
    claim_amount DECIMAL(12,2),
    claim_status VARCHAR(30),
    FOREIGN KEY (policy_id)
        REFERENCES policies(policy_id)
);

CREATE TABLE audit_log (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_id INT NOT NULL,
    action VARCHAR(100),
    old_status VARCHAR(30),
    new_status VARCHAR(30),
    old_premium DECIMAL(12,2),
    new_premium DECIMAL(12,2),
    audit_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (policy_id)
        REFERENCES policies(policy_id)
);


-- ==================================================
-- 3. INSERT SAMPLE DATA
-- ==================================================

INSERT INTO customers
(customer_name, email, phone, address, national_id)
VALUES
('Arun', 'arun@gmail.com', '9876543210', 'Chennai', 'ID1001'),
('Rahul', 'rahul@gmail.com', '9876543211', 'Bangalore', 'ID1002'),
('Kumar', 'kumar@gmail.com', '9876543212', 'Mumbai', 'ID1003'),
('Vijay', 'vijay@gmail.com', '9876543213', 'Delhi', 'ID1004');

INSERT INTO policies
(policy_number, customer_id, agent_id, premium,
 sum_insured, premium_due_date, status, no_claim_years,
 payment_token)
VALUES
('POL101', 1, 501, 10000, 500000,
 DATE_ADD(CURDATE(), INTERVAL 10 DAY), 'Active', 3, 'TOKEN101'),

('POL102', 2, 501, 15000, 800000,
 DATE_ADD(CURDATE(), INTERVAL 20 DAY), 'Active', 5, 'TOKEN102'),

('POL103', 3, 502, 12000, 600000,
 DATE_ADD(CURDATE(), INTERVAL 45 DAY), 'Active', 2, 'TOKEN103'),

('POL104', 4, 502, 18000, 900000,
 DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Active', 0, 'TOKEN104'),

('POL105', 1, 501, 9000, 400000,
 DATE_ADD(CURDATE(), INTERVAL 15 DAY), 'Active', 4, 'TOKEN105');


INSERT INTO claims
(policy_id, claim_amount, claim_status)
VALUES
(1, 5000, 'Approved'),
(2, 10000, 'Pending'),
(3, 3000, 'Approved'),
(5, 2000, 'Rejected');


-- ==================================================
-- TASK 1: CREATE VIEW
-- vw_policy_due
-- Policies due within 30 days
-- Hide sensitive columns
-- ==================================================

CREATE VIEW vw_policy_due AS
SELECT
    p.policy_id,
    p.policy_number,
    c.customer_name,
    c.email,
    c.phone,
    p.agent_id,
    p.premium,
    p.sum_insured,
    p.premium_due_date,
    p.status
FROM policies p
JOIN customers c
ON p.customer_id = c.customer_id
WHERE p.premium_due_date
BETWEEN CURDATE()
AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
AND p.status = 'Active';

-- Display view

SELECT * FROM vw_policy_due;


-- ==================================================
-- TASK 2: SCALAR FUNCTION
-- Premium with No Claim Discount
-- ==================================================

DELIMITER //

CREATE FUNCTION fn_PremiumWithNoClaimDiscount(
    p_premium DECIMAL(12,2),
    p_no_claim_years INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_discount DECIMAL(5,2);

    SET v_discount = LEAST(p_no_claim_years * 5, 25);

    RETURN p_premium - (p_premium * v_discount / 100);
END //

DELIMITER ;

-- Test scalar function

SELECT
    fn_PremiumWithNoClaimDiscount(10000, 3)
    AS Discounted_Premium;


-- ==================================================
-- TASK 3: RENEW POLICY STORED PROCEDURE
-- Validation:
-- 1. Policy must be Active
-- 2. No Pending Claim
-- 3. Recalculate premium
-- 4. Insert audit row
-- 5. Use transaction
-- ==================================================

DELIMITER //

CREATE PROCEDURE usp_RenewPolicy(
    IN p_policy_id INT,
    IN p_new_due_date DATE,
    OUT p_new_premium DECIMAL(12,2)
)
BEGIN
    DECLARE v_status VARCHAR(30);
    DECLARE v_premium DECIMAL(12,2);
    DECLARE v_no_claim_years INT;
    DECLARE v_pending_claims INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET p_new_premium = NULL;

    START TRANSACTION;

    -- Get policy details

    SELECT status, premium, no_claim_years
    INTO v_status, v_premium, v_no_claim_years
    FROM policies
    WHERE policy_id = p_policy_id
    FOR UPDATE;

    -- Validate active policy

    IF v_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Policy is not active';
    END IF;

    -- Check pending claims

    SELECT COUNT(*)
    INTO v_pending_claims
    FROM claims
    WHERE policy_id = p_policy_id
    AND claim_status = 'Pending';

    IF v_pending_claims > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Policy has pending claims';
    END IF;

    -- Calculate new premium

    SET p_new_premium =
        fn_PremiumWithNoClaimDiscount(
            v_premium,
            v_no_claim_years
        );

    -- Update policy

    UPDATE policies
    SET premium = p_new_premium,
        premium_due_date = p_new_due_date
    WHERE policy_id = p_policy_id;

    -- Insert audit record

    INSERT INTO audit_log
    (policy_id, action, old_status, new_status,
     old_premium, new_premium)
    VALUES
    (p_policy_id, 'Policy Renewed',
     v_status, v_status,
     v_premium, p_new_premium);

    COMMIT;

END //

DELIMITER ;


-- Execute renewal procedure
-- Policy 1 has no pending claims

CALL usp_RenewPolicy(
    1,
    DATE_ADD(CURDATE(), INTERVAL 1 YEAR),
    @renewed_premium
);

SELECT @renewed_premium AS New_Premium;


-- ==================================================
-- TASK 3: TABLE-VALUED FUNCTION ALTERNATIVE
-- MySQL does not support user-defined
-- table-valued functions.
-- Use a view and parameterized procedure.
-- ==================================================

CREATE VIEW vw_agent_renewal_quotes AS
SELECT
    p.policy_id,
    p.policy_number,
    p.agent_id,
    c.customer_name,
    p.premium AS original_premium,
    p.no_claim_years,
    fn_PremiumWithNoClaimDiscount(
        p.premium,
        p.no_claim_years
    ) AS renewal_quote
FROM policies p
JOIN customers c
ON p.customer_id = c.customer_id
WHERE p.status = 'Active';


-- Procedure returns renewal quotes for an agent

DELIMITER //

CREATE PROCEDURE usp_GetAgentRenewalQuotes(
    IN p_agent_id INT
)
BEGIN
    SELECT *
    FROM vw_agent_renewal_quotes
    WHERE agent_id = p_agent_id;
END //

DELIMITER ;

-- Display quotes for agent 501

CALL usp_GetAgentRenewalQuotes(501);


-- ==================================================
-- TASK 4: CURSOR-BASED PROCEDURE
-- Find policies with lapsed premiums
-- Update status to Lapsed
-- Log each update
-- ==================================================

DELIMITER //

CREATE PROCEDURE usp_LapsePoliciesCursor()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_policy_id INT;
    DECLARE v_old_premium DECIMAL(12,2);

    DECLARE policy_cursor CURSOR FOR
        SELECT policy_id
        FROM policies
        WHERE premium_due_date < CURDATE()
        AND status = 'Active';

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    OPEN policy_cursor;

    read_loop: LOOP

        FETCH policy_cursor INTO v_policy_id;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        SELECT premium
        INTO v_old_premium
        FROM policies
        WHERE policy_id = v_policy_id;

        -- Update policy status

        UPDATE policies
        SET status = 'Lapsed'
        WHERE policy_id = v_policy_id;

        -- Log each update

        INSERT INTO audit_log
        (policy_id, action, old_status, new_status,
         old_premium, new_premium)
        VALUES
        (v_policy_id, 'Policy Lapsed',
         'Active', 'Lapsed',
         v_old_premium, v_old_premium);

    END LOOP;

    CLOSE policy_cursor;

    COMMIT;

END //

DELIMITER ;


-- Execute cursor procedure

CALL usp_LapsePoliciesCursor();

SELECT * FROM audit_log;


-- ==================================================
-- SET-BASED ALTERNATIVE
-- Same operation without a cursor
-- ==================================================

START TRANSACTION;

-- Log all policies before updating

INSERT INTO audit_log
(policy_id, action, old_status, new_status,
 old_premium, new_premium)
SELECT
    policy_id,
    'Policy Lapsed',
    'Active',
    'Lapsed',
    premium,
    premium
FROM policies
WHERE premium_due_date < CURDATE()
AND status = 'Active';

-- Update all matching policies together

UPDATE policies
SET status = 'Lapsed'
WHERE premium_due_date < CURDATE()
AND status = 'Active';

COMMIT;


-- ==================================================
-- FINAL VERIFICATION
-- ==================================================

SELECT * FROM customers;

SELECT * FROM policies;

SELECT * FROM claims;

SELECT * FROM vw_policy_due;

SELECT * FROM vw_agent_renewal_quotes;

SELECT * FROM audit_log;
