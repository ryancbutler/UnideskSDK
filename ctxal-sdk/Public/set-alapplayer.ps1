function Set-ALApplayer
{
<#
.SYNOPSIS
  Edits values of an application layer
.DESCRIPTION
  Edits values of an application layer
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.PARAMETER id
  ID of the applayer to edit
.PARAMETER name
  Name of the application layer
.PARAMETER description
  Description of the layer
.PARAMETER scriptpath
  Path of script to be run
.PARAMETER icon
  Icon ID (default 196608)
.PARAMETER OsLayerSwitching
  Allow OS Switching NotBoundToOsLayer=ON BoundToOsLayer=OFF
.EXAMPLE
  $app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
  Set-alapplayer -websession $websession -name "7-Zip" -description "7-zip" -id $app.Id -scriptpath "C:\NeededScript.ps1" -OsLayerSwitching BoundToOsLayer
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$id,
[Parameter(Mandatory=$true)][string]$name,
[Parameter(Mandatory=$false)][string]$description="",
[Parameter(Mandatory=$false)][string]$scriptpath="",
[Parameter(Mandatory=$false)][string]$icon="196608",
[Parameter(Mandatory=$true)][ValidateSet("NotBoundToOsLayer", "BoundToOsLayer")][string]$OsLayerSwitching
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <EditLayer xmlns="http://www.unidesk.com/">
      <command>
        <Id>$id</Id>
        <Name>$name</Name>
        <Description>$description</Description>
        <IconId>$icon</IconId>
        <ScriptPath>$scriptpath</ScriptPath>
        <OsLayerSwitching>$OsLayerSwitching</OsLayerSwitching>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </EditLayer>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/EditLayer";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}

$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
  if ($PSCmdlet.ShouldProcess("Setting app layer $name")) {

  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content

  if($obj.Envelope.Body.EditLayerResponse.EditLayerResult.Error)
  {
    throw $obj.Envelope.Body.EditLayerResponse.EditLayerResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.EditLayerResponse.EditLayerResult.WorkTicketId)"
    return $obj.Envelope.Body.EditLayerResponse.EditLayerResult.WorkTicketId
  }

  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
