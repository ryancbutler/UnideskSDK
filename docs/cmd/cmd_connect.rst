 Commands
=========================

This page contains details on **** commands.

Connect-ALsession
-------------------------


NAME
    Connect-ALsession
    
SYNOPSIS
    Connects to the Citrix Application Layering appliance and creates a web request session
    
    
SYNTAX
    Connect-ALsession [-Credential] <PSCredential> [-aplip] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Connects to the Citrix Application Layering appliance and creates a web request session
    

PARAMETERS
    -Credential <PSCredential>
        PowerShell credential object
        
    -aplip <String>
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>$websession = Connect-alsession -aplip $aplip -Credential $Credential -Verbose
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Connect-ALsession -examples".
    For more information, type: "get-help Connect-ALsession -detailed".
    For technical information, type: "get-help Connect-ALsession -full".




