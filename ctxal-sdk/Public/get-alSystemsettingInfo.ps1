function Get-ALSystemSettingInfo
{
<#
.SYNOPSIS
  Gets appliance System Settings
.DESCRIPTION
  Gets appliance System Settings
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.EXAMPLE
  Get-ALSystemSettingInfo -websession $websession
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
    <QuerySystemSettings xmlns="http://www.unidesk.com/">
      <query>
      </query>
    </QuerySystemSettings>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QuerySystemSettings";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

if($obj.Envelope.Body.QuerySystemSettingsResponse.QuerySystemSettingsResult.Error)
  {
    throw $obj.Envelope.Body.QuerySystemSettingsResponse.QuerySystemSettingsResult.Error.message
  }
  else {
    return $obj.Envelope.Body.QuerySystemSettingsResponse.QuerySystemSettingsResult.Settings.SysSetting
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
