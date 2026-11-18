
IF DB_ID('Day7_LogisticsDB') IS NULL CREATE DATABASE Day7_LogisticsDB;
GO
USE Day7_LogisticsDB;
GO

DROP TABLE IF EXISTS dbo.DeliveryEvents;
DROP TABLE IF EXISTS dbo.Shipments;
DROP TABLE IF EXISTS dbo.Employees;
DROP TABLE IF EXISTS dbo.Customers;
DROP TABLE IF EXISTS dbo.Carriers;
DROP TABLE IF EXISTS dbo.Hubs;
GO

CREATE TABLE dbo.Hubs (
    HubID INT PRIMARY KEY, HubName VARCHAR(80) NOT NULL,
    City VARCHAR(60) NOT NULL, Region VARCHAR(40) NOT NULL
);
CREATE TABLE dbo.Carriers (
    CarrierID INT PRIMARY KEY, CarrierName VARCHAR(80) NOT NULL
);
CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY, CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(60) NOT NULL
);
CREATE TABLE dbo.Employees (
    EmployeeID INT PRIMARY KEY, EmployeeName VARCHAR(100) NOT NULL,
    SupervisorID INT NULL REFERENCES dbo.Employees(EmployeeID),
    HubID INT NOT NULL REFERENCES dbo.Hubs(HubID)
);
CREATE TABLE dbo.Shipments (
    ShipmentID INT PRIMARY KEY, CustomerID INT NOT NULL REFERENCES dbo.Customers(CustomerID),
    CarrierID INT NOT NULL REFERENCES dbo.Carriers(CarrierID),
    OriginHubID INT NOT NULL REFERENCES dbo.Hubs(HubID),
    DestinationHubID INT NOT NULL REFERENCES dbo.Hubs(HubID),
    EmployeeID INT NOT NULL REFERENCES dbo.Employees(EmployeeID),
    ShipDate DATE NOT NULL, PromisedDate DATE NOT NULL, DeliveredDate DATE NULL,
    ShippingCost DECIMAL(10,2) NOT NULL CHECK (ShippingCost >= 0)
);
CREATE TABLE dbo.DeliveryEvents (
    EventID INT PRIMARY KEY, ShipmentID INT NOT NULL REFERENCES dbo.Shipments(ShipmentID),
    EventType VARCHAR(40) NOT NULL, EventDate DATETIME2 NOT NULL,
    EventNote VARCHAR(200) NULL
);

INSERT dbo.Hubs VALUES
(1,'Chennai Central','Chennai','South'),(2,'Bengaluru Hub','Bengaluru','South'),
(3,'Mumbai West','Mumbai','West'),(4,'Delhi North','Delhi','North'),
(5,'Kolkata East','Kolkata','East'),(6,'Hyderabad Hub','Hyderabad','South');
INSERT dbo.Carriers VALUES
(1,'BlueDart'),(2,'DHL'),(3,'Delhivery'),(4,'FedEx');
INSERT dbo.Customers VALUES
(1,'Aarav Stores','Chennai'),(2,'Bright Retail','Bengaluru'),
(3,'City Mart','Mumbai'),(4,'Delta Traders','Delhi'),
(5,'Evergreen Shop','Kolkata'),(6,'Fresh Basket','Hyderabad');
INSERT dbo.Employees VALUES
(1,'Meera',NULL,1),(2,'Kavin',1,1),(3,'Nisha',1,2),
(4,'Rohit',NULL,3),(5,'Ananya',4,4),(6,'Vikram',4,5);
INSERT dbo.Shipments VALUES
(101,1,1,1,2,2,'2026-10-01','2026-10-03','2026-10-06',850),
(102,2,2,2,3,3,'2026-10-02','2026-10-05','2026-10-05',1200),
(103,3,3,3,4,4,'2026-10-03','2026-10-06','2026-10-10',950),
(104,4,1,4,5,5,'2026-10-04','2026-10-08','2026-10-07',700),
(105,5,4,5,1,6,'2026-10-05','2026-10-09',NULL,1500),
(106,6,2,1,6,2,'2026-10-06','2026-10-08','2026-10-12',650),
(107,1,3,2,4,3,'2026-10-07','2026-10-11','2026-10-11',1100),
(108,2,4,3,1,4,'2026-10-08','2026-10-12','2026-10-15',1350),
(109,3,1,4,2,5,'2026-10-09','2026-10-13','2026-10-13',500),
(110,4,2,5,3,6,'2026-10-10','2026-10-14',NULL,900),
(111,5,3,1,3,2,'2026-10-11','2026-10-14','2026-10-17',780),
(112,6,4,2,5,3,'2026-10-12','2026-10-16','2026-10-16',1600);
INSERT dbo.DeliveryEvents VALUES
(1,101,'PickedUp','2026-10-01T09:00','Collected'),(2,101,'Delivered','2026-10-06T16:00','Late delivery'),
(3,102,'Delivered','2026-10-05T12:00','On time'),(4,103,'Delayed','2026-10-08T10:00','Weather'),
(5,103,'Delivered','2026-10-10T17:00','Delivered'),(6,104,'Delivered','2026-10-07T11:00','Early'),
(7,105,'InTransit','2026-10-08T14:00','In transit'),(8,106,'Delivered','2026-10-12T18:00','Late'),
(9,107,'Delivered','2026-10-11T15:00','On time'),(10,108,'Delivered','2026-10-15T13:00','Late'),
(11,109,'Delivered','2026-10-13T10:00','On time'),(12,110,'InTransit','2026-10-14T10:00','In transit');
GO

