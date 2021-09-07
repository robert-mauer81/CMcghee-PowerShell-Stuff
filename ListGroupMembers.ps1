

Get-EventLog -LogName "system"  | Where-Object -FilterScript{$_.Message -like '*interface*' -and $_.Message -like '*iscsi*'} | Format-List -Property index,entrytype,message