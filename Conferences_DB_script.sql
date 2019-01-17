-- Last modification date on vertabelo: 2019-01-08 17:01:22.679
USE master
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name='ConferencesDB')
	DROP DATABASE ConferencesDB;

CREATE DATABASE ConferencesDB;
GO

USE ConferencesDB
GO
-- tables
-- Table: Attendees

IF OBJECT_ID('dbo.Attendees','U') IS NOT NULL
BEGIN
--removal of foreign key from ConferencesAttendees table
	IF OBJECT_ID('ConferencesAttendees_Attendees', 'F') IS NOT NULL
		ALTER TABLE dbo.ConferencesAttendees
			DROP CONSTRAINT ConferencesAttendees_Attendees;
--removal of foreign key from Students table			
	IF OBJECT_ID('Students_Attendees', 'F') IS NOT NULL
		ALTER TABLE dbo.Students
			DROP CONSTRAINT Students_Attendees;

	DROP TABLE dbo.Attendees; 
END

CREATE TABLE Attendees (
    AttendeeID	int	 IDENTITY	NOT NULL,
    FirstName	varchar(50)		NULL,
    LastName	varchar(50)		NULL,
    CustomerID  int				NOT NULL,
    CONSTRAINT Attendees_pk PRIMARY KEY  (AttendeeID)
);

-- Table: Conferences

IF OBJECT_ID('dbo.Conferences','U') IS NOT NULL
BEGIN
--removal of foreign key from ConferencesDays table	
	IF OBJECT_ID('ConferencesDays_Conferences','F') IS NOT NULL
		ALTER TABLE dbo.ConferencesDays
			DROP CONSTRAINT ConferencesDays_Conferences;

	DROP TABLE dbo.Conferences;
END

CREATE TABLE Conferences (
    ConferenceID int  IDENTITY  NOT NULL,
    TookPlace	 bit			NOT NULL,
    Description  nvarchar(200)  NULL,
    CONSTRAINT Conferences_pk PRIMARY KEY  (ConferenceID)
);

-- Table: ConferencesAttendees

IF OBJECT_ID('dbo.ConferencesAttendees', 'U') IS NOT NULL
BEGIN
--removal of foreign key from WorkshopsAttendees table
	IF OBJECT_ID('WorkshopsAttendees_ConferencesAttendees','F') IS NOT NULL
		ALTER TABLE dbo.WorkshopsAttendees
			DROP CONSTRAINT WorkshopsAttendees_Conferences_Attendees;

	DROP TABLE dbo.ConferencesAttendees;
END

CREATE TABLE ConferencesAttendees (
    ConferenceAttendeeID	int   IDENTITY	NOT NULL,
    AttendeeID				int				NOT NULL,
    ConferenceReservationID int				NOT NULL,
    CONSTRAINT ConferencesAttendees_pk PRIMARY KEY  (ConferenceAttendeeID)
);

-- Table: ConferencesDays

IF OBJECT_ID('dbo.ConferencesDays','U') IS NOT NULL
BEGIN
--removal of foreign key from ConferencesReservations table
	IF OBJECT_ID('ConferencesReservations_ConferencesDays','F') IS NOT NULL
		ALTER TABLE dbo.ConferencesReservations
			DROP CONSTRAINT ConferencesReservations_Conferences_Days;
--removal of foreign key from Workshops table	
	IF OBJECT_ID('Workshops_ConferencesDays','F') IS NOT NULL
		ALTER TABLE dbo.Workshops
			DROP CONSTRAINT Workshops_ConferencesDays;

	DROP TABLE dbo.ConferencesDays;
END

CREATE TABLE ConferencesDays (
    ConferenceDayID		int IDENTITY NOT NULL,
    ConferenceID		int			NOT NULL,
    Day					date		NOT NULL,
    SeatNo				int			NOT NULL,
    BasicPrice			money		NOT NULL,
    PricingLevelID		int			NOT NULL,
    EnrollmentStartDay	date		NOT NULL,
    CONSTRAINT ConferencesDays_pk PRIMARY KEY  (ConferenceDayID)
);

-- Table: ConferencesReservations

IF OBJECT_ID('dbo.ConferencesReservations','U') IS NOT NULL
	DROP TABLE dbo.ConferencesReservations;

CREATE TABLE ConferencesReservations (
    ConferenceReservationID int IDENTITY NOT NULL,
    OrderID					int			NOT NULL,
    ConferenceDayID			int			NOT NULL,
    CONSTRAINT ConferencesReservations_pk PRIMARY KEY  (ConferenceReservationID)
);

-- Table: Customers

IF OBJECT_ID('dbo.Customers','U') IS NOT NULL
BEGIN
--removal of foreign key from Orders table
	IF OBJECT_ID('Orders_Customers','F') IS NOT NULL
		ALTER TABLE Orders
			DROP CONSTRAINT Orders_Customers;
	
	DROP TABLE dbo.Customers;
END

