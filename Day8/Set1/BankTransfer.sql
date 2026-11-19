SET NOCOUNT ON;
GO
/* ======================= SET 1: BANK TRANSFER ======================= */
IF OBJECT_ID('dbo.BankTransactions','U') IS NOT NULL DROP TABLE dbo.BankTransactions;
IF OBJECT_ID('dbo.BankAccounts','U') IS NOT NULL DROP TABLE dbo.BankAccounts;
GO
CREATE TABLE dbo.BankAccounts(AccountID INT PRIMARY KEY,AccountName NVARCHAR(80) NOT NULL,Balance DECIMAL(12,2) NOT NULL CHECK(Balance>=0),AccountStatus VARCHAR(20) NOT NULL CHECK(AccountStatus IN('ACTIVE','BLOCKED')));
CREATE TABLE dbo.BankTransactions(TransactionID INT IDENTITY PRIMARY KEY,FromAccount INT NULL,ToAccount INT NULL,Amount DECIMAL(12,2) NOT NULL,Fee DECIMAL(12,2) NOT NULL DEFAULT 0,TransactionType VARCHAR(30) NOT NULL,TransactionDate DATETIME2 DEFAULT SYSUTCDATETIME(),FOREIGN KEY(FromAccount) REFERENCES dbo.BankAccounts(AccountID),FOREIGN KEY(ToAccount) REFERENCES dbo.BankAccounts(AccountID));
INSERT dbo.BankAccounts VALUES(101,'Asha',5000,'ACTIVE'),(102,'Bala',2500,'ACTIVE'),(103,'Blocked',800,'BLOCKED');
GO
-- Task 1: Transfer with validation, locking, TRY/CATCH, COMMIT/ROLLBACK and THROW.
DECLARE @From INT=101,@To INT=102,@Amount DECIMAL(12,2)=500;
BEGIN TRY
 BEGIN TRAN;
 IF @From=@To OR @Amount<=0 THROW 50001,'Invalid transfer parameters.',1;
 IF NOT EXISTS(SELECT 1 FROM dbo.BankAccounts WITH(UPDLOCK,HOLDLOCK) WHERE AccountID=@From AND AccountStatus='ACTIVE') THROW 50002,'Source missing or inactive.',1;
 IF NOT EXISTS(SELECT 1 FROM dbo.BankAccounts WITH(UPDLOCK,HOLDLOCK) WHERE AccountID=@To AND AccountStatus='ACTIVE') THROW 50003,'Destination missing or inactive.',1;
 IF (SELECT Balance FROM dbo.BankAccounts WITH(UPDLOCK,HOLDLOCK) WHERE AccountID=@From)<@Amount THROW 50004,'Insufficient funds.',1;
 UPDATE dbo.BankAccounts SET Balance=Balance-@Amount WHERE AccountID=@From;
 UPDATE dbo.BankAccounts SET Balance=Balance+@Amount WHERE AccountID=@To;
 INSERT dbo.BankTransactions(FromAccount,ToAccount,Amount,TransactionType) VALUES(@From,@To,@Amount,'TRANSFER');
 COMMIT; PRINT 'Transfer committed.';
END TRY BEGIN CATCH
 IF XACT_STATE()<>0 ROLLBACK; PRINT ERROR_MESSAGE(); THROW;
END CATCH;
GO
-- Task 2: Deliberate failure after debit; rollback evidence (balances before/after).
SELECT AccountID,Balance AS BeforeDeliberateFailure FROM dbo.BankAccounts WHERE AccountID IN(101,102);
BEGIN TRY
 BEGIN TRAN;
 UPDATE dbo.BankAccounts SET Balance=Balance-100 WHERE AccountID=101;
 THROW 50010,'Deliberate failure after debit.',1;
 UPDATE dbo.BankAccounts SET Balance=Balance+100 WHERE AccountID=102;
 COMMIT;
END TRY BEGIN CATCH
 IF XACT_STATE()<>0 ROLLBACK; PRINT CONCAT('Expected rollback: ',ERROR_MESSAGE());
