function Get-ALPendingOp
{
<#
.SYNOPSIS
  Gets appliance operation based on ID
.DESCRIPTION
  Gets appliance operation based on ID
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER id
  workticket id
.EXAMPLE
 Get-ALPendingOp -websession $websession -id $myworkid
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$id
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"  
  Test-ALWebsession -WebSession $websession
  }
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
<s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<QueryPendingOperation xmlns="http://www.unidesk.com/">
<query>
    <Id>$id</Id>
</query>
</QueryPendingOperation>
</s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryPendingOperation";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}

$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

if($obj.Envelope.Body.QueryPendingOperationResponse.QueryPendingOperationResult.Error)
    {
      throw $obj.Envelope.Body.QueryPendingOperationResponse.QueryPendingOperationResult.Error.message
    }
    else {
      return $obj.Envelope.Body.QueryPendingOperationResponse.QueryPendingOperationResult
    }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
