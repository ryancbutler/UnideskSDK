Invoke Commands
=========================

This page contains details on **Invoke** commands.

Invoke-ALLayerFinalize
-------------------------


NAME
    Invoke-ALLayerFinalize
    
SYNOPSIS
    Runs finalize process on a layer
    
    
SYNTAX
    Invoke-ALLayerFinalize [-websession] <Object> [-fileshareid] <String> [-LayerRevisionId] <String> [-uncpath] <String> [-filename] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Runs finalize process on a layer
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -fileshareid <String>
        ID of file share location used to store disk
        
    -LayerRevisionId <String>
        Revision ID of layer to be finalized
        
    -uncpath <String>
        UNC Path of fileshare
        
    -filename <String>
        Filename of the disk
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
    
    $apprevs = get-alapplayerdetail -websession $websession -id $app.Id
    $shares = get-alremoteshare -websession $websession
    $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Finalizable"}|Sort-Object revision -Descending|select -First 1
    $disklocation = get-allayerinstalldisk -websession $websession -layerid $apprevid.LayerId
    invoke-allayerfinalize -websession $websession -fileshareid $shares.id -LayerRevisionId $apprevid.Id -uncpath $disklocation.diskuncpath -filename $disklocation.diskname
    
    
    
    
REMARKS
    To see the examples, type: "get-help Invoke-ALLayerFinalize -examples".
    For more information, type: "get-help Invoke-ALLayerFinalize -detailed".
    For technical information, type: "get-help Invoke-ALLayerFinalize -full".


Invoke-ALPublish
-------------------------

NAME
    Invoke-ALPublish
    
SYNOPSIS
    Publishes image(template)
    
    
SYNTAX
    Invoke-ALPublish [-websession] <Object> [-imageid] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Publishes image(template)
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -imageid <String>
        Image ID to be published
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$images = Get-ALimage -websession $websession|where{$_.name -eq "Win 10 Accounting"}
    
    $image = get-alimagedetail -websession $websession -id $images.Id
    invoke-alpublish -websession $websession -imageid $images.id
    
    
    
    
REMARKS
    To see the examples, type: "get-help Invoke-ALPublish -examples".
    For more information, type: "get-help Invoke-ALPublish -detailed".
    For technical information, type: "get-help Invoke-ALPublish -full".




