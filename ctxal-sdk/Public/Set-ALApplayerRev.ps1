function Set-ALApplayerRev {
  <#
.SYNOPSIS
  Edits values of an application layer version
.DESCRIPTION
  Edits values of an application layer version
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER layerid
  ID of the applayer to edit
.PARAMETER revid
  ID of the applayer version to edit
.PARAMETER name
  Name of the application layer version
.PARAMETER description
  Description of the layer version
.EXAMPLE
  $app = Get-ALapplayer -websession $websession|where{$_.name -eq "WS2016 - CtxSt - Citrix Studio"}
  $appdetail = Get-ALapplayerDetail -websession $websession -id $app.Id
  $appver = $appdetail.Revisions.AppLayerRevisionDetail | select-object -last 1
  Set-alapplayer -websession $websession -layerid $app.Id -revid $appver.Id -name "7-Zip" -description "7-zip"
#>
  [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)][string]$layerid,
    [Parameter(Mandatory = $true)][string]$revid,
    [Parameter(Mandatory = $false)][string]$name,
    [Parameter(Mandatory = $false)][string]$description
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {

    $applayer = get-alapplayerdetail -websession $websession -id $layerid
    $applayerName = $applayer.LayerSummary.Name
    $applayerDescription = $applayer.Description
    $icon = $applayer.LayerSummary.ImageId
    $OsLayerSwitching = $applayer.OsLayerSwitching

    $RevisionChanges = foreach ($revision in $applayer.Revisions.AppLayerRevisionDetail) {
        if ($revision.Id -ne $revid) {
            "            <LayerRevisionChange>
                <Id>$($revision.Id)</Id>
                <Name>$($revision.DisplayedVersion)</Name>
                <Description>$($revision.Description)</Description>
            </LayerRevisionChange>"
        }
        else {
            #Check for existing params
            if ([string]::IsNullOrWhiteSpace($name)) {
              $name = $revision.DisplayedVersion
              Write-Verbose "Using existing name value $name"
            }

            if (!$PSBoundParameters.ContainsKey('description')) {
              $description = $revision.Description
              Write-Verbose "Using existing description value $description"
            }
            else {
              if ([string]::IsNullOrWhiteSpace($description)) {
              $description = "" 
              }
            }
            
            "            <LayerRevisionChange>
                <Id>$($revision.Id)</Id>
                <Name>$name</Name>
                <Description>$description</Description>
            </LayerRevisionChange>"
        }
        $null = $description
    }

    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <EditLayer xmlns="http://www.unidesk.com/">
      <command>
        <Id>$layerid</Id>
        <Name>$applayerName</Name>
        <Description>$applayerDescription</Description>
        <IconId>$icon</IconId>
        <ScriptPath>$scriptpath</ScriptPath>
        <OsLayerSwitching>$OsLayerSwitching</OsLayerSwitching>
        <Reason />
        <RevisionChanges>
$RevisionChanges
        </RevisionChanges>
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
