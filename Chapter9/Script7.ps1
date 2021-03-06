$subId = ""
$serverName = "azuredemosqldemo"
$resourceGroup = "MyAzureLabSQL"
$dbName = "Azuredemodatabase"
$server = Get-AzSqlServer -ServerName $serverName -ResourceGroupName $resourceGroup
Set-AzSqlDatabaseBackupLongTermRetentionPolicy -ServerName $serverName -DatabaseName $dbName `
-ResourceGroupName $resourceGroup -WeeklyRetention P10W -YearlyRetention P7Y -WeekOfYear 15
