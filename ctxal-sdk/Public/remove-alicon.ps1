function remove-ALicon
{
<#
.SYNOPSIS
  Removes icon based on ID
.DESCRIPTION
  Removes icon based on ID
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER iconid
  Icon ID
.EXAMPLE
  Remove-ALicon -websession $websession -iconid "4259847"
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(    
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$iconid
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <DeleteIcon xmlns="http://www.unidesk.com/">
      <command>
        <IconId>$iconid</IconId>
      </command>
    </DeleteIcon>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/DeleteIcon";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Removing ICONID $iconid")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content
  return $obj.Envelope.Body.DeleteIconResponse.DeleteIconResult.ErrorCode
}

}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
