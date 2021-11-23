Param(
[string]$user = (Read-Host -Prompt "Please enter the name of the user to unlock")
)
Get-Aduser -filter { Name -eq '$user' } | Unlock-ADAccount