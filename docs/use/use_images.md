# Images

## Get Image Composition

```powershell
$image = Get-ALImageComp -websession $websession -name "Windows 10 Accounting"
$image.OSLayer
$image.PlatformLayer
$image.AppLayer
```

## Create New Image

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
$osrevs = get-aloslayerDetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
$plats = get-alplatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
$platrevs = get-alplatformlayerdetail -websession $websession -id $plats.id
$platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
#Application IDs
$apps = @("Winscp","7-zip")
$appids = @()
foreach ($app in $apps)
{
    $applayerid = Get-ALapplayer -websession $websession|where{$_.name -eq $app}
    $apprevs = get-alapplayerDetail -websession $websession -id $applayerid.Id
    $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
    $appids += $apprevid.Id
}
new-alimage -websession $websession -name "Windows 10 Accounting" -description "Accounting" -connectorid $connector.id -osrevid $osrevid.Id -appids $appids -platrevid $platformrevid.id -diskformat $connector.ValidDiskFormats.DiskFormat -ElasticLayerMode Session
```

## Edit Image

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
$osrevs = get-aloslayerdetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
$plats = Get-ALPlatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
$platrevs = get-alplatformlayerdetail -websession $websession -id $plats.id
$platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
$image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting"}
Set-alimage -websession $websession -name $images.Name -description "My new description" -connectorid $connector.id -osrevid $osrevid.Id -platrevid $platformrevid.id -id $image.Id -ElasticLayerMode Session -diskformat $connector.ValidDiskFormats.DiskFormat
```
## Edit image with latest revision for a specific app
```powershell
$app = "Winscp"
$applayerid = Get-ALapplayer -websession $websession|where{$_.name -eq $app}
$apprevs = get-alapplayerDetail -websession $websession -id $applayerid.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
Set-alimage -websession $websession -name $images.Name -description "My new description" -connectorid $connector.id -osrevid $osrevid.Id -platrevid $platformrevid.id -id $image.Id -ElasticLayerMode Session -diskformat $connector.ValidDiskFormats.DiskFormat -applayerid $applayerid.LayerId -apprevid $apprevid.Id
```

## Remove Image

```powershell
$image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting"}
Remove-ALImage -websession $websession -imageid $image.id
```

## Publish Image

```powershell
$image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting"}
invoke-alpublish -websession $websession -imageid $image.id
```

## Clone Image

```powershell
$image = Get-ALimage -websession $websession | where {$_.name -eq "Windows 10 Accounting"}
New-ALImageClone -websession $websession -imageid $image.Id -Confirm:$false -OutVariable ALImageClone
```