Export Commands
=========================

This page contains details on **Export** commands.

Export-ALLayerRev
-------------------------


NAME
    Export-ALLayerRev
    
SYNOPSIS
    Gets revisions that can be used to export
    
    
SYNTAX
    Export-ALLayerRev [-websession] <Object> [-sharepath] <String> [-id] <String> [[-username] <String>] [[-sharepw] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Gets revisions that can be used to export
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -sharepath <String>
        Share UNC Path type
        
    -id <String>
        ID(s) of revision layers to export
        
    -username <String>
        Share username
        
    -sharepw <String>
        Share password
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Export-ALlayerrev -websession $websession -sharepath "\\myserver\path\layers" -id @(12042,225252,2412412)
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Export-ALLayerRev -examples".
    For more information, type: "get-help Export-ALLayerRev -detailed".
    For technical information, type: "get-help Export-ALLayerRev -full".




