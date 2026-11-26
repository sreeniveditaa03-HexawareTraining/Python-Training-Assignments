
-- Day 10 - Set 2
-- Testing and Evidence

USE BankAuditDB;
GO

-- TEST 1: Insert transactions

INSERT INTO account_transaction
(transaction_id, account_id, transaction_type, amount)
VALUES
(101, 1, 'Deposit', 2000),
(102, 2, 'Withdrawal', 1000);
GO

SELECT * FROM transaction_audit;
GO

-- TEST 2: Update transaction

UPDATE account_transaction
SET amount = 2500
WHERE transaction_id = 101;
GO

SELECT * FROM transaction_audit;
GO

-- TEST 3: Delete transaction

DELETE FROM account_transaction
WHERE transaction_id = 102;
GO

SELECT * FROM transaction_audit;
GO

-- TEST 4: Valid account update

UPDATE savings_accounts
SET balance = 12000
WHERE account_id = 1;
GO

SELECT * FROM accounts;
GO

-- TEST 5: Batch update five accounts
-- One account will have a negative balance.
-- The entire statement should fail.

BEGIN TRY

    UPDATE savings_accounts
    SET balance =
        CASE account_id
            WHEN 1 THEN 13000
            WHEN 2 THEN 16000
            WHEN 3 THEN -500
            WHEN 4 THEN 14000
            WHEN 5 THEN 22000
        END
    WHERE account_id IN (1, 2, 3, 4, 5);

END TRY
BEGIN CATCH

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

END CATCH;
GO

-- Verify all five account balances
SELECT * FROM accounts
ORDER BY account_id;
GO

-- TEST 6: Nested and recursive trigger settings

SELECT
    name,
    value,
    value_in_use
FROM sys.configurations
WHERE name = 'nested triggers';
GO

SELECT
    name,
    is_recursive_triggers_on
FROM sys.databases
WHERE name = 'BankAuditDB';
GO

-- Disable recursive triggers for this database
ALTER DATABASE BankAuditDB
SET RECURSIVE_TRIGGERS OFF;
GO

-- Final audit history
SELECT * FROM transaction_audit
ORDER BY audit_id;
GO
