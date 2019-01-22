use ConferencesDB
GO

IF EXISTS(SELECT *
          FROM sys.objects
          WHERE [name] = 'V_ATTENDEES_COUNT_PER_DAY' AND type = 'V')
  DROP VIEW [dbo].V_ATTENDEES_COUNT_PER_DAY
GO

CREATE VIEW V_ATTENDEES_COUNT_PER_DAY
AS
    SELECT cf.[Description], cd.ConferenceDayID, cd.DayDate, SeatNo, COUNT(cat.ConferenceAttendeeID) AS attendees_number
    FROM ConferencesDays AS cd
    LEFT OUTER JOIN Conferences AS cf
    ON cf.ConferenceID = cd.ConferenceID
    LEFT OUTER JOIN ConferencesReservations AS cr
    ON cr.ConferenceDayID = cd.ConferenceDayID
    LEFT OUTER JOIN ConferencesAttendees cat
    ON cat.ConferenceReservationID = cr.ConferenceReservationID
    GROUP BY cf.[Description], cd.ConferenceDayID, cd.DayDate, SeatNo
GO

IF EXISTS(SELECT *
          FROM sys.objects
          WHERE [name] = 'V_TopCustomers' AND type = 'V')
  DROP VIEW [dbo].V_TopCustomers
GO

CREATE VIEW V_Top_10_Customers
AS 
	select TOP 10 CustomerID, (select count(OrderID) from Orders as ord
	where ord.CustomerID = cus.CustomerID) as OrdersMade, 
	Name, IsCompany, NIP, Phone
	from Customers as cus
	order by OrdersMade desc;
GO


IF EXISTS(SELECT *
          FROM sys.objects
          WHERE [name] = 'V_CustomersPayments' AND type = 'V')
  DROP VIEW [dbo].V_CustomersPayments
GO

create view V_Customers_Payments
as 
select Customers.CustomerID, Name, Phone, OrderID, Payments.PaymentID, PaymentDate, Value
 from Customers
inner join Orders
on Orders.CustomerID = Customers.CustomerID
inner join Payments
on Payments.PaymentID = Orders.PaymentID
GO


IF EXISTS(SELECT *
          FROM sys.objects
          WHERE [name] = 'V_Attendees_Of_Workshops' AND type = 'V')
  DROP VIEW [dbo].V_Attendees_Of_Workshops
GO

create view V_Attendees_Of_Workshops
as
select Attendees.AttendeeID, FirstName, LastName, CustomerID, Workshops.WorkshopID from workshops
inner join WorkshopsReservations
on workshops.workshopID = WorkshopsReservations.WorkshopID
inner join WorkshopsAttendees
on WorkshopsAttendees.WorkshopReservationID = WorkshopsReservations.WorkshopReservationID
inner join ConferencesAttendees
on ConferencesAttendees.ConferenceAttendeeID = WorkshopsAttendees.ConferenceAttendeeID
inner join Attendees
on Attendees.AttendeeID = ConferencesAttendees.AttendeeID
where FirstName is not null;
GO


IF EXISTS(SELECT *
          FROM sys.objects
          WHERE [name] = 'V_Attendees_Of_Conferences' AND type = 'V')
  DROP VIEW [dbo].V_Attendees_Of_Conferences
GO

create view V_Attendees_Of_Conferences
as
select ConferencesDays.ConferenceDayID,
		Attendees.AttendeeID, FirstName, LastName
from Conferences
inner join ConferencesDays
on Conferences.ConferenceID = ConferencesDays.ConferenceID
inner join ConferencesReservations
on ConferencesReservations.ConferenceDayID = ConferencesDays.ConferenceDayID
inner join ConferencesAttendees
on ConferencesAttendees.ConferenceReservationID = ConferencesReservations.ConferenceReservationID
inner join Attendees
on Attendees.AttendeeID = ConferencesAttendees.AttendeeID
where FirstName is not null;
GO


