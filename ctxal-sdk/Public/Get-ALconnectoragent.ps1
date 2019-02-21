function Get-ALconnectoragent {
<#
.SYNOPSIS
    Gets connector agents
.DESCRIPTION
    Gets connector agents
.PARAMETER websession
    Existing Webrequest session for ELM Appliance
.EXAMPLE
    Get-ALconnectoragent -websession $websession
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
    "Host" = "$($websession.aplip):3504"
    "Referer" =  "https://$($websession.aplip):3504/ui/"
  }
try
{
    $content = Invoke-RestMethod -Method GET -Uri "https://$($websession.aplip):3504/api/Agents?filter[include]=host" -Headers $headers
} catch {
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
} finally {

}

return $content


}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}

}
