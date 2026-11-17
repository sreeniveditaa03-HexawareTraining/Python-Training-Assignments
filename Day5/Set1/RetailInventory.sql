--TASK 2 --

CREATE DATABASE RetailInventoryDB;
USE RetailInventoryDB;


USE RetailInventoryDB;
GO

-- 1. Supplier Table
CREATE TABLE Supplier (
    Supplier_ID INT PRIMARY KEY,
    Supplier_Name VARCHAR(100) NOT NULL,
    Supplier_Phone VARCHAR(15) NOT NULL
);


-- 2. Category Table
CREATE TABLE Category (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL UNIQUE
);


-- 3. Product Table
CREATE TABLE Product (
    SKU VARCHAR(20) PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Category_ID INT NOT NULL,
    Supplier_ID INT NOT NULL,
    Reorder_Level INT NOT NULL DEFAULT 10,

    CONSTRAINT CHK_ReorderLevel
        CHECK (Reorder_Level >= 0),

    CONSTRAINT FK_Product_Category
        FOREIGN KEY (Category_ID)
        REFERENCES Category(Category_ID),

    CONSTRAINT FK_Product_Supplier
        FOREIGN KEY (Supplier_ID)
        REFERENCES Supplier(Supplier_ID)
);


-- 4. Warehouse Table
CREATE TABLE Warehouse (
    Warehouse_ID INT PRIMARY KEY,
    Warehouse_Name VARCHAR(100) NOT NULL UNIQUE
);


-- 5. Inventory Table
CREATE TABLE Inventory (
    SKU VARCHAR(20) NOT NULL,
    Warehouse_ID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 0,

    CONSTRAINT PK_Inventory
        PRIMARY KEY (SKU, Warehouse_ID),

    CONSTRAINT CHK_Quantity
        CHECK (Quantity >= 0),

    CONSTRAINT FK_Inventory_Product
        FOREIGN KEY (SKU)
        REFERENCES Product(SKU)
        ON DELETE CASCADE,

    CONSTRAINT FK_Inventory_Warehouse
        FOREIGN KEY (Warehouse_ID)
        REFERENCES Warehouse(Warehouse_ID)
);

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;


-- TASK 3 --
INSERT INTO Supplier
(Supplier_ID, Supplier_Name, Supplier_Phone)
VALUES
(1, 'ABC Traders', '9876543210'),
(2, 'Global Supplies', '9876501234'),
(3, 'Prime Distributors', '9876512345'),
(4, 'Tech World', '9876523456'),
(5, 'Fresh Mart Suppliers', '9876534567'),
(6, 'Fashion Hub', '9876545678'),
(7, 'Smart Electronics', '9876556789'),
(8, 'Daily Needs Co', '9876567890'),
(9, 'Mega Wholesale', '9876578901'),
(10, 'Universal Traders', '9876589012');

INSERT INTO Category (Category_ID, Category_Name)
VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Grocery'),
(4, 'Furniture'),
(5, 'Accessories'),
(6, 'Footwear'),
(7, 'Stationery'),
(8, 'Home Appliances'),
(9, 'Sports'),
(10, 'Beauty Products');

INSERT INTO Product
(SKU, Product_Name, Category_ID, Supplier_ID, Reorder_Level)
VALUES
('P101', 'Laptop', 1, 1, 5),
('P102', 'T-Shirt', 2, 2, 10),
('P103', 'Rice Bag', 3, 3, 20),
('P104', 'Office Chair', 4, 4, 5),
('P105', 'Smart Watch', 5, 5, 8),
('P106', 'Sports Shoes', 6, 6, 10),
('P107', 'Notebook', 7, 7, 15),
('P108', 'Mixer Grinder', 8, 8, 5),
('P109', 'Football', 9, 9, 10),
('P110', 'Face Cream', 10, 10, 12);

INSERT INTO Warehouse
(Warehouse_ID, Warehouse_Name)
VALUES
(1, 'Chennai Warehouse'),
(2, 'Bangalore Warehouse'),
(3, 'Mumbai Warehouse'),
(4, 'Hyderabad Warehouse'),
(5, 'Delhi Warehouse'),
(6, 'Pune Warehouse'),
(7, 'Kochi Warehouse'),
(8, 'Coimbatore Warehouse'),
(9, 'Kolkata Warehouse'),
(10, 'Jaipur Warehouse');

INSERT INTO Inventory
(SKU, Warehouse_ID, Quantity)
VALUES
('P101', 1, 25),
('P102', 2, 50),
('P103', 3, 100),
('P104', 4, 30),
('P105', 5, 40),
('P106', 6, 60),
('P107', 7, 80),
('P108', 8, 35),
('P109', 9, 45),
('P110', 10, 55);


BEGIN TRY
    INSERT INTO Supplier
    (Supplier_ID, Supplier_Name, Supplier_Phone)
    VALUES
    (1, 'Duplicate Supplier', '9999999999');
END TRY
BEGIN CATCH
    SELECT 'Duplicate Key Error' AS Test,
           ERROR_MESSAGE() AS Error_Message;
END CATCH;


BEGIN TRY
    INSERT INTO Product
    (SKU, Product_Name, Category_ID, Supplier_ID, Reorder_Level)
    VALUES
    ('P999', 'Invalid Product', 1, 999, 5);
END TRY
BEGIN CATCH
    SELECT 'Missing Parent Error' AS Test,
           ERROR_MESSAGE() AS Error_Message;
END CATCH;


BEGIN TRY
    INSERT INTO Inventory
    (SKU, Warehouse_ID, Quantity)
    VALUES
    ('P101', 2, -50);
END TRY
BEGIN CATCH
    SELECT 'Negative Quantity Error' AS Test,
           ERROR_MESSAGE() AS Error_Message;
END CATCH;


BEGIN TRY
    INSERT INTO Supplier
    (Supplier_ID, Supplier_Name, Supplier_Phone)
    VALUES
    (11, NULL, '9999999999');
END TRY
BEGIN CATCH
    SELECT 'NULL Mandatory Column Error' AS Test,
           ERROR_MESSAGE() AS Error_Message;
END CATCH;


-- TASK 4 --

UPDATE Supplier
SET Supplier_Phone = '9123456780'
WHERE Supplier_ID = 3;


DELETE FROM Product
WHERE SKU IN ('P109', 'P110');


SELECT * FROM Product;









