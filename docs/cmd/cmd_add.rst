 Commands
=========================

This page contains details on **** commands.

Add-ALAppAssignment
-------------------------


NAME
    Add-ALAppAssignment
    
SYNOPSIS
    Adds a layer(application) assignment to image(template)
    
    
SYNTAX
    Add-ALAppAssignment [-websession] <Object> [-apprevid] <String> [-imageid] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Adds a layer(application) assignment to image(template)
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -apprevid <String>
        Application layer version to be added
        
    -imageid <String>
        Image or template where application should be added
        
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
    $apprevs = get-alapplayerDetail -websession $websession -id $app.Id
    $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    add-alappassignment -websession $websession -apprevid $apprevid.id -imageid $image.id
    
    
    
    
REMARKS
    To see the examples, type: "get-help Add-ALAppAssignment -examples".
    For more information, type: "get-help Add-ALAppAssignment -detailed".
    For technical information, type: "get-help Add-ALAppAssignment -full".


Add-ALELAppassignment
-------------------------

NAME
    Add-ALELAppassignment
    
SYNOPSIS
    Adds a user account or group to an applications elastic layer assignment
    
    
SYNTAX
    Add-ALELAppassignment [-websession] <Object> [-apprevid] <String> [-unideskid] <Int64> [-directoryjunctionid] <Int64> [-ldapguid] <String> [-ldapdn] <String> [-sid] <String> [-objecttype] <String> [[-imageid] <Int64>] 
    [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Adds a user account or group to an applications elastic layer assignment
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -apprevid <String>
        Application version layer ID
        
    -unideskid <Int64>
        
    -directoryjunctionid <Int64>
        
    -ldapguid <String>
        
    -ldapdn <String>
        
    -sid <String>
        
    -objecttype <String>
        
    -imageid <Int64>
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$user = get-alldapobject -websession $websession -object "myusername"
    
    add-alelappassignment -websession $websession -apprevid $apprevid.Id -unideskid $unideskid -objecttype $objecttype -directoryjunctionid $directoryjunctionid -ldapguid $ldapguid -ldapdn $ldapdn -sid $sid -Confirm:$False
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>$users = @('MyGroup1','MyGroup2','Domain Users')
    
    $finduser = $users|get-alldapobject -websession $websession
    $app = Get-ALapplayerDetail -websession $websession|where{$_.name -eq "Libre Office"}
    $apprevs = Get-ALapplayerDetail -websession $websession -id $app.Id
    $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
    $add-alelappassignment -websession $websession -apprevid $apprevid.Id -unideskid $finduser.unideskid -objecttype $finduser.objecttype -directoryjunctionid $finduser.directoryjunctionid -ldapguid $finduser.guid -ldapdn 
    $finduser.dn -sid $finsuser.sid -Confirm:$False
    
    
    
    
REMARKS
    To see the examples, type: "get-help Add-ALELAppassignment -examples".
    For more information, type: "get-help Add-ALELAppassignment -detailed".
    For technical information, type: "get-help Add-ALELAppassignment -full".




