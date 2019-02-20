function Get-ALconnectortype
{
<#
.SYNOPSIS
  Gets all Connector Types
.DESCRIPTION
  Gets all Connector Types
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
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
    <QueryPlatformConnectors xmlns="http://www.unidesk.com/">
      <query>
        <Features>None</Features>
      </query>
    </QueryPlatformConnectors>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryPlatformConnectors";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content


if($obj.Envelope.Body.QueryPlatformConnectorsResponse.QueryPlatformConnectorsResult.Error)
  {
    throw $obj.Envelope.Body.QueryPlatformConnectorsResponse.QueryPlatformConnectorsResult.Error.message
  }
  else {
    return $obj.Envelope.Body.QueryPlatformConnectorsResponse.QueryPlatformConnectorsResult.Connectors.PlatformConnectorDetails
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
