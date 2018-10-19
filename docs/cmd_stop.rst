Stop Commands
=========================

This page contains details on **Stop** commands.

Stop-ALWorkTicket
-------------------------


NAME
    Stop-ALWorkTicket
    
SYNOPSIS
    Stops or cancels a running layer operation process
    
    
SYNTAX
    Stop-ALWorkTicket [-websession] <Object> [-id] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Stops or cancels a running layer operation process
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM  Appliance
        
    -id <String>
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Stop-ALWorkTicket -websession $websession
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Stop-ALWorkTicket -examples".
    For more information, type: "get-help Stop-ALWorkTicket -detailed".
    For technical information, type: "get-help Stop-ALWorkTicket -full".




