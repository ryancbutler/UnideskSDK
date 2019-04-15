# System Info

## Get System Information (Version)

```powershell
Get-ALSystemInfo -websession $websession
```

## Get System Settings

```powershell
get-alsystemsettinginfo -websession $websession|Select-Object -ExpandProperty value -Property @{Name="SettingName"; Expression = {$_.Name}}
```