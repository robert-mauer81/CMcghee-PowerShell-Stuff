Import-Module SQLServer -force

$Credential = Get-Credential
Connect-AzAccount -Credential $Credential
# Enter the SubscriptionId where you want to create the database below
$SubscriptionId = ''
# Enter the ResourceGroup where you want to create the database below
$resourceGroupName = ""
# Enter the location where you want to create the database below, default in westus2
$location = "westus2"
$adminSqlLogin = "SqlAdmin"
$password = "P@55w.rd"
# Set server name
$serverName = "AZR-SVR$(Get-Random)"
# The  database name
$databaseName = "AZRangerSmartRetail"
# The ip address range that you want to allow to access the database
$startIp = "0.0.0.0"
$endIp = "0.0.0.0"
$SQLInstance = "SQLInstance$(Get-Random)"
$TSQLFile = "https://github.com/NathanielShelly/Powershell_AZRangers/blob/383d2663d5a6aaa591939f09c615f56b4dcf30b3/SQLCreateSmartRetailDB.sql"

Set-AzContext -SubscriptionId $subscriptionId 
New-AzResourceGroup -Name $resourceGroupName -Location $location
New-AzSqlServer -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -Location $location `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential `
        -ArgumentList $adminSqlLogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -FirewallRuleName "AllowedIPs" -StartIpAddress $startIp -EndIpAddress $endIp

New-AzSqlDatabase  -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -DatabaseName $databaseName `
    -RequestedServiceObjectiveName "S0" 

Invoke-Sqlcmd -ServerInstance $SqlInstance -Database $databaseName -InputFile  $TSQLFile