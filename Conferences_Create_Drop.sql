

-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2019-01-08 17:01:22.679

-- tables
-- Table: Attendees
CREATE TABLE Attendees (
    AttendeeID int  NOT NULL,
    FirstName varchar(50)  NULL,
    LastName varchar(50)  NULL,
    CustomerID int  NOT NULL,
    CONSTRAINT Attendees_pk PRIMARY KEY  (AttendeeID)
);

-- Table: Conferences
CREATE TABLE Conferences (
    ConferenceID int  NOT NULL,
    TookPlace bit  NOT NULL,
    Description nvarchar(200)  NULL,
    CONSTRAINT Conferences_pk PRIMARY KEY  (ConferenceID)
);

-- Table: ConferencesAttendees
CREATE TABLE ConferencesAttendees (
    ConferenceAttendeeID int  NOT NULL,
    AttendeeID int  NOT NULL,
    ConferenceReservationID int  NOT NULL,
    CONSTRAINT ConferencesAttendees_pk PRIMARY KEY  (ConferenceAttendeeID)
);

-- Table: ConferencesDays
CREATE TABLE ConferencesDays (
    ConferenceDayID int  NOT NULL,
    ConferenceID int  NOT NULL,
    Day date  NOT NULL,
    SeatNo int  NOT NULL,
    BasicPrice money  NOT NULL,
    PricingLevelID int  NOT NULL,
    EnrollmentStartDay date  NOT NULL,
    CONSTRAINT ConferencesDays_pk PRIMARY KEY  (ConferenceDayID)
);

-- Table: ConferencesReservations
CREATE TABLE ConferencesReservations (
    ConferenceReservationID int  NOT NULL,
    OrderID int  NOT NULL,
    ConferenceDayID int  NOT NULL,
    CONSTRAINT ConferencesReservations_pk PRIMARY KEY  (ConferenceReservationID)
);

-- Table: Customers
CREATE TABLE Customers (
    CustomerID int  NOT NULL,
    Name nvarchar(50)  NOT NULL,
    NIP char(10)  NULL,
    IsCompany bit  NOT NULL,
    Phone varchar(12)  NOT NULL,
    CONSTRAINT Customers_pk PRIMARY KEY  (CustomerID)
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID int  NOT NULL,
    OrderDate date  NOT NULL,
    CustomerID int  NOT NULL,
    PaymentID int  NULL,
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);

-- Table: Payments
CREATE TABLE Payments (
    PaymentID int  NOT NULL,
    PaymentDay date  NOT NULL,
    Value money  NOT NULL,
    CONSTRAINT Payments_pk PRIMARY KEY  (PaymentID)
);

-- Table: PricingLevels
CREATE TABLE PricingLevels (
    PricingLevelID int  NOT NULL,
    StartDay smallint  NOT NULL,
    Discount decimal(4,3)  NOT NULL,
    CONSTRAINT PricingLevels_pk PRIMARY KEY  (PricingLevelID)
);

-- Table: Students
CREATE TABLE Students (
    CardNo int  NOT NULL,
    AttendeeID int  NOT NULL,
    CONSTRAINT Students_pk PRIMARY KEY  (CardNo)
);

-- Table: Workshops
CREATE TABLE Workshops (
    WorkshopID int  NOT NULL,
    StartTime time(0)  NOT NULL,
    Duration time(0)  NOT NULL,
    SeatNo int  NOT NULL,
    ConferenceDayID int  NOT NULL,
    Price money  NOT NULL,
    IsCancelled bit  NOT NULL,
    EnrollmentStartDay date  NOT NULL,
    CONSTRAINT Workshops_pk PRIMARY KEY  (WorkshopID)
);

-- Table: WorkshopsAttendees
CREATE TABLE WorkshopsAttendees (
    WorkshopAttendeeID int  NOT NULL,
    ConferenceAttendeeID int  NOT NULL,
    WorkshopReservationID int  NOT NULL,
    CONSTRAINT WorkshopsAttendees_pk PRIMARY KEY  (WorkshopAttendeeID)
);

-- Table: WorkshopsReservations
CREATE TABLE WorkshopsReservations (
    WorkshopReservationID int  NOT NULL,
    WorkshopID int  NOT NULL,
    OrderID int  NOT NULL,
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

