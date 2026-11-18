
IF DB_ID('Day7_BankLoansDB') IS NULL CREATE DATABASE Day7_BankLoansDB;
GO
USE Day7_BankLoansDB;
GO
DROP TABLE IF EXISTS dbo.Repayments;
DROP TABLE IF EXISTS dbo.LoanGuarantors;
DROP TABLE IF EXISTS dbo.Loans;
DROP TABLE IF EXISTS dbo.Customers;
DROP TABLE IF EXISTS dbo.Branches;
GO
CREATE TABLE dbo.Branches(BranchID INT PRIMARY KEY,BranchName VARCHAR(80),Region VARCHAR(40));
CREATE TABLE dbo.Customers(CustomerID INT PRIMARY KEY,CustomerName VARCHAR(100));
CREATE TABLE dbo.Loans(
 LoanID INT PRIMARY KEY,CustomerID INT NOT NULL REFERENCES dbo.Customers(CustomerID),
 BranchID INT NOT NULL REFERENCES dbo.Branches(BranchID),
 Principal DECIMAL(12,2) NOT NULL,Outstanding DECIMAL(12,2) NOT NULL,
 InstalmentsDue INT NOT NULL DEFAULT 0,LoanDate DATE NOT NULL,
 CHECK(Principal>0 AND Outstanding>=0 AND InstalmentsDue>=0)
);
CREATE TABLE dbo.Repayments(
 RepaymentID INT PRIMARY KEY,LoanID INT NOT NULL REFERENCES dbo.Loans(LoanID),
 PaymentDate DATE NOT NULL,Amount DECIMAL(12,2) NOT NULL CHECK(Amount>0)
);
CREATE TABLE dbo.LoanGuarantors(
 LoanID INT NOT NULL REFERENCES dbo.Loans(LoanID),
 GuarantorCustomerID INT NOT NULL REFERENCES dbo.Customers(CustomerID),
 PRIMARY KEY(LoanID,GuarantorCustomerID)
);
INSERT dbo.Branches VALUES
(1,'Chennai Main','South'),(2,'Bengaluru Central','South'),
(3,'Mumbai Fort','West'),(4,'Delhi Connaught','North'),(5,'Kolkata Park','East');
INSERT dbo.Customers VALUES
(1,'Arun Kumar'),(2,'Priya Shah'),(3,'Rahul Das'),(4,'Meena Iyer'),
(5,'Karthik Rao'),(6,'Divya Nair'),(7,'Vikram Singh'),(8,'Anitha Roy');
INSERT dbo.Loans VALUES
(201,1,1,500000,300000,4,'2026-01-10'),
(202,2,1,300000,120000,1,'2026-02-12'),
(203,3,2,700000,650000,5,'2026-03-15'),
(204,1,2,200000,80000,0,'2026-04-01'),
(205,4,3,450000,200000,2,'2026-04-18'),
(206,5,3,900000,800000,6,'2026-05-20'),
(207,6,4,250000,100000,0,'2026-06-05'),
(208,7,4,600000,400000,3,'2026-06-22'),
(209,8,1,150000,50000,0,'2026-07-10'),
(210,3,3,350000,200000,1,'2026-08-01');
INSERT dbo.Repayments VALUES
(1,201,'2026-09-01',10000),(2,201,'2026-10-01',10000),
(3,202,'2026-10-15',12000),(4,203,'2026-08-01',15000),
(5,204,'2026-10-20',20000),(6,205,'2026-07-01',9000),
(7,206,'2026-06-01',12000),(8,207,'2026-10-25',8000),
(9,208,'2026-08-15',11000),(10,210,'2026-10-10',7000);
INSERT dbo.LoanGuarantors VALUES
(201,2),(202,1),(203,5),(204,3),(205,6),(206,7),(207,8),(208,1);
GO

-- TASK 1: TEN BUSINESS QUESTIONS
-- Q1 Loans overdue by more than three instalments
SELECT l.LoanID,c.CustomerName,l.InstalmentsDue,l.Outstanding
FROM dbo.Loans l JOIN dbo.Customers c ON c.CustomerID=l.CustomerID
WHERE l.InstalmentsDue>3;

-- Q2 Customers with loans in more than one branch
SELECT c.CustomerID,c.CustomerName,COUNT(DISTINCT l.BranchID) BranchCount
FROM dbo.Customers c JOIN dbo.Loans l ON l.CustomerID=c.CustomerID
GROUP BY c.CustomerID,c.CustomerName HAVING COUNT(DISTINCT l.BranchID)>1;

