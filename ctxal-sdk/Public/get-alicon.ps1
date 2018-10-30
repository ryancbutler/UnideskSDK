function Get-ALicon
{
<#
.SYNOPSIS
  Gets all icon IDs
.DESCRIPTION
  Gets all icon IDs
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  Get-ALicon -websession $websession
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
    <QueryLayerIcons xmlns="http://www.unidesk.com/">
      <query/>
    </QueryLayerIcons>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryLayerIcons";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

$final = @()
foreach ($iconid in $obj.Envelope.Body.QueryLayerIconsResponse.QueryLayerIconsResult.IconIds.long)
{
  $final += [PSCustomObject]@{
    ICONID = $iconid
    URL = "https://$($websession.aplip)/Unidesk.Web/GetImage.ashx?id=$iconid"
    }
  
}

return $final
}


end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
