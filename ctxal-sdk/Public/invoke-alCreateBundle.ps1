function Invoke-ALCreateBundle
{
<#
.SYNOPSIS
  Creates diagnostic bundle
.DESCRIPTION
  Creates diagnostic bundle
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  Invoke-ALCreateBundle -websession $websession
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[switch]$IncludeCrashDumps
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {

if($IncludeCrashDumps)
{
  $IncludeCoreFiles = "true"
}
else {
  $IncludeCoreFiles = "false"
}

[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <GatherDiagnostics xmlns="http://www.unidesk.com/">
      <command>
        <IncludeCoreFiles>$includecorefiles</IncludeCoreFiles>
        <SendEmail>false</SendEmail>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </GatherDiagnostics>
  </s:Body>
</s:Envelope>
"@
$headers = @{
    SOAPAction = "http://www.unidesk.com/GatherDiagnostics";
    "Content-Type" = "text/xml; charset=utf-8";
    UNIDESK_TOKEN = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    if ($PSCmdlet.ShouldProcess("Exporting logs")) {
      $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
      [xml]$obj = $return.Content
      if($obj.Envelope.Body.GatherDiagnosticsResponse.GatherDiagnosticsResult.Error)
      {
        throw $obj.Envelope.Body.GatherDiagnosticsResponse.GatherDiagnosticsResult.Error.message
      }
      else {
        return $obj.Envelope.Body.GatherDiagnosticsResponse.GatherDiagnosticsResult.WorkTicketId
      }
    }
    
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}