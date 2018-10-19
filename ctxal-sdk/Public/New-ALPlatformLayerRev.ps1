function New-ALPlatformLayerRev
{
<#
.SYNOPSIS
  Creates new platform layer version
.DESCRIPTION
  Creates new platform layer version
.PARAMETER websession
  Existing Webrequest session for ELM  Appliance
.PARAMETER osrevid
  OS version layer id to use
.PARAMETER connectorid
  ID of Connector to use
.PARAMETER description
  Description of the layer
.PARAMETER shareid
  ID of file share
.PARAMETER layerid
  Platform layer ID
.PARAMETER layerrevid
  Version ID to base version from 
.PARAMETER version
  Version of the new layer
.PARAMETER DiskName
  Disk file name
.PARAMETER size
  Size of layer in MB (default 10240)
.PARAMETER diskformat
  Disk format of the image
.PARAMETER HypervisorPlatformTypeId
  Hypervisor type of platform layer (default=vsphere)
.PARAMETER ProvisioningPlatformTypeId
  Provisioning type MCS or PVS (default=mcs)
.PARAMETER BrokerPlatformTypeId
  Broker type used (default=xendesktop)
.EXAMPLE
  $connector = Get-ALconnector -websession $websession -type "Create"
  $shares = get-alremoteshare -websession $websession
  $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
  $osrevs = get-aloslayerdetail -websession $websession -id $oss.id
  $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  $plats = Get-ALPlatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
  $platrevs = get-alplatformlayerDetail -websession $websession -id $plats.id
  $platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1

  $params = @{
  websession = $websession;
  osrevid = $osrevid.Id;
  connectorid =  $connector.Id;
  shareid = $shares.id;
  layerid = $plats.Id;
  layerrevid = $platformrevid.id;
  version = "5.0";
  Diskname = $plats.Name;
  Verbose = $true;
  Description = "test";
  diskformat = $connector.ValidDiskFormats.DiskFormat;
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$osrevid,
[Parameter(Mandatory=$true)]$connectorid,
[Parameter(Mandatory=$false)]$Description="",
[Parameter(Mandatory=$true)]$shareid,
[Parameter(Mandatory=$true)]$layerid,
[Parameter(Mandatory=$true)]$layerrevid,
[Parameter(Mandatory=$true)]$version,
[Parameter(Mandatory=$true)]$Diskname,
[Parameter(Mandatory=$false)]$size="10240",
[Parameter(Mandatory=$true)]$diskformat,
[Parameter(Mandatory=$false)]$HypervisorPlatformTypeId="vsphere",
[Parameter(Mandatory=$false)]$ProvisioningPlatformTypeId="mcs",
[Parameter(Mandatory=$false)]$BrokerPlatformTypeId="xendesktop"
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <CreatePlatformLayerRevision xmlns="http://www.unidesk.com/">
      <command>
        <RevisionInfo>
          <Name>$version</Name>
          <Description>$Description</Description>
          <LayerSizeMiB>$size</LayerSizeMiB>
        </RevisionInfo>
        <LayerId>$layerid</LayerId>
        <SelectedFileShare>$shareid</SelectedFileShare>
        <PackagingDiskFilename>$Diskname</PackagingDiskFilename>
        <PackagingDiskFormat>$diskformat</PackagingDiskFormat>
        <PlatformConnectorConfigId>$connectorid</PlatformConnectorConfigId>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
        <BaseLayerRevisionId>$layerrevid</BaseLayerRevisionId>
        <OsLayerRevisionId>$osrevid</OsLayerRevisionId>
        <HypervisorPlatformTypeId>$HypervisorPlatformTypeId</HypervisorPlatformTypeId>
        <ProvisioningPlatformTypeId>$ProvisioningPlatformTypeId</ProvisioningPlatformTypeId>
        <BrokerPlatformTypeId>$BrokerPlatformTypeId</BrokerPlatformTypeId>
      </command>
    </CreatePlatformLayerRevision>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/CreatePlatformLayerRevision";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
  if ($PSCmdlet.ShouldProcess("Creating platform layerversion $version from $layerrevid")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content


  if($obj.Envelope.Body.CreatePlatformLayerRevisionResponse.CreatePlatformLayerRevisionResult.Error)
  {
    throw $obj.Envelope.Body.CreatePlatformLayerRevisionResponse.CreatePlatformLayerRevisionResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.CreatePlatformLayerRevisionResponse.CreatePlatformLayerRevisionResult.WorkTicketId)"
    return $obj.Envelope.Body.CreatePlatformLayerRevisionResponse.CreatePlatformLayerRevisionResult
  }
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
