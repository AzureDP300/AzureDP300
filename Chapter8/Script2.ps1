<#
EXAMPLE 1: 

    $ResourceGroup="myDemoDP300RG"
    $Location="southcentralus"
    $SQLServer="sqldemodp300"
    $AdminUser="SQLAdminSvc "
    $AdminPassword="DP300!@#$"
    $SQLDatabase="mydemodatabasedp300"
    $Edition="Standard"
    $ServiceObject="S0"

PS C:\Users\pjayaram> .\Chapter9_Build.ps1 -Sub $sub -ResourceGroup $ResourceGroup -location $location -SQLServer $SQLServer -AdminUser $UserName -AdminPassword $Password -SQLDatabase $SQLDatabase -Edition $Edition -ServiceObject $ServiceObject
#>
[CmdletBinding()]
param (
[String] $ResourceGroup,
[String] $Location,
[String] $SQLServer,
[String] $AdminUser,
[String] $AdminPassword,
[String] $SQLDatabase,
[String] $Edition="Standard",
[string] $ServiceObject,
[String] $Profile="C:\users\pjayaram\MyAzureProfileDP300.JSON"
)

#Login to Azure using Azure profile
Import-AzContext -Path $Profile

#Create the resource group 
New-AzResourceGroup -Name $ResourceGroup -Location $Location

#Convert the password into a secure string, run the following ConvertTo-SecureString cmdlet
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AdminUser, $(ConvertTo-SecureString -String $AdminPassword -AsPlainText -Force)

#Create Azure SQL Server

New-AzSqlServer -ServerName $SQLServer –location $location -ResourceGroupName $ResourceGroup -SqlAdministratorCredentials $credentials -ServerVersion '12.0'

# Get the requested service Objects

if ($Edition -eq "Standard") {
    #S0,S1,S2,S3,S4,S6,S7,S9,S12
    switch ($ServiceObject) {
        "S0" { $RequestedServiceObjectiveName = "S0" }
        "S1" { $RequestedServiceObjectiveName = "S1" }
        "S2" { $RequestedServiceObjectiveName = "S2" }
        "S3" { $RequestedServiceObjectiveName = "S3" }
        "S4" { $RequestedServiceObjectiveName = "S4" }
        "S5" { $RequestedServiceObjectiveName = "S5" }
        "S6" { $RequestedServiceObjectiveName = "S6" }
        "S7" { $RequestedServiceObjectiveName = "S7" }
        "S9" { $RequestedServiceObjectiveName = "S9" }
        "S12" { $RequestedServiceObjectiveName = "S12" }
        default { $RequestedServiceObjectiveName = "S0" }
    }
}
elseif ($edition -eq "Premium") {
    #P1,P2,P4,P11,P6,P15
    switch ($ServiceObject) {
        "P1" { $RequestedServiceObjectiveName = "P1" }
        "P2" { $RequestedServiceObjectiveName = "P2" }
        "P4" { $RequestedServiceObjectiveName = "P4" }
        "P6" { $RequestedServiceObjectiveName = "P6" }
        "P11" { $RequestedServiceObjectiveName = "P11" }
        "P15" { $RequestedServiceObjectiveName = "P15" }
        default { $RequestedServiceObjectiveName = "P1" }
    }
}

#Create Azure SQL database
New-AzSqlDatabase -ServerName $SQLServer -ResourceGroupName $ResourceGroup -DatabaseName $SQLDatabase -Edition $Edition -RequestedServiceObjectiveName S1

#Allow the firewalls
#Make sure to enter the correct Client IP address
New-AzSqlServerFirewallRule -ServerName $SQLServer -ResourceGroupName $ResourceGroup -AllowAllAzureIPs
New-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroup -ServerName $SQLServer -FirewallRuleName "Client IP" -StartIpAddress "165.197.64.224" -EndIpAddress "165.197.64.255"
