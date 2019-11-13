function Get-ALCachePointInfo {
  <#
.SYNOPSIS
  Gets appliance Layering Service Info
.DESCRIPTION
  Gets appliance Layering Service Info
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  Get-ALCachePointInfo -websession $websession
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
    <QueryCachePoints xmlns="http://www.unidesk.com/"/>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/QueryCachePoints";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
    [xml]$obj = $return.Content

    if ($obj.Envelope.Body.QueryCachePointsResponse.QueryCachePointsResult.Error) {
      throw $obj.Envelope.Body.QueryCachePointsResponse.QueryCachePointsResult.Error.message
    }
    else {
      return $obj.Envelope.Body.QueryCachePointsResponse.QueryCachePointsResult.CachePointResults.CachePointSummary
    }
  }
  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}