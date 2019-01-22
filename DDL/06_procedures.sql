USE ConferencesDB
GO

-- jak nie zwroci zera rekordow to procedura powinna przerwac transakcje
-- proba dodania uczestnika drugi raz na ten sam warsztat
-- EXECUTE proc_addAttendeeToWorkshopIfNotAssigned 272, 21

IF OBJECT_ID ( 'dbo.proc_addAttendeeToWorkshopIfNotAssigned', 'P' ) IS NOT NULL
    DROP PROCEDURE dbo.proc_addAttendeeToWorkshopIfNotAssigned;
GO

CREATE PROCEDURE dbo.proc_addAttendeeToWorkshopIfNotAssigned
    @conferenceAttendeeId INT,
    @workshopId INT
AS
BEGIN
SET NOCOUNT ON
IF EXISTS
    (SELECT wat.ConferenceAttendeeID, wat.WorkshopAttendeeID, cd.ConferenceDayID, ws.WorkshopID
    FROM ConferencesAttendees  AS cat
    JOIN ConferencesReservations AS cr
    ON cr.ConferenceReservationID = cat.ConferenceReservationID
    JOIN ConferencesDays AS cd
    ON cd.ConferenceDayID = cr.ConferenceDayID
    JOIN WorkshopsAttendees AS wat
    ON wat.ConferenceAttendeeID = cat.ConferenceAttendeeID
    JOIN Workshops AS ws
    ON ws.ConferenceDayID = cd.ConferenceDayID
    WHERE wat.ConferenceAttendeeID = @conferenceAttendeeId -- parametr
    	AND ws.WorkshopID = @workshopId -- 2 parametr
   )
  RAISERROR('Attendee with id %d is already assigned to the workshop %d', 16, 1,
			@conferenceAttendeeId,@workshopId)

ELSE
   PRINT FORMATMESSAGE('Attendee %d added to %d', @conferenceAttendeeId, @workshopId)
END;
GO

IF OBJECT_ID ( 'dbo.proc_Add_Conference', 'P' ) IS NOT NULL
    DROP PROCEDURE dbo.proc_Add_Conference;
GO

CREATE PROCEDURE dbo.proc_Add_Conference
	@description nvarchar(200)
AS
INSERT INTO Conferences(Description) VALUES(@description);
GO

IF OBJECT_ID ( 'dbo.proc_Add_Workshop', 'P' ) IS NOT NULL
    DROP PROCEDURE dbo.proc_Add_Workshop;
GO

CREATE PROCEDURE dbo.proc_Add_Workshop
	@start_time				time(0),
	@duration				time(0),
	@seat_no				int,
	@conference_day_id		int,
	@price					money,
	@enrollment_start_day	date
AS 
BEGIN
INSERT INTO Workshops(StartTime, Duration, SeatNo, ConferenceDayID, Price, EnrollmentStartDay)
VALUES(@start_time, @duration, @seat_no, @conference_day_id, @price, @enrollment_start_day)

END;
