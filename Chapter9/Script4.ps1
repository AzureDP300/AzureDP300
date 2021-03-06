#!/bin/bash
$subscription = "" # add subscription here

az account set -s $subscription 

$location="eastus"

$resource="resource-$(Get-Random)"
$server="sqlserver-$(Get-Random)"
$database="database-$(Get-Random)"

$failover="failover-$(Get-Random)"
$failoverLocation="westus"
$failoverServer="sqlsecondary-$(Get-Random)"

$login="sampleLogin"
$password="samplePassword123!"

echo "Using resource group $resource with login: $login, password: $password..."

echo "Creating $resource..."
az group create --name $resource --location "$location"

echo "Creating $server in $location..."
az sql server create --name $server --resource-group $resource --location "$location"  --admin-user $login --admin-password $password

echo "Creating $database on $server..."
az sql db create --name $database --resource-group $resource --server $server --sample-name AdventureWorksLT

echo "Creating $failoverServer in $failoverLocation..."
az sql server create --name $failoverServer --resource-group $resource --location "$failoverLocation" --admin-user $login --admin-password $password

echo "Creating $failover between $server and $failoverServer..."
az sql failover-group create --name $failover --partner-server $failoverServer --resource-group $resource --server $server --failover-policy Automatic --grace-period 2 --add-db $database

echo "Confirming role of $failoverServer is secondary..." # note ReplicationRole property
az sql failover-group show --name $failover --resource-group $resource --server $server
