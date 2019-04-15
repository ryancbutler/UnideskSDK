# Local Users

## Get Local Users

```powershell
Get-ALLocalUser -websession $websession
```

## Set Local Admin Password

```powershell
Set-ALAdminUser -websession $websession -Password $PlainPassword -Verbose
```