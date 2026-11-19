IF OBJECT_ID('dbo.AirlineBookings','U') IS NOT NULL DROP TABLE dbo.AirlineBookings;
IF OBJECT_ID('dbo.AirlineSeats','U') IS NOT NULL DROP TABLE dbo.AirlineSeats;
GO
CREATE TABLE dbo.AirlineSeats(FlightID INT,SeatNo VARCHAR(10),SeatStatus VARCHAR(20) CHECK(SeatStatus IN('AVAILABLE','BOOKED')),PRIMARY KEY(FlightID,SeatNo));
CREATE TABLE dbo.AirlineBookings(BookingID INT IDENTITY PRIMARY KEY,FlightID INT,SeatNo VARCHAR(10),PassengerName NVARCHAR(100),Fare DECIMAL(10,2),BookingDate DATETIME2 DEFAULT SYSUTCDATETIME(),CONSTRAINT UQ_BookingSeat UNIQUE(FlightID,SeatNo),FOREIGN KEY(FlightID,SeatNo) REFERENCES dbo.AirlineSeats(FlightID,SeatNo));
INSERT dbo.AirlineSeats VALUES(501,'1A','AVAILABLE'),(501,'1B','AVAILABLE'),(501,'1C','AVAILABLE'),(502,'2A','AVAILABLE'),(502,'2B','AVAILABLE');
GO
-- Task 1: atomic seat update + booking insert; locked conditional update avoids double booking.
DECLARE @Flight INT=501,@Seat VARCHAR(10)='1A',@Passenger NVARCHAR(100)='Nivedita',@Fare DECIMAL(10,2)=1200;
BEGIN TRY
 BEGIN TRAN;
 UPDATE dbo.AirlineSeats WITH(UPDLOCK,HOLDLOCK) SET SeatStatus='BOOKED' WHERE FlightID=@Flight AND SeatNo=@Seat AND SeatStatus='AVAILABLE';
 IF @@ROWCOUNT=0 THROW 50101,'Seat unavailable.',1;
 INSERT dbo.AirlineBookings(FlightID,SeatNo,PassengerName,Fare) VALUES(@Flight,@Seat,@Passenger,@Fare);
 COMMIT; PRINT 'Seat booked.';
END TRY BEGIN CATCH
 IF XACT_STATE()<>0 ROLLBACK; PRINT ERROR_MESSAGE(); THROW;
END CATCH;
GO
-- Task 2 concurrency notes: run two sessions against an AVAILABLE seat such as 1C.
/* Session A: SET TRANSACTION ISOLATION LEVEL READ COMMITTED; BEGIN TRAN; UPDATE dbo.AirlineSeats WITH(UPDLOCK,HOLDLOCK) SET SeatStatus='BOOKED' WHERE FlightID=501 AND SeatNo='1C' AND SeatStatus='AVAILABLE'; WAITFOR DELAY '00:00:10'; IF @@ROWCOUNT=1 INSERT dbo.AirlineBookings(FlightID,SeatNo,PassengerName,Fare) VALUES(501,'Session A',900); COMMIT;
   Session B concurrently attempts same conditional UPDATE/INSERT. A row lock serializes the conditional update; after A commits, B sees no available row. SERIALIZABLE also protects key ranges but may increase blocking/deadlocks. UNIQUE(FlightID,SeatNo) is final protection. Reset 1C between trials. */
-- Tasks 3 & 4: fare RANK/DENSE_RANK and running revenue in a CTE.
;WITH Ranked AS(SELECT BookingID,FlightID,SeatNo,PassengerName,Fare,BookingDate,RANK() OVER(PARTITION BY FlightID ORDER BY Fare DESC) AS FareRank,DENSE_RANK() OVER(PARTITION BY FlightID ORDER BY Fare DESC) AS DenseRank,ROW_NUMBER() OVER(PARTITION BY FlightID ORDER BY Fare DESC,BookingID) AS RowNum FROM dbo.AirlineBookings), R AS(SELECT *,SUM(Fare) OVER(PARTITION BY FlightID ORDER BY BookingDate,BookingID ROWS UNBOUNDED PRECEDING) AS RunningRevenue FROM Ranked)
SELECT FlightID,PassengerName,SeatNo,Fare,FareRank,DenseRank,RowNum,RunningRevenue FROM R ORDER BY FlightID,Fare DESC,BookingID;
GO
/* RANK tied values share rank and leave gaps (1,1,3); DENSE_RANK ties share rank without gaps (1,1,2); ROW_NUMBER is unique. Task 5 MongoDB transaction shown in JS file. */
