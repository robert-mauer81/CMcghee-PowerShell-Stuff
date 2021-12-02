
$Value = Read-Host Enter value to check

#Create excel connect
$path =  "$env:temp\excelsampledata\financial.xlsx"

$xl = New-Object -COM "Excel.Application"
$xl.Visible = $true
$wb = $xl.Workbooks.Open($path)
#worksheet
$ws = $wb.Sheets.Item(1)

#look at cell ?
for ($i = 1; $i -le 3; $i++) {
  if ( $ws.Cells.Item($i, 1).Value -eq $value ) {
    Write-host "Woot Woot"
    break
  }
}