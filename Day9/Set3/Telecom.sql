
-- =====================================================
-- DAY 9 - SET 3: TELECOM LOW-BALANCE FOLLOW-UP
-- MYSQL 8.0
-- =====================================================

CREATE DATABASE IF NOT EXISTS TelecomRechargeDB;
USE TelecomRechargeDB;

-- =====================================================
-- 1. DROP EXISTING OBJECTS
-- =====================================================

DROP VIEW IF EXISTS vw_prepaid_subscribers;
DROP VIEW IF EXISTS vw_recharge_summary;

DROP PROCEDURE IF EXISTS usp_Recharge;
DROP PROCEDURE IF EXISTS usp_LastFiveRecharges;
DROP PROCEDURE IF EXISTS usp_LowBalanceCursor;

DROP FUNCTION IF EXISTS fn_ValidityDaysLeft;

DROP TABLE IF EXISTS notification_log;
DROP TABLE IF EXISTS recharge_history;
DROP TABLE IF EXISTS recharge_plans;
DROP TABLE IF EXISTS subscribers;


-- =====================================================
-- 2. CREATE TABLES
-- =====================================================

CREATE TABLE subscribers (
    subscriber_id INT PRIMARY KEY AUTO_INCREMENT,
    subscriber_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    plan_name VARCHAR(50),
    balance DECIMAL(10,2) DEFAULT 0,
    validity_end_date DATE,
    CHECK (account_type IN ('Prepaid', 'Postpaid'))
);


CREATE TABLE recharge_plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(50) UNIQUE NOT NULL,
    min_amount DECIMAL(10,2) NOT NULL,
    max_amount DECIMAL(10,2) NOT NULL,
    validity_days INT NOT NULL,
    active BOOLEAN DEFAULT TRUE
);


CREATE TABLE recharge_history (
    recharge_id INT PRIMARY KEY AUTO_INCREMENT,
    subscriber_id INT NOT NULL,
    plan_name VARCHAR(50) NOT NULL,
    recharge_amount DECIMAL(10,2) NOT NULL,
    recharge_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subscriber_id)
        REFERENCES subscribers(subscriber_id)
);


CREATE TABLE notification_log (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    subscriber_id INT NOT NULL,
    message VARCHAR(255),
    notification_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (subscriber_id)
        REFERENCES subscribers(subscriber_id)
);


-- =====================================================
-- 3. INSERT SAMPLE DATA
-- =====================================================

INSERT INTO recharge_plans
(plan_name, min_amount, max_amount, validity_days, active)
VALUES
('Basic', 10, 500, 28, TRUE),
('Unlimited', 199, 999, 56, TRUE),
('Premium', 299, 1999, 84, TRUE);


INSERT INTO subscribers
(subscriber_name, phone_number, account_type,
 plan_name, balance, validity_end_date)
VALUES
('Arun', '9876543210', 'Prepaid',
 'Basic', 30, DATE_ADD(CURDATE(), INTERVAL 10 DAY)),

('Rahul', '9876543211', 'Prepaid',
 'Unlimited', 150, DATE_ADD(CURDATE(), INTERVAL 20 DAY)),

('Kumar', '9876543212', 'Prepaid',
 'Premium', 25, DATE_ADD(CURDATE(), INTERVAL 5 DAY)),

('Vijay', '9876543213', 'Postpaid',
 'Premium', 500, DATE_ADD(CURDATE(), INTERVAL 30 DAY)),

('Ajay', '9876543214', 'Prepaid',
 'Basic', 45, DATE_ADD(CURDATE(), INTERVAL 15 DAY)),

('Ravi', '9876543215', 'Prepaid',
 'Unlimited', 80, DATE_ADD(CURDATE(), INTERVAL 25 DAY));


INSERT INTO recharge_history
(subscriber_id, plan_name, recharge_amount)
VALUES
(1, 'Basic', 100),
(1, 'Basic', 200),
(2, 'Unlimited', 299),
(3, 'Premium', 399),
(5, 'Basic', 100),
(6, 'Unlimited', 199);


-- =====================================================
-- TASK 1: CREATE VIEWS
-- =====================================================

-- View 1: Prepaid subscribers only
-- Postpaid subscribers are hidden.