CREATE TABLE Customers (
    CustomerID	int   IDENTITY	NOT NULL,
    Name		nvarchar(50)	NOT NULL,
    NIP			char(10)		NULL,
    IsCompany	bit				NOT NULL,
    Phone		varchar(12)		NOT NULL,
    CONSTRAINT Customers_pk PRIMARY KEY  (CustomerID)
);


--tests -to be romoved from this file
--tests start

--test start for checkIfNIPConsistOfDigitsOnly constraint in Customers table
USE ConferencesDB

DELETE FROM Customers
WHERE CustomerID IN (
SELECT CustomerID
FROM Customers
)

SELECT * FROM Customers

SELECT * FROM Customers
INSERT Customers(Name, NIP, Phone, IsCompany)
VALUES ('Jan Kowalski', '0123456789','012345678901', '1')
GO

SELECT * FROM Customers
INSERT Customers(Name, NIP, Phone, IsCompany)
VALUES ('Jan Kowalski', 'qwertyuiop','012345678901', '1')
GO
--test end for checkIfNIPConsistOfDigitsOnly constraint in Customers table

--tests end

-- Table: Orders

IF OBJECT_ID('dbo.Orders','U') IS NOT NULL
BEGIN
--removal of foreign key from WokrshopsReservationsOrders table
	IF OBJECT_ID('WorkshopsReservations_Orders','F') IS NOT NULL
		ALTER TABLE WorkshopsReservations
			DROP CONSTRAINT WorkshopsReservations_Orders;
--removal of foreign key from ConferencesReservations table
	IF OBJECT_ID('ConferencesReservations_Orders','F') IS NOT NULL
		ALTER TABLE ConferencesReservations
			DROP CONSTRAINT ConferencesReservations_Orders;

	DROP TABLE dbo.Orders;
END

CREATE TABLE Orders (
    OrderID		int   IDENTITY	NOT NULL,
    OrderDate	date			NOT NULL,
    CustomerID	int				NOT NULL,
    PaymentID	int				NULL,
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);

-- Table: Payments

IF OBJECT_ID('dbo.Payments', 'U') IS NOT NULL
	DROP TABLE dbo.Payments;

CREATE TABLE Payments (
    PaymentID	int   IDENTITY	NOT NULL,
    PaymentDay	date			NOT NULL,
    Value		money			NOT NULL,
    CONSTRAINT Payments_pk PRIMARY KEY  (PaymentID)
);

-- Table: PricingLevels

IF OBJECT_ID('dbo.PricingLevels', 'U') IS NOT NULL
	DROP TABLE dbo.PricingLevels;

CREATE TABLE PricingLevels (
    PricingLevelID	int	 IDENTITY	NOT NULL,
    StartDay		smallint		NOT NULL,
    Discount		decimal(4,3)	NOT NULL,
    CONSTRAINT PricingLevels_pk PRIMARY KEY  (PricingLevelID)
);

-- Table: Students

IF OBJECT_ID('dbo.Students', 'U') IS NOT NULL
	DROP TABLE dbo.Students;

CREATE TABLE Students (
    CardNo		int   IDENTITY	NOT NULL,
    AttendeeID	int				NOT NULL,
    CONSTRAINT Students_pk PRIMARY KEY  (CardNo)
);

-- Table: Workshops

IF OBJECT_ID('dbo.Workshops', 'U') IS NOT NULL
BEGIN
--removal of foreign key from WorkshopsReservations table
	IF OBJECT_ID('WorkshopsReservations_Workshops','F') IS NOT NULL
		ALTER TABLE WorkshopsReservations
			DROP CONSTRAINT WorkshopsReservations_Workshops;

	DROP TABLE dbo.Workshops;
END

CREATE TABLE Workshops (
    WorkshopID			int   IDENTITY	NOT NULL,
    StartTime			time(0)			NOT NULL,
    Duration			time(0)			NOT NULL,
    SeatNo				int				NOT NULL,
    ConferenceDayID		int				NOT NULL,
    Price				money			NOT NULL,
    IsCancelled			bit				NOT NULL,
    EnrollmentStartDay	date			NOT NULL,
    CONSTRAINT Workshops_pk PRIMARY KEY  (WorkshopID)
);

-- Table: WorkshopsAttendees

IF OBJECT_ID('dbo.WorkshopsAttendees','U') IS NOT NULL
	DROP TABLE dbo.WorkshopsAttendees;

CREATE TABLE WorkshopsAttendees (
    WorkshopAttendeeID		int   IDENTITY	NOT NULL,
    ConferenceAttendeeID	int				NOT NULL,
    WorkshopReservationID	int				NOT NULL,
    CONSTRAINT WorkshopsAttendees_pk PRIMARY KEY  (WorkshopAttendeeID)
);

-- Table: WorkshopsReservations

IF OBJECT_ID('dbo.WorkshopsReservations','U') IS NOT NULL
	DROP TABLE dbo.WorkshopsReservations;


CREATE TABLE WorkshopsReservations (
    WorkshopReservationID	int IDENTITY NOT NULL,
    WorkshopID				int			NOT NULL,
    OrderID					int			NOT NULL,
    CONSTRAINT WorkshopsReservations_pk PRIMARY KEY  (WorkshopReservationID)
);

