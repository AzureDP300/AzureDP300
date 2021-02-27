--You can use sys.server_resource_stats to return CPU usage, IO, and storage data for an Azure SQL Managed Instance. 
--The data is collected and aggregated within five-minute intervals. There is one row for every 15 seconds reporting.
--The data returned includes CPU usage, storage size, IO utilization, and managed instance SKU. Historical data is retained for approximately 14 days.
DECLARE @s datetime;  
DECLARE @e datetime;  
SET @s= DateAdd(d,-7,GetUTCDate());  
SET @e= GETUTCDATE();  
SELECT resource_name, AVG(avg_cpu_percent) AS Average_Compute_Utilization
FROM sys.server_resource_stats
WHERE start_time BETWEEN @s AND @e  
GROUP BY resource_name  
HAVING AVG(avg_cpu_percent) >= 80;
