function Set-ALApplayer {
  <#
.SYNOPSIS
  Edits values of an application layer
.DESCRIPTION
  Edits values of an application layer
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER id
  ID of the applayer to edit
.PARAMETER name
  Name of the application layer
.PARAMETER description
  Description of the layer
.PARAMETER scriptpath
  Path of script to be run
.PARAMETER icon
  Icon ID
.PARAMETER OsLayerSwitching
  Allow OS Switching NotBoundToOsLayer=ON BoundToOsLayer=OFF
.EXAMPLE
  $app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
  Set-alapplayer -websession $websession -name "7-Zip" -description "7-zip" -id $app.Id -scriptpath "C:\NeededScript.ps1" -OsLayerSwitching BoundToOsLayer
#>
  [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)][string]$id,
    [Parameter(Mandatory = $false)][string]$name,
    [Parameter(Mandatory = $false)][string]$description,
    [Parameter(Mandatory = $false)][string]$scriptpath,
    [Parameter(Mandatory = $false)][string]$icon,
    [Parameter(Mandatory = $false)][ValidateSet("NotBoundToOsLayer", "BoundToOsLayer")][string]$OsLayerSwitching
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {

    $applayer = get-alapplayerdetail -websession $websession -id $id

    #Check for existing params
    if ([string]::IsNullOrWhiteSpace($name)) {
      $name = $applayer.LayerSummary.Name
      Write-Verbose "Using existing name value $name"
    }

    if ([string]::IsNullOrWhiteSpace($description)) {
 
      $description = $applayer.$description
      if ([string]::IsNullOrWhiteSpace($applayer.$description)) {
        $description = ""
      }
      else {
        $description = $applayer.description
      }
      Write-Verbose "Using existing description value $description"
    }

    if ([string]::IsNullOrWhiteSpace($scriptpath)) {
      Write-Verbose "Using existing host value"
  
      if ([string]::IsNullOrWhiteSpace($applayer.ScriptPath)) {
        $scriptpath = ""
      }
      else {
        $scriptpath = $applayer.ScriptPath
      }
      Write-Verbose "Using existing scriptpath value $scriptpath"
    }

    if ([string]::IsNullOrWhiteSpace($icon)) {
  
      $icon = $applayer.LayerSummary.ImageId
      Write-Verbose "Using existing icon value $icon"
    }

    if ([string]::IsNullOrWhiteSpace($OsLayerSwitching)) {
      $OsLayerSwitching = $applayer.OsLayerSwitching
      Write-Verbose "Using existing OsLayerSwitching value $OsLayerSwitching"
    }

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
    Write-Verbose $xml
    $xml >> "C:\temp\myxml.xml"
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/EditLayer";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }

    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    if ($PSCmdlet.ShouldProcess("Setting app layer $name")) {

      $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
      [xml]$obj = $return.Content

      if ($obj.Envelope.Body.EditLayerResponse.EditLayerResult.Error) {
        throw $obj.Envelope.Body.EditLayerResponse.EditLayerResult.Error.message

      }
      else {
        Write-Verbose "WORKTICKET: $($obj.Envelope.Body.EditLayerResponse.EditLayerResult.WorkTicketId)"
        return $true
      }

    }
  }
  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
