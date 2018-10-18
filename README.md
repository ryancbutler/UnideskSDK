[![Build status](https://ci.appveyor.com/api/projects/status/ty6dlw382m8fimdq/branch/master?retina=true)](https://ci.appveyor.com/project/ryancbutler/unidesksdk/branch/master)
# Citrix App Layering PowerShell SDK (BETA)
This is a reversed engineered SDK that emulates the SOAP calls that AL uses to manage the appliance.  Currently only supports version **4.11 or later**.  **THIS USES UNSUPPORTED API CALLS.  PLEASE USE WITH CAUTION.**

Tested with PVS and vCenter connectors only.  All other connectors may fail depending on command.
# Usage
## Install Manually
```
Import-Module ".\ctxal-sdk.psm1"
```
## Install PSGallery
```
Find-Module -name ctxal-sdk
Install-Module -Name ctxal-sdk -Scope CurrentUser
```

## Connect and Disconnect
### Connect
```
$aplip = "192.168.1.5"
$pass = "Password"
$username = "administrator"
$SecurePassword = ConvertTo-SecureString $Pass -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)
$websession = Connect-alsession -aplip $aplip -Credential $Credential -Verbose
```
### Disconnect
```
disconnect-alsession -websession $websession
```
## Finalize Layer
```
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
$apprevs = get-alapplayerdetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Finalizable"}|Sort-Object revision -Descending|select -First 1
$disklocation = get-allayerinstalldisk -websession $websession -id $apprevid.LayerId
invoke-allayerfinalize -websession $websession -fileshareid $fileshare.id -LayerRevisionId $apprevid.Id -uncpath $disklocation.diskuncpath -filename $disklocation.diskname
```
## Cancel Task
Locate ID of Task `Get-ALStatus -websession $websession`
```
Stop-ALWorkTicket -id 123456 -websession $websession
```

## Operating System Layers

### Import Operating System
**CURRENTLY ONLY WORKS WITH VSPHERE AND XENSERVER**

#### vCenter
```
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$shares = get-alremoteshare -websession $websession
#vCenter Command
$vm = Get-VM "Windows2016VM"
$vmid = $vm.Id -replace "VirtualMachine-",""
$response = import-aloslayer -websession $websession -vmname $vm.name -connectorid $connector.id -shareid $fileshare.id -name "Windows 2016" -version "1.0" -vmid $vmid -hypervisor esxi
```
#### Citrix Hypervisor (XenServer)
Thanks Dan Feller!
```
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$shares = get-alremoteshare -websession $websession
#Xen Command
$XenVM = get-xenvm -name $VMName
$response = import-aloslayer -websession $websession -vmname $vmname -connectorid $connector.id -shareid $fileshare.id -name "Windows 2016" -version "1.0" -vmid $XenVM.uuid -hypervisor xenserver
```
### New Operating System Layer Version
```
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 2016 Standard"}
$osrevs = get-aloslayerDetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
$myosrev = new-aloslayerrev -websession $websession -version "2.0" -connectorid $connector.Id -osid $oss.id -osrevid $osrevid.id -diskformat $connector.ValidDiskFormats.DiskFormat -shareid $fileshare.id

#Keep checking for change in task
do{
$status = get-alstatus -websession $websession|where{$_.id -eq $myosrev.WorkTicketId}
Start-Sleep -Seconds 5
} Until ($status.state -eq "ActionRequired")
#use function to extractt VM NAME from status message
get-alvmname -message $status.WorkItems.WorkItemResult.Status
```

## Application Layers

### New Application Layer
```
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$fileshare = Get-ALRemoteshare -websession $websession
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
$osrevs = get-aloslayerDetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
new-alapplayer -websession $websession -version "1.0" -name "Accounting APP" -description "Accounting application" -connectorid $connector.id -osrevid $osrevid.Id -diskformat $connector.ValidDiskFormats.DiskFormat -OsLayerSwitching BoundToOsLayer -fileshareid $fileshare.id
```
### New Application Layer Version
```
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
$oss = Get-ALOsLayer -websession $websession
$osrevs = get-aloslayerdetail -websession $websession -id $app.AssociatedOsLayerId
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
$apprevs = get-alapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
new-alapplayerrev -websession $websession -version "9.0" -name $app.Name -connectorid $connector.id -appid $app.Id -apprevid $apprevid.id -osrevid $osrevid.Id -diskformat $connector.ValidDiskFormats.DiskFormat -fileshareid $fileshare.id
```
### Set Application Layer

```
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
Set-alapplayer -websession $websession -name "7-Zip" -description "7-zip" -id $app.Id -scriptpath "C:\NeededScript.ps1" -OsLayerSwitching BoundToOsLayer
```

## Platform Layers

### New Platform Layer
```
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 2016 Standard"}
$osrevs = get-aloslayerdetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
New-ALPlatformLayer -websession $websession -osrevid $osrevid.Id -name "Citrix XA VDA 7.18" -connectorid $connector.id -shareid $fileshare.id -diskformat $connector.ValidDiskFormats.DiskFormat -type Create
```
### New Platform Layer Version
```
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
$osrevs = get-aloslayerdetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
$plats = Get-ALPlatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
$platrevs = get-alplatformlayerDetail -websession $websession -id $plats.id
$platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1

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

## Images

### Get Image Composition
```
$image = Get-ALImageComp -websession $websession -name "Windows 10 Accounting"
$image.OSLayer
$image.PlatformLayer
$image.AppLayer
```

### Create New Image
```
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
$osrevs = get-aloslayerDetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
$plats = get-alplatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
$platrevs = get-alplatformlayerdetail -websession $websession -id $plats.id
$platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
#Application IDs
$apps = @("Winscp","7-zip")
$appids = @()
foreach ($app in $apps)
{
    $applayerid = Get-ALapplayer -websession $websession|where{$_.name -eq $app}
    $apprevs = get-alapplayerDetail -websession $websession -id $applayerid.Id
    $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    $appids += $apprevid.Id
}
new-alimage -websession $websession -name "Windows 10 Accounting" -description "Accounting" -connectorid $connector.id -osrevid $osrevid.Id -appids $appids -platrevid $platformrevid.id -diskformat $connector.ValidDiskFormats.DiskFormat -ElasticLayerMode Session
```
### Edit Image

```
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
$osrevs = get-aloslayerdetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
$plats = Get-ALPlatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
$platrevs = get-alplatformlayerdetail -websession $websession -id $plats.id
$platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
$image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting"}
Set-alimage -websession $websession -name $images.Name -description "My new description" -connectorid $connector.id -osrevid $osrevid.Id -platrevid $platformrevid.id -id $image.Id -ElasticLayerMode Session -diskformat $connector.ValidDiskFormats.DiskFormat
```

### Remove Image

```
$image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting"}
Remove-ALImage -websession $websession -imageid $image.id
```

### Publish Image
```
$image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting""}
invoke-alpublish -websession $websession -imageid $image.id
```
## Application Assignments

### Images

#### Add app layers to an image
```
$image = Get-ALimage -websession $websession|where{$_.name -eq "Accounting}
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = get-alapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
add-alappassignment -websession $websession -apprevid $apprevid.id -imageid $image.id
```
#### Remove app layers from an image
```
$image = Get-ALimage -websession $websession|where{$_.name -eq "Accounting}
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = get-alapplayer -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
remove-alappassignment -websession $websession -applayerid $apprevid.LayerId -imageid $image.id
```
### Images
#### Add user\group to Elastic Layers
```
$users = @('MyGroup1','MyGroup2','Domain Users')
$finduser = $users|get-alldapobject -websession $websession
$app = Get-ALapplayerDetail -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = Get-ALapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
$add = $finduser|add-alelappassignment -websession $websession -apprevid $apprevid.Id
```
#### Remove user\group to Elastic Layers
```
$users = @('MyGroup1','MyGroup2','Domain Users')
$finduser = $users|get-alldapobject -websession $websession
$app = Get-ALapplayerDetail -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = Get-ALapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
$finduser|remove-alelappassignment -websession $websession -apprevid $apprevid.Id
```

### System Info

#### Get System Information (Version)
```
Get-ALSystemInfo -websession $websession
```

#### Get System Settings
```
$settings = get-alsystemsettingInfo -websession $websession

foreach ($setting in $settings)
{
write-host "Name: $($setting.name)"
write-host "Value: $($setting.value.'#text')"
} 
```