-- TASK 1: TEN BUSINESS QUESTIONS USING JOINS
-- Q1 INNER JOIN: shipments with customer and carrier names
SELECT s.ShipmentID,c.CustomerName,ca.CarrierName,s.ShippingCost
FROM dbo.Shipments s INNER JOIN dbo.Customers c ON c.CustomerID=s.CustomerID
INNER JOIN dbo.Carriers ca ON ca.CarrierID=s.CarrierID;

-- Q2 INNER JOIN: shipments delayed by more than two days
SELECT s.ShipmentID,ca.CarrierName,s.PromisedDate,s.DeliveredDate,
       DATEDIFF(DAY,s.PromisedDate,s.DeliveredDate) AS DelayDays
FROM dbo.Shipments s JOIN dbo.Carriers ca ON ca.CarrierID=s.CarrierID
WHERE s.DeliveredDate > DATEADD(DAY,2,s.PromisedDate);

-- Q3 LEFT JOIN: hubs with no outbound shipments
SELECT h.HubID,h.HubName
FROM dbo.Hubs h LEFT JOIN dbo.Shipments s ON s.OriginHubID=h.HubID
WHERE s.ShipmentID IS NULL;

-- Q4 FULL OUTER JOIN: show hubs even if they have no outbound or inbound shipments
SELECT COALESCE(o.HubName,i.HubName) AS HubName,
       o.OutboundCount,i.InboundCount
FROM (SELECT h.HubID,h.HubName,COUNT(s.ShipmentID) OutboundCount
      FROM dbo.Hubs h LEFT JOIN dbo.Shipments s ON s.OriginHubID=h.HubID
      GROUP BY h.HubID,h.HubName) o
FULL OUTER JOIN
     (SELECT h.HubID,h.HubName,COUNT(s.ShipmentID) InboundCount
      FROM dbo.Hubs h LEFT JOIN dbo.Shipments s ON s.DestinationHubID=h.HubID
      GROUP BY h.HubID,h.HubName) i ON i.HubID=o.HubID;

-- Q5 SELF JOIN: employees and their supervisors
SELECT e.EmployeeName AS Employee, m.EmployeeName AS Supervisor
FROM dbo.Employees e LEFT JOIN dbo.Employees m ON m.EmployeeID=e.SupervisorID;

-- Q6 INNER JOIN: shipment delivery events
SELECT s.ShipmentID,e.EventType,e.EventDate,e.EventNote
FROM dbo.Shipments s JOIN dbo.DeliveryEvents e ON e.ShipmentID=s.ShipmentID
ORDER BY s.ShipmentID,e.EventDate;

-- Q7 LEFT JOIN: all customers and their shipment counts, including zero
SELECT c.CustomerName,COUNT(s.ShipmentID) AS ShipmentCount
FROM dbo.Customers c LEFT JOIN dbo.Shipments s ON s.CustomerID=c.CustomerID
GROUP BY c.CustomerID,c.CustomerName;

-- Q8 INNER JOIN: shipment count and total cost by carrier
SELECT ca.CarrierName,COUNT(*) ShipmentCount,SUM(s.ShippingCost) TotalCost
FROM dbo.Carriers ca JOIN dbo.Shipments s ON s.CarrierID=ca.CarrierID
GROUP BY ca.CarrierID,ca.CarrierName;

-- Q9 FULL OUTER JOIN: customers and shipments, retaining unmatched rows
SELECT c.CustomerName,s.ShipmentID
FROM dbo.Customers c FULL OUTER JOIN dbo.Shipments s ON s.CustomerID=c.CustomerID;

