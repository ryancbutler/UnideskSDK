function Get-ALPlatformLayerDetail {
  <#
.SYNOPSIS
  Gets detailed information on a platform layer including revisions
.DESCRIPTION
  Gets detailed information on a platform layer including revisions
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER id
  Platform layer ID
.EXAMPLE
  get-alplatformlayerDetail -websession $websession -id $platform.id
#>
  [cmdletbinding()]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)][string]$id
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {
    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryPlatformLayerDetails xmlns="http://www.unidesk.com/">
      <query>
        <Id>$id</Id>
      </query>
    </QueryPlatformLayerDetails>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/QueryPlatformLayerDetails";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }

    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
    [xml]$obj = $return.Content

    if ($obj.Envelope.Body.QueryPlatformLayerDetailsResponse.QueryPlatformLayerDetailsResult.Error) {
      throw $obj.Envelope.Body.QueryPlatformLayerDetailsResponse.QueryPlatformLayerDetailsResult.Error.message
    }
    else {
      return $obj.Envelope.Body.QueryPlatformLayerDetailsResponse.QueryPlatformLayerDetailsResult
    }
  }
  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
