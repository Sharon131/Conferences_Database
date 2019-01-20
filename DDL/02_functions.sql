USE ConferencesDB
GO

IF OBJECT_ID ('FnCheckIsPhoneNumber', 'FN') IS NOT NULL
-- deletes function
    DROP FUNCTION dbo.FnCheckIsPhoneNumber
GO

CREATE OR ALTER FUNCTION FnCheckIsPhoneNumber(@phone varchar(20))
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
