function Get-ALconnector
{
<#
.SYNOPSIS
  Gets all appliance connectors currently configured
.DESCRIPTION
  Gets all appliance connectors currently configured
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER type
  Connector type for publishing or creating layers\images
.EXAMPLE
  Get-ALconnector -websession $websession -type "Publish"
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][ValidateSet("Create","Publish")][string]$type
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryPlatformConnectorConfig xmlns="http://www.unidesk.com/">
      <query>
        <Features>$type</Features>
      </query>
    </QueryPlatformConnectorConfig>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryPlatformConnectorConfig";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content


if($obj.Envelope.Body.QueryPlatformConnectorConfigResponse.QueryPlatformConnectorConfigResult.Error)
  {
    throw $obj.Envelope.Body.QueryPlatformConnectorConfigResponse.QueryPlatformConnectorConfigResult.Error.message
  }
  else {
    return $obj.Envelope.Body.QueryPlatformConnectorConfigResponse.QueryPlatformConnectorConfigResult.Configurations.PlatformConnectorConfig
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