-- Q3 Guarantors who are also borrowers (self relationship through customer table)
SELECT DISTINCT g.GuarantorCustomerID,c.CustomerName
FROM dbo.LoanGuarantors g JOIN dbo.Loans l ON l.CustomerID=g.GuarantorCustomerID
JOIN dbo.Customers c ON c.CustomerID=g.GuarantorCustomerID;

-- Q4 Branches with no loans
SELECT b.BranchID,b.BranchName FROM dbo.Branches b
LEFT JOIN dbo.Loans l ON l.BranchID=b.BranchID WHERE l.LoanID IS NULL;

-- Q5 Loans with customer and branch details
SELECT l.LoanID,c.CustomerName,b.BranchName,l.Principal,l.Outstanding
FROM dbo.Loans l JOIN dbo.Customers c ON c.CustomerID=l.CustomerID
JOIN dbo.Branches b ON b.BranchID=l.BranchID;

-- Q6 Customers and their loans, including customers without loans
SELECT c.CustomerName,l.LoanID,l.Outstanding
FROM dbo.Customers c LEFT JOIN dbo.Loans l ON l.CustomerID=c.CustomerID;

-- Q7 Each loan and its repayment records
SELECT l.LoanID,r.RepaymentID,r.PaymentDate,r.Amount
FROM dbo.Loans l LEFT JOIN dbo.Repayments r ON r.LoanID=l.LoanID;

-- Q8 Total repayments by branch
SELECT b.BranchName,SUM(r.Amount) TotalRepaid
FROM dbo.Branches b JOIN dbo.Loans l ON l.BranchID=b.BranchID
JOIN dbo.Repayments r ON r.LoanID=l.LoanID GROUP BY b.BranchID,b.BranchName;

-- Q9 Customers who have more than one loan
SELECT c.CustomerName,COUNT(l.LoanID) LoanCount
FROM dbo.Customers c JOIN dbo.Loans l ON l.CustomerID=c.CustomerID
GROUP BY c.CustomerID,c.CustomerName HAVING COUNT(l.LoanID)>1;

-- Q10 Loans with their guarantor names
SELECT l.LoanID,c.CustomerName AS Borrower,gc.CustomerName AS Guarantor
FROM dbo.Loans l JOIN dbo.Customers c ON c.CustomerID=l.CustomerID
LEFT JOIN dbo.LoanGuarantors g ON g.LoanID=l.LoanID
LEFT JOIN dbo.Customers gc ON gc.CustomerID=g.GuarantorCustomerID;

-- TASK 2: CORRELATED AND UNCORRELATED SUBQUERIES
-- Uncorrelated: branch average outstanding
SELECT BranchID,AVG(Outstanding) BranchAverage
FROM dbo.Loans GROUP BY BranchID;

-- Correlated: customers whose total exposure exceeds their branch's average loan exposure
WITH CustomerExposure AS (
 SELECT CustomerID,BranchID,SUM(Outstanding) TotalExposure
 FROM dbo.Loans GROUP BY CustomerID,BranchID
)
SELECT ce.CustomerID,c.CustomerName,ce.BranchID,ce.TotalExposure
FROM CustomerExposure ce JOIN dbo.Customers c ON c.CustomerID=ce.CustomerID
WHERE ce.TotalExposure > (
 SELECT AVG(x.Outstanding) FROM dbo.Loans x WHERE x.BranchID=ce.BranchID
);

-- TASK 3: EXISTS / NOT EXISTS - loan but no repayment in last 60 days
SELECT DISTINCT c.CustomerID,c.CustomerName
FROM dbo.Customers c
WHERE EXISTS (SELECT 1 FROM dbo.Loans l WHERE l.CustomerID=c.CustomerID)
AND NOT EXISTS (
 SELECT 1 FROM dbo.Loans l JOIN dbo.Repayments r ON r.LoanID=l.LoanID
 WHERE l.CustomerID=c.CustomerID
   AND r.PaymentDate>=DATEADD(DAY,-60,CONVERT(date,GETDATE()))
);

-- TASK 4: BRANCHES WHOSE HIGHEST LOAN EXCEEDS BANK-WIDE AVERAGE OF BRANCH MAXIMUMS
SELECT b.BranchID,b.BranchName,MAX(l.Principal) HighestLoan
FROM dbo.Branches b JOIN dbo.Loans l ON l.BranchID=b.BranchID
GROUP BY b.BranchID,b.BranchName
HAVING MAX(l.Principal) > (
 SELECT AVG(CAST(BranchMax AS DECIMAL(12,2)))
 FROM (SELECT MAX(Principal) BranchMax FROM dbo.Loans GROUP BY BranchID) x
);
GO
