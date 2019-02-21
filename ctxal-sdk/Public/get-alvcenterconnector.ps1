function Get-AlVcenterConnector {
<#
.SYNOPSIS
  Gets Vcenter Connector configuration
.DESCRIPTION
  Gets Vcenter Connector configuration
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER name
  Name of object to return
.EXAMPLE
  Get-AlVcenterConnector -websession $websession
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$false)][SupportsWildcards()][string]$name="*"
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
  if($_.ErrorDetails.Message)
  {
    if($_.ErrorDetails.Message)
    {
    $temp = $_.ErrorDetails.Message|ConvertFrom-Json
    Write-error $temp.error.message
    Write-error $temp.error.sqlmessage
    write-error $temp.error.staus
    throw "Process failed!"
    }
    else {
      throw $_
    }
  }
  else {
    throw $_
  }
} finally {
   
   
}

return $content|Where-Object{$_.name -like $name}
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
