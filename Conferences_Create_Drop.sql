-- Last modification date on vertabelo: 2019-01-08 17:01:22.679
USE master

IF EXISTS (SELECT * FROM sys.databases WHERE name='Conferences_Database')
	DROP DATABASE Conferences_Database;

CREATE DATABASE Conferences_Database;
GO

USE Conferences_Database

-- tables
-- Table: Attendees

IF OBJECT_ID('dbo.Attendees','U') IS NOT NULL
BEGIN
	IF OBJECT_ID('Conferences_Attendees_Attendees', 'F') IS NOT NULL
		ALTER TABLE dbo.Conferences_Attendees
			DROP CONSTRAINT Conferences_Attendees_Attendees;
			
	IF OBJECT_ID('Student_Attendees', 'F') IS NOT NULL
		ALTER TABLE dbo.Student
			DROP CONSTRAINT Student_Attendees;

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
	IF OBJECT_ID('Conferences_Days_Conferences','F') IS NOT NULL
		ALTER TABLE dbo.Conferences_Days
			DROP CONSTRAINT Conferences_Days_Conferences;

	DROP TABLE dbo.Conferences;
END

CREATE TABLE Conferences (
    ConferenceID int  IDENTITY  NOT NULL,
    TookPlace	 bit			NOT NULL,
    Description  nvarchar(200)  NULL,
    CONSTRAINT Conferences_pk PRIMARY KEY  (ConferenceID)
);

-- Table: ConferencesAttendees

IF OBJECT_ID('dbo.Conferences_Attendees', 'U') IS NOT NULL
BEGIN
	IF OBJECT_ID('Workshops_Attendees_Conferences_Attendees','F') IS NOT NULL
		ALTER TABLE dbo.Workshops_Attendees
			DROP CONSTRAINT Workshops_Attendees_Conferences_Attendees;

	DROP TABLE dbo.Conferences_Attendees;
END

CREATE TABLE ConferencesAttendees (
    ConferenceAttendeeID	int   IDENTITY	NOT NULL,
    AttendeeID				int				NOT NULL,
    ConferenceReservationID int				NOT NULL,
    CONSTRAINT ConferencesAttendees_pk PRIMARY KEY  (ConferenceAttendeeID)
);

-- Table: ConferencesDays

IF OBJECT_ID('dbo.Conferences_Days','U') IS NOT NULL
BEGIN
	IF OBJECT_ID('Conferences_Reservations_Conferences_Days','F') IS NOT NULL
		ALTER TABLE dbo.Conferences_Reservations
			DROP CONSTRAINT Conferences_Reservations_Conferences_Days;
	
	IF OBJECT_ID('Workshops_ConferencesDays','F') IS NOT NULL
		ALTER TABLE dbo.Workshops
			DROP CONSTRAINT Workshops_ConferencesDays;

	DROP TABLE dbo.Conferences_Days;
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

IF OBJECT_ID('dbo.Conferences_Reservations','U') IS NOT NULL
	DROP TABLE dbo.Conferences_Reservations;

CREATE TABLE ConferencesReservations (
    ConferenceReservationID int IDENTITY NOT NULL,
    OrderID					int			NOT NULL,
    ConferenceDayID			int			NOT NULL,
    CONSTRAINT ConferencesReservations_pk PRIMARY KEY  (ConferenceReservationID)
);

-- Table: Customers

IF OBJECT_ID('dbo.Customers','U') IS NOT NULL
BEGIN
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

-- Table: Orders

IF OBJECT_ID('dbo.Orders','U') IS NOT NULL
BEGIN
	IF OBJECT_ID('Workshops_Reservations_Orders','F') IS NOT NULL
		ALTER TABLE Workshops_Reservations
			DROP CONSTRAINT Workshops_Reservations_Orders;

	IF OBJECT_ID('Conferences_Reservations_Orders','F') IS NOT NULL
		ALTER TABLE Conferences_Reservations
			DROP CONSTRAINT Conferences_Reservations_Orders;

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

IF OBJECT_ID('dbo.Pricing_Levels', 'U') IS NOT NULL
	DROP TABLE dbo.Pricing_Levels;

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
	IF OBJECT_ID('Workshops_Reservations_Workshops','F') IS NOT NULL
		ALTER TABLE Workshops_Reservations
			DROP CONSTRAINT Workshops_Reservations_Workshops;

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

IF OBJECT_ID('dbo.Workshops_Attendees','U') IS NOT NULL
	DROP TABLE dbo.Workshops_Attendees;

CREATE TABLE WorkshopsAttendees (
    WorkshopAttendeeID		int   IDENTITY	NOT NULL,
    ConferenceAttendeeID	int				NOT NULL,
    WorkshopReservationID	int				NOT NULL,
    CONSTRAINT WorkshopsAttendees_pk PRIMARY KEY  (WorkshopAttendeeID)
);

-- Table: WorkshopsReservations

IF OBJECT_ID('dbo.Workshops_Reservations','U') IS NOT NULL
	DROP TABLE dbo.Workshops_Reservations;


CREATE TABLE WorkshopsReservations (
    WorkshopReservationID	int IDENTITY NOT NULL,
    WorkshopID				int			NOT NULL,
    OrderID					int			NOT NULL,
    CONSTRAINT WorkshopsReservations_pk PRIMARY KEY  (WorkshopReservationID)
);

-- foreign keys
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

-- Reference: Orders_Customers (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: Orders_Payments (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Payments
    FOREIGN KEY (PaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: Students_Attendees (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Attendees
    FOREIGN KEY (AttendeeID)
    REFERENCES Attendees (AttendeeID);

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

-- End of file.

