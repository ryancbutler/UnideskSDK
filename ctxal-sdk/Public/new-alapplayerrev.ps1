function New-ALAppLayerRev
{
<#
.SYNOPSIS
  Creates a new layer version
.DESCRIPTION
  Creates a new layer version
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.PARAMETER version
  Version of the revision
.PARAMETER name
  Name of the layer revision
.PARAMETER description
  Description of the revision
.PARAMETER connectorid
  ID of Connector to use
.PARAMETER apprevid
  Base application version layer id to use
.PARAMETER osrevid
  OS version layer id to use
.PARAMETER platformrevid
  Platform version ID if needed
.PARAMETER diskformat
  Diskformat to store layer
.PARAMETER size
  Size of layer in GB (default 10240)
.EXAMPLE
  $fileshare = Get-ALRemoteshare -websession $websession
  $connector = Get-ALconnector -websession $websession -type Create
  $app = Get-ALapplayer -websession $websession|where{$_.name -eq "7-Zip"}
  $oss = Get-ALOsLayer -websession $websession
  $osrevs = get-aloslayerdetail -websession $websession -id $app.AssociatedOsLayerId
  $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  $apprevs = get-alapplayerDetail -websession $websession -id $app.Id
  $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  new-alapplayerrev -websession $websession -version "9.0" -name $app.Name -connectorid $connector.id -appid $app.Id -apprevid $apprevid.id -osrevid $osrevid.Id -diskformat $connector.ValidDiskFormats.DiskFormat -fileshareid $fileshare.id
#>  
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$version,
[Parameter(Mandatory=$true)]$name,
[Parameter(Mandatory=$false)]$description="",
[Parameter(Mandatory=$true)]$connectorid,
[Parameter(Mandatory=$true)]$appid,
[Parameter(Mandatory=$true)]$apprevid,
[Parameter(Mandatory=$true)]$osrevid,
[Parameter(Mandatory=$false)]$platformrevid,
[Parameter(Mandatory=$true)]$diskformat,
[Parameter(Mandatory=$true)]$fileshareid,
[Parameter(Mandatory=$false)]$size="10240"
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
if (-not ([string]::IsNullOrWhiteSpace($platformrevid)))
{
Write-Verbose "Creating with Platform layer"
$plat = @" 
<PlatformLayerRevisionId>$platformrevid</PlatformLayerRevisionId>
"@
}
else
{
Write-Verbose "Creating withOUT Platform layer"
$plat = @" 
<PlatformLayerRevisionId xsi:nil="true"/>
"@
}

[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <CreateAppLayerRevision xmlns="http://www.unidesk.com/">
      <command>
        <RevisionInfo>
          <Name>$version</Name>
          <Description>$description</Description>
          <LayerSizeMiB>$size</LayerSizeMiB>
        </RevisionInfo>
        <LayerId>$appid</LayerId>
        <SelectedFileShare>$fileshareid</SelectedFileShare>
        <PackagingDiskFilename>$name</PackagingDiskFilename>
        <PackagingDiskFormat>$diskformat</PackagingDiskFormat>
        <PlatformConnectorConfigId>$connectorid</PlatformConnectorConfigId>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
        <BaseLayerRevisionId>$apprevid</BaseLayerRevisionId>
        <OsLayerRevisionId>$osrevid</OsLayerRevisionId>
        $plat
        <CreationEnvironmentAppRevisions/>
      </command>
    </CreateAppLayerRevision>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/CreateAppLayerRevision";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Creating $apprevid version $version")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content

  if($obj.Envelope.Body.CreateAppLayerRevisionResponse.CreateAppLayerRevisionResult.Error)
  {
    throw $obj.Envelope.Body.CreateAppLayerRevisionResponse.CreateAppLayerRevisionResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.CreateAppLayerRevisionResponse.CreateAppLayerRevisionResult.WorkTicketId)"
    return $obj.Envelope.Body.CreateAppLayerRevisionResponse.CreateAppLayerRevisionResult
  }
}

}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
