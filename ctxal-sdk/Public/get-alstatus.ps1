function Get-ALStatus
{
<#
.SYNOPSIS
  Gets any non-completed task currently running on appliance
.DESCRIPTION
  Gets any non-completed task currently running on appliance
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.EXAMPLE
  Get-ALStatus -websession $websession
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryActivity xmlns="http://www.unidesk.com/">
      <query>
      </query>
    </QueryActivity>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryActivity";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content
 
  if($obj.Envelope.Body.QueryActivityResponse.QueryActivityResult.Error)
  {
    throw $obj.Envelope.Body.QueryActivityResponse.QueryActivityResult.Error.message
  }
  else {
    return $obj.Envelope.Body.QueryActivityResponse.QueryActivityResult.Events.WorkTicketUpdatedEvent.Result.WorkTickets.WorkTicketResult
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
