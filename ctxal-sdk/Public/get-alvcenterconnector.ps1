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
  $temp = $_.ErrorDetails.Message|ConvertFrom-Json
  Write-error $temp.error.message
  Write-error $temp.error.sqlmessage
  write-error $temp.error.staus
  throw "Process failed!"
} finally {
   
   
}

return $content
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
