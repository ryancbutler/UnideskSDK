remove Commands
=========================

This page contains details on **remove** commands.

Remove-ALAppassignment
-------------------------


NAME
    Remove-ALAppassignment
    
SYNOPSIS
    Removes a layer(application) assignment to image(template)
    
    
SYNTAX
    Remove-ALAppassignment [-websession] <Object> [-applayerid] <String> [-imageid] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Removes a layer(application) assignment to image(template)
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -applayerid <String>
        
    -imageid <String>
        Image or template where application should be removed
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$image = Get-ALimage -websession $websession|where{$_.name -eq "Accounting}
    
    $app = Get-ALapplayer -websession $websession|where{$_.name -eq "Libre Office"}
    $apprevs = get-alapplayer -websession $websession -id $app.Id
    $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    remove-alappassignment -websession $websession -applayerid $apprevid.LayerId -imageid $image.id
    
    
    
    
REMARKS
    To see the examples, type: "get-help Remove-ALAppassignment -examples".
    For more information, type: "get-help Remove-ALAppassignment -detailed".
    For technical information, type: "get-help Remove-ALAppassignment -full".


Remove-ALAppLayerRev
-------------------------

NAME
    Remove-ALAppLayerRev
    
SYNOPSIS
    Removes a app layer version
    
    
SYNTAX
    Remove-ALAppLayerRev [-websession] <Object> [-appid] <Object> [-apprevid] <Object> [-fileshareid] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Removes a app layer version
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -appid <Object>
        Base application layer version id to use
        
    -apprevid <Object>
        Application revision version id to use
        
    -fileshareid <Object>
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$fileshare = Get-ALRemoteshare -websession $websession
    
    $appid = Get-ALapplayer -websession $websession | where{$_.name -eq "7-Zip"}
    $apprevid = get-alapplayerDetail -websession $websession -id $appid.Id
    $apprevid = $apprevid.Revisions.AppLayerRevisionDetail | where{$_.candelete -eq $true} | Sort-Object revision -Descending | select -First 1
    remove-alapplayerrev -websession $websession -appid $appid.Id -apprevid $apprevid.id -fileshareid $fileshare.id
    
    
    
    
REMARKS
    To see the examples, type: "get-help Remove-ALAppLayerRev -examples".
    For more information, type: "get-help Remove-ALAppLayerRev -detailed".
    For technical information, type: "get-help Remove-ALAppLayerRev -full".


remove-ALDirectory
-------------------------

NAME
    remove-ALDirectory
    
SYNOPSIS
    Removes Directory Junction
    
    
SYNTAX
    remove-ALDirectory [-websession] <Object> [-id] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Removes Directory Junction
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -id <String>
        Directory Junction ID
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Remove-ALDirectory -websession $websession -id "4915204"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help remove-ALDirectory -examples".
    For more information, type: "get-help remove-ALDirectory -detailed".
    For technical information, type: "get-help remove-ALDirectory -full".


Remove-ALELAppassignment
-------------------------

NAME
    Remove-ALELAppassignment
    
SYNOPSIS
    Removes a user account or group to an applications elastic layer assignment
    
    
SYNTAX
    Remove-ALELAppassignment [-websession] <Object> [-applayerid] <String> [-user] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Removes a user account or group to an applications elastic layer assignment
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -applayerid <String>
        
    -user <String>
        LDAP located user object
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$user = get-alldapobject -websession $websession -object "myusername"
    
    remove-alelappassignment -websession $websession -apprevid $apprevid.Id -user $user
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>$users = @('MyGroup1','MyGroup2','Domain Users')
    
    $finduser = $users|get-alldapobject -websession $websession
    $app = Get-ALapplayerDetail -websession $websession|where{$_.name -eq "Libre Office"}
    $apprevs = Get-ALapplayerDetail -websession $websession -id $app.Id
    $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    $finduser|remove-alelappassignment -websession $websession -apprevid $apprevid.Id
    
    
    
    
REMARKS
    To see the examples, type: "get-help Remove-ALELAppassignment -examples".
    For more information, type: "get-help Remove-ALELAppassignment -detailed".
    For technical information, type: "get-help Remove-ALELAppassignment -full".


remove-ALicon
-------------------------

NAME
    remove-ALicon
    
SYNOPSIS
    Removes icon based on ID
    
    
SYNTAX
    remove-ALicon [-websession] <Object> [-iconid] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Removes icon based on ID
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -iconid <String>
        Icon ID
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Remove-ALicon -websession $websession -iconid "4259847"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help remove-ALicon -examples".
    For more information, type: "get-help remove-ALicon -detailed".
    For technical information, type: "get-help remove-ALicon -full".


Remove-ALImage
-------------------------

NAME
    Remove-ALImage
    
SYNOPSIS
    Removes image(template)
    
    
SYNTAX
    Remove-ALImage [-websession] <Object> [-id] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Removes image(template)
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -id <String>
        ID of image to remove
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting"}
    
    Remove-ALImage -websession $websession -imageid $image.id
    
    
    
    
REMARKS
    To see the examples, type: "get-help Remove-ALImage -examples".
    For more information, type: "get-help Remove-ALImage -detailed".
    For technical information, type: "get-help Remove-ALImage -full".


Remove-ALOSLayerRev
-------------------------

NAME
    Remove-ALOSLayerRev
    
SYNOPSIS
    Removes a OS layer version
    
    
SYNTAX
    Remove-ALOSLayerRev [-websession] <Object> [-osid] <Object> [-osrevid] <Object> [-fileshareid] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Removes a OS layer version
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -osid <Object>
        Base OS layer version id to use
        
    -osrevid <Object>
        OS revision version id to use
        
    -fileshareid <Object>
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$fileshare = Get-ALRemoteshare -websession $websession
    
    $osid = Get-ALOSlayer -websession $websession | where{$_.name -eq "Windows 10 x64"}
    $osrevid = Get-ALOSlayerDetail -websession $websession -id $osid.Id
    $osrevid = $osrevid.Revisions.OSLayerRevisionDetail | where{$_.candelete -eq $true} | Sort-Object revision -Descending | select -Last 1
    remove-aloslayerrev -websession $websession -osid $osid.Id -osrevid $osrevid.id -fileshareid $fileshare.id
    
    
    
    
REMARKS
    To see the examples, type: "get-help Remove-ALOSLayerRev -examples".
    For more information, type: "get-help Remove-ALOSLayerRev -detailed".
    For technical information, type: "get-help Remove-ALOSLayerRev -full".


Remove-ALPlatformLayerRev
-------------------------

NAME
    Remove-ALPlatformLayerRev
    
SYNOPSIS
    Removes a platform layer version
    
    
SYNTAX
    Remove-ALPlatformLayerRev [-websession] <Object> [-platformid] <Object> [-platformrevid] <Object> [-fileshareid] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Removes a platform layer version
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -platformid <Object>
        Base platform layer version id to use
        
    -platformrevid <Object>
        Platform revision version id to use
        
    -fileshareid <Object>
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$fileshare = Get-ALRemoteshare -websession $websession
    
    $platformid = Get-ALPlatformlayer -websession $websession | where{$_.name -eq "Windows 10 VDA"}
    $platformrevid = Get-ALPlatformlayerDetail -websession $websession -id $platformid.Id
    $platformrevid = $platformrevid.Revisions.PlatformLayerRevisionDetail | where{$_.candelete -eq $true} | Sort-Object revision -Descending | select -First 1
    remove-alplatformlayerrev -websession $websession -platformid $platformid.Id -platformrevid $platformrevid.id -fileshareid $fileshare.id
    
    
    
    
REMARKS
    To see the examples, type: "get-help Remove-ALPlatformLayerRev -examples".
    For more information, type: "get-help Remove-ALPlatformLayerRev -detailed".
    For technical information, type: "get-help Remove-ALPlatformLayerRev -full".




