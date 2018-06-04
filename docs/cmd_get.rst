Get Commands
=========================

This page contains details on **Get** commands.

Get-ALapplayer
-------------------------


NAME
    Get-ALapplayer
    
SYNOPSIS
    Gets all application layers
    
    
SYNTAX
    Get-ALapplayer [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets all application layers
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALapplayer -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALapplayer -examples".
    For more information, type: "get-help Get-ALapplayer -detailed".
    For technical information, type: "get-help Get-ALapplayer -full".


Get-ALapplayerDetail
-------------------------

NAME
    Get-ALapplayerDetail
    
SYNOPSIS
    Gets detailed information on Application Layer including revisions(versions)
    
    
SYNTAX
    Get-ALapplayerDetail [-websession] <Object> [-id] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets detailed information on Application Layer including revisions(versions)
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    -id <String>
        Application layer ID
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>get-alapplayer -websession $websession -id $app.Id
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALapplayerDetail -examples".
    For more information, type: "get-help Get-ALapplayerDetail -detailed".
    For technical information, type: "get-help Get-ALapplayerDetail -full".


Get-ALconnector
-------------------------

NAME
    Get-ALconnector
    
SYNOPSIS
    Gets all appliance connectors currently configured
    
    
SYNTAX
    Get-ALconnector [-websession] <Object> [-type] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets all appliance connectors currently configured
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    -type <Object>
        Connector type for publishing or creating layers\images
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALconnector -websession $websession -type "Publish"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALconnector -examples".
    For more information, type: "get-help Get-ALconnector -detailed".
    For technical information, type: "get-help Get-ALconnector -full".


Get-ALimage
-------------------------

NAME
    Get-ALimage
    
SYNOPSIS
    Gets all images(templates)
    
    
SYNTAX
    Get-ALimage [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets all images(templates)
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALimage -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALimage -examples".
    For more information, type: "get-help Get-ALimage -detailed".
    For technical information, type: "get-help Get-ALimage -full".


Get-ALimageDetail
-------------------------

NAME
    Get-ALimageDetail
    
SYNOPSIS
    Gets additional image(template) detail
    
    
SYNTAX
    Get-ALimageDetail [-websession] <Object> [-id] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets additional image(template) detail
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    -id <String>
        Image(template) id
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>get-alimagedetail -websession $websession -id $image.id
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALimageDetail -examples".
    For more information, type: "get-help Get-ALimageDetail -detailed".
    For technical information, type: "get-help Get-ALimageDetail -full".


Get-ALLayerInstallDisk
-------------------------

NAME
    Get-ALLayerInstallDisk
    
SYNOPSIS
    Gets install disk location during finalize process
    
    
SYNTAX
    Get-ALLayerInstallDisk [-websession] <Object> [-id] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets install disk location during finalize process
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    -id <Object>
        Layer ID to be located
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>get-allayerinstalldisk -websession $websession -layerid $apprevid.LayerId
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALLayerInstallDisk -examples".
    For more information, type: "get-help Get-ALLayerInstallDisk -detailed".
    For technical information, type: "get-help Get-ALLayerInstallDisk -full".


Get-ALLdapObject
-------------------------

NAME
    Get-ALLdapObject
    
SYNOPSIS
    Locates LDAP user or group object
    
    
SYNTAX
    Get-ALLdapObject [-websession] <Object> [-object] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Locates LDAP user or group object
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    -object <String>
        Group or user to be located
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>get-alldapobject -websession $websession -object "myusername"
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>$users = @('MyGroup1','MyGroup2','Domain Users')
    
    $finduser = $users|get-alldapobject -websession $websession
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALLdapObject -examples".
    For more information, type: "get-help Get-ALLdapObject -detailed".
    For technical information, type: "get-help Get-ALLdapObject -full".


Get-ALOsLayer
-------------------------

NAME
    Get-ALOsLayer
    
SYNOPSIS
    Gets all OS layers
    
    
SYNTAX
    Get-ALOsLayer [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets all OS layers
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALOsLayer -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALOsLayer -examples".
    For more information, type: "get-help Get-ALOsLayer -detailed".
    For technical information, type: "get-help Get-ALOsLayer -full".


Get-ALOsLayerDetail
-------------------------

NAME
    Get-ALOsLayerDetail
    
SYNOPSIS
    Gets detailed information on a OS layer including revisions
    
    
SYNTAX
    Get-ALOsLayerDetail [-websession] <Object> [-id] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets detailed information on a OS layer including revisions
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    -id <String>
        Operating System Layer ID
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>get-aloslayerdetail -websession $websession -id $app.AssociatedOsLayerId
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALOsLayerDetail -examples".
    For more information, type: "get-help Get-ALOsLayerDetail -detailed".
    For technical information, type: "get-help Get-ALOsLayerDetail -full".


Get-ALPendingOp
-------------------------

NAME
    Get-ALPendingOp
    
SYNOPSIS
    Gets appliance operation based on ID
    
    
SYNTAX
    Get-ALPendingOp [-websession] <Object> [-id] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets appliance operation based on ID
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    -id <String>
        workticket id
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALPendingOp -websession $websession -id $myworkid
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALPendingOp -examples".
    For more information, type: "get-help Get-ALPendingOp -detailed".
    For technical information, type: "get-help Get-ALPendingOp -full".


Get-ALPlatformlayer
-------------------------

NAME
    Get-ALPlatformlayer
    
SYNOPSIS
    Gets all platform layers
    
    
SYNTAX
    Get-ALPlatformlayer [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets all platform layers
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALPlatformlayer -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALPlatformlayer -examples".
    For more information, type: "get-help Get-ALPlatformlayer -detailed".
    For technical information, type: "get-help Get-ALPlatformlayer -full".


Get-ALPlatformLayerDetail
-------------------------

NAME
    Get-ALPlatformLayerDetail
    
SYNOPSIS
    Gets detailed information on a platform layer including revisions
    
    
SYNTAX
    Get-ALPlatformLayerDetail [-websession] <Object> [-id] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets detailed information on a platform layer including revisions
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    -id <String>
        Platform layer ID
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>get-alplatformlayerDetail -websession $websession -id $platform.id
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALPlatformLayerDetail -examples".
    For more information, type: "get-help Get-ALPlatformLayerDetail -detailed".
    For technical information, type: "get-help Get-ALPlatformLayerDetail -full".


Get-ALRemoteshare
-------------------------

NAME
    Get-ALRemoteshare
    
SYNOPSIS
    Gets CIFS share information currently configured
    
    
SYNTAX
    Get-ALRemoteshare [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets CIFS share information currently configured
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALRemoteshare -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALRemoteshare -examples".
    For more information, type: "get-help Get-ALRemoteshare -detailed".
    For technical information, type: "get-help Get-ALRemoteshare -full".


Get-ALStatus
-------------------------

NAME
    Get-ALStatus
    
SYNOPSIS
    Gets any non-completed task currently running on appliance
    
    
SYNTAX
    Get-ALStatus [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets any non-completed task currently running on appliance
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for CAL Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALStatus -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALStatus -examples".
    For more information, type: "get-help Get-ALStatus -detailed".
    For technical information, type: "get-help Get-ALStatus -full".


Get-ALVMName
-------------------------

NAME
    Get-ALVMName
    
SYNOPSIS
    Extracts VM name out of "action required" task
    
    
SYNTAX
    Get-ALVMName [-message] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Extracts VM name out of "action required" task
    

PARAMETERS
    -message <Object>
        Message from pending operation
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALVMName -message -message $status.WorkItems.WorkItemResult.Status
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALVMName -examples".
    For more information, type: "get-help Get-ALVMName -detailed".
    For technical information, type: "get-help Get-ALVMName -full".




