# Platform Layers

## New Platform Layer

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 2016 Standard"}
$osrevs = get-aloslayerdetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
New-ALPlatformLayer -websession $websession -osrevid $osrevid.Id -name "Citrix XA VDA 7.18" -connectorid $connector.id -shareid $fileshare.id -diskformat $connector.ValidDiskFormats.DiskFormat -type Create
```

## New Platform Layer Version

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
$osrevs = get-aloslayerdetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
$plats = Get-ALPlatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
$platrevs = get-alplatformlayerDetail -websession $websession -id $plats.id
$platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1

$params = @{
websession = $websession;
osrevid = $osrevid.Id;
connectorid =  $connector.Id;
shareid = $fileshare.id;
layerid = $plats.Id;
layerrevid = $platformrevid.id;
version = "5.0";
Diskname = $plats.Name;
Verbose = $true;
Description = "Citrix VDA 7.18 with windows 10";
diskformat = $connector.ValidDiskFormats.DiskFormat;
}

New-ALPlatformLayerRev @params
```
## Remove Platform Layer Revision

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$platformid = Get-ALPlatformlayer -websession $websession | where{$_.name -eq "Windows 10 VDA"}
$platformrevid = Get-ALPlatformlayerDetail -websession $websession -id $platformid.Id
$platformrevid = $platformrevid.Revisions.PlatformLayerRevisionDetail | where{$_.candelete -eq $true} | Sort-Object DisplayedVersion -Descending | select -First 1
remove-alplatformlayerrev -websession $websession -platformid $platformid.Id -platformrevid $platformrevid.id -fileshareid $fileshare.id
```