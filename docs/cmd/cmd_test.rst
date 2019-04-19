 Commands
=========================

This page contains details on **** commands.

test-aldirectory
-------------------------


NAME
    test-aldirectory
    
SYNOPSIS
    Test Directory Junction connectivity
    
    
SYNTAX
    test-aldirectory [-websession] <Object> [-serveraddress] <String> [[-port] <String>] [-usessl] [<CommonParameters>]
    
    
DESCRIPTION
    Test Directory Junction connectivity
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -serveraddress <String>
        AD server to connect
        
    -port <String>
        AD port (uses 389 and 636 by default)
        
    -usessl [<SwitchParameter>]
        Connect via SSL
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>test-aldirectory -websession $websession -serveraddress "mydc.domain.com" -Verbose
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>test-aldirectory -websession $websession -serveraddress "mydc.domain.com" -Verbose -usessl
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help test-aldirectory -examples".
    For more information, type: "get-help test-aldirectory -detailed".
    For technical information, type: "get-help test-aldirectory -full".


test-aldirectoryauth
-------------------------

NAME
    test-aldirectoryauth
    
SYNOPSIS
    Test Directory Junction authentication
    
    
SYNTAX
    test-aldirectoryauth [-websession] <Object> [-serveraddress] <String> [[-port] <String>] [-usessl] [-username] <String> [-adpassword] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Test Directory Junction authentication
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -serveraddress <String>
        AD server to connect
        
    -port <String>
        AD port (uses 389 and 636 by default)
        
    -usessl [<SwitchParameter>]
        Connect via SSL
        
    -username <String>
        AD username (eg admin@domain.com)
        
    -adpassword <String>
        AD password
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>test-aldirectoryauth -websession $websession -serveraddress "mydc.domain.com" -Verbose -username "admin@domain.com" -adpassword "MYPASSWORD"
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>test-aldirectoryauth -websession $websession -serveraddress "mydc.domain.com" -Verbose -usessl -username "admin@domain.com" -adpassword "MYPASSWORD"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help test-aldirectoryauth -examples".
    For more information, type: "get-help test-aldirectoryauth -detailed".
    For technical information, type: "get-help test-aldirectoryauth -full".


test-aldirectorydn
-------------------------

NAME
    test-aldirectorydn
    
SYNOPSIS
    Test Directory Junction DN path
    
    
SYNTAX
    test-aldirectorydn [-websession] <Object> [-serveraddress] <String> [[-port] <String>] [-usessl] [-username] <String> [-adpassword] <String> [-basedn] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Test Directory Junction DN path
    

PARAMETERS
    -websession <Object>
        Existing Webrequest session for ELM Appliance
        
    -serveraddress <String>
        AD server to connect
        
    -port <String>
        AD port (uses 389 and 636 by default)
        
    -usessl [<SwitchParameter>]
        Connect via SSL
        
    -username <String>
        AD username (eg admin@domain.com)
        
    -adpassword <String>
        AD password
        
    -basedn <String>
        Base AD DN
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>test-aldirectorydn -websession $websession -serveraddress "mydc.domain.com" -Verbose -username "admin@domain.com" -adpassword "MYPASSWORD" -basedn DC=domain,DC=com
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>test-aldirectorydn -websession $websession -serveraddress "mydc.domain.com" -Verbose -usessl -username "admin@domain.com" -adpassword "MYPASSWORD" -basedn DC=domain,DC=com
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help test-aldirectorydn -examples".
    For more information, type: "get-help test-aldirectorydn -detailed".
    For technical information, type: "get-help test-aldirectorydn -full".




