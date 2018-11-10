Set Commands
=========================

This page contains details on **Set** commands.

Set-ALApplayer
-------------------------


NAME
    Set-ALApplayer
    
SYNOPSIS
    Edits values of an application layer
    
    
SYNTAX
    Set-ALApplayer [-websession] <Object> [-id] <String> [-name] <String> [[-description] <String>] [[-scriptpath] <String>] [[-icon] <String>] [-OsLayerSwitching] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Edits values of an application layer
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -id <String>
        ID of the applayer to edit
        
    -name <String>
        Name of the application layer
        
    -description <String>
        Description of the layer
        
    -scriptpath <String>
        Path of script to be run
        
    -icon <String>
        Icon ID (default 196608)
        
    -OsLayerSwitching <String>
        Allow OS Switching NotBoundToOsLayer=ON BoundToOsLayer=OFF
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
    
    Set-alapplayer -websession $websession -name "7-Zip" -description "7-zip" -id $app.Id -scriptpath "C:\NeededScript.ps1" -OsLayerSwitching BoundToOsLayer
    
    
    
    
REMARKS
    To see the examples, type: "get-help Set-ALApplayer -examples".
    For more information, type: "get-help Set-ALApplayer -detailed".
    For technical information, type: "get-help Set-ALApplayer -full".


Set-ALImage
-------------------------

NAME
    Set-ALImage
    
SYNOPSIS
    Edits values of a image(template)
    
    
SYNTAX
    Set-ALImage [-websession] <Object> [-id] <String> [-name] <String> [[-description] <String>] [-connectorid] <String> [-osrevid] <String> [-platrevid] <String> [[-ElasticLayerMode] <String>] [-diskformat] <String> [[-size] 
    <String>] [[-icon] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Edits values of a image(template)
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -id <String>
        ID of image
        
    -name <String>
        Name of the image
        
    -description <String>
        Description of the image
        
    -connectorid <String>
        ID of Connector to use
        
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
    
    PS C:\>$fileshare = Get-ALRemoteshare -websession $websession
    
    $connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
    $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
    $osrevs = get-aloslayerdetail -websession $websession -id $oss.id
    $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    $plats = Get-ALPlatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
    $platrevs = get-alplatformlayerdetail -websession $websession -id $plats.id
    $platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    $image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting"}
    Set-alimage -websession $websession -name $images.Name -description "My new description" -connectorid $connector.id -osrevid $osrevid.Id -platrevid $platformrevid.id -id $image.Id -ElasticLayerMode Session -diskformat 
    $connector.ValidDiskFormats.DiskFormat
    
    
    
    
REMARKS
    To see the examples, type: "get-help Set-ALImage -examples".
    For more information, type: "get-help Set-ALImage -detailed".
    For technical information, type: "get-help Set-ALImage -full".




