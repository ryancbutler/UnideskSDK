# Citrix App Layering PowerShell SDK (BETA)

[![Build status](https://ci.appveyor.com/api/projects/status/ty6dlw382m8fimdq/branch/master?retina=true)](https://ci.appveyor.com/project/ryancbutler/unidesksdk/branch/master)

This is a reversed engineered SDK that emulates the SOAP calls that AL uses to manage the appliance.  Currently only supports version **4.11 or later**.  **THIS USES UNSUPPORTED API CALLS.  PLEASE USE WITH CAUTION.**

- [Citrix App Layering PowerShell SDK (BETA)](#citrix-app-layering-powershell-sdk--beta-)
  * [Install and Update](#install-and-update)
    + [Install Manually](#install-manually)
    + [Install PSGallery](#install-psgallery)
    + [Update PSGallery](#update-psgallery)
  * [Connect and Disconnect](#connect-and-disconnect)
    + [Connect](#connect)
    + [Disconnect](#disconnect)
  * [Finalize Layer](#finalize-layer)
  * [Task Status](#task-status)
    + [Get Task Status](#get-task-status)
    + [Cancel Task](#cancel-task)
  * [Operating System Layers](#operating-system-layers)
    + [Import Operating System](#import-operating-system)
      - [vCenter](#vcenter)
      - [Citrix Hypervisor (XenServer)](#citrix-hypervisor--xenserver-)
    + [New Operating System Layer Version](#new-operating-system-layer-version)
  * [Application Layers](#application-layers)
    + [New Application Layer](#new-application-layer)
    + [New Application Layer Version](#new-application-layer-version)
    + [Set Application Layer](#set-application-layer)
  * [Platform Layers](#platform-layers)
    + [New Platform Layer](#new-platform-layer)
    + [New Platform Layer Version](#new-platform-layer-version)
  * [Images](#images)
    + [Get Image Composition](#get-image-composition)
    + [Create New Image](#create-new-image)
    + [Edit Image](#edit-image)
    + [Remove Image](#remove-image)
    + [Publish Image](#publish-image)
  * [Application Assignments](#application-assignments)
    + [Add app layers to an image](#add-app-layers-to-an-image)
    + [Remove app layers from an image](#remove-app-layers-from-an-image)
    + [Add user\group to Elastic Layers](#add-user-group-to-elastic-layers)
    + [Remove user\group from Elastic Layers](#remove-user-group-from-elastic-layers)
  * [Icons](#icons)
    + [Get icon ids](#get-icon-ids)
    + [Export all icons (save as png)](#export-all-icons--save-as-png-)
    + [Get icon associations](#get-icon-associations)
    + [Create new icon](#create-new-icon)
    + [Remove icon](#remove-icon)
  * [Export and Import Layers](#export-and-import-layers)
    + [Export Layers](#export-layers)
    + [Import Layers](#import-layers)
  * [Directory Junction](#directory-junction)
    + [New Directory Junction](#new-directory-junction)
    + [Get ALL Directory Junctions](#get-all-directory-junctions)
    + [Get Directory Junction Info](#get-directory-junction-info)
    + [Set Directory Junction Info](#set-directory-junction-info)
    + [Delete Directory Junction](#delete-directory-junction)
    + [User Info](#user-info)
  * [System Info](#system-info)
    + [Get System Information (Version)](#get-system-information--version-)
    + [Get System Settings](#get-system-settings)

## Install and Update

### Install Manually

```powershell
Import-Module ".\ctxal-sdk.psm1"
```

### Install PSGallery

```powershell
Find-Module -name ctxal-sdk
Install-Module -Name ctxal-sdk -Scope CurrentUser
```

### Update PSGallery

```powershell
Find-Module -name ctxal-sdk
Update-Module -Name ctxal-sdk
```

## Connect and Disconnect

### Connect

```powershell
$aplip = "192.168.1.5"
$pass = "Password"
$username = "administrator"
$SecurePassword = ConvertTo-SecureString $Pass -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)
$websession = Connect-alsession -aplip $aplip -Credential $Credential -Verbose
```

### Disconnect

```powershell
disconnect-alsession -websession $websession
```

## Finalize Layer

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
$apprevs = get-alapplayerdetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Finalizable"}|Sort-Object revision -Descending|select -First 1
$disklocation = get-allayerinstalldisk -websession $websession -id $apprevid.LayerId
invoke-allayerfinalize -websession $websession -fileshareid $fileshare.id -LayerRevisionId $apprevid.Id -uncpath $disklocation.diskuncpath -filename $disklocation.diskname
```
## Task Status

### Get Task Status
Get all tasks

```powershell
Get-ALStatus -websession $websession
```

Get specific task based on ID (accepts wildcard)
```powershell
Get-ALStatus -id 123456 -websession $websession
```

### Cancel Task
Locate ID of Task `Get-ALStatus -websession $websession`

```powershell
Stop-ALWorkTicket -id 123456 -websession $websession
```

## Operating System Layers

### Import Operating System

#### vCenter

```powershell
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

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYXenServer"}
$shares = get-alremoteshare -websession $websession
#Xen Command
$XenVM = get-xenvm -name $VMName
$response = import-aloslayer -websession $websession -vmname $vmname -connectorid $connector.id -shareid $fileshare.id -name "Windows 2016" -version "1.0" -vmid $XenVM.uuid -hypervisor xenserver
```

### New Operating System Layer Version

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 2016 Standard"}
$osrevs = get-aloslayerDetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
$myosrev = new-aloslayerrev -websession $websession -version "2.0" -connectorid $connector.Id -osid $oss.id -osrevid $osrevid.id -diskformat $connector.ValidDiskFormats.DiskFormat -shareid $fileshare.id

#Keep checking for change in task
do{
$status = get-alstatus -websession $websession -id $myosrev.WorkTicketId
Start-Sleep -Seconds 5
} Until ($status.state -eq "ActionRequired")
#use function to extract VM NAME from status message
get-alvmname -message $status.WorkItems.WorkItemResult.Status
```

## Application Layers

### New Application Layer

```powershell
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$fileshare = Get-ALRemoteshare -websession $websession
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
$osrevs = get-aloslayerDetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
new-alapplayer -websession $websession -version "1.0" -name "Accounting APP" -description "Accounting application" -connectorid $connector.id -osrevid $osrevid.Id -diskformat $connector.ValidDiskFormats.DiskFormat -OsLayerSwitching BoundToOsLayer -fileshareid $fileshare.id
```

### New Application Layer Version

```powershell
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

```powershell
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
Set-alapplayer -websession $websession -name "7-Zip" -description "7-zip" -id $app.Id -scriptpath "C:\NeededScript.ps1" -OsLayerSwitching BoundToOsLayer
```

## Platform Layers

### New Platform Layer

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 2016 Standard"}
$osrevs = get-aloslayerdetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
New-ALPlatformLayer -websession $websession -osrevid $osrevid.Id -name "Citrix XA VDA 7.18" -connectorid $connector.id -shareid $fileshare.id -diskformat $connector.ValidDiskFormats.DiskFormat -type Create
```

### New Platform Layer Version

```powershell
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

```powershell
$image = Get-ALImageComp -websession $websession -name "Windows 10 Accounting"
$image.OSLayer
$image.PlatformLayer
$image.AppLayer
```

### Create New Image

```powershell
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

```powershell
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

```powershell
$image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting"}
Remove-ALImage -websession $websession -imageid $image.id
```

### Publish Image

```powershell
$image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting""}
invoke-alpublish -websession $websession -imageid $image.id
```

## Application Assignments

### Add app layers to an image

```powershell
$image = Get-ALimage -websession $websession|where{$_.name -eq "Accounting}
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = get-alapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
add-alappassignment -websession $websession -apprevid $apprevid.id -imageid $image.id
```

### Remove app layers from an image

```powershell
$image = Get-ALimage -websession $websession|where{$_.name -eq "Accounting}
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = get-alapplayer -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
remove-alappassignment -websession $websession -applayerid $apprevid.LayerId -imageid $image.id
```

### Add user\group to Elastic Layers

```powershell
$users = @('MyGroup1','MyGroup2','Domain Users')
$finduser = $users|get-alldapobject -websession $websession
$app = Get-ALapplayerDetail -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = Get-ALapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
$add = $finduser|add-alelappassignment -websession $websession -apprevid $apprevid.Id
```

### Remove user\group from Elastic Layers

```powershell
$users = @('MyGroup1','MyGroup2','Domain Users')
$finduser = $users|get-alldapobject -websession $websession
$app = Get-ALapplayerDetail -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = Get-ALapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
$finduser|remove-alelappassignment -websession $websession -apprevid $apprevid.Id
```

## Icons

### Get icon ids

```powershell
Get-ALicon -websession $websession
```

### Export all icons (save as png)

```powershell
$icons = Get-ALicon -websession $websession

foreach($icon in $icons)
{
    #No authentication needed to grab image
    Invoke-WebRequest -uri $($icon.url) -OutFile ("D:\Temp\icons\" + $($icon.iconid)+".png")
}
```

### Get icon associations

```powershell
Get-ALiconassoc -websession $websession -iconid "196608"
```

### Create new icon

```powershell
$iconfile = "D:\Temp\icons\myiconpic.png"
$temp = new-alicon -WebSession $websession -iconfile $iconfile -Verbose
```

### Remove icon

```powershell
Remove-ALicon -websession $websession -iconid "4259840"
```
## Export and Import Layers

Gets "Exportable" Layers

```powershell
$mypath = "\\mynas\layershare\"
Get-ALExportableRev -websession $websession -sharepath $mypath
```

Gets "Exportable" layers including ones that are already present

```powershell
$mypath = "\\mynas\layershare\"
Get-ALExportableRev -websession $websession -sharepath $mypath -showall
```

Gets "Importable" Layers

```powershell
$mypath = "\\mynas\layershare\"
Get-ALimportableRev -websession $websession -sharepath $mypath
```

Gets "Importable" layers including ones that are already present

```powershell
$mypath = "\\mynas\layershare\"
Get-ALimportableRev -websession $websession -sharepath $mypath -showall
```

### Export Layers

Exports all "exportable" layers to fileshare

```powershell
$mypath = "\\mynas\layershare\"
Get-ALExportableRev -websession $websession -sharepath $mypath|Export-ALlayerrev -websession $websession -sharepath $mypath
```

Exports all "exportable" layers to fileshare with authenication. (Press CTRL key to select more than one layer)

```powershell
$mypath = "\\mynas\layershare\"
$myusername = "mydomain@domain.com"
$sharepw = "mysupersecret"
Get-ALExportableRev -websession $websession -sharepath $mypath -username $myusername -sharepw $sharepw|Export-ALlayerrev -websession $websession -sharepath $mypath -username $myusername -sharepw $sharepw
```

Allows user to select which layers to export. (Press CTRL key to select more than one layer)

```powershell
$mypath = "\\mynas\layershare\"
Get-ALExportableRev -websession $websession -sharepath $mypath|Out-gridview -PassThru|Export-ALlayerrev -websession $websession -sharepath $mypath
```

### Import Layers

Imports all "importable" layers to fileshare

```powershell
$mypath = "\\mynas\layershare\"
Get-ALImportableRev -websession $websession -sharepath $mypath|Import-ALlayerrev -websession $websession -sharepath $mypath
```

Imports all "importable" layers to fileshare with authenication. (Press CTRL key to select more than one layer)

```powershell
$mypath = "\\mynas\layershare\"
$myusername = "mydomain@domain.com"
$sharepw = "mysupersecret"
Get-ALImportableRev -websession $websession -sharepath $mypath -username $myusername -sharepw $sharepw|Import-ALlayerrev -websession $websession -sharepath $mypath -username $myusername -sharepw $sharepw
```

Allows user to select which layers to import. (Press CTRL key to select more than one layer)

```powershell
$mypath = "\\mynas\layershare\"
Get-ALImportableRev -websession $websession -sharepath $mypath|Out-gridview -PassThru|Import-ALlayerrev -websession $websession -sharepath $mypath
```
## Directory Junction

### New Directory Junction

```powershell
new-aldirectory -websession $websession -serveraddress "mydc.domain.com" -Verbose -usessl -username "admin@domain.com" -adpassword "MYPASSWORD" -basedn DC=domain,DC=com -name "Mydirectory"
```

### Get ALL Directory Junctions

```powershell
Get-ALDirectory -websession $websession
```

### Get Directory Junction Info

```powershell
get-aldirectorydetail -websession $websession -id $directory.id
```

### Set Directory Junction Info

```powershell
Set-aldirectory -websession $websession -adpassword "MYPASSWORD" -id $directory.id -name "MYNEWNAME"
```

### Delete Directory Junction

```powershell
Remove-ALDirectory -websession $websession -id "4915204"
```

### User Info

```powershell
$dir = Get-ALDirectory -websession $websession|where{$_.name -eq "MyDirectory"}
$userid = Get-ALUserList -websession $websession -junctionid $dir.id -dn "CN=Users,DC=mydomain,DC=com"|Where-Object {$_.loginname -eq "myusername"}
$userdetail = Get-ALUserDetail -websession $websession -junctionid $dir.id -ldapguid $userid.DirectoryId.LdapGuid -dn $userid.DirectoryId.LdapDN -id $userid.DirectoryId.UnideskId
$apps = Get-ALUserAssignment -websession $websession -id $userid.DirectoryId.UnideskId -Verbose
$apps|Select-Object LayerName,CurrentRevision,PendingRevision,AssignedViaDisplayName
```

## System Info

### Get System Information (Version)

```powershell
Get-ALSystemInfo -websession $websession
```

### Get System Settings

```powershell
get-alsystemsettinginfo -websession $websession|Select-Object -ExpandProperty value -Property @{Name="SettingName"; Expression = {$_.Name}}
```
