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
.PARAMETER includescripts
  Include ELM script hosts in return
.EXAMPLE
  Get-AlVcenterConnector -websession $websession
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$false)][SupportsWildcards()][string]$name="*",
[Parameter(Mandatory=$false)][switch]$includescripts
)
Begin {Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"}

Process{

#do the request
$headers = @{
  "Cookie" = ("UMCSessionCoookie=" + $($websession.token))
  "Accept" = "*/*"
  "Content-Type" = "application/json"
  "Host" = "$($websession.aplip):3504"
  "Referer" =  "https://$($websession.aplip):3504/ui/"
}
try
{
    if($includescripts)
    {
      $content = Invoke-RestMethod -Method Get -Uri "https://$($websession.aplip):3504/api/Configurations?filter=%7B%22include%22%3A%22scripts%22%7D" -Headers $headers
    }
    else 
    {
      $content = Invoke-RestMethod -Method Get -Uri "https://$($websession.aplip):3504/api/Configurations" -Headers $headers
    }
    
} catch {
  if($_.ErrorDetails.Message)
  {
    $temp = $_.ErrorDetails.Message|ConvertFrom-Json
    if($temp.message)
    {
      Write-error $temp.message
    }
    else {
      Write-error $temp.error.message
      Write-error $temp.error.sqlmessage
      write-error $temp.error.staus
    }
    throw "Process failed!"
  }
  else {
    throw $_
  }
} finally {
   
   
}

return $content|Where-Object{$_.pccName -like $name}
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
