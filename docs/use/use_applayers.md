# Application Layers

## New Application Layer

```powershell
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$fileshare = Get-ALRemoteshare -websession $websession
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
$osrevs = get-aloslayerDetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
new-alapplayer -websession $websession -version "1.0" -name "Accounting APP" -description "Accounting application" -connectorid $connector.id -osrevid $osrevid.Id -diskformat $connector.ValidDiskFormats.DiskFormat -OsLayerSwitching BoundToOsLayer -fileshareid $fileshare.id
```

## New Application Layer Version

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
$oss = Get-ALOsLayer -websession $websession
$osrevs = get-aloslayerdetail -websession $websession -id $app.AssociatedOsLayerId
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
$apprevs = get-alapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
new-alapplayerrev -websession $websession -version "9.0" -name $app.Name -connectorid $connector.id -appid $app.Id -apprevid $apprevid.id -osrevid $osrevid.Id -diskformat $connector.ValidDiskFormats.DiskFormat -fileshareid $fileshare.id
```

## Set Application Layer

```powershell
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
Set-alapplayer -websession $websession -name "7-Zip" -description "7-zip" -id $app.Id -scriptpath "C:\NeededScript.ps1" -OsLayerSwitching BoundToOsLayer
```
## Remove Application Layer Revision

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$appid = Get-ALapplayer -websession $websession | where{$_.name -eq "7-Zip"}
$apprevid = get-alapplayerDetail -websession $websession -id $appid.Id
$apprevid = $apprevid.Revisions.AppLayerRevisionDetail | where{$_.candelete -eq $true} | Sort-Object DisplayedVersion -Descending | select -First 1
remove-alapplayerrev -websession $websession -appid $appid.Id -apprevid $apprevid.id -fileshareid $fileshare.id
```