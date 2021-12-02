$Value = Read-Host Enter value to check

#Create connection to Worksheet
$path = "D:\Testfiles\financial.xlsx"

$xl = New-Object -COM "Excel.Application"
$xl.Visible = $false
$wb = $xl.Workbooks.Open($path)
#worksheet
$ws = $wb.Sheets.Item(1)

#look at cell ?

if ([bool]$ws.cells.find("$Value")) {
    $foundit = "Yep $Value is there"
    write-host $foundit
       
}
    
