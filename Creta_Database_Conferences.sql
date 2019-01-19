use Conferences


-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2018-12-31 18:08:57.55

-- tables

-- Table: Attendees

IF OBJECT_ID('dbo.Attendees','U') IS NOT NULL
BEGIN
	IF OBJECT_ID('Conferences_Attendees_Attendees', 'F') IS NOT NULL
		ALTER TABLE dbo.Conferences_Attendees
			DROP CONSTRAINT Conferences_Attendees_Attendees;
			
	IF OBJECT_ID('Attendees_Student', 'F') IS NOT NULL
		ALTER TABLE dbo.Student
			DROP CONSTRAINT Attendees_Student;

	DROP TABLE dbo.Attendees; 
END

CREATE TABLE Attendees (
    AttendeeID int  NOT NULL,
    First_Name varchar(50)  NULL,
    Last_Name varchar(50)  NULL,
    CustomerID int  NOT NULL,
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
    ConferenceID int  NOT NULL,
    Happened bit  NOT NULL,
    Description nvarchar(200)  NULL,
    CONSTRAINT Conferences_pk PRIMARY KEY  (ConferenceID)
);

-- Table: Conferences_Attendees

IF OBJECT_ID('dbo.Conferences_Attendees', 'U') IS NOT NULL
BEGIN
	IF OBJECT_ID('Workshops_Attendees_Conferences_Attendees','F') IS NOT NULL
		ALTER TABLE dbo.Workshops_Attendees
			DROP CONSTRAINT Workshops_Attendees_Conferences_Attendees;

	DROP TABLE dbo.Conferences_Attendees;
END


CREATE TABLE Conferences_Attendees (
    ConferenceAttendeeID int  NOT NULL,
    AttendeeID int  NOT NULL,
    ConferenceReservationID int  NOT NULL,
    CONSTRAINT Conferences_Attendees_pk PRIMARY KEY  (ConferenceAttendeeID)
);

-- Table: Conferences_Days

IF OBJECT_ID('dbo.Conferences_Days','U') IS NOT NULL
BEGIN
	IF OBJECT_ID('Conferences_Reservations_Conferences_Days','F') IS NOT NULL
		ALTER TABLE dbo.Conferences_Reservations
			DROP CONSTRAINT Conferences_Reservations_Conferences_Days;
	
	IF OBJECT_ID('Conferences_Days_Workshops','F') IS NOT NULL
		ALTER TABLE dbo.Workshops
			DROP CONSTRAINT Conferences_Days_Workshops;

	DROP TABLE dbo.Conferences_Days;
END

CREATE TABLE Conferences_Days (
    ConferenceDayID int  NOT NULL,
    ConferenceID int  NOT NULL,
    Day date  NOT NULL,
    Seats_no int  NOT NULL,
    BasicPrice money  NOT NULL,
    PricingLevelID int  NOT NULL,
    EnrollmentStartDay date  NOT NULL,
    CONSTRAINT Conferences_Days_pk PRIMARY KEY  (ConferenceDayID)
);

-- Table: Conferences_Reservations

IF OBJECT_ID('dbo.Conferences_Reservations','U') IS NOT NULL
	DROP TABLE dbo.Conferences_Reservations;

CREATE TABLE Conferences_Reservations (
    ConferenceReservationID int  NOT NULL,
    OrderID int  NOT NULL,
    ConferenceDayID int  NOT NULL,
    CONSTRAINT Conferences_Reservations_pk PRIMARY KEY  (ConferenceReservationID)
);

-- Table: Customer

IF OBJECT_ID('dbo.Customer','U') IS NOT NULL
BEGIN
	IF OBJECT_ID('Orders_Customer','F') IS NOT NULL
		ALTER TABLE Orders
			DROP CONSTRAINT Orders_Customer;
	
	DROP TABLE dbo.Customer;
END

CREATE TABLE Customer (
    CustomerID int  NOT NULL,
    Name nvarchar(50)  NOT NULL,
    NIP char(10)  NULL,
    IsCompany bit  NOT NULL,
    Phone varchar(12)  NOT NULL,
    CONSTRAINT Customer_pk PRIMARY KEY  (CustomerID)
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
    OrderID int  NOT NULL,
    OrderDate date  NOT NULL,
    CustomerID int  NOT NULL,
    PaymentID int  NULL,
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);

-- Table: Payments

IF OBJECT_ID('dbo.Payments', 'U') IS NOT NULL
	DROP TABLE dbo.Payments;

CREATE TABLE Payments (
    PaymentID int  NOT NULL,
    PaymentDay date  NOT NULL,
    Value money  NOT NULL,
    CONSTRAINT Payments_pk PRIMARY KEY  (PaymentID)
);

-- Table: Pricing_Levels

IF OBJECT_ID('dbo.Pricing_Levels', 'U') IS NOT NULL
	DROP TABLE dbo.Pricing_Levels;

CREATE TABLE Pricing_Levels (
    PricingLevelID int  NOT NULL,
    StartDay smallint  NOT NULL,
    Discount decimal(4,3)  NOT NULL,
    CONSTRAINT Pricing_Levels_pk PRIMARY KEY  (PricingLevelID)
);

-- Table: Student

IF OBJECT_ID('dbo.Student', 'U') IS NOT NULL
	DROP TABLE dbo.Student;