-- creation of foreign keys
-- Reference: Attendees_Customers (table: Attendees)
ALTER TABLE Attendees ADD CONSTRAINT Attendees_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: ConferencesAttendees_Attendees (table: ConferencesAttendees)
ALTER TABLE ConferencesAttendees ADD CONSTRAINT ConferencesAttendees_Attendees
    FOREIGN KEY (AttendeeID)
    REFERENCES Attendees (AttendeeID);

-- Reference: ConferencesAttendees_ConferencesReservations (table: ConferencesAttendees)
ALTER TABLE ConferencesAttendees ADD CONSTRAINT ConferencesAttendees_ConferencesReservations
    FOREIGN KEY (ConferenceReservationID)
    REFERENCES ConferencesReservations (ConferenceReservationID);

-- Reference: ConferencesDays_Conferences (table: ConferencesDays)
ALTER TABLE ConferencesDays ADD CONSTRAINT ConferencesDays_Conferences
    FOREIGN KEY (ConferenceID)
    REFERENCES Conferences (ConferenceID);

-- Reference: ConferencesDays_PricingLevels (table: ConferencesDays)
ALTER TABLE ConferencesDays ADD CONSTRAINT ConferencesDays_PricingLevels
    FOREIGN KEY (PricingLevelID)
    REFERENCES PricingLevels (PricingLevelID);

-- Reference: ConferencesReservations_ConferencesDays (table: ConferencesReservations)
ALTER TABLE ConferencesReservations ADD CONSTRAINT ConferencesReservations_ConferencesDays
    FOREIGN KEY (ConferenceDayID)
    REFERENCES ConferencesDays (ConferenceDayID);

-- Reference: ConferencesReservations_Orders (table: ConferencesReservations)
ALTER TABLE ConferencesReservations ADD CONSTRAINT ConferencesReservations_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

--adding check constraint to NIP column of Customers table
ALTER TABLE Customers 
ADD CONSTRAINT checkIfNIPConsistOfDigitsOnly CHECK (IsNumeric(NIP) = 1);

--adding default value constraint to IsCompany column of Customers table
ALTER TABLE Customers
ADD CONSTRAINT defaultValueForIsCompany DEFAULT 1 for IsCompany; 

-- Reference: Orders_Customers (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: Orders_Payments (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Payments
    FOREIGN KEY (PaymentID)
    REFERENCES Payments (PaymentID);

--adding check constraint to Discount column of PricingLevels table
ALTER TABLE PricingLevels
ADD CONSTRAINT checkIfDiscountIsEqualOrLowerThanOne CHECK (Discount <= 1);

-- Reference: Students_Attendees (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Attendees
    FOREIGN KEY (AttendeeID)
    REFERENCES Attendees (AttendeeID);

--adding check constraint to CardNo column of Students table
ALTER TABLE Students
ADD CONSTRAINT checkIfCardNoConsistOfDigitsOnly CHECK (IsNumeric(CardNo) = 1);

USE ConferencesDB
ALTER TABLE Students 
DROP CONSTRAINT checkIfCardNoConsistOfDigitsOnly

-- Reference: WorkshopsAttendees_ConferencesAttendees (table: WorkshopsAttendees)
ALTER TABLE WorkshopsAttendees ADD CONSTRAINT WorkshopsAttendees_ConferencesAttendees
    FOREIGN KEY (ConferenceAttendeeID)
    REFERENCES ConferencesAttendees (ConferenceAttendeeID);


-- Reference: WorkshopsAttendees_WorkshopsReservations (table: WorkshopsAttendees)
ALTER TABLE WorkshopsAttendees ADD CONSTRAINT WorkshopsAttendees_WorkshopsReservations
    FOREIGN KEY (WorkshopReservationID)
    REFERENCES WorkshopsReservations (WorkshopReservationID);

-- Reference: WorkshopsReservations_Orders (table: WorkshopsReservations)
ALTER TABLE WorkshopsReservations ADD CONSTRAINT WorkshopsReservations_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: WorkshopsReservations_Workshops (table: WorkshopsReservations)
ALTER TABLE WorkshopsReservations ADD CONSTRAINT WorkshopsReservations_Workshops
    FOREIGN KEY (WorkshopID)
    REFERENCES Workshops (WorkshopID);

-- Reference: Workshops_ConferencesDays (table: Workshops)
ALTER TABLE Workshops ADD CONSTRAINT Workshops_ConferencesDays
    FOREIGN KEY (ConferenceDayID)
    REFERENCES ConferencesDays (ConferenceDayID);

--Procedury do wprawadzania danych
--Dodanie rejestracji uczestnika (Attendee) na dany dzien konferencji
SET ANSI_NULLS ON 
GO 
SET QUOTED_IDENTIFIER ON 
GO 
--https://docs.microsoft.com/en-us/sql/t-sql/statements/set-ansi-nulls-transact-sql?view=sql-server-2017
--CREATE PROCEDURE [dbo].[ConferencesReservations]



-- End of file.