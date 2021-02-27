CREATE TABLE dbo.DemoTable( 
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 SearchString1 NVARCHAR(100), 
 SearchString2 NVARCHAR(100))
GO

INSERT INTO dbo.DemoTable (SearchString1, SearchString2)
SELECT TOP 10000 NEWID(), NEWID()
FROM SYS.all_columns SC1 
    CROSS JOIN SYS.all_columns SC2
GO 

INSERT INTO dbo.DemoTable (SearchString1, SearchString2)
SELECT TOP 20000 'SQL Server', NEWID()
FROM SYS.all_columns SC1
        CROSS JOIN SYS.all_columns SC2

CREATE INDEX IX_DemoTable_SearchString1 on dbo.DemoTable (SearchString1)
GO

CREATE PROCEDURE dbo.GetDataSearchString1
(@SearchString1 AS NVARCHAR(100))
AS
BEGIN
    SELECT * FROM dbo.DemoTable 
    WHERE SearchString1 = @SearchString1
END
