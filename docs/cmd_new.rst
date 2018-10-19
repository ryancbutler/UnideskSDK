New Commands
=========================

This page contains details on **New** commands.

New-ALAppLayer
-------------------------


NAME
    New-ALAppLayer
    
SYNOPSIS
    Creates a new application layer
    
    
SYNTAX
    New-ALAppLayer [-websession] <Object> [-version] <Object> [-name] <Object> [[-description] <Object>] [[-revdescription] <Object>] [[-OsLayerSwitching] <String>] [-connectorid] <Object> [-osrevid] <Object> [[-platformrevid] 
    <Object>] [-diskformat] <Object> [-fileshareid] <Object> [[-size] <Object>] [[-icon] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates a new application layer
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM  Appliance
        
    -version <Object>
        Version of the layer
        
    -name <Object>
        Name of the layer
        
    -description <Object>
        Description of the layer
        
    -revdescription <Object>
        Revision description
        
    -OsLayerSwitching <String>
        Allow OS Switching NotBoundToOsLayer=ON BoundToOsLayer=OFF
        
    -connectorid <Object>
        ID of Connector to use
        
    -osrevid <Object>
        Operating system version ID
        
    -platformrevid <Object>
        Platform version ID if needed
        
    -diskformat <Object>
        Disk format of the image
        
    -fileshareid <Object>
        Fileshare ID to store disk
        
    -size <Object>
        Size of layer in GB (default 10240)
        
    -icon <Object>
        Icon ID (default 196608)
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
    
    $fileshare = Get-ALRemoteshare -websession $websession
    $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
    $osrevs = get-aloslayerDetail -websession $websession -id $oss.id
    $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    new-alapplayer -websession $websession -version "1.0" -name "Accounting APP" -description "Accounting application" -connectorid $connector.id -osrevid $osrevid.Id -diskformat $connector.ValidDiskFormats.DiskFormat 
    -OsLayerSwitching BoundToOsLayer -fileshareid $fileshare.id
    
    
    
    
REMARKS
    To see the examples, type: "get-help New-ALAppLayer -examples".
    For more information, type: "get-help New-ALAppLayer -detailed".
    For technical information, type: "get-help New-ALAppLayer -full".


New-ALAppLayerRev
-------------------------

NAME
    New-ALAppLayerRev
    
SYNOPSIS
    Creates a new layer version
    
    
SYNTAX
    New-ALAppLayerRev [-websession] <Object> [-version] <Object> [-name] <Object> [[-description] <Object>] [-connectorid] <Object> [-appid] <Object> [-apprevid] <Object> [-osrevid] <Object> [[-platformrevid] <Object>] 
    [-diskformat] <Object> [-fileshareid] <Object> [[-size] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates a new layer version
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM  Appliance
        
    -version <Object>
        Version of the revision
        
    -name <Object>
        Name of the layer revision
        
    -description <Object>
        Description of the revision
        
    -connectorid <Object>
        ID of Connector to use
        
    -appid <Object>
        
    -apprevid <Object>
        Base application version layer id to use
        
    -osrevid <Object>
        OS version layer id to use
        
    -platformrevid <Object>
        Platform version ID if needed
        
    -diskformat <Object>
        Diskformat to store layer
        
    -fileshareid <Object>
        
    -size <Object>
        Size of layer in GB (default 10240)
        
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
    $app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
    $oss = Get-ALOsLayer -websession $websession
    $osrevs = get-aloslayerdetail -websession $websession -id $app.AssociatedOsLayerId
    $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    $apprevs = get-alapplayerDetail -websession $websession -id $app.Id
    $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    new-alapplayerrev -websession $websession -version "9.0" -name $app.Name -connectorid $connector.id -appid $app.Id -apprevid $apprevid.id -osrevid $osrevid.Id -diskformat $connector.ValidDiskFormats.DiskFormat -fileshareid 
    $fileshare.id
    
    
    
    
REMARKS
    To see the examples, type: "get-help New-ALAppLayerRev -examples".
    For more information, type: "get-help New-ALAppLayerRev -detailed".
    For technical information, type: "get-help New-ALAppLayerRev -full".


New-ALImage
-------------------------

NAME
    New-ALImage
    
SYNOPSIS
    Creates new image(template)
    
    
SYNTAX
    New-ALImage [-websession] <Object> [-name] <Object> [[-description] <Object>] [-connectorid] <Object> [-appids] <Object> [-osrevid] <Object> [-platrevid] <Object> [[-ElasticLayerMode] <String>] [-diskformat] <Object> 
    [[-size] <Object>] [[-icon] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates new image(template)
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM  Appliance
        
    -name <Object>
        Name of the layer
        
    -description <Object>
        Description of the layer
        
    -connectorid <Object>
        ID of Connector to use
        
    -appids <Object>
        IDs of application versions to add to image
        
    -osrevid <Object>
        Operating system layer version ID
        
    -platrevid <Object>
        Platform layer version ID
        
    -ElasticLayerMode <String>
        Elastic Layer setting for the image. Options "None","Session","Office365","SessionOffice365","Desktop"
        
    -diskformat <Object>
        Disk format of the image
        
    -size <Object>
        Size of layer in GB (default 102400)
        
    -icon <Object>
        Icon ID (default 196608)
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$connector = Get-ALconnector -websession $websession -type "Publish"|where{$_.name -eq "PVS"}
    
    $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
    $osrevs = get-aloslayer -websession $websession -id $oss.id
    $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    $plats = get-alplatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
    $platrevs = get-alplatformlayerdetail -websession $websession -id $plats.id
    $platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    $ids = @("1081350","1081349")
    new-alimage -websession $websession -name "Win10TEST55" -description "Accounting" -connectorid $connector.id -osrevid $osrevid.Id -appids $ids -platrevid $platformrevid.id -diskformat $connector.ValidDiskFormats.DiskFormat 
    -elasticlayermode Desktop
    
    
    
    
REMARKS
    To see the examples, type: "get-help New-ALImage -examples".
    For more information, type: "get-help New-ALImage -detailed".
    For technical information, type: "get-help New-ALImage -full".


New-ALOsLayerRev
-------------------------

NAME
    New-ALOsLayerRev
    
SYNOPSIS
    Creates new OS layer version
    
    
SYNTAX
    New-ALOsLayerRev [-websession] <Object> [-version] <Object> [[-description] <Object>] [-connectorid] <Object> [-osid] <Object> [-osrevid] <Object> [[-platformrevid] <Object>] [-diskformat] <Object> [-shareid] <Object> 
    [[-size] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates new OS layer version
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM  Appliance
        
    -version <Object>
        Version of the new layer
        
    -description <Object>
        Description of the layer
        
    -connectorid <Object>
        ID of Connector to use
        
    -osid <Object>
        Operating system layer ID
        
    -osrevid <Object>
        OS version layer id to use
        
    -platformrevid <Object>
        Platform version ID if needed
        
    -diskformat <Object>
        Disk format of the image
        
    -shareid <Object>
        ID of file share
        
    -size <Object>
        Size of layer in GB (default 61440)
        
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
    $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 2016 Standard"}
    $osrevs = get-aloslayerDetail -websession $websession -id $oss.id
    $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    new-aloslayerrev -websession $websession -version "2.0" -connectorid $connector.Id -osid $oss.id -osrevid $osrevid.id -diskformat $connector.ValidDiskFormats.DiskFormat -shareid $fileshare.id
    
    
    
    
REMARKS
    To see the examples, type: "get-help New-ALOsLayerRev -examples".
    For more information, type: "get-help New-ALOsLayerRev -detailed".
    For technical information, type: "get-help New-ALOsLayerRev -full".


New-ALPlatformLayer
-------------------------

NAME
    New-ALPlatformLayer
    
SYNOPSIS
    Creates new platform layer
    
    
SYNTAX
    New-ALPlatformLayer [-websession] <Object> [-osrevid] <Object> [-connectorid] <Object> [[-Description] <Object>] [-shareid] <Object> [[-iconid] <Object>] [-name] <Object> [[-size] <Object>] [-diskformat] <Object> 
    [[-platformrevid] <Object>] [-type] <Object> [[-HypervisorPlatformTypeId] <Object>] [[-ProvisioningPlatformTypeId] <Object>] [[-BrokerPlatformTypeId] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates new platform layer
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM  Appliance
        
    -osrevid <Object>
        OS version layer id to use
        
    -connectorid <Object>
        ID of Connector to use
        
    -Description <Object>
        Description of the layer
        
    -shareid <Object>
        ID of file share
        
    -iconid <Object>
        
    -name <Object>
        Name of the layer
        
    -size <Object>
        Size of layer in GB (default 10240)
        
    -diskformat <Object>
        Disk format of the image
        
    -platformrevid <Object>
        Platform version ID if needed
        
    -type <Object>
        Type of platform layer to create (Create or Publish)
        
    -HypervisorPlatformTypeId <Object>
        Hypervisor type of platform layer (default=vsphere)
        
    -ProvisioningPlatformTypeId <Object>
        Provisioning type MCS or PVS (default=mcs)
        
    -BrokerPlatformTypeId <Object>
        Broker type used (default=xendesktop)
        
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
    $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 2016 Standard"}
    $osrevs = get-aloslayerdetail -websession $websession -id $oss.id
    $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    New-ALPlatformLayer -websession $websession -osrevid $osrevid.Id -name "Citrix XA VDA 7.18" -connectorid $connector.id -shareid $fileshare.id -diskformat $connector.ValidDiskFormats.DiskFormat -type Create
    
    
    
    
REMARKS
    To see the examples, type: "get-help New-ALPlatformLayer -examples".
    For more information, type: "get-help New-ALPlatformLayer -detailed".
    For technical information, type: "get-help New-ALPlatformLayer -full".


New-ALPlatformLayerRev
-------------------------

NAME
    New-ALPlatformLayerRev
    
SYNOPSIS
    Creates new platform layer version
    
    
SYNTAX
    New-ALPlatformLayerRev [-websession] <Object> [-osrevid] <Object> [-connectorid] <Object> [[-Description] <Object>] [-shareid] <Object> [-layerid] <Object> [-layerrevid] <Object> [-version] <Object> [-Diskname] <Object> 
    [[-size] <Object>] [-diskformat] <Object> [[-HypervisorPlatformTypeId] <Object>] [[-ProvisioningPlatformTypeId] <Object>] [[-BrokerPlatformTypeId] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates new platform layer version
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM  Appliance
        
    -osrevid <Object>
        OS version layer id to use
        
    -connectorid <Object>
        ID of Connector to use
        
    -Description <Object>
        Description of the layer
        
    -shareid <Object>
        ID of file share
        
    -layerid <Object>
        Platform layer ID
        
    -layerrevid <Object>
        Version ID to base version from
        
    -version <Object>
        Version of the new layer
        
    -Diskname <Object>
        Disk file name
        
    -size <Object>
        Size of layer in MB (default 10240)
        
    -diskformat <Object>
        Disk format of the image
        
    -HypervisorPlatformTypeId <Object>
        Hypervisor type of platform layer (default=vsphere)
        
    -ProvisioningPlatformTypeId <Object>
        Provisioning type MCS or PVS (default=mcs)
        
    -BrokerPlatformTypeId <Object>
        Broker type used (default=xendesktop)
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$connector = Get-ALconnector -websession $websession -type "Create"
    
    $shares = get-alremoteshare -websession $websession
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
    shareid = $shares.id;
    layerid = $plats.Id;
    layerrevid = $platformrevid.id;
    version = "5.0";
    Diskname = $plats.Name;
    Verbose = $true;
    Description = "test";
    diskformat = $connector.ValidDiskFormats.DiskFormat;
    
    
    
    
REMARKS
    To see the examples, type: "get-help New-ALPlatformLayerRev -examples".
    For more information, type: "get-help New-ALPlatformLayerRev -detailed".
    For technical information, type: "get-help New-ALPlatformLayerRev -full".