END CATCH;
SELECT AccountID,Balance AS AfterRollback FROM dbo.BankAccounts WHERE AccountID IN(101,102);
GO
-- Task 3: SAVEPOINT rolls back fee-posting step while transfer is retained.
BEGIN TRY
 BEGIN TRAN;
 UPDATE dbo.BankAccounts SET Balance=Balance-200 WHERE AccountID=101 AND Balance>=200;
 IF @@ROWCOUNT=0 THROW 50020,'Insufficient balance.',1;
 UPDATE dbo.BankAccounts SET Balance=Balance+200 WHERE AccountID=102;
 INSERT dbo.BankTransactions(FromAccount,ToAccount,Amount,TransactionType) VALUES(101,102,200,'TRANSFER_SAVEPOINT');
 SAVE TRAN FeeSavepoint;
 BEGIN TRY
  INSERT dbo.BankTransactions(FromAccount,ToAccount,Amount,Fee,TransactionType) VALUES(101,102,0,10,'FEE');
  THROW 50021,'Simulated fee posting failure.',1;
 END TRY BEGIN CATCH
  IF XACT_STATE()=1 ROLLBACK TRAN FeeSavepoint; PRINT 'Fee step rolled back to savepoint; transfer retained.';
 END CATCH;
 COMMIT; PRINT 'Transfer committed.';
END TRY BEGIN CATCH
 IF XACT_STATE()<>0 ROLLBACK; THROW;
END CATCH;
GO
-- Task 4: Statement CTE using ROW_NUMBER and LAG of running balance.
INSERT dbo.BankTransactions(FromAccount,ToAccount,Amount,TransactionType,TransactionDate) VALUES(101,102,50,'TRANSFER',DATEADD(day,-2,SYSUTCDATETIME())),(102,101,25,'TRANSFER',DATEADD(day,-1,SYSUTCDATETIME()));
DECLARE @StatementAccount INT=101,@Month DATE=DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),1);
;WITH L AS(SELECT TransactionID,TransactionDate,TransactionType,Amount,CASE WHEN ToAccount=@StatementAccount THEN Amount WHEN FromAccount=@StatementAccount THEN -Amount ELSE 0 END AS SignedAmount FROM dbo.BankTransactions WHERE (FromAccount=@StatementAccount OR ToAccount=@StatementAccount) AND TransactionDate>=@Month AND TransactionDate<DATEADD(month,1,@Month)), R AS(SELECT *,ROW_NUMBER() OVER(ORDER BY TransactionDate,TransactionID) AS RN,SUM(SignedAmount) OVER(ORDER BY TransactionDate,TransactionID ROWS UNBOUNDED PRECEDING) AS RunningBalance FROM L)
SELECT TransactionID,TransactionDate,TransactionType,SignedAmount,LAG(RunningBalance,1,0) OVER(ORDER BY TransactionDate,TransactionID) AS PreviousBalance,RunningBalance,RN FROM R ORDER BY TransactionDate,TransactionID;
GO
-- Task 5 notes: two-session isolation experiment. Run manually in two SSMS tabs.
/* READ COMMITTED - Session A: SET TRANSACTION ISOLATION LEVEL READ COMMITTED; BEGIN TRAN; SELECT Balance FROM dbo.BankAccounts WHERE AccountID=101; WAITFOR DELAY '00:00:10'; SELECT Balance FROM dbo.BankAccounts WHERE AccountID=101; COMMIT;
   Session B during A's wait: UPDATE dbo.BankAccounts SET Balance=Balance+100 WHERE AccountID=101; Under READ COMMITTED, B can commit between A's statements, so the second read may differ.
   SNAPSHOT: enable outside a transaction: ALTER DATABASE CURRENT SET ALLOW_SNAPSHOT_ISOLATION ON; Session A: SET TRANSACTION ISOLATION LEVEL SNAPSHOT; BEGIN TRAN; SELECT Balance FROM dbo.BankAccounts WHERE AccountID=101; WAITFOR DELAY '00:00:10'; SELECT Balance FROM dbo.BankAccounts WHERE AccountID=101; COMMIT; Session B commits an update during the wait; A sees the same row version for both reads. Snapshot row-version storage has a cost. MongoDB version is in JS file. */
