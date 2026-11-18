
IF DB_ID('Day7_RetailReturnsDB') IS NULL CREATE DATABASE Day7_RetailReturnsDB;
GO
USE Day7_RetailReturnsDB;
GO
DROP TABLE IF EXISTS dbo.ReturnFeedback;
DROP TABLE IF EXISTS dbo.Refunds;
DROP TABLE IF EXISTS dbo.Returns;
DROP TABLE IF EXISTS dbo.Sales;
DROP TABLE IF EXISTS dbo.Employees;
DROP TABLE IF EXISTS dbo.Stores;
DROP TABLE IF EXISTS dbo.Customers;
DROP TABLE IF EXISTS dbo.Products;
GO
CREATE TABLE dbo.Products(ProductID INT PRIMARY KEY,ProductName VARCHAR(100));
CREATE TABLE dbo.Customers(CustomerID INT PRIMARY KEY,CustomerName VARCHAR(100));
CREATE TABLE dbo.Stores(StoreID INT PRIMARY KEY,StoreName VARCHAR(80),Region VARCHAR(40));
CREATE TABLE dbo.Employees(EmployeeID INT PRIMARY KEY,EmployeeName VARCHAR(100),
 ManagerID INT NULL REFERENCES dbo.Employees(EmployeeID),StoreID INT REFERENCES dbo.Stores(StoreID));
CREATE TABLE dbo.Sales(SaleID INT PRIMARY KEY,ProductID INT REFERENCES dbo.Products(ProductID),
 CustomerID INT REFERENCES dbo.Customers(CustomerID),StoreID INT REFERENCES dbo.Stores(StoreID),
 SaleDate DATE NOT NULL,Quantity INT NOT NULL CHECK(Quantity>0));
CREATE TABLE dbo.Returns(ReturnID INT PRIMARY KEY,SaleID INT REFERENCES dbo.Sales(SaleID),
 ReturnDate DATE NOT NULL,Reason VARCHAR(150));
CREATE TABLE dbo.Refunds(RefundID INT PRIMARY KEY,ReturnID INT REFERENCES dbo.Returns(ReturnID),
 RefundDate DATE NOT NULL,RefundAmount DECIMAL(10,2) NOT NULL CHECK(RefundAmount>=0));
CREATE TABLE dbo.ReturnFeedback(FeedbackID INT PRIMARY KEY,ReturnID INT REFERENCES dbo.Returns(ReturnID),
 CustomerComment VARCHAR(250),Sentiment VARCHAR(20));
INSERT dbo.Products VALUES(1,'Laptop'),(2,'Headphones'),(3,'Shoes'),(4,'Backpack'),(5,'Watch');
INSERT dbo.Customers VALUES(1,'Aarav'),(2,'Priya'),(3,'Rahul'),(4,'Meena'),(5,'Kavin');
INSERT dbo.Stores VALUES(1,'Chennai Store','South'),(2,'Bengaluru Store','South'),
(3,'Mumbai Store','West'),(4,'Delhi Store','North');
INSERT dbo.Employees VALUES(1,'Manager Meera',NULL,1),(2,'Arun',1,1),(3,'Divya',1,2),
(4,'Rohit',NULL,3),(5,'Nisha',4,3);
INSERT dbo.Sales VALUES
(301,1,1,1,'2026-09-01',10),(302,2,2,1,'2026-09-02',20),
(303,3,3,2,'2026-09-03',15),(304,4,4,2,'2026-09-04',10),
(305,5,5,3,'2026-09-05',12),(306,1,2,3,'2026-09-06',8),
(307,2,3,4,'2026-09-07',25),(308,3,1,4,'2026-09-08',10),
(309,4,5,1,'2026-09-09',18),(310,5,4,2,'2026-09-10',14);
INSERT dbo.Returns VALUES
(401,301,'2026-09-10','Defective'),(402,302,'2026-09-11','Not as described'),
(403,303,'2026-09-12','Wrong size'),(404,305,'2026-09-14','Damaged'),
(405,307,'2026-09-15','Changed mind'),(406,309,'2026-09-16','Defective');
INSERT dbo.Refunds VALUES
(501,401,'2026-09-12',12000),(502,402,'2026-09-13',3000),
(503,404,'2026-09-16',4500),(504,406,'2026-09-18',2500);
INSERT dbo.ReturnFeedback VALUES
(601,401,'Device did not turn on','Negative'),(602,402,'Product differed from image','Negative'),
(603,403,'Size was too small','Neutral'),(604,404,'Package arrived damaged','Negative');
GO

