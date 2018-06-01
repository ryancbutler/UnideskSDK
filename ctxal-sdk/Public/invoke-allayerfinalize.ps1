function Invoke-ALLayerFinalize
{
<#
.SYNOPSIS
  Runs finalize process on a layer
.DESCRIPTION
  Runs finalize process on a layer
.PARAMETER fileshareid
  ID of file share location used to store disk
.PARAMETER LayerRevisionId
  Revision ID of layer to be finalized
.PARAMETER uncpath
  UNC Path of fileshare
.PARAMETER filename
  Filename of the disk
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.EXAMPLE
  $app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
  $apprevs = get-alapplayerdetail -websession $websession -id $app.Id
  $shares = get-alremoteshare -websession $websession
  $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Finalizable"}|Sort-Object revision -Descending|select -First 1
  $disklocation = get-allayerinstalldisk -websession $websession -layerid $apprevid.LayerId
  invoke-allayerfinalize -websession $websession -fileshareid $shares.id -LayerRevisionId $apprevid.Id -uncpath $disklocation.diskuncpath -filename $disklocation.diskname
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$fileshareid,
[Parameter(Mandatory=$true)]$LayerRevisionId,
[Parameter(Mandatory=$true)]$uncpath,
[Parameter(Mandatory=$true)]$filename,
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
    <FinalizeLayerRevision xmlns="http://www.unidesk.com/">
      <command>
        <SelectedFileShare>$fileshareid</SelectedFileShare>
        <LayerRevisionId>$LayerRevisionId</LayerRevisionId>
        <InstallDiskUncPath>$uncpath</InstallDiskUncPath>
        <InstallDiskFilename>$filename</InstallDiskFilename>
        <ScriptPath/>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </FinalizeLayerRevision>
  </s:Body>
</s:Envelope>
"@
$headers = @{
    SOAPAction = "http://www.unidesk.com/FinalizeLayerRevision";
    "Content-Type" = "text/xml; charset=utf-8";
    UNIDESK_TOKEN = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    if ($PSCmdlet.ShouldProcess("Finalizing $LayerRevisionId")) { 
      $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
      [xml]$obj = $return.Content
      if($obj.Envelope.Body.FinalizeLayerRevisionResponse.FinalizeLayerRevisionResult.Error)
      {
        throw $obj.Envelope.Body.FinalizeLayerRevisionResponse.FinalizeLayerRevisionResult.Error.message
      }
      else {
        return $obj.Envelope.Body.FinalizeLayerRevisionResponse.FinalizeLayerRevisionResult
      }
    }
    
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}