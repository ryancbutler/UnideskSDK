# Task Status

## Get Task Status
Get all tasks

```powershell
Get-ALStatus -websession $websession
```

Get specific task based on ID (accepts wildcard)
```powershell
Get-ALStatus -id 123456 -websession $websession
```

## Cancel Task
Locate ID of Task `Get-ALStatus -websession $websession`

```powershell
Stop-ALWorkTicket -id 123456 -websession $websession
```