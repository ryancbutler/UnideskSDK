function Get-AlVcenterConnector {
<#
.SYNOPSIS
  Gets Vcenter Connector configuration
.DESCRIPTION
  Gets Vcenter Connector configuration
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  Get-AlVcenterConnector -websession $websession
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession
)
Begin {Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"}

Process{

#do the request
$headers = @{
  "Cookie" = ("UMCSessionCoookie=" + $($websession.token))
  "Accept" = "*/*"
  "Content-Type" = "application/json" 
}
try
{
    $content = Invoke-RestMethod -Method Get -Uri "https://$($websession.aplip):3504/api/Configurations/" -Headers $headers
} catch {
    throw $_
} finally {
   
   
}

return $content
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
