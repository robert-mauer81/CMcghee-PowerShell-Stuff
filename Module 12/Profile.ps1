$host.PrivateData.ErrorForegroundColor = 'Yellow'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.sqlserver.smo")
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete