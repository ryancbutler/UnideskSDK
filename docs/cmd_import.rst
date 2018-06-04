Import Commands
=========================

This page contains details on **Import** commands.

Import-ALOsLayer
-------------------------


NAME
    Import-ALOsLayer
    
SYNOPSIS
    Creates a new operating system layer
    
    
SYNTAX
    Import-ALOsLayer [-websession] <Object> [-vmname] <Object> [[-description] <Object>] [-connectorid] <Object> [-shareid] <Object> [[-icon] <Object>] [-name] <Object> [[-size] <Object>] [-version] <Object> [-vmid] <Object> 
    [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates a new operating system layer
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    -vmname <Object>
        Virtual machine name to import from
        
    -description <Object>
        Description of the layer
        
    -connectorid <Object>
        ID of Connector to use
        
    -shareid <Object>
        ID of file share
        
    -icon <Object>
        Icon ID (default 196608)
        
    -name <Object>
        Name of the layer
        
    -size <Object>
        Size of layer in GB (default 61440)
        
    -version <Object>
        Version number of the layer
        
    -vmid <Object>
        Virtual Machine ID from vCenter
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$fileshare = Get-ALRemoteshare -websession $websession
    
    $connector = Get-ALconnector -websession $websession -type Create
    $shares = get-alremoteshare -websession $websession
    #vCenter Command
    $vm = Get-VM "Windows2016VM"
    $vmid = $vm.Id -replace "VirtualMachine-",""
    $response = import-aloslayer -websession $websession -vmname $vm.name -connectorid $connector.id -shareid $fileshare.id -name "Windows 2016" -version "1.0" -vmid $vmid
    
    
    
    
REMARKS
    To see the examples, type: "get-help Import-ALOsLayer -examples".
    For more information, type: "get-help Import-ALOsLayer -detailed".
    For technical information, type: "get-help Import-ALOsLayer -full".




