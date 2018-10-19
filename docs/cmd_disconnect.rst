Disconnect Commands
=========================

This page contains details on **Disconnect** commands.

Disconnect-ALsession
-------------------------


NAME
    Disconnect-ALsession
    
SYNOPSIS
    Logs off and disconnects web session
    
    
SYNTAX
    Disconnect-ALsession [-websession] <Object> [<CommonParameters>]
    
    
DESCRIPTION
    Logs off and disconnects web session
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM  Appliance
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Disconnect-ALsession -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Disconnect-ALsession -examples".
    For more information, type: "get-help Disconnect-ALsession -detailed".
    For technical information, type: "get-help Disconnect-ALsession -full".