-- Q10 SELF JOIN: employees working at the same hub
SELECT e1.EmployeeName Employee1,e2.EmployeeName Employee2,h.HubName
FROM dbo.Employees e1 JOIN dbo.Employees e2
  ON e1.HubID=e2.HubID AND e1.EmployeeID<e2.EmployeeID
JOIN dbo.Hubs h ON h.HubID=e1.HubID;

-- TASK 2: IN, EXISTS, ANY AND ALL SUBQUERIES
-- Customers who have shipped to every hub (relational division using NOT EXISTS)
SELECT c.CustomerID,c.CustomerName
FROM dbo.Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.Hubs h
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.Shipments s
        WHERE s.CustomerID=c.CustomerID AND s.DestinationHubID=h.HubID
    )
);

-- Customers who shipped to at least one hub in the South region (IN)
SELECT CustomerID,CustomerName FROM dbo.Customers
WHERE CustomerID IN (SELECT CustomerID FROM dbo.Shipments);

-- Carriers with at least one shipment delayed more than two days (EXISTS)
SELECT ca.CarrierID,ca.CarrierName FROM dbo.Carriers ca
WHERE EXISTS (
 SELECT 1 FROM dbo.Shipments s
 WHERE s.CarrierID=ca.CarrierID AND s.DeliveredDate>DATEADD(DAY,2,s.PromisedDate)
);

-- Carriers whose average delivery delay exceeds overall average delay (ANY)
WITH CarrierDelay AS (
 SELECT CarrierID,AVG(CAST(DATEDIFF(DAY,PromisedDate,DeliveredDate) AS DECIMAL(10,2))) AvgDelay
 FROM dbo.Shipments WHERE DeliveredDate IS NOT NULL GROUP BY CarrierID
), OverallDelay AS (
 SELECT AVG(CAST(DATEDIFF(DAY,PromisedDate,DeliveredDate) AS DECIMAL(10,2))) AvgDelay
 FROM dbo.Shipments WHERE DeliveredDate IS NOT NULL
)
SELECT ca.CarrierName,cd.AvgDelay FROM CarrierDelay cd
JOIN dbo.Carriers ca ON ca.CarrierID=cd.CarrierID
WHERE cd.AvgDelay > (SELECT AvgDelay FROM OverallDelay);

-- Carriers whose average delay is greater than ALL individual carrier averages except themselves
WITH D AS (
 SELECT CarrierID,AVG(CAST(DATEDIFF(DAY,PromisedDate,DeliveredDate) AS DECIMAL(10,2))) AvgDelay
 FROM dbo.Shipments WHERE DeliveredDate IS NOT NULL GROUP BY CarrierID
)
SELECT c.CarrierName,d.AvgDelay FROM D d JOIN dbo.Carriers c ON c.CarrierID=d.CarrierID
WHERE d.AvgDelay >= ALL (SELECT d2.AvgDelay FROM D d2 WHERE d2.CarrierID<>d.CarrierID);

-- TASK 3: REWRITE TWO SUBQUERIES AS JOINS
-- Subquery form 1: customers who have shipments
SELECT CustomerID,CustomerName FROM dbo.Customers
WHERE CustomerID IN (SELECT CustomerID FROM dbo.Shipments);
-- Join rewrite
SELECT DISTINCT c.CustomerID,c.CustomerName
FROM dbo.Customers c JOIN dbo.Shipments s ON s.CustomerID=c.CustomerID;

-- Subquery form 2: carriers with delayed shipments
SELECT CarrierID,CarrierName FROM dbo.Carriers ca
WHERE EXISTS (SELECT 1 FROM dbo.Shipments s
              WHERE s.CarrierID=ca.CarrierID
              AND s.DeliveredDate>DATEADD(DAY,2,s.PromisedDate));
-- Join rewrite
SELECT DISTINCT ca.CarrierID,ca.CarrierName
FROM dbo.Carriers ca JOIN dbo.Shipments s ON s.CarrierID=ca.CarrierID
WHERE s.DeliveredDate>DATEADD(DAY,2,s.PromisedDate);

-- TASK 4: NESTED SUBQUERY - SECOND-HIGHEST SHIPPING COST PER HUB
SELECT h.HubName,
       (SELECT MAX(x.ShippingCost)
        FROM dbo.Shipments x
        WHERE x.OriginHubID=h.HubID
          AND x.ShippingCost < (SELECT MAX(y.ShippingCost)
                                FROM dbo.Shipments y
                                WHERE y.OriginHubID=h.HubID)
       ) AS SecondHighestShippingCost
FROM dbo.Hubs h;
GO