CREATE TABLE Student (
    Card_no int  NOT NULL,
    AttendeeID int  NOT NULL,
    CONSTRAINT Student_pk PRIMARY KEY  (Card_no)
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
    WorkshopID int  NOT NULL,
    Start_time time(0)  NOT NULL,
    Duration time(0)  NOT NULL,
    Seats_no int  NOT NULL,
    ConferenceDayID int  NOT NULL,
    Price money  NOT NULL,
    isCancelled bit  NOT NULL,
    EnrollmentStartDay date  NOT NULL,
    CONSTRAINT Workshops_pk PRIMARY KEY  (WorkshopID)
);

-- Table: Workshops_Attendees

IF OBJECT_ID('dbo.Workshops_Attendees','U') IS NOT NULL
	DROP TABLE dbo.Workshops_Attendees;

CREATE TABLE Workshops_Attendees (
    WorkshopAttendeeID int  NOT NULL,
    ConferenceAttendeeID int  NOT NULL,
    WorkshopReservationID int  NOT NULL,
    CONSTRAINT Workshops_Attendees_pk PRIMARY KEY  (WorkshopAttendeeID)
);

-- Table: Workshops_Reservations

IF OBJECT_ID('dbo.Workshops_Reservations','U') IS NOT NULL
	DROP TABLE dbo.Workshops_Reservations;

CREATE TABLE Workshops_Reservations (
    WorkshopReservationID int  NOT NULL,
    OrderID int  NOT NULL,
    WorkShopID int  NOT NULL,
    CONSTRAINT Workshops_Reservations_pk PRIMARY KEY  (WorkshopReservationID)
);

-- foreign keys
-- Reference: Attendees_Customer (table: Attendees)
ALTER TABLE Attendees ADD CONSTRAINT Attendees_Customer
    FOREIGN KEY (CustomerID)
    REFERENCES Customer (CustomerID);

-- Reference: Attendees_Student (table: Student)
ALTER TABLE Student ADD CONSTRAINT Attendees_Student
    FOREIGN KEY (AttendeeID)
    REFERENCES Attendees (AttendeeID);

-- Reference: Conferences_Attendees_Attendees (table: Conferences_Attendees)
ALTER TABLE Conferences_Attendees ADD CONSTRAINT Conferences_Attendees_Attendees
    FOREIGN KEY (AttendeeID)
    REFERENCES Attendees (AttendeeID);

-- Reference: Conferences_Attendees_Conferences_Reservations (table: Conferences_Attendees)
ALTER TABLE Conferences_Attendees ADD CONSTRAINT Conferences_Attendees_Conferences_Reservations
    FOREIGN KEY (ConferenceReservationID)
    REFERENCES Conferences_Reservations (ConferenceReservationID);

-- Reference: Conferences_Days_Conferences (table: Conferences_Days)
ALTER TABLE Conferences_Days ADD CONSTRAINT Conferences_Days_Conferences
    FOREIGN KEY (ConferenceID)
    REFERENCES Conferences (ConferenceID);

-- Reference: Conferences_Days_Pricing_Levels (table: Conferences_Days)
ALTER TABLE Conferences_Days ADD CONSTRAINT Conferences_Days_Pricing_Levels
    FOREIGN KEY (PricingLevelID)
    REFERENCES Pricing_Levels (PricingLevelID);

-- Reference: Conferences_Days_Workshops (table: Workshops)
ALTER TABLE Workshops ADD CONSTRAINT Conferences_Days_Workshops
    FOREIGN KEY (ConferenceDayID)
    REFERENCES Conferences_Days (ConferenceDayID);

-- Reference: Conferences_Reservations_Conferences_Days (table: Conferences_Reservations)
ALTER TABLE Conferences_Reservations ADD CONSTRAINT Conferences_Reservations_Conferences_Days
    FOREIGN KEY (ConferenceDayID)
    REFERENCES Conferences_Days (ConferenceDayID);

-- Reference: Conferences_Reservations_Orders (table: Conferences_Reservations)
ALTER TABLE Conferences_Reservations ADD CONSTRAINT Conferences_Reservations_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: Orders_Customer (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Customer
    FOREIGN KEY (CustomerID)
    REFERENCES Customer (CustomerID);

-- Reference: Payments_Orders (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Payments_Orders
    FOREIGN KEY (PaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: Workshops_Attendees_Conferences_Attendees (table: Workshops_Attendees)
ALTER TABLE Workshops_Attendees ADD CONSTRAINT Workshops_Attendees_Conferences_Attendees
    FOREIGN KEY (ConferenceAttendeeID)
    REFERENCES Conferences_Attendees (ConferenceAttendeeID);

-- Reference: Workshops_Attendees_Workshops_Reservations (table: Workshops_Attendees)
ALTER TABLE Workshops_Attendees ADD CONSTRAINT Workshops_Attendees_Workshops_Reservations
    FOREIGN KEY (WorkshopReservationID)
    REFERENCES Workshops_Reservations (WorkshopReservationID);

-- Reference: Workshops_Reservations_Orders (table: Workshops_Reservations)
ALTER TABLE Workshops_Reservations ADD CONSTRAINT Workshops_Reservations_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: Workshops_Reservations_Workshops (table: Workshops_Reservations)
ALTER TABLE Workshops_Reservations ADD CONSTRAINT Workshops_Reservations_Workshops
    FOREIGN KEY (WorkShopID)
    REFERENCES Workshops (WorkshopID);

-- End of file.

