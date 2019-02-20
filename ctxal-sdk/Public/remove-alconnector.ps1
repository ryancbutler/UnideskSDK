function Remove-ALConnector
{
<#
.SYNOPSIS
  Removes Connector
.DESCRIPTION
  Removes Connector
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER connid
  Connector ID
.EXAMPLE
  Remove-ALConnector -websession $websession -connid $conn.Id
#>  
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$connid
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <DeletePlatformConnectorConfiguration xmlns="http://www.unidesk.com/">
      <command>
        <Id>$connid</Id>
      </command>
    </DeletePlatformConnectorConfiguration>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/DeletePlatformConnectorConfiguration";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;

}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Removing $connid")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content

  if($obj.Envelope.Body.DeletePlatformConnectorConfigurationResponse.DeletePlatformConnectorConfigurationResult.Error)
  {
    throw $obj.Envelope.Body.DeletePlatformConnectorConfigurationResponse.DeletePlatformConnectorConfigurationResult.Error.message

  }
  else {
    #return $obj
    #Write-Verbose "WORKTICKET: $($obj.Envelope.Body.DeleteAppLayerRevisionsResponse.DeleteAppLayerRevisionsResult.WorkTicketId)"
    #return $obj.Envelope.Body.DeleteAppLayerRevisionsResponse.DeleteAppLayerRevisionsResult
  }
}

}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
