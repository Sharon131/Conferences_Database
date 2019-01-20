USE ConferencesDB
GO

IF OBJECT_ID ('fn_checkIsPhoneNumber', 'FN') IS NOT NULL
-- deletes function
    DROP FUNCTION dbo.fn_checkIsPhoneNumber
GO

CREATE OR ALTER FUNCTION fn_checkIsPhoneNumber(@phone varchar(20))
RETURNS numeric
AS
BEGIN
	IF @phone NOT LIKE '%[^0-9 +-]%' -- limit text only to the
		BEGIN
			-- check if there is at most one '+'
			IF LEN(@phone) - LEN(REPLACE(@phone,'+','')) > 1
				RETURN 0;
			IF PATINDEX('%+%', @phone) > 1 -- note: first idx is 1
				RETURN 0;
			IF PATINDEX('% %', @phone) = 1
				RETURN 0;
			IF PATINDEX('%-%', @phone) = 1
				RETURN 0;
			IF @phone LIKE '%[+ -]'
				RETURN 0;
			RETURN 1;
		END
	RETURN 0;
END;
GO



-- Lista osobowa uczestnikow na dzien konferencji
IF OBJECT_ID ('fn_getAttendeesForConferenceDay', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_getAttendeesForConferenceDay
GO

CREATE FUNCTION dbo.fn_getAttendeesForConferenceDay (@conferenceId INTEGER)
RETURNS TABLE
AS
RETURN
(
   SELECT cat.ConferenceAttendeeID, atn.FirstName, atn.LastName, cf.[Description], cd.ConferenceDayID, cd.Day
    FROM ConferencesDays AS cd
    LEFT OUTER JOIN Conferences AS cf
    ON cf.ConferenceID = cd.ConferenceID
    LEFT OUTER JOIN ConferencesReservations AS cr
    ON cr.ConferenceDayID = cd.ConferenceDayID
    LEFT OUTER JOIN ConferencesAttendees cat
    ON cat.ConferenceReservationID = cr.ConferenceReservationID
    LEFT OUTER JOIN Attendees AS atn
	ON atn.AttendeeID = cat.AttendeeID
    WHERE cd.ConferenceID = @conferenceId
	ORDER BY LastName ASC
);
GO

-- TODO list osobowa uczestnikow na dany warsztat
