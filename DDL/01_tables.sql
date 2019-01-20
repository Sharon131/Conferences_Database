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
		ALTER TABLE dbo.ConferencesAttendeescheckIfINIP
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
    Phone		varchar(20)		NOT NULL,
    CONSTRAINT Customers_pk PRIMARY KEY  (CustomerID)
);

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
    PaymentDate	date			NOT NULL,
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
    CardNo		int   UNIQUE	NOT NULL,
    AttendeeID	int	  UNIQUE	NOT NULL,
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
