Import Commands
=========================

This page contains details on **Import** commands.

Import-ALLayerRev
-------------------------


NAME
    Import-ALLayerRev
    
SYNOPSIS
    Imports existing layers from share into ELM
    
    
SYNTAX
    Import-ALLayerRev [-websession] <Object> [-sharepath] <String> [-id] <String> [[-username] <String>] [[-sharepw] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Imports existing layers from share into ELM
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -sharepath <String>
        Share UNC Path type
        
    -id <String>
        ID(s) of revision layers to export
        
    -username <String>
        Share username
        
    -sharepw <String>
        Share password
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Import-ALlayerrevs -websession $websession -sharepath "\\myserver\path\layers" -id @(12042,225252,2412412)
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Import-ALLayerRev -examples".
    For more information, type: "get-help Import-ALLayerRev -detailed".
    For technical information, type: "get-help Import-ALLayerRev -full".


Import-ALOsLayer
-------------------------

NAME
    Import-ALOsLayer
    
SYNOPSIS
    Creates a new operating system layer
    
    
SYNTAX
    Import-ALOsLayer [-websession] <Object> [-vmname] <String> [[-description] <String>] [-connectorid] <String> [-shareid] <String> [[-icon] <String>] [-name] <String> [[-size] <String>] [-version] <String> [-vmid] <String> 
    [-hypervisor] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates a new operating system layer
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -vmname <String>
        Virtual machine name to import from
        
    -description <String>
        Description of the layer
        
    -connectorid <String>
        ID of Connector to use
        
    -shareid <String>
        ID of file share
        
    -icon <String>
        Icon ID (default 196608)
        
    -name <String>
        Name of the layer
        
    -size <String>
        Size of layer in GB (default 61440)
        
    -version <String>
        Version number of the layer
        
    -vmid <String>
        Virtual Machine ID from vCenter or GUID XenCenter
        
    -hypervisor <String[]>
        Hypversior to import from (ESXI or XenServer)
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$fileshare = Get-ALRemoteshare -websession $websession
    
    $connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
    $shares = get-alremoteshare -websession $websession
    #vCenter Command
    $vm = Get-VM "Windows2016VM"
    $vmid = $vm.Id -replace "VirtualMachine-",""
    $response = import-aloslayer -websession $websession -vmname $vm.name -connectorid $connector.id -shareid $fileshare.id -name "Windows 2016" -version "1.0" -vmid $vmid -hypervisor esxi
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>$fileshare = Get-ALRemoteshare -websession $websession
    
    $connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYXenCenter"}
    $shares = get-alremoteshare -websession $websession
    #Xen Command
    $XenVM = get-xenvm -name $VMName
    $response = import-aloslayer -websession $websession -vmname $vmname -connectorid $connector.id -shareid $fileshare.id -name "Windows 2016" -version "1.0" -vmid $XenVM.uuid -hypervisor xenserver
    
    
    
    
REMARKS
    To see the examples, type: "get-help Import-ALOsLayer -examples".
    For more information, type: "get-help Import-ALOsLayer -detailed".
    For technical information, type: "get-help Import-ALOsLayer -full".




