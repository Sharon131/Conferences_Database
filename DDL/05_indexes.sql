USE ConferencesDB
GO

IF ((SELECT COUNT(*)
FROM sys.indexes
WHERE name='idx_customername' AND object_id = OBJECT_ID('dbo.Customers')) = 1)
DROP INDEX idx_customername ON Customers
GO

CREATE INDEX idx_customername
ON Customers (Name);