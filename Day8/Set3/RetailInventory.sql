
/* ======================= SET 3: RETAIL INVENTORY RESERVATION ======================= */
IF OBJECT_ID('dbo.OrderLines','U') IS NOT NULL DROP TABLE dbo.OrderLines;
IF OBJECT_ID('dbo.RetailOrders','U') IS NOT NULL DROP TABLE dbo.RetailOrders;
IF OBJECT_ID('dbo.RetailProducts','U') IS NOT NULL DROP TABLE dbo.RetailProducts;
GO
CREATE TABLE dbo.RetailProducts(ProductID INT PRIMARY KEY,ProductName NVARCHAR(100),CategoryID INT,StockQty INT CHECK(StockQty>=0),UnitPrice DECIMAL(10,2));
CREATE TABLE dbo.RetailOrders(OrderID INT IDENTITY PRIMARY KEY,CustomerName NVARCHAR(100),OrderDate DATETIME2 DEFAULT SYSUTCDATETIME(),OrderStatus VARCHAR(20));
CREATE TABLE dbo.OrderLines(OrderLineID INT IDENTITY PRIMARY KEY,OrderID INT REFERENCES dbo.RetailOrders(OrderID),ProductID INT REFERENCES dbo.RetailProducts(ProductID),Quantity INT CHECK(Quantity>0),UnitPrice DECIMAL(10,2));
INSERT dbo.RetailProducts VALUES(1,'Laptop',10,5,65000),(2,'Mouse',10,50,800),(3,'Keyboard',10,30,1500),(4,'Phone',20,8,40000),(5,'Tablet',20,4,25000),(6,'Headphones',10,20,2500),(7,'Monitor',10,3,12000),(8,'Camera',20,6,35000);
GO
-- Task 1: stock decrements + order header + lines in one transaction; any failure aborts.
DECLARE @Customer NVARCHAR(100)='Demo Customer',@OrderID INT,@P1 INT=1,@Q1 INT=2,@P2 INT=2,@Q2 INT=3;
BEGIN TRY
 BEGIN TRAN;
 UPDATE dbo.RetailProducts SET StockQty=StockQty-@Q1 WHERE ProductID=@P1 AND StockQty>=@Q1;
 IF @@ROWCOUNT=0 THROW 50301,'Insufficient stock for product 1.',1;
 UPDATE dbo.RetailProducts SET StockQty=StockQty-@Q2 WHERE ProductID=@P2 AND StockQty>=@Q2;
 IF @@ROWCOUNT=0 THROW 50302,'Insufficient stock for product 2.',1;
 INSERT dbo.RetailOrders(CustomerName,OrderStatus) VALUES(@Customer,'PLACED'); SET @OrderID=SCOPE_IDENTITY();
 INSERT dbo.OrderLines(OrderID,ProductID,Quantity,UnitPrice) SELECT @OrderID,V.ProductID,V.Quantity,P.UnitPrice FROM (VALUES(@P1,@Q1),(@P2,@Q2)) V(ProductID,Quantity) JOIN dbo.RetailProducts P ON P.ProductID=V.ProductID;
 COMMIT; PRINT 'Order placed and inventory reserved.';
END TRY BEGIN CATCH
 IF XACT_STATE()<>0 ROLLBACK; PRINT CONCAT('Order rollback: ',ERROR_MESSAGE());
END CATCH;
GO
-- Insufficient-stock rollback proof: attempt to reserve 999 laptops.
SELECT ProductID,StockQty AS BeforeAttempt FROM dbo.RetailProducts WHERE ProductID=1;
BEGIN TRY
 BEGIN TRAN;
 UPDATE dbo.RetailProducts SET StockQty=StockQty-999 WHERE ProductID=1 AND StockQty>=999;
 IF @@ROWCOUNT=0 THROW 50310,'Deliberate insufficient-stock failure.',1;
 COMMIT;
END TRY BEGIN CATCH
 IF XACT_STATE()<>0 ROLLBACK; PRINT CONCAT('Expected rollback: ',ERROR_MESSAGE());
END CATCH;
SELECT ProductID,StockQty AS AfterRollback FROM dbo.RetailProducts WHERE ProductID=1;
GO
-- Task 2: correlated subquery - below category average stock.
SELECT P.ProductID,P.ProductName,P.CategoryID,P.StockQty FROM dbo.RetailProducts P WHERE P.StockQty<(SELECT AVG(1.0*P2.StockQty) FROM dbo.RetailProducts P2 WHERE P2.CategoryID=P.CategoryID) ORDER BY P.CategoryID,P.StockQty;
GO
-- Task 3: CTE ranking products by sales in category (top three). Sales derived from order lines.
;WITH Sales AS(SELECT P.ProductID,P.ProductName,P.CategoryID,COALESCE(SUM(L.Quantity),0) UnitsSold,COALESCE(SUM(L.Quantity*L.UnitPrice),0) Revenue FROM dbo.RetailProducts P LEFT JOIN dbo.OrderLines L ON L.ProductID=P.ProductID GROUP BY P.ProductID,P.ProductName,P.CategoryID), Ranked AS(SELECT *,ROW_NUMBER() OVER(PARTITION BY CategoryID ORDER BY UnitsSold DESC,Revenue DESC,ProductID) AS CategoryRow FROM Sales)
SELECT ProductID,ProductName,CategoryID,UnitsSold,Revenue,CategoryRow FROM Ranked WHERE CategoryRow<=3 ORDER BY CategoryID,CategoryRow;
GO
-- Task 4: month-over-month LEAD/LAG (sample order dates currently default to today).
;WITH Monthly AS(SELECT L.ProductID,P.ProductName,DATEFROMPARTS(YEAR(O.OrderDate),MONTH(O.OrderDate),1) SalesMonth,SUM(L.Quantity) UnitsSold,SUM(L.Quantity*L.UnitPrice) Revenue FROM dbo.OrderLines L JOIN dbo.RetailOrders O ON O.OrderID=L.OrderID JOIN dbo.RetailProducts P ON P.ProductID=L.ProductID GROUP BY L.ProductID,P.ProductName,DATEFROMPARTS(YEAR(O.OrderDate),MONTH(O.OrderDate),1)), Compare AS(SELECT *,LAG(Revenue) OVER(PARTITION BY ProductID ORDER BY SalesMonth) PreviousRevenue,LEAD(Revenue) OVER(PARTITION BY ProductID ORDER BY SalesMonth) NextRevenue FROM Monthly)
SELECT ProductID,ProductName,SalesMonth,UnitsSold,Revenue,PreviousRevenue,NextRevenue,Revenue-PreviousRevenue AS MoMChange FROM Compare ORDER BY ProductID,SalesMonth;
GO
/* Task 5 MongoDB: conditional single-document $inc stock updates are atomic. If stock/product and order header/order lines are separate documents, use a multi-document transaction for all-or-nothing order placement. Transactions cost extra coordination/commit time and need replica set or sharded-cluster deployment. JS file demonstrates both. */
