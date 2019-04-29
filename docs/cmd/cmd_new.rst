 Commands
=========================

This page contains details on **** commands.

New-ALAppLayer
-------------------------


NAME
    New-ALAppLayer
    
SYNOPSIS
    Creates a new application layer
    
    
SYNTAX
    New-ALAppLayer [-websession] <Object> [-version] <String> [-name] <String> [[-description] <String>] [[-revdescription] <String>] [[-OsLayerSwitching] <String>] [-connectorid] <String> [-osrevid] <String> [[-platformrevid] 
    <String>] [-diskformat] <String> [-fileshareid] <String> [[-size] <String>] [[-icon] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates a new application layer
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -version <String>
        Version of the layer
        
    -name <String>
        Name of the layer
        
    -description <String>
        Description of the layer
        
    -revdescription <String>
        Revision description
        
    -OsLayerSwitching <String>
        Allow OS Switching NotBoundToOsLayer=ON BoundToOsLayer=OFF
        
    -connectorid <String>
        ID of Connector to use
        
    -osrevid <String>
        Operating system version ID
        
    -platformrevid <String>
        Platform version ID if needed
        
    -diskformat <String>
        Disk format of the image
        
    -fileshareid <String>
        Fileshare ID to store disk
        
    -size <String>
        Size of layer in GB (default 10240)
        
    -icon <String>
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
    New-ALAppLayerRev [-websession] <Object> [-version] <String> [-name] <String> [[-description] <String>] [-connectorid] <String> [-appid] <String> [-apprevid] <String> [-osrevid] <String> [[-platformrevid] <String>] 
    [-diskformat] <String> [-fileshareid] <String> [[-size] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates a new layer version
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -version <String>
        Version of the revision
        
    -name <String>
        Name of the layer revision
        
    -description <String>
        Description of the revision
        
    -connectorid <String>
        ID of Connector to use
        
    -appid <String>
        
    -apprevid <String>
        Base application version layer id to use
        
    -osrevid <String>
        OS version layer id to use
        
    -platformrevid <String>
        Platform version ID if needed
        
    -diskformat <String>
        Diskformat to store layer
        
    -fileshareid <String>
        
    -size <String>
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


new-aldirectory
-------------------------

NAME
    new-aldirectory
    
SYNOPSIS
    Creates Directory Junction
    
    
SYNTAX
    new-aldirectory [-websession] <Object> [-name] <String> [-serveraddress] <String> [[-port] <String>] [-usessl] [-username] <String> [-adpassword] <String> [-basedn] <String> [-force] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates Directory Junction
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -name <String>
        Junction name
        
    -serveraddress <String>
        AD server to connect
        
    -port <String>
        AD port (uses 389 and 636 by default)
        
    -usessl [<SwitchParameter>]
        Connect via SSL
        
    -username <String>
        AD username (eg admin@domain.com)
        
    -adpassword <String>
        AD password
        
    -basedn <String>
        Base AD DN
        
    -force [<SwitchParameter>]
        Skip AD tests
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>new-aldirectory -websession $websession -serveraddress "mydc.domain.com" -Verbose -username "admin@domain.com" -adpassword "MYPASSWORD" -basedn DC=domain,DC=com -name "Mydirectory"
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>new-aldirectory -websession $websession -serveraddress "mydc.domain.com" -Verbose -usessl -username "admin@domain.com" -adpassword "MYPASSWORD" -basedn DC=domain,DC=com -name "Mydirectory"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help new-aldirectory -examples".
    For more information, type: "get-help new-aldirectory -detailed".
    For technical information, type: "get-help new-aldirectory -full".


new-ALicon
-------------------------

NAME
    new-ALicon
    
SYNOPSIS
    Converts and uploads image file to be used as icon
    
    
SYNTAX
    new-ALicon [-websession] <Object> [-iconfile] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Converts and uploads image file to be used as icon
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -iconfile <Object>
        Icon filename
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Upload-ALicon -websession $websession -iconfilename "d:\mysweeticon.png"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help new-ALicon -examples".
    For more information, type: "get-help new-ALicon -detailed".
    For technical information, type: "get-help new-ALicon -full".


New-ALImage
-------------------------

NAME
    New-ALImage
    
SYNOPSIS
    Creates new image(template)
    
    
SYNTAX
    New-ALImage [-websession] <Object> [-name] <String> [[-description] <String>] [-connectorid] <String> [-appids] <String[]> [-osrevid] <String> [-platrevid] <String> [[-ElasticLayerMode] <String>] [-diskformat] <String> 
    [[-size] <String>] [[-icon] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates new image(template)
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -name <String>
        Name of the layer
        
    -description <String>
        Description of the layer
        
    -connectorid <String>
        ID of Connector to use
        
    -appids <String[]>
        IDs of application versions to add to image
        
    -osrevid <String>
        Operating system layer version ID
        
    -platrevid <String>
        Platform layer version ID
        
    -ElasticLayerMode <String>
        Elastic Layer setting for the image. Options "None","Session","Office365","SessionOffice365","Desktop"
        
    -diskformat <String>
        Disk format of the image
        
    -size <String>
        Size of layer in GB (default 102400)
        
    -icon <String>
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


New-ALImageClone
-------------------------

NAME
    New-ALImageClone
    
SYNOPSIS
    Clones an Image
    
    
SYNTAX
    New-ALImageClone [-websession] <Object> [-imageid] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Clones an Image
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -imageid <Object>
        id for the image to be cloned
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$image = Get-ALimage -websession $websession | where {$_.name -eq "Windows 10 Accounting"}
    
    New-ALImageClone -websession $websession -imageid $image.Id -Confirm:$false -OutVariable ALImageClone
    
    
    
    
REMARKS
    To see the examples, type: "get-help New-ALImageClone -examples".
    For more information, type: "get-help New-ALImageClone -detailed".
    For technical information, type: "get-help New-ALImageClone -full".


New-ALOsLayerRev
-------------------------

NAME
    New-ALOsLayerRev
    
SYNOPSIS
    Creates new OS layer version
    
    
SYNTAX
    New-ALOsLayerRev [-websession] <Object> [-version] <String> [[-description] <String>] [-connectorid] <String> [-osid] <String> [-osrevid] <String> [[-platformrevid] <String>] [-diskformat] <String> [-shareid] <String> 
    [[-size] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates new OS layer version
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -version <String>
        Version of the new layer
        
    -description <String>
        Description of the layer
        
    -connectorid <String>
        ID of Connector to use
        
    -osid <String>
        Operating system layer ID
        
    -osrevid <String>
        OS version layer id to use
        
    -platformrevid <String>
        Platform version ID if needed
        
    -diskformat <String>
        Disk format of the image
        
    -shareid <String>
        ID of file share
        
    -size <String>
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
    New-ALPlatformLayer [-websession] <Object> [-osrevid] <String> [-connectorid] <String> [[-Description] <String>] [-shareid] <String> [[-iconid] <String>] [-name] <String> [[-size] <String>] [-diskformat] <String> 
    [[-platformrevid] <String>] [-type] <String> [[-HypervisorPlatformTypeId] <String>] [[-ProvisioningPlatformTypeId] <String>] [[-BrokerPlatformTypeId] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates new platform layer
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -osrevid <String>
        OS version layer id to use
        
    -connectorid <String>
        ID of Connector to use
        
    -Description <String>
        Description of the layer
        
    -shareid <String>
        ID of file share
        
    -iconid <String>
        
    -name <String>
        Name of the layer
        
    -size <String>
        Size of layer in GB (default 10240)
        
    -diskformat <String>
        Disk format of the image
        
    -platformrevid <String>
        Platform version ID if needed
        
    -type <String>
        Type of platform layer to create (Create or Publish)
        
    -HypervisorPlatformTypeId <String>
        Hypervisor type of platform layer (default=vsphere)
        
    -ProvisioningPlatformTypeId <String>
        Provisioning type MCS or PVS (default=mcs)
        
    -BrokerPlatformTypeId <String>
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
    New-ALPlatformLayerRev [-websession] <Object> [-osrevid] <String> [-connectorid] <String> [[-Description] <String>] [-shareid] <String> [-layerid] <String> [-layerrevid] <String> [-version] <String> [-Diskname] <String> 
    [[-size] <String>] [-diskformat] <String> [[-HypervisorPlatformTypeId] <String>] [[-ProvisioningPlatformTypeId] <String>] [[-BrokerPlatformTypeId] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates new platform layer version
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -osrevid <String>
        OS version layer id to use
        
    -connectorid <String>
        ID of Connector to use
        
    -Description <String>
        Description of the layer
        
    -shareid <String>
        ID of file share
        
    -layerid <String>
        Platform layer ID
        
    -layerrevid <String>
        Version ID to base version from
        
    -version <String>
        Version of the new layer
        
    -Diskname <String>
        Disk file name
        
    -size <String>
        Size of layer in MB (default 10240)
        
    -diskformat <String>
        Disk format of the image
        
    -HypervisorPlatformTypeId <String>
        Hypervisor type of platform layer (default=vsphere)
        
    -ProvisioningPlatformTypeId <String>
        Provisioning type MCS or PVS (default=mcs)
        
    -BrokerPlatformTypeId <String>
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


new-AlVcenterConnector
-------------------------

NAME
    new-AlVcenterConnector
    
SYNOPSIS
    Creates vCenter Connector configuration
    
    
SYNTAX
    new-AlVcenterConnector [-websession] <Object> [-name] <Object> [-dc] <Object> [-datastore] <Object> [-hostsystem] <Object> [-network] <Object> [-folder] <Object> [-connid] <Object> [-vcenterpass] <Object> [-username] 
    <Object> [-vcenter] <Object> [[-vmtemplate] <Object>] [[-cachesize] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Creates vCenter Connector configuration
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -name <Object>
        Name of the new connector
        
    -dc <Object>
        vCenter Datacenter id
        
    -datastore <Object>
        vCenter Datastore id
        
    -hostsystem <Object>
        vCenter ESXI hostname id
        
    -network <Object>
        vCenter network id
        
    -folder <Object>
        vCenter folder id
        
    -connid <Object>
        ELM platform connection id
        
    -vcenterpass <Object>
        vCenter password to authenticate
        
    -username <Object>
        vCenter username to authenticate
        
    -vcenter <Object>
        vCenter hostname
        
    -vmtemplate <Object>
        vCenter template id to use
        
    -cachesize <Object>
        Cache size for connector (GB)
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$Params = @{
    
    Name = "MyconnectorTest"
    DC = $dc
    DATASTORE = $datastore
    HOSTSYSTEM = $hostvar
    NETWORK = $network
    FOLDER = $folder
    CONNID = $type.Id
    VMTEMPLATE = $template
    CACHESIZE = "250"
    }
    
    new-AlVcenterConnector -websession $websession -username $usernamevc -vcenter $vcentername -vcenterpass $vcenterpassword @params
    
    
    
    
REMARKS
    To see the examples, type: "get-help new-AlVcenterConnector -examples".
    For more information, type: "get-help new-AlVcenterConnector -detailed".
    For technical information, type: "get-help new-AlVcenterConnector -full".




