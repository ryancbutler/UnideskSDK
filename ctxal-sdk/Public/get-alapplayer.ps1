function Get-ALapplayer
{
<#
.SYNOPSIS
  Gets all application layers
.DESCRIPTION
  Gets all application layers
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.EXAMPLE
  Get-ALapplayer -websession $websession
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
    <QueryApplicationLayers xmlns="http://www.unidesk.com/">
      <query>
        <ResourceFarmId>0</ResourceFarmId>
        <Filter/>
      </query>
    </QueryApplicationLayers>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryApplicationLayers";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content


if($obj.Envelope.Body.QueryApplicationLayersResponse.QueryApplicationLayersResult.Error)
  {
    throw $obj.Envelope.Body.QueryApplicationLayersResponse.QueryApplicationLayersResult.Error.message
  }
  else {
    return $obj.Envelope.Body.QueryApplicationLayersResponse.QueryApplicationLayersResult.AppLayers.LayerEntitySummary
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