CREATE VIEW vw_prepaid_subscribers AS
SELECT
    subscriber_id,
    subscriber_name,
    phone_number,
    plan_name,
    balance,
    validity_end_date
FROM subscribers
WHERE account_type = 'Prepaid';


-- Display prepaid subscribers

SELECT * FROM vw_prepaid_subscribers;


-- View 2: Recharge summary

CREATE VIEW vw_recharge_summary AS
SELECT
    s.subscriber_id,
    s.subscriber_name,
    COUNT(r.recharge_id) AS total_recharges,
    COALESCE(SUM(r.recharge_amount), 0)
        AS total_recharge_amount
FROM subscribers s
LEFT JOIN recharge_history r
    ON s.subscriber_id = r.subscriber_id
GROUP BY
    s.subscriber_id,
    s.subscriber_name;


-- Display recharge summary

SELECT * FROM vw_recharge_summary;


-- Demonstrate row-level hiding

-- Postpaid subscriber Vijay will not appear.

SELECT * FROM vw_prepaid_subscribers
WHERE subscriber_name = 'Vijay';


-- =====================================================
-- TASK 2: STORED PROCEDURE
-- usp_Recharge
-- =====================================================

DELIMITER //

CREATE PROCEDURE usp_Recharge(
    IN p_subscriber_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_plan_name VARCHAR(50),
    OUT p_new_balance DECIMAL(10,2)
)
BEGIN

    DECLARE v_balance DECIMAL(10,2);
    DECLARE v_account_type VARCHAR(20);
    DECLARE v_min_amount DECIMAL(10,2);
    DECLARE v_max_amount DECIMAL(10,2);
    DECLARE v_validity_days INT;
    DECLARE v_plan_active BOOLEAN;
    DECLARE v_plan_exists INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET p_new_balance = NULL;

    START TRANSACTION;

    -- Validate subscriber and lock row

    SELECT balance, account_type
    INTO v_balance, v_account_type
    FROM subscribers
    WHERE subscriber_id = p_subscriber_id
    FOR UPDATE;

    -- Only prepaid subscribers can recharge

    IF v_account_type <> 'Prepaid' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Recharge allowed only for prepaid subscribers';
    END IF;

    -- Validate amount

    IF p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Recharge amount must be greater than zero';
    END IF;

    -- Get plan details

    SELECT COUNT(*)
    INTO v_plan_exists
    FROM recharge_plans
    WHERE plan_name = p_plan_name;

    IF v_plan_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid recharge plan';
    END IF;

    SELECT min_amount, max_amount,
           validity_days, active
    INTO v_min_amount, v_max_amount,
         v_validity_days, v_plan_active
    FROM recharge_plans
    WHERE plan_name = p_plan_name;

    IF v_plan_active = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Recharge plan is inactive';
    END IF;

    IF p_amount < v_min_amount
       OR p_amount > v_max_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Recharge amount does not match plan limits';
    END IF;

    -- Calculate new balance

    SET p_new_balance = v_balance + p_amount;

    -- Update subscriber balance and plan

    UPDATE subscribers
    SET balance = p_new_balance,
        plan_name = p_plan_name,
        validity_end_date =
            DATE_ADD(
                GREATEST(
                    COALESCE(validity_end_date, CURDATE()),
                    CURDATE()
                ),
                INTERVAL v_validity_days DAY
            )
    WHERE subscriber_id = p_subscriber_id;

    -- Insert recharge history

    INSERT INTO recharge_history
    (subscriber_id, plan_name, recharge_amount)
    VALUES
    (p_subscriber_id, p_plan_name, p_amount);

    COMMIT;

END //

DELIMITER ;


-- Execute recharge procedure

CALL usp_Recharge(
    1,
    100,
    'Basic',
    @new_balance
);

SELECT @new_balance AS Updated_Balance;


-- =====================================================
-- TASK 3: SCALAR FUNCTION
-- fn_ValidityDaysLeft
-- =====================================================

DELIMITER //

CREATE FUNCTION fn_ValidityDaysLeft(
    p_subscriber_id INT
)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN

    DECLARE v_days_left INT DEFAULT NULL;

    SELECT GREATEST(
        DATEDIFF(validity_end_date, CURDATE()),
        0
    )
    INTO v_days_left
    FROM subscribers
    WHERE subscriber_id = p_subscriber_id;

    RETURN v_days_left;

