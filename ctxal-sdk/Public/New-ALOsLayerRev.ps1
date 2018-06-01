function New-ALOsLayerRev
{
<#
.SYNOPSIS
  Creates new OS layer version
.DESCRIPTION
  Creates new OS layer version
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.PARAMETER version
  Version of the new layer
.PARAMETER description
  Description of the layer
.PARAMETER connectorid
  ID of Connector to use
.PARAMETER osid
  Operating system layer ID
.PARAMETER osrevid
  OS version layer id to use
.PARAMETER platformrevid
  Platform version ID if needed
.PARAMETER diskformat
  Disk format of the image
.PARAMETER shareid
  ID of file share
.PARAMETER size
  Size of layer in GB (default 61440)
.EXAMPLE
  $fileshare = Get-ALRemoteshare -websession $websession
  $connector = Get-ALconnector -websession $websession -type Create
  $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 2016 Standard"}
  $osrevs = get-aloslayerDetail -websession $websession -id $oss.id
  $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  new-aloslayerrev -websession $websession -version "2.0" -connectorid $connector.Id -osid $oss.id -osrevid $osrevid.id -diskformat $connector.ValidDiskFormats.DiskFormat -shareid $fileshare.id
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$version,
[Parameter(Mandatory=$false)]$description="",
[Parameter(Mandatory=$true)]$connectorid,
[Parameter(Mandatory=$true)]$osid,
[Parameter(Mandatory=$true)]$osrevid,
[Parameter(Mandatory=$false)]$platformrevid,
[Parameter(Mandatory=$true)]$diskformat,
[Parameter(Mandatory=$true)]$shareid,
[Parameter(Mandatory=$false)]$size="61440"
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
    <CreateOsLayerRevision xmlns="http://www.unidesk.com/">
      <command>
        <RevisionInfo>
          <Name>$version</Name>
          <Description>$description</Description>
          <LayerSizeMiB>$size</LayerSizeMiB>
        </RevisionInfo>
        <LayerId>$osid</LayerId>
        <SelectedFileShare>$shareid</SelectedFileShare>
        <PackagingDiskFilename>$name</PackagingDiskFilename>
        <PackagingDiskFormat>$diskformat</PackagingDiskFormat>
        <PlatformConnectorConfigId>$connectorid</PlatformConnectorConfigId>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
        <BaseLayerRevisionId>$osrevid</BaseLayerRevisionId>
        $plat
      </command>
    </CreateOsLayerRevision>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/CreateOsLayerRevision";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  if ($PSCmdlet.ShouldProcess("Creating OS version $version from $osrevid")) { 
  [xml]$obj = $return.Content

  if($obj.Envelope.Body.CreateOsLayerRevisionResponse.CreateOsLayerRevisionResult.Error)
  {
    throw $obj.Envelope.Body.CreateOsLayerRevisionResponse.CreateOsLayerRevisionResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.CreateOsLayerRevisionResponse.CreateOsLayerRevisionResult.WorkTicketId)"
    return $obj.Envelope.Body.CreateOsLayerRevisionResponse.CreateOsLayerRevisionResult.WorkTicketId
  }
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
