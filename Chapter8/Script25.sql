--The view sys.resource_stats is available in the master data and it helps to monitor performance as per specific service tier and compute size. 
--It collects data every 5 minutes and stores it upto 14 days retention. 
--Note: To monitor the Azure SQL Database, Connect to Master database using SSMS connection properties. 
--In this query, you need to enter your Azure database name. For example, in this below query, we are monitoring data for [AzureDemoDatabase]. 

SELECT TOP 10 *
FROM sys.resource_stats
WHERE database_name = 'azuredemodatabase'
ORDER BY start_time DESC;