-- TASK 1: TEN BUSINESS QUESTIONS
-- Q1 Products with return rate above 10 percent
SELECT p.ProductID,p.ProductName,
 CAST(COUNT(DISTINCT r.ReturnID)*100.0/NULLIF(SUM(DISTINCT s.Quantity),0) AS DECIMAL(6,2)) AS ReturnRatePercent
FROM dbo.Products p JOIN dbo.Sales s ON s.ProductID=p.ProductID
LEFT JOIN dbo.Returns r ON r.SaleID=s.SaleID
GROUP BY p.ProductID,p.ProductName
HAVING COUNT(DISTINCT r.ReturnID)*100.0/NULLIF(SUM(DISTINCT s.Quantity),0)>10;

-- Q2 Customers with returns but no refund
SELECT DISTINCT c.CustomerID,c.CustomerName
FROM dbo.Customers c JOIN dbo.Sales s ON s.CustomerID=c.CustomerID
JOIN dbo.Returns r ON r.SaleID=s.SaleID
LEFT JOIN dbo.Refunds f ON f.ReturnID=r.ReturnID
WHERE f.RefundID IS NULL;

-- Q3 Stores with highest total refund value
SELECT TOP (1) WITH TIES st.StoreName,SUM(f.RefundAmount) TotalRefund
FROM dbo.Stores st JOIN dbo.Sales s ON s.StoreID=st.StoreID
JOIN dbo.Returns r ON r.SaleID=s.SaleID JOIN dbo.Refunds f ON f.ReturnID=r.ReturnID
GROUP BY st.StoreID,st.StoreName ORDER BY SUM(f.RefundAmount) DESC;

-- Q4 Employees and their managers (self join)
SELECT e.EmployeeName Employee,m.EmployeeName Manager
FROM dbo.Employees e LEFT JOIN dbo.Employees m ON m.EmployeeID=e.ManagerID;

-- Q5 Returns with customer, product and store details
SELECT r.ReturnID,c.CustomerName,p.ProductName,st.StoreName,r.Reason
FROM dbo.Returns r JOIN dbo.Sales s ON s.SaleID=r.SaleID
JOIN dbo.Customers c ON c.CustomerID=s.CustomerID
JOIN dbo.Products p ON p.ProductID=s.ProductID
JOIN dbo.Stores st ON st.StoreID=s.StoreID;

-- Q6 All products and their return counts, including zero returns
SELECT p.ProductName,COUNT(r.ReturnID) ReturnCount
FROM dbo.Products p LEFT JOIN dbo.Sales s ON s.ProductID=p.ProductID
LEFT JOIN dbo.Returns r ON r.SaleID=s.SaleID
GROUP BY p.ProductID,p.ProductName;

-- Q7 Refund totals by region
SELECT st.Region,SUM(f.RefundAmount) TotalRefund
FROM dbo.Stores st JOIN dbo.Sales s ON s.StoreID=st.StoreID
JOIN dbo.Returns r ON r.SaleID=s.SaleID JOIN dbo.Refunds f ON f.ReturnID=r.ReturnID
GROUP BY st.Region;

-- Q8 Return feedback with return details
SELECT r.ReturnID,r.Reason,fb.CustomerComment,fb.Sentiment
FROM dbo.Returns r LEFT JOIN dbo.ReturnFeedback fb ON fb.ReturnID=r.ReturnID;

-- Q9 Customers with more than one return
SELECT c.CustomerName,COUNT(r.ReturnID) ReturnCount
FROM dbo.Customers c JOIN dbo.Sales s ON s.CustomerID=c.CustomerID
JOIN dbo.Returns r ON r.SaleID=s.SaleID
GROUP BY c.CustomerID,c.CustomerName HAVING COUNT(r.ReturnID)>1;

-- Q10 Stores and sales/return totals, retaining stores with no sales
SELECT st.StoreName,COUNT(DISTINCT s.SaleID) SalesCount,COUNT(DISTINCT r.ReturnID) ReturnCount
FROM dbo.Stores st LEFT JOIN dbo.Sales s ON s.StoreID=st.StoreID
LEFT JOIN dbo.Returns r ON r.SaleID=s.SaleID
GROUP BY st.StoreID,st.StoreName;

-- TASK 2: IN / NOT IN NULL PITFALL / NOT EXISTS
-- IN: customers who have at least one return
SELECT CustomerID,CustomerName FROM dbo.Customers
WHERE CustomerID IN (
 SELECT s.CustomerID FROM dbo.Sales s JOIN dbo.Returns r ON r.SaleID=s.SaleID
);

