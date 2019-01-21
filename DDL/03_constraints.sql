USE ConferencesDB
GO
-- creation of foreign keys
-- Reference: Attendees_Customers (table: Attendees)
ALTER TABLE Attendees ADD CONSTRAINT Attendees_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

--adding default constraint to TookPlace column of Conferences table
ALTER TABLE Conferences
ADD CONSTRAINT TookPlaceDefault DEFAULT 0 FOR TookPlace;

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

--adding default constraint to BasicPrice column of ConferencesDays table
ALTER TABLE ConferencesDays
ADD CONSTRAINT DefaultForBasicPrice DEFAULT 0 FOR BasicPrice;

--adding default constraint to EnrollmentStartDay column of ConferencesDays table
ALTER TABLE ConferencesDays
ADD CONSTRAINT EnrollmentStartDayCheck CHECK(EnrollmentStartDay<=DayDate);

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
ADD CONSTRAINT isNipNumber CHECK (NIP NOT LIKE '%[^0-9]%');

ALTER TABLE Customers
ADD CONSTRAINT isPhoneNumber CHECK (dbo.fn_checkIsPhoneNumber(Phone) = 1);

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

--adding check constraint to OrderDate column of Orders table
ALTER TABLE Orders 
ADD CONSTRAINT CheckIfOrderDateIsFromPast CHECK(OrderDate <= getdate());

--adding check constraint to PaymentDate column of Payments table
ALTER TABLE Payments
ADD CONSTRAINT CheckIfPaymentDateIsFromPast CHECK(PaymentDate <= getdate());

--adding check constraint to Discount column of PricingLevels table
ALTER TABLE PricingLevels
ADD CONSTRAINT checkIfDiscountIsEqualOrLowerThanOne CHECK (Discount <= 1);

-- Reference: Students_Attendees (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Attendees
    FOREIGN KEY (AttendeeID)
    REFERENCES Attendees (AttendeeID);

--adding check constraint to CardNo column of Students table
--ALTER TABLE Students
--ADD CONSTRAINT checkIfCardNoConsistOfDigitsOnly CHECK (IsNumeric(CardNo) = 1);

--adding unique constraint to CardNo column of Students table
ALTER TABLE Students
ADD CONSTRAINT setCardNoToBeUnique UNIQUE (CardNo);

--adding unique constraint to AttendeeID column of Student table
ALTER TABLE Students
ADD CONSTRAINT setAttendeeIDToBeUnique UNIQUE (AttendeeID);

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

--adding default constraint to Duration column of Workshop table
ALTER TABLE Workshops
ADD CONSTRAINT DefaultForDuration DEFAULT '2:00:00' FOR Duration;

--adding default constraint to Price column of Workshop table
ALTER TABLE Workshops
ADD CONSTRAINT DefaultForPrice DEFAULT 50 FOR Price;
