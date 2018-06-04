function Get-ALapplayerDetail
{
<#
.SYNOPSIS
  Gets detailed information on Application Layer including revisions(versions)
.DESCRIPTION
  Gets detailed information on Application Layer including revisions(versions)
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.PARAMETER id
  Application layer ID
.EXAMPLE
  get-alapplayer -websession $websession -id $app.Id
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
    <QueryApplicationLayerDetails xmlns="http://www.unidesk.com/">
      <query>
        <Id>$id</Id>
      </query>
    </QueryApplicationLayerDetails>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryApplicationLayerDetails";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}

$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

if($obj.Envelope.Body.QueryApplicationLayerDetailsResponse.QueryApplicationLayerDetailsResult.Error)
  {
    throw $obj.Envelope.Body.QueryApplicationLayerDetailsResponse.QueryApplicationLayerDetailsResult.Error.message
  
  }
  else {
    return $obj.Envelope.Body.QueryApplicationLayerDetailsResponse.QueryApplicationLayerDetailsResult
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}