-- Demonstrate NOT IN NULL pitfall: NULL in subquery makes result unknown
SELECT CustomerID,CustomerName FROM dbo.Customers
WHERE CustomerID NOT IN (
 SELECT CASE WHEN r.ReturnID=401 THEN NULL ELSE s.CustomerID END
 FROM dbo.Sales s JOIN dbo.Returns r ON r.SaleID=s.SaleID
);

-- Correct approach: NOT EXISTS is safe with NULL values
SELECT c.CustomerID,c.CustomerName FROM dbo.Customers c
WHERE NOT EXISTS (
 SELECT 1 FROM dbo.Sales s JOIN dbo.Returns r ON r.SaleID=s.SaleID
 WHERE s.CustomerID=c.CustomerID
);

-- TASK 3: ANY AND ALL - compare each store's refund total with other stores in same region
WITH StoreRefund AS (
 SELECT st.StoreID,st.StoreName,st.Region,COALESCE(SUM(f.RefundAmount),0) RefundTotal
 FROM dbo.Stores st LEFT JOIN dbo.Sales s ON s.StoreID=st.StoreID
 LEFT JOIN dbo.Returns r ON r.SaleID=s.SaleID
 LEFT JOIN dbo.Refunds f ON f.ReturnID=r.ReturnID
 GROUP BY st.StoreID,st.StoreName,st.Region
)
-- ANY: store refund total is greater than at least one other store in its region
SELECT a.StoreName,a.Region,a.RefundTotal
FROM StoreRefund a
WHERE a.RefundTotal > ANY (
 SELECT b.RefundTotal FROM StoreRefund b
 WHERE b.Region=a.Region AND b.StoreID<>a.StoreID
);

-- ALL: store refund total is greater than every other store in its region
WITH StoreRefund AS (
 SELECT st.StoreID,st.StoreName,st.Region,COALESCE(SUM(f.RefundAmount),0) RefundTotal
 FROM dbo.Stores st LEFT JOIN dbo.Sales s ON s.StoreID=st.StoreID
 LEFT JOIN dbo.Returns r ON r.SaleID=s.SaleID
 LEFT JOIN dbo.Refunds f ON f.ReturnID=r.ReturnID
 GROUP BY st.StoreID,st.StoreName,st.Region
)
SELECT a.StoreName,a.Region,a.RefundTotal
FROM StoreRefund a
WHERE a.RefundTotal > ALL (
 SELECT b.RefundTotal FROM StoreRefund b
 WHERE b.Region=a.Region AND b.StoreID<>a.StoreID
);

-- TASK 4: TWO NESTED SUBQUERIES
-- Nested query 1: products whose return count exceeds the average return count per product
SELECT p.ProductName
FROM dbo.Products p
WHERE (SELECT COUNT(*) FROM dbo.Sales s JOIN dbo.Returns r ON r.SaleID=s.SaleID
       WHERE s.ProductID=p.ProductID)
      >
      (SELECT AVG(CAST(x.ReturnCount AS DECIMAL(10,2)))
       FROM (SELECT COUNT(r.ReturnID) ReturnCount
             FROM dbo.Products p2 LEFT JOIN dbo.Sales s2 ON s2.ProductID=p2.ProductID
             LEFT JOIN dbo.Returns r ON r.SaleID=s2.SaleID
             GROUP BY p2.ProductID) x);

-- Nested query 2: stores whose refund total is above the average store refund total
SELECT st.StoreName
FROM dbo.Stores st
WHERE (SELECT COALESCE(SUM(f.RefundAmount),0)
       FROM dbo.Sales s JOIN dbo.Returns r ON r.SaleID=s.SaleID
       JOIN dbo.Refunds f ON f.ReturnID=r.ReturnID
       WHERE s.StoreID=st.StoreID)
      >
      (SELECT AVG(CAST(y.TotalRefund AS DECIMAL(10,2)))
       FROM (SELECT st2.StoreID,COALESCE(SUM(f2.RefundAmount),0) TotalRefund
             FROM dbo.Stores st2 LEFT JOIN dbo.Sales s2 ON s2.StoreID=st2.StoreID
             LEFT JOIN dbo.Returns r2 ON r2.SaleID=s2.SaleID
             LEFT JOIN dbo.Refunds f2 ON f2.ReturnID=r2.ReturnID
             GROUP BY st2.StoreID) y);
GO
