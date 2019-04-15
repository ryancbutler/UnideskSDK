# Operating System Layers

## Import Operating System

### vCenter

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$shares = get-alremoteshare -websession $websession
#vCenter Command
$vm = Get-VM "Windows2016VM"
$vmid = $vm.Id -replace "VirtualMachine-",""
$response = import-aloslayer -websession $websession -vmname $vm.name -connectorid $connector.id -shareid $fileshare.id -name "Windows 2016" -version "1.0" -vmid $vmid -hypervisor esxi
```

### Citrix Hypervisor (XenServer)

Thanks Dan Feller!

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYXenServer"}
$shares = get-alremoteshare -websession $websession
#Xen Command
$XenVM = get-xenvm -name $VMName
$response = import-aloslayer -websession $websession -vmname $vmname -connectorid $connector.id -shareid $fileshare.id -name "Windows 2016" -version "1.0" -vmid $XenVM.uuid -hypervisor xenserver
```

## New Operating System Layer Version

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
$oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 2016 Standard"}
$osrevs = get-aloslayerDetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
$myosrev = new-aloslayerrev -websession $websession -version "2.0" -connectorid $connector.Id -osid $oss.id -osrevid $osrevid.id -diskformat $connector.ValidDiskFormats.DiskFormat -shareid $fileshare.id

#Keep checking for change in task
do{
$status = get-alstatus -websession $websession -id $myosrev.WorkTicketId
Start-Sleep -Seconds 5
} Until ($status.state -eq "ActionRequired")
#use function to extract VM NAME from status message
get-alvmname -message $status.WorkItems.WorkItemResult.Status
```

## Remove Operating System Layer Revision

```powershell
$fileshare = Get-ALRemoteshare -websession $websession
$osid = Get-ALOSlayer -websession $websession | where{$_.name -eq "Windows 10 x64"}
$osrevid = Get-ALOSlayerDetail -websession $websession -id $osid.Id
$osrevid = $osrevid.Revisions.OSLayerRevisionDetail | where{$_.candelete -eq $true} | Sort-Object DisplayedVersion -Descending | select -Last 1
remove-aloslayerrev -websession $websession -osid $osid.Id -osrevid $osrevid.id -fileshareid $fileshare.id
```