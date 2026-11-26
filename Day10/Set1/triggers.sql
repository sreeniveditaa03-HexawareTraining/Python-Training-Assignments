
-- Day 10 - Set 1
-- Retail Price Change Audit

-- Create Database
IF DB_ID('RetailAuditDB') IS NULL
    CREATE DATABASE RetailAuditDB;
GO

USE RetailAuditDB;
GO

-- 1. Create Product Price Table
CREATE TABLE product_price (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL
);
GO

-- 2. Create Price Audit Table
CREATE TABLE price_audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    changed_by VARCHAR(128),
    changed_at DATETIME2 DEFAULT SYSDATETIME()
);
GO

-- 3. Create Rejected Price Attempts Table
CREATE TABLE rejected_price_attempt (
    rejection_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    attempted_price DECIMAL(10,2),
    cost_price DECIMAL(10,2),
    attempted_by VARCHAR(128),
    attempted_at DATETIME2 DEFAULT SYSDATETIME(),
    reason VARCHAR(255)
);
GO

-- 4. Insert Sample Products
INSERT INTO product_price
(product_id, product_name, cost_price, selling_price)
VALUES
(1, 'Laptop', 40000, 50000),
(2, 'Mobile', 12000, 16000),
(3, 'Keyboard', 500, 800),
(4, 'Mouse', 200, 350),
(5, 'Monitor', 8000, 10000);
GO

-- 5. AFTER UPDATE Trigger
-- Records successful price changes.

CREATE TRIGGER trg_PriceAudit
ON product_price
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO price_audit
    (
        product_id,
        old_price,
        new_price,
        changed_by,
        changed_at
    )
    SELECT
        d.product_id,
        d.selling_price,
        i.selling_price,
        SUSER_SNAME(),
        SYSDATETIME()
    FROM deleted d
    INNER JOIN inserted i
        ON d.product_id = i.product_id
    WHERE d.selling_price <> i.selling_price;
END;
GO

-- 6. INSTEAD OF UPDATE Trigger
-- Rejects prices below cost and logs rejected attempts.

CREATE TRIGGER trg_ValidatePrice
ON product_price
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Log invalid price attempts
    INSERT INTO rejected_price_attempt
    (
        product_id,
        attempted_price,
        cost_price,
        attempted_by,
        attempted_at,
        reason
    )
    SELECT
        i.product_id,
        i.selling_price,
        i.cost_price,
        SUSER_SNAME(),
        SYSDATETIME(),
        'Selling price cannot be below cost price'
    FROM inserted i
    INNER JOIN deleted d
        ON i.product_id = d.product_id
    WHERE i.selling_price < i.cost_price;

    -- Apply only valid updates
    UPDATE p
    SET
        p.product_name = i.product_name,
        p.cost_price = i.cost_price,
        p.selling_price = i.selling_price
    FROM product_price p
    INNER JOIN inserted i
        ON p.product_id = i.product_id
    WHERE i.selling_price >= i.cost_price;
END;
GO

-- Check initial products
SELECT * FROM product_price;
GO
