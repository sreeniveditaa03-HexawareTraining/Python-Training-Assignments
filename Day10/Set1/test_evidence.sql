
-- Day 10 - Set 1
-- Trigger Testing and Evidence

USE RetailAuditDB;
GO

-- TEST 1: Single-row valid price update

PRINT 'TEST 1: Single Row Update';

UPDATE product_price
SET selling_price = 52000
WHERE product_id = 1;

SELECT * FROM product_price
WHERE product_id = 1;

SELECT * FROM price_audit
WHERE product_id = 1;
GO

-- TEST 2: Multi-row valid price updates

PRINT 'TEST 2: Multi Row Valid Updates';

UPDATE product_price
SET selling_price =
    CASE product_id
        WHEN 2 THEN 17000
        WHEN 4 THEN 400
        WHEN 5 THEN 9500
    END
WHERE product_id IN (2, 4, 5);

SELECT * FROM product_price;

SELECT * FROM price_audit
ORDER BY audit_id;
GO

-- TEST 3: Attempt to set price below cost

PRINT 'TEST 3: Rejected Price Update';

UPDATE product_price
SET selling_price = 300
WHERE product_id = 3;

SELECT * FROM product_price
WHERE product_id = 3;

SELECT * FROM rejected_price_attempt
ORDER BY rejection_id;
GO

-- TEST 4: Multi-row update with one invalid price

PRINT 'TEST 4: Mixed Multi Row Update';

UPDATE product_price
SET selling_price =
    CASE product_id
        WHEN 1 THEN 55000
        WHEN 2 THEN 18000
        WHEN 3 THEN 400
        WHEN 4 THEN 450
        WHEN 5 THEN 11000
    END
WHERE product_id IN (1, 2, 3, 4, 5);

-- Check final product prices
SELECT * FROM product_price
ORDER BY product_id;

-- Check successful price changes
SELECT * FROM price_audit
ORDER BY audit_id;

-- Check rejected attempts
SELECT * FROM rejected_price_attempt
ORDER BY rejection_id;
GO

-- TEST 5: Verify audit history

PRINT 'TEST 5: Final Audit History';

SELECT
    product_id,
    old_price,
    new_price,
    changed_by,
    changed_at
FROM price_audit
ORDER BY audit_id;
GO
