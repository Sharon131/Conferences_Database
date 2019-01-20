USE ConferencesDB
GO
--TRIGGERS
--check if PaymentDate is not from the future -if so, it is not inserted
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_checkIfPaymentDateIsNotFromTheFuture_Orders_InsteadOfInsert]'))
DROP TRIGGER [dbo].[tr_checkIfPaymentDateIsNotFromTheFuture_Orders_InsteadOfInsert]
GO

CREATE TRIGGER [dbo].[tr_checkIfPaymentDateIsNotFromTheFuture_Orders_InsteadOfInsert] 
   ON  [dbo].[Payments] 
   INSTEAD OF INSERT
AS 
BEGIN	
   IF((SELECT PaymentDate FROM Inserted) > GETDATE())
   BEGIN
      RAISERROR('The payment date you tried to insert can not be from the future. Statement terminated.', 16, 1)
      --RETURN
   END
   ELSE
   BEGIN
   INSERT INTO Payments(PaymentDate, [Value])
   SELECT PaymentDate, [Value] FROM inserted
   END
END
