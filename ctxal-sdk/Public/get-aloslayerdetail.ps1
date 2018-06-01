function Get-ALOsLayerDetail
{
<#
.SYNOPSIS
  Gets detailed information on a OS layer including revisions
.DESCRIPTION
  Gets detailed information on a OS layer including revisions
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.PARAMETER id
  Operating System Layer ID
.EXAMPLE
  get-aloslayerdetail -websession $websession -id $app.AssociatedOsLayerId
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
    <QueryOsLayerDetails xmlns="http://www.unidesk.com/">
      <query>
        <Id>$id</Id>
      </query>
    </QueryOsLayerDetails>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryOsLayerDetails";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}

$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

if($obj.Envelope.Body.QueryOsLayerDetailsResponse.QueryOsLayerDetailsResult.Error)
    {
      throw $obj.Envelope.Body.QueryOsLayerDetailsResponse.QueryOsLayerDetailsResult.Error.message
    }
    else {
      return $obj.Envelope.Body.QueryOsLayerDetailsResponse.QueryOsLayerDetailsResult
    }
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
