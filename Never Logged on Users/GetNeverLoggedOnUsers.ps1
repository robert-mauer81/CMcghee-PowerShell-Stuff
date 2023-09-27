#The below command lists all users who never logged on.
Get-ADUser -Filter { (lastlogontimestamp -notlike "*") } | Select Name, DistinguishedName

#If you want to list only enabled ad users, you can add one more check in the above filter.
Get-ADUser -Filter { (lastlogontimestamp -notlike "*") -and (enabled -eq $true) } | Select Name, DistinguishedName

#If you are familiar with LDAP filter you can also find never logged in users by using ldap filter.

Get-ADUser -ldapfilter '(&(!lastlogontimestamp=*)(!useraccountcontrol:1.2.840.113556.1.4.803:=2))' | Select-object Name, DistinguishedName

# In most cases, we may want to find AD users who created in last certain days or months and not logged in their system. To achieve this, we need to filter users by created time.
#The below powershell command lists all AD users who are created in 30 days before and still not logged in.

$days = 30
$createdtime = (Get-Date).Adddays( - ($days))
Get-ADUser -Filter { (lastlogontimestamp -notlike "*") -and (enabled -eq $true) -and (whencreated -lt $createdtime) } | Select-object Name, DistinguishedName

#Export Never Logged On AD Users to CSV file
#We can export users into CSV file using Export-CSV cmdlet. The following command export all the never logged in users who are created in 30 days before into CSV file.

$createdtime = (Get-Date).Adddays( - (30))
Get-ADUser -Filter { (lastlogontimestamp -notlike "*") -and (enabled -eq $true) -and (whencreated -lt $createdtime) } | Select-object Name, DistinguishedName |
Export-CSV "C:\NeverLoggedOnUsers.csv" -NoTypeInformation -Encoding UTF8
