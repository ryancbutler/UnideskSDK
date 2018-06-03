function Get-ALVMName
{
<#
.SYNOPSIS
  Extracts VM name out of "action required" task
.DESCRIPTION
  Extracts VM name out of "action required" task
.PARAMETER message
  Message from pending operation
.EXAMPLE
  Get-ALVMName -message -message $status.WorkItems.WorkItemResult.Status
#>    
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$message
)
Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
Process {
$pattern = "(?<=\]).+?(?=\[)"
$result = [regex]::match($message, $pattern)
Write-Verbose $result
return $result.value
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
