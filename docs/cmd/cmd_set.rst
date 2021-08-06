 Commands
=========================

This page contains details on **** commands.

Set-ALAdminUser
-------------------------


NAME
    Set-ALAdminUser
    
SYNOPSIS
    Sets Administrator User Password
    
    
SYNTAX
    Set-ALAdminUser [-websession] <Object> [[-Password] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Sets Administrator User Password
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -Password <String>
        New Password for the User
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Set-ALAdminUser -websession $websession -Password $PlainPassword -Verbose
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Set-ALAdminUser -examples".
    For more information, type: "get-help Set-ALAdminUser -detailed".
    For technical information, type: "get-help Set-ALAdminUser -full".


Set-ALApplayer
-------------------------

NAME
    Set-ALApplayer
    
SYNOPSIS
    Edits values of an application layer
    
    
SYNTAX
    Set-ALApplayer [-websession] <Object> [-id] <String> [[-name] <String>] [[-description] <String>] [[-scriptpath] <String>] [[-icon] <String>] [[-OsLayerSwitching] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
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
        Icon ID
        
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


Set-ALConnectorCred
-------------------------

NAME
    Set-ALConnectorCred
    
SYNOPSIS
    Sets Connector Credentials
    
    
SYNTAX
    Set-ALConnectorCred [-websession] <Object> [-username] <String> [-password] <String> [-config] <PSObject> [-connector] <PSObject> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Sets Connector Username and Pass
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -username <String>
        Username to be used for Connector
        
    -password <String>
        password to be used for Connector
        
    -config <PSObject>
        Configuration settings for specific connector (Use get-alconnectordetail)
        
    -connector <PSObject>
        Configurations for specific connector (Use get-alconnector)
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Set-ALconnectorCred -websession $websession -config $ConnectorConfig -connector $connector -username "domain\first.last" -password "Test123
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Set-ALConnectorCred -examples".
    For more information, type: "get-help Set-ALConnectorCred -detailed".
    For technical information, type: "get-help Set-ALConnectorCred -full".


set-aldirectory
-------------------------

NAME
    set-aldirectory
    
SYNOPSIS
    Sets properties of an existing Directory Junction
    
    
SYNTAX
    set-aldirectory [-websession] <Object> [-id] <Object> [[-name] <String>] [[-serveraddress] <String>] [[-port] <String>] [[-usessl] <String>] [[-username] <String>] [-adpassword] <String> [-force] [-WhatIf] [-Confirm] 
    [<CommonParameters>]
    
    
DESCRIPTION
    Sets properties of an existing Directory Junction
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -id <Object>
        Junction ID
        
    -name <String>
        Junction name
        
    -serveraddress <String>
        AD server to connect
        
    -port <String>
        AD port (uses 389 and 636 by default)
        
    -usessl <String>
        Connect via SSL
        
    -username <String>
        AD username (eg admin@domain.com)
        
    -adpassword <String>
        AD password
        
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
    
    PS C:\>Set-aldirectory -websession $websession -adpassword "MYPASSWORD" -id $directory.id
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Set-aldirectory -websession $websession -adpassword "MYPASSWORD" -id $directory.id -name "MYNEWNAME"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help set-aldirectory -examples".
    For more information, type: "get-help set-aldirectory -detailed".
    For technical information, type: "get-help set-aldirectory -full".


Set-ALImage
-------------------------

NAME
    Set-ALImage
    
SYNOPSIS
    Edits values of a image(template)
    
    
SYNTAX
    Set-ALImage [-websession] <Object> [-id] <String> [[-name] <String>] [[-description] <String>] [[-connectorid] <String>] [[-osrevid] <String>] [[-platrevid] <String>] [[-applayerid] <Array>] [[-apprevid] <Array>] 
    [[-ElasticLayerMode] <String>] [[-diskformat] <String>] [[-size] <String>] [[-icon] <String>] [[-syspreptype] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
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
        
    -applayerid <Array>
        Application layer ID
        
    -apprevid <Array>
        Application layer version ID
        
    -ElasticLayerMode <String>
        Elastic Layer setting for the image. Options "None","Session","Office365","SessionOffice365","Desktop"
        
    -diskformat <String>
        Disk format of the image
        
    -size <String>
        Size of layer in MB
        
    -icon <String>
        Icon ID
        
    -syspreptype <String>
        Syspreptype for the Image. Options "None","Offline"
        
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
    $connector.ValidDiskFormats.DiskFormat -syspreptype Offline
    
    ### Edit image with latest revision for a specific app or apps ***
    $apps = @("Winscp","7-zip")
    $applayerids = foreach ($app in $apps){Get-ALapplayer -websession $websession|where{$_.name -eq $app}}
    $apprevs = foreach ($applayerid in $applayerids){get-alapplayerDetail -websession $websession -id $applayerid.Id}
    $apprevid = foreach ($apprev in $apprevs){$apprev.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1}
    Set-alimage -websession $websession -name $images.Name -description "My new description" -connectorid $connector.id -osrevid $osrevid.Id -platrevid $platformrevid.id -id $image.Id -ElasticLayerMode Session -diskformat 
    $connector.ValidDiskFormats.DiskFormat -applayerid $apprevid.LayerId -apprevid $apprevid.Id -syspreptype Offline
    
    
    
    
REMARKS
    To see the examples, type: "get-help Set-ALImage -examples".
    For more information, type: "get-help Set-ALImage -detailed".
    For technical information, type: "get-help Set-ALImage -full".


Set-alVcenterConnector
-------------------------

NAME
    Set-alVcenterConnector
    
SYNOPSIS
    Sets Vcenter Connector configuration
    
    
SYNTAX
    Set-alVcenterConnector [-websession] <Object> [-config] <Object> [-force] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Sets Vcenter Connector configuration
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -config <Object>
        Connector Config
        
    -force [<SwitchParameter>]
        Skip Verify
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Set-VcenterConnector -websession $websession -config $connectorconfig
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Set-alVcenterConnector -examples".
    For more information, type: "get-help Set-alVcenterConnector -detailed".
    For technical information, type: "get-help Set-alVcenterConnector -full".




