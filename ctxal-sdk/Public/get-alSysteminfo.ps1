function Get-ALSystemInfo
{
<#
.SYNOPSIS
  Gets appliance System Details
.DESCRIPTION
  Gets appliance System Details
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  Get-ALSystemInfo -websession $websession
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
    <QueryManagementApplianceDetailsWithParam xmlns="http://www.unidesk.com/">
      <query>
        <IncludeNetworkInfo>false</IncludeNetworkInfo>
      </query>
    </QueryManagementApplianceDetailsWithParam>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryManagementApplianceDetailsWithParam";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

if($obj.Envelope.Body.QueryManagementApplianceDetailsWithParamResponse.QueryManagementApplianceDetailsWithParamResult.Error)
  {
    throw $obj.Envelope.Body.QueryManagementApplianceDetailsWithParamResponse.QueryManagementApplianceDetailsWithParamResult.Error.message
  }
  else {
    return $obj.Envelope.Body.QueryManagementApplianceDetailsWithParamResponse.QueryManagementApplianceDetailsWithParamResult
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
