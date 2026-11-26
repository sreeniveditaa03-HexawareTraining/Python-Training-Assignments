
-- Day 10 - Set 2
-- Bank Account Balance Guard

IF DB_ID('BankAuditDB') IS NULL
    CREATE DATABASE BankAuditDB;
GO

USE BankAuditDB;
GO

-- 1. Account Table
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    account_type VARCHAR(20),
    balance DECIMAL(12,2)
);
GO

-- 2. Transaction Table
CREATE TABLE account_transaction (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_type VARCHAR(20),
    amount DECIMAL(12,2),
    transaction_date DATETIME2 DEFAULT SYSDATETIME()
);
GO

-- 3. Audit Table
CREATE TABLE transaction_audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    transaction_id INT,
    account_id INT,
    action_type VARCHAR(20),
    old_amount DECIMAL(12,2),
    new_amount DECIMAL(12,2),
    changed_by VARCHAR(128),
    changed_at DATETIME2 DEFAULT SYSDATETIME()
);
GO

-- 4. Sample Accounts
INSERT INTO accounts VALUES
(1, 'Arun', 'Savings', 10000),
(2, 'Bala', 'Savings', 15000),
(3, 'Divya', 'Savings', 8000),
(4, 'Kumar', 'Savings', 12000),
(5, 'Priya', 'Savings', 20000);
GO

-- 5. AFTER INSERT, UPDATE, DELETE Trigger
CREATE TRIGGER trg_TransactionAudit
ON account_transaction
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT audit
    INSERT INTO transaction_audit
    (transaction_id, account_id, action_type,
     old_amount, new_amount, changed_by)
    SELECT
        i.transaction_id,
        i.account_id,
        'INSERT',
        NULL,
        i.amount,
        SUSER_SNAME()
    FROM inserted i
    LEFT JOIN deleted d
        ON i.transaction_id = d.transaction_id
    WHERE d.transaction_id IS NULL;

    -- UPDATE audit
    INSERT INTO transaction_audit
    (transaction_id, account_id, action_type,
     old_amount, new_amount, changed_by)
    SELECT
        i.transaction_id,
        i.account_id,
        'UPDATE',
        d.amount,
        i.amount,
        SUSER_SNAME()
    FROM inserted i
    INNER JOIN deleted d
        ON i.transaction_id = d.transaction_id;

    -- DELETE audit
    INSERT INTO transaction_audit
    (transaction_id, account_id, action_type,
     old_amount, new_amount, changed_by)
    SELECT
        d.transaction_id,
        d.account_id,
        'DELETE',
        d.amount,
        NULL,
        SUSER_SNAME()
    FROM deleted d
    LEFT JOIN inserted i
        ON d.transaction_id = i.transaction_id
    WHERE i.transaction_id IS NULL;
END;
GO

-- 6. Create Account View
CREATE VIEW savings_accounts
AS
SELECT account_id, customer_name, account_type, balance
FROM accounts
WHERE account_type = 'Savings';
GO

-- 7. INSTEAD OF UPDATE Trigger
CREATE TRIGGER trg_PreventNegativeBalance
ON savings_accounts
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE balance < 0
    )
    BEGIN
        THROW 50001,
        'Savings account balance cannot be negative.',
        1;
    END;

    UPDATE a
    SET
        a.customer_name = i.customer_name,
        a.account_type = i.account_type,
        a.balance = i.balance
    FROM accounts a
    INNER JOIN inserted i
        ON a.account_id = i.account_id;
END;
GO

SELECT * FROM accounts;
GO
