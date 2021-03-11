#define the connection string
$SqlConnection.ConnectionString = "Data Source=TCP:mydemodb3001d.database.windows.net,1433;Initial Catalog=Analytics;User ID=pjayaram@domain.com;Password=thanVitha@2021;MultipleActiveResultSets=False;Connect Timeout=30;Encrypt=True;TrustServerCertificate=False;Authentication='Active Directory Password';Application Name='MyTest'"
#Prepare the Query
$SqlQuery = 'SELECT TOP(10) * FROM [dbo].[device]'
# Build a connection to Azure SQL database.
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
#Represents a Transact-SQL statement or stored procedure to execute against a SQL Server database #Next, let us set up the SQL Connections. 
#Use SQL Client class in the System.Data namespace to instantiate a new SqlConnection and SqlCommand object.

$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
#Use SqlCommand of the SqlConnection object to add $Query data to the CommandText property.
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
#The SqlDataAdapter class creates an in-memory table fill a dataset with the data that are extracted from the SQL server
$SqlAdapter.Fill($DataSet)
#Display the result
$DataSet.Tables[0] |Format-Table –AutoSize 

