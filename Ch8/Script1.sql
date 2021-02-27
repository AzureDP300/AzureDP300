SELECT 
   top(10)     
   database_name,  
   sku, 
   avg_cpu_percent, 
   avg_instance_cpu_percent,
   avg_data_io_percent, 
   avg_log_write_percent,
   max_worker_percent,
   max_session_percent,  
   storage_in_megabytes, 
   dtu_limit,  
   start_time,  
   end_time
FROM 
	sys.resource_stats 
order by 
	start_time DESC;

-- The data collection process runs with a frequency of 5 minutes. Azure retains 14 days’ worth of historical data. 

DECLARE @startime datetime;  
DECLARE @endtime datetime;  
SET @starttime= DateAdd(d,-2,GetUTCDate());  
SET @endtime= GETUTCDATE();  
SELECT 
database_name, 
AVG(avg_cpu_percent) Average_Compute_Utilization   
FROM sys.resource_stats   
WHERE start_time BETWEEN @starttime AND @endtime 
GROUP BY database_name  
HAVING 
AVG(avg_cpu_percent) >= 75  
