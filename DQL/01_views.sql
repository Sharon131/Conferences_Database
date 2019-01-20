USE ConferencesDB
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

-- TODO lista klientow najczesciej korzystajacych z ich uslug

