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
        Existing Webrequest session for ELM Appliance
        
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
        Existing Webrequest session for ELM Appliance
        
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


Get-ALAuditInfo
-------------------------

NAME
    Get-ALAuditInfo
    
SYNOPSIS
    Gets audit information
    
    
SYNTAX
    Get-ALAuditInfo [-websession] <Object> [-entitytype] <String> [[-id] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Gets System Settings
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -entitytype <String>
        Type of log to pull
        
    -id <String>
        ID of entity to pull audit logs
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALAuditInfo -websession $websession -entitytype OsLayer -id 753664
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ALAuditInfo -websession $websession -entitytype ManagementAppliance
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALAuditInfo -examples".
    For more information, type: "get-help Get-ALAuditInfo -detailed".
    For technical information, type: "get-help Get-ALAuditInfo -full".


Get-ALCachePointInfo
-------------------------

NAME
    Get-ALCachePointInfo
    
SYNOPSIS
    Gets appliance Layering Service Info
    
    
SYNTAX
    Get-ALCachePointInfo [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets appliance Layering Service Info
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALCachePointInfo -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALCachePointInfo -examples".
    For more information, type: "get-help Get-ALCachePointInfo -detailed".
    For technical information, type: "get-help Get-ALCachePointInfo -full".


Get-ALconnector
-------------------------

NAME
    Get-ALconnector
    
SYNOPSIS
    Gets all appliance connectors currently configured
    
    
SYNTAX
    Get-ALconnector [-websession] <Object> [-type] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets all appliance connectors currently configured
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -type <String>
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


Get-ALDirectory
-------------------------

NAME
    Get-ALDirectory
    
SYNOPSIS
    Gets Directory Junctions
    
    
SYNTAX
    Get-ALDirectory [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets Directory Junctions
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALDirectory -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALDirectory -examples".
    For more information, type: "get-help Get-ALDirectory -detailed".
    For technical information, type: "get-help Get-ALDirectory -full".


Get-ALDirectoryDetail
-------------------------

NAME
    Get-ALDirectoryDetail
    
SYNOPSIS
    Gets additional directory junction detail
    
    
SYNTAX
    Get-ALDirectoryDetail [-websession] <Object> [-id] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets additional directory junction detail
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -id <String>
        Directory Junction id
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>get-aldirectorydetail -websession $websession -id $directory.id
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALDirectoryDetail -examples".
    For more information, type: "get-help Get-ALDirectoryDetail -detailed".
    For technical information, type: "get-help Get-ALDirectoryDetail -full".


Get-ALExportableRev
-------------------------

NAME
    Get-ALExportableRev
    
SYNOPSIS
    Gets revisions that can be used to export to share
    
    
SYNTAX
    Get-ALExportableRev [-websession] <Object> [-sharepath] <String> [[-username] <String>] [[-sharepw] <String>] [-showall] [<CommonParameters>]
    
    
DESCRIPTION
    Gets revisions that can be used to export to share
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -sharepath <String>
        Share UNC Path type
        
    -username <String>
        Share username
        
    -sharepw <String>
        Share password
        
    -showall [<SwitchParameter>]
        Get all layers including non exportable ones
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALExportableRev -websession $websession -sharepath "\\myserver\path\layers"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALExportableRev -examples".
    For more information, type: "get-help Get-ALExportableRev -detailed".
    For technical information, type: "get-help Get-ALExportableRev -full".


Get-ALicon
-------------------------

NAME
    Get-ALicon
    
SYNOPSIS
    Gets all icon IDs
    
    
SYNTAX
    Get-ALicon [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets all icon IDs
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALicon -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALicon -examples".
    For more information, type: "get-help Get-ALicon -detailed".
    For technical information, type: "get-help Get-ALicon -full".


Get-ALiconassoc
-------------------------

NAME
    Get-ALiconassoc
    
SYNOPSIS
    Gets items associated with icon
    
    
SYNTAX
    Get-ALiconassoc [-websession] <Object> [-iconid] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets items associated with icon
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -iconid <String>
        Icon ID
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALicon -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALiconassoc -examples".
    For more information, type: "get-help Get-ALiconassoc -detailed".
    For technical information, type: "get-help Get-ALiconassoc -full".


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
        Existing Webrequest session for ELM Appliance
        
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


Get-ALImageComp
-------------------------

NAME
    Get-ALImageComp
    
SYNOPSIS
    Gets image composition details
    
    
SYNTAX
    Get-ALImageComp [-websession] <Object> [[-id] <String>] [[-name] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Gets image composition details
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -id <String>
        Image(template) id
        
    -name <String>
        Image name (supports wildcard)
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Gets all images and layer composition
    
    Get-ALImageComp -websession $websession
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Gets image and layer composition based on ID
    
    Get-ALImageComp -websession $websession -id 5535
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Gets image and layer composition based on name
    
    Get-ALImageComp -websession $websession -name "Windows 10"
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Gets image and layer composition based on name (wildcard)
    
    Get-ALImageComp -websession $websession -name "*10*"
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALImageComp -examples".
    For more information, type: "get-help Get-ALImageComp -detailed".
    For technical information, type: "get-help Get-ALImageComp -full".


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
        Existing Webrequest session for ELM Appliance
        
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


Get-ALImportableRev
-------------------------

NAME
    Get-ALImportableRev
    
SYNOPSIS
    Gets revisions that can be used to import
    
    
SYNTAX
    Get-ALImportableRev [-websession] <Object> [-sharepath] <String> [[-username] <String>] [[-sharepw] <String>] [-showall] [<CommonParameters>]
    
    
DESCRIPTION
    Gets revisions that can be used to import
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -sharepath <String>
        Share UNC Path type
        
    -username <String>
        Share username
        
    -sharepw <String>
        Share password
        
    -showall [<SwitchParameter>]
        Get all layers including non exportable ones
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALImportableRev -websession $websession -sharepath "\\myserver\path\layers"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALImportableRev -examples".
    For more information, type: "get-help Get-ALImportableRev -detailed".
    For technical information, type: "get-help Get-ALImportableRev -full".


Get-ALLayerInstallDisk
-------------------------

NAME
    Get-ALLayerInstallDisk
    
SYNOPSIS
    Gets install disk location during finalize process
    
    
SYNTAX
    Get-ALLayerInstallDisk [-websession] <Object> [-id] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets install disk location during finalize process
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -id <String>
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
        Existing Webrequest session for ELM Appliance
        
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
        Existing Webrequest session for ELM Appliance
        
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
        Existing Webrequest session for ELM Appliance
        
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
        Existing Webrequest session for ELM Appliance
        
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
        Existing Webrequest session for ELM Appliance
        
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
        Existing Webrequest session for ELM Appliance
        
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
        Existing Webrequest session for ELM Appliance
        
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
    Get-ALStatus [-websession] <Object> [[-id] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Gets any non-completed task currently running on appliance
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -id <String>
        Workticket ID of job
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALStatus -websession $websession
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ALStatus -websession $websession -id "4521984"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALStatus -examples".
    For more information, type: "get-help Get-ALStatus -detailed".
    For technical information, type: "get-help Get-ALStatus -full".


Get-ALSystemInfo
-------------------------

NAME
    Get-ALSystemInfo
    
SYNOPSIS
    Gets appliance System Details
    
    
SYNTAX
    Get-ALSystemInfo [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets appliance System Details
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALSystemInfo -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALSystemInfo -examples".
    For more information, type: "get-help Get-ALSystemInfo -detailed".
    For technical information, type: "get-help Get-ALSystemInfo -full".


Get-ALSystemSettingInfo
-------------------------

NAME
    Get-ALSystemSettingInfo
    
SYNOPSIS
    Gets appliance System Settings
    
    
SYNTAX
    Get-ALSystemSettingInfo [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Gets appliance System Settings
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALSystemSettingInfo -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALSystemSettingInfo -examples".
    For more information, type: "get-help Get-ALSystemSettingInfo -detailed".
    For technical information, type: "get-help Get-ALSystemSettingInfo -full".


Get-ALUserAssignment
-------------------------

NAME
    Get-ALUserAssignment
    
SYNOPSIS
    Gets user app layer assignments
    
    
SYNTAX
    Get-ALUserAssignment [-websession] <Object> [-id] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets user app layer assignments
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -id <String>
        Unidesk ID of user
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALUserAssignments -websession $websession -id "4521984" -Verbose
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALUserAssignment -examples".
    For more information, type: "get-help Get-ALUserAssignment -detailed".
    For technical information, type: "get-help Get-ALUserAssignment -full".


Get-ALUserDetail
-------------------------

NAME
    Get-ALUserDetail
    
SYNOPSIS
    Gets detailed information on user from directory junction
    
    
SYNTAX
    Get-ALUserDetail [-websession] <Object> [-id] <String> [-junctionid] <String> [-ldapguid] <String> [-dn] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets detailed information on user from directory junction
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -id <String>
        Unidesk ID of user
        
    -junctionid <String>
        Directory junction ID
        
    -ldapguid <String>
        
    -dn <String>
        LDAP DN of user
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALUserDetail -websession $websession -junctionid $dir.id -ldapguid $userid.DirectoryId.LdapGuid -dn $userid.DirectoryId.LdapDN -id $userid.DirectoryId.UnideskId
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALUserDetail -examples".
    For more information, type: "get-help Get-ALUserDetail -detailed".
    For technical information, type: "get-help Get-ALUserDetail -full".


Get-ALUserList
-------------------------

NAME
    Get-ALUserList
    
SYNOPSIS
    Gets list of users and groups for specific LDAP DN
    
    
SYNTAX
    Get-ALUserList [-websession] <Object> [-junctionid] <String> [-dn] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Gets list of users and groups for specific LDAP DN
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -junctionid <String>
        Directory junction ID
        
    -dn <String>
        LDAP DN of user location
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ALUserList -websession $websession -junctionid $dir.id -dn "CN=Users,DC=mydomain,DC=com"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALUserList -examples".
    For more information, type: "get-help Get-ALUserList -detailed".
    For technical information, type: "get-help Get-ALUserList -full".


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
    
    PS C:\>Get-ALVMName -message $status.WorkItems.WorkItemResult.Status
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ALVMName -examples".
    For more information, type: "get-help Get-ALVMName -detailed".
    For technical information, type: "get-help Get-ALVMName -full".




