# Connect and Disconnect

## Connect

```powershell
$aplip = "192.168.1.5"
$pass = "Password"
$username = "administrator"
$SecurePassword = ConvertTo-SecureString $Pass -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)
$websession = Connect-alsession -aplip $aplip -Credential $Credential -Verbose
```

## Disconnect

```powershell
disconnect-alsession -websession $websession
```