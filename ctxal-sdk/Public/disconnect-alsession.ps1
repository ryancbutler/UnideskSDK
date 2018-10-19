function Disconnect-ALsession
{
<#
.SYNOPSIS
  Logs off and disconnects web session
.DESCRIPTION
  Logs off and disconnects web session
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  Disconnect-ALsession -websession $websession
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
    <Logout xmlns="http://www.unidesk.com/"/>
  </s:Body>
</s:Envelope>
"@
$headers = @{
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
SOAPAction = "http://www.unidesk.com/Logout";
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession|Out-Null
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
