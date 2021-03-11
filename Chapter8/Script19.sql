SELECT COUNT(*) AS [Sessions]
FROM sys.dm_exec_connections;

--If you're analyzing a SQL Server workload, modify the query to focus on a specific database. 
--This query helps you determine possible session needs for the database if you are considering moving it to Azure.

SELECT COUNT(*) AS [Sessions]
FROM sys.dm_exec_connections C
INNER JOIN sys.dm_exec_sessions S ON (S.session_id = C.session_id)
INNER JOIN sys.databases D ON (D.database_id = S.database_id)
WHERE D.name = 'MyDatabase';

