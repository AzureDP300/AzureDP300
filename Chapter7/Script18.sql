SELECT COUNT(*) AS [Concurrent_Requests]
FROM sys.dm_exec_requests R;

--To analyze the workload of a SQL Server database, modify this query to filter on the specific database you want to analyze. 
--For example, if you have an on-premises database named MyDatabase, this Transact-SQL query returns the count of concurrent requests in that database:

SELECT COUNT(*) AS [Concurrent_Requests]
FROM sys.dm_exec_requests R
INNER JOIN sys.databases D ON D.database_id = R.database_id
AND D.name = 'MyDatabase';
