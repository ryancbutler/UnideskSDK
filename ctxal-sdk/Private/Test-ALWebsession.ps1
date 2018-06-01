function Test-ALWebsession
{
<#
.SYNOPSIS
    Tests for valid web request session
.DESCRIPTION
    Tests for valid web request session
.PARAMETER websession
    Existing Webrequest session for CAL Appliance
.EXAMPLE
   Test-ALWebsession -websession $websession
#>
[cmdletbinding()]
[OutputType([System.boolean])]
Param(
[Parameter(Mandatory=$true)]$websession
)
Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  }
Process {

if([string]::IsNullOrWhiteSpace($websession.token))
{
    throw "Not Connected.  Run Connect-ALSession to connect"
}
else
{
    Write-Verbose "Connection OK"
    #return $true
}

}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}