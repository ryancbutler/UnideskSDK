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




