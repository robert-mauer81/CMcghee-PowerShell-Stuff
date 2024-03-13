#tASK 1
#Create a variable
$logPath = "C:\Logs\"
#Get type
		$logPath.GetType()
#identify properties and methods
		$logPath | Get-Member
#Creat secon variable
$logFile = "log.txt"
#Update contents
		$logPath += $logFile
#or
		$logpath = Join-Path $logPath -ChildPath $logFile		
		$logPath
#Replace C with D and Update
		$logPath.Replace("C:","D:")
		$logPath = $logPath.Replace("C:","D:")
		$logPath

#Task 2 DateTime
#Create Variable
		$today = Get-Date
#Identiy type and get methods andprops
		$today.GetType()
		$today | Get-Member
#Use $Today tp creat a string
		$logFile = [string]$today.Year + "-" + $today.Month + "-" + $today.Day + "-" + $today.Hour + "-" + $today.Minute + ".txt"
		#or credit Room 2 :
		$logfile = '{0}-{1}-{2}-{3}-{4}.txt' -f $today.Year , $today.Month , $today.Day ,$today.Hour ,$today.Minute
#Create a variable -30 days
		$cutOffDate = $today.AddDays(-30)
#Use Variable in Filter
Get-ADUser -Properties LastLogonDate -Filter {LastLogonDate -gt $cutOffDate}

#Task 3 Array to update dept
# Popuolate arra with AD users from marketing
$mktgUsers = Get-ADUser -Filter {Department -eq "Marketing"} -Properties Department
#Count users in marketing
		$mktgUsers.count
# Show first user
		$mktgUsers[0]
#Cahnge the users department in the array to Business Development
		$mktgUsers | Set-ADUser -Department "Business Development"
#or written another way 
		$mktgUsers | ForEach-Object {set-aduser $_ -Department "Business Development"} 	
# View the update
		$mktgUsers | Format-Table Name,Department
#Verify ther are no more users with the Marketing value for Department
		Get-ADUser -Filter {Department -eq "Marketing"}
#Verify change
		Get-ADUser -Filter {Department -eq "Business Development"}
        
		Get-ADUser -Filter {Department -eq "Business Development"} | Measure-Object

#Task 4 ArraryList
#Create an ArrayList
		[System.Collections.ArrayList]$computers="LON-SRV1","LON-SRV2","LON-DC1"
#Verify it is an ArrayLsit and not Fixed
		$computers.IsFixedSize
#Add to the arraylist
		$computers.Add("LON-DC2")
#Remove from the ArrayLsit
		$computers.Remove("LON-SRV2")
#Show variable content
		$computers

#Task 5
#Create maillist hash t
		$mailList=@{"Frank"="Frank@fabriakm.com";"Libby"="LHayward@contso.com";"Matej"="MSTaojanov@tailspintoys.com"}
#Display contents
		$mailList
#Libbys email
		$mailList.Libby
#Update Libs email
		$mailList.Libby="Libby.Hayward@contoso.com"
#Add to the Hasj table
		$mailList.Add("Stela","Stela.Sahiti")
#Remove from the hash T and view
		$mailList.Remove("Frank")
		$mailList