END //

DELIMITER ;


-- Test scalar function

SELECT
    subscriber_id,
    subscriber_name,
    fn_ValidityDaysLeft(subscriber_id)
        AS validity_days_left
FROM subscribers;


-- =====================================================
-- TASK 3: TABLE-VALUED FUNCTION ALTERNATIVE
-- MySQL does not support user-defined table-valued
-- functions. Use a stored procedure returning a table.
-- =====================================================

DELIMITER //

CREATE PROCEDURE usp_LastFiveRecharges(
    IN p_subscriber_id INT
)
BEGIN

    SELECT
        recharge_id,
        subscriber_id,
        plan_name,
        recharge_amount,
        recharge_date
    FROM recharge_history
    WHERE subscriber_id = p_subscriber_id
    ORDER BY recharge_date DESC, recharge_id DESC
    LIMIT 5;

END //

DELIMITER ;


-- Get last five recharges of subscriber 1

CALL usp_LastFiveRecharges(1);


-- =====================================================
-- TASK 4: CURSOR-BASED PROCEDURE
-- Insert notification for subscribers below 50
-- =====================================================

DELIMITER //

CREATE PROCEDURE usp_LowBalanceCursor()
BEGIN

    DECLARE done INT DEFAULT 0;
    DECLARE v_subscriber_id INT;
    DECLARE v_balance DECIMAL(10,2);

    DECLARE subscriber_cursor CURSOR FOR
        SELECT subscriber_id, balance
        FROM subscribers
        WHERE account_type = 'Prepaid'
        AND balance < 50;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    OPEN subscriber_cursor;

    read_loop: LOOP

        FETCH subscriber_cursor
        INTO v_subscriber_id, v_balance;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO notification_log
        (subscriber_id, message)
        VALUES
        (
            v_subscriber_id,
            CONCAT(
                'Low balance alert! Current balance: ',
                v_balance,
                '. Please recharge.'
            )
        );

    END LOOP;

    CLOSE subscriber_cursor;

    COMMIT;

END //

DELIMITER ;


-- Execute cursor procedure

CALL usp_LowBalanceCursor();

SELECT * FROM notification_log;


-- =====================================================
-- SET-BASED ALTERNATIVE
-- Same operation without a cursor
-- =====================================================

INSERT INTO notification_log
(subscriber_id, message)
SELECT
    subscriber_id,
    CONCAT(
        'Low balance alert! Current balance: ',
        balance,
        '. Please recharge.'
    )
FROM subscribers
WHERE account_type = 'Prepaid'
AND balance < 50;


-- Display notification records

SELECT * FROM notification_log;


-- =====================================================
-- TIMING COMPARISON
-- CURSOR VS SET-BASED
-- =====================================================

-- Measure cursor execution time

DELETE FROM notification_log;

SET @cursor_start = NOW(6);

CALL usp_LowBalanceCursor();

SET @cursor_end = NOW(6);

SET @cursor_time =
    TIMESTAMPDIFF(
        MICROSECOND,
        @cursor_start,
        @cursor_end
    ) / 1000;


-- Remove cursor results before testing set-based query

DELETE FROM notification_log;


-- Measure set-based execution time

SET @set_start = NOW(6);

INSERT INTO notification_log
(subscriber_id, message)
SELECT
    subscriber_id,
    CONCAT(
        'Low balance alert! Current balance: ',
        balance,
        '. Please recharge.'
    )
FROM subscribers
WHERE account_type = 'Prepaid'
AND balance < 50;

SET @set_end = NOW(6);

SET @set_time =
    TIMESTAMPDIFF(
        MICROSECOND,
        @set_start,
        @set_end
    ) / 1000;


-- Display timing comparison

SELECT
    @cursor_time AS Cursor_Time_Milliseconds,
    @set_time AS Set_Based_Time_Milliseconds;


-- =====================================================
-- FINAL VERIFICATION
-- =====================================================

SELECT * FROM subscribers;

SELECT * FROM recharge_plans;

SELECT * FROM recharge_history;

SELECT * FROM notification_log;

SELECT * FROM vw_prepaid_subscribers;

SELECT * FROM vw_recharge_summary;
