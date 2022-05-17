function Set-ALOslayer {
  <#
.SYNOPSIS
  Edits values of an os layer
.DESCRIPTION
  Edits values of an os layer
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER id
  ID of the os layer to edit
.PARAMETER name
  Name of the os layer
.PARAMETER description
  Description of the layer
.PARAMETER scriptpath
  Path of script to be run
.PARAMETER icon
  Icon ID
.EXAMPLE
  $os = Get-ALoslayer -websession $websession|where{$_.name -eq "Server2016"}
  Set-ALoslayer -websession $websession -name "Server2019" -description "7-zip" -id $os.Id -scriptpath "C:\NeededScript.ps1"
#>
  [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)][string]$id,
    [Parameter(Mandatory = $false)][string]$name,
    [Parameter(Mandatory = $false)][string]$description,
    [Parameter(Mandatory = $false)][string]$scriptpath,
    [Parameter(Mandatory = $false)][string]$icon
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {

    $OSlayer = get-alOslayerdetail -websession $websession -id $id

    #Check for existing params
    if ([string]::IsNullOrWhiteSpace($name)) {
      $name = $OSlayer.LayerSummary.Name
      Write-Verbose "Using existing name value $name"
    }

    if ([string]::IsNullOrWhiteSpace($description)) {
 
      $description = $OSlayer.$description
      if ([string]::IsNullOrWhiteSpace($OSlayer.$description)) {
        $description = ""
      }
      else {
        $description = $OSlayer.description
      }
      Write-Verbose "Using existing description value $description"
    }

    if ([string]::IsNullOrWhiteSpace($scriptpath)) {
      Write-Verbose "Using existing host value"
  
      if ([string]::IsNullOrWhiteSpace($OSlayer.ScriptPath)) {
        $scriptpath = ""
      }
      else {
        $scriptpath = $OSlayer.ScriptPath
      }
      Write-Verbose "Using existing scriptpath value $scriptpath"
    }

    if ([string]::IsNullOrWhiteSpace($icon)) {
  
      $icon = $OSlayer.LayerSummary.ImageId
      Write-Verbose "Using existing icon value $icon"
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