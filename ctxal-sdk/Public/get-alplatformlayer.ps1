function Get-ALPlatformlayer {
  <#
.SYNOPSIS
  Gets all platform layers
.DESCRIPTION
  Gets all platform layers
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  Get-ALPlatformlayer -websession $websession
#>
  [cmdletbinding()]
  Param(
    [Parameter(Mandatory = $true)]$websession
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {
    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryPlatformLayers xmlns="http://www.unidesk.com/">
      <query>
        <ResourceFarmId>0</ResourceFarmId>
        <Filter/>
      </query>
    </QueryPlatformLayers>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/QueryPlatformLayers";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }

    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
    [xml]$obj = $return.Content

    if ($obj.Envelope.Body.QueryPlatformLayersResponse.QueryPlatformLayersResult.Error) {
      throw $obj.Envelope.Body.QueryPlatformLayersResponse.QueryPlatformLayersResult.Error.message
    }
    else {
      return $obj.Envelope.Body.QueryPlatformLayersResponse.QueryPlatformLayersResult.PlatformLayers.LayerEntitySummary
    }
  }
  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
