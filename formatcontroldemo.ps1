#control spacing/with with comma
'{2,15} {0,20} {1,10}' -f 'zero', 'one', 'two'

#nother
foreach ($i in  2 , 3, 5) {
    foreach ($j in 5, 6, 7) {
        '{0,0} * {1,1}   = {2,5}' -f ($i, $j, ($i * $j))
    }
}

#formatting instruction added using a colon
foreach ($i in  2 , 3, 5) {
    foreach ($j in 5, 5, 5) {
        '{0,0} * {1,4}   = HEXx{2,2:x2}' -f ($i, $j, ($i * $j))
    }
}

#Date format
$dt = (Get-Date)
Write-Host "Unformatted $dt"

write-host "Now it is formatted $('{0:yyyy-MM-dd }' -f $dt)"