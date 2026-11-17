
-- 1. CREATE DATABASE
CREATE DATABASE BankDB;
USE BankDB;


-- 2. CREATE TABLES


CREATE TABLE Customer (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200)
);

CREATE TABLE Relationship_Manager (
    Manager_ID INT AUTO_INCREMENT PRIMARY KEY,
    Manager_Name VARCHAR(100) NOT NULL
);

CREATE TABLE Branch (
    Branch_ID INT AUTO_INCREMENT PRIMARY KEY,
    Branch_Name VARCHAR(100) NOT NULL,
    Manager_ID INT,
    FOREIGN KEY (Manager_ID)
        REFERENCES Relationship_Manager(Manager_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Account_Type (
    Account_Type_ID INT AUTO_INCREMENT PRIMARY KEY,
    Account_Type VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Account (
    Account_Number BIGINT AUTO_INCREMENT PRIMARY KEY,
    Account_Type_ID INT NOT NULL,
    Branch_ID INT NOT NULL,
    Balance DECIMAL(12,2) NOT NULL,
    Opened_Date DATE NOT NULL,

    CHECK (Balance >= 0),

    FOREIGN KEY (Account_Type_ID)
        REFERENCES Account_Type(Account_Type_ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    FOREIGN KEY (Branch_ID)
        REFERENCES Branch(Branch_ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Customer and Account many-to-many relationship
CREATE TABLE Customer_Account (
    Customer_ID INT,
    Account_Number BIGINT,

    PRIMARY KEY (Customer_ID, Account_Number),

    FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Account_Number)
        REFERENCES Account(Account_Number)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Account_Activity (
    Transaction_ID INT AUTO_INCREMENT PRIMARY KEY,
    Account_Number BIGINT NOT NULL,
    Transaction_Date DATETIME NOT NULL,
    Transaction_Text VARCHAR(255),

    FOREIGN KEY (Account_Number)
        REFERENCES Account(Account_Number)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- 3. INSERT SAMPLE DATA


INSERT INTO Customer (Customer_Name, Address)
VALUES
('Arun', 'Chennai'),
('Priya', 'Madurai'),
('Rahul', 'Coimbatore'),
('Divya', 'Chennai'),
('Karthik', 'Salem');

INSERT INTO Relationship_Manager (Manager_Name)
VALUES
('Ravi'),
('Kumar');

INSERT INTO Branch (Branch_Name, Manager_ID)
VALUES
('Tambaram', 1),
('Velachery', 2);

INSERT INTO Account_Type (Account_Type)
VALUES
('Savings'),
('Current');

INSERT INTO Account
(Account_Type_ID, Branch_ID, Balance, Opened_Date)
VALUES
(1, 1, 25000, '2026-07-10'),
(2, 1, 50000, '2026-08-15'),
(1, 2, 30000, '2026-09-05'),
(1, 1, 15000, '2026-06-20'),
(2, 2, 75000, '2026-09-20'),
(1, 1, 10000, '2026-10-05');

INSERT INTO Customer_Account
(Customer_ID, Account_Number)
VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6);

INSERT INTO Account_Activity
(Account_Number, Transaction_Date, Transaction_Text)
VALUES
(1, '2026-09-01 09:00:00', 'ATM Withdrawal'),
(1, '2026-09-05 10:00:00', 'Salary Credit'),
(1, '2026-09-10 11:00:00', 'UPI Payment'),
(2, '2026-09-12 12:00:00', 'Cash Deposit'),
(3, '2026-09-15 13:00:00', 'ATM Withdrawal');


-- 4. DISPLAY TABLES AND DATA


SHOW TABLES;

SELECT * FROM Customer;
SELECT * FROM Relationship_Manager;
SELECT * FROM Branch;
SELECT * FROM Account_Type;
SELECT * FROM Account;
SELECT * FROM Customer_Account;
SELECT * FROM Account_Activity;


-- 5. DROP, TRUNCATE AND DELETE


CREATE TABLE Test_Identity (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50)
);

INSERT INTO Test_Identity (Name)
VALUES ('Arun'), ('Priya'), ('Rahul');

SELECT * FROM Test_Identity;

-- DELETE: removes selected rows
DELETE FROM Test_Identity WHERE ID = 1;

-- DELETE rollback demonstration
START TRANSACTION;

DELETE FROM Test_Identity WHERE ID = 2;

ROLLBACK;

SELECT * FROM Test_Identity;

-- TRUNCATE: removes all rows and resets AUTO_INCREMENT
TRUNCATE TABLE Test_Identity;

INSERT INTO Test_Identity (Name)
VALUES ('New User');

SELECT * FROM Test_Identity;

-- DROP: removes the complete table
DROP TABLE Test_Identity;

-- ==========================================
-- 6. INSERT, UPDATE AND DELETE
-- ==========================================

-- INSERT
INSERT INTO Customer (Customer_Name, Address)
VALUES ('Vikram', 'Trichy');

-- UPDATE
UPDATE Account
SET Balance = 40000
WHERE Account_Number = 1;

-- DELETE
DELETE FROM Account_Activity
WHERE Transaction_ID = 5;


-- 7. WHERE CLAUSES


-- AND
SELECT * FROM Account
WHERE Balance > 10000 AND Balance < 60000;

-- OR
SELECT * FROM Customer
WHERE Address = 'Chennai' OR Address = 'Madurai';

-- IN
SELECT * FROM Account
WHERE Account_Type_ID IN (1, 2);

-- BETWEEN
SELECT * FROM Account
WHERE Balance BETWEEN 10000 AND 50000;



SELECT
    Account_Number,
    Account_Type_ID,
    Balance,
    Opened_Date
FROM Account
WHERE Opened_Date BETWEEN '2026-07-01' AND '2026-09-30'
AND Balance > 20000;

-- 9. CUSTOMER ACCOUNT DETAILS

SELECT
    C.Customer_Name,
    C.Address,
    A.Account_Number,
    AT.Account_Type,
    B.Branch_Name,
    RM.Manager_Name,
    A.Balance
FROM Customer C
JOIN Customer_Account CA
    ON C.Customer_ID = CA.Customer_ID
JOIN Account A
    ON CA.Account_Number = A.Account_Number
JOIN Account_Type AT
    ON A.Account_Type_ID = AT.Account_Type_ID
JOIN Branch B
    ON A.Branch_ID = B.Branch_ID
LEFT JOIN Relationship_Manager RM
    ON B.Manager_ID = RM.Manager_ID;
