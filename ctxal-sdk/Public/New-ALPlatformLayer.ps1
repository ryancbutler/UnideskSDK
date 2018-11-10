function New-ALPlatformLayer
{
<#
.SYNOPSIS
  Creates new platform layer
.DESCRIPTION
  Creates new platform layer
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER osrevid
  OS version layer id to use
.PARAMETER connectorid
  ID of Connector to use
.PARAMETER description
  Description of the layer
.PARAMETER shareid
  ID of file share
.PARAMETER icon
  Icon ID (default 196608)
.PARAMETER name
  Name of the layer
.PARAMETER size
  Size of layer in GB (default 10240)
.PARAMETER type
  Type of platform layer to create (Create or Publish)
.PARAMETER diskformat
  Disk format of the image
.PARAMETER platformrevid
  Platform version ID if needed
.PARAMETER version
  Version of the new layer
.PARAMETER description
  Description of the layer
.PARAMETER connectorid
  ID of Connector to use
.PARAMETER HypervisorPlatformTypeId
  Hypervisor type of platform layer (default=vsphere)
.PARAMETER ProvisioningPlatformTypeId
  Provisioning type MCS or PVS (default=mcs)
.PARAMETER BrokerPlatformTypeId
  Broker type used (default=xendesktop)
.EXAMPLE
  $fileshare = Get-ALRemoteshare -websession $websession
  $connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
  $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 2016 Standard"}
  $osrevs = get-aloslayerdetail -websession $websession -id $oss.id
  $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  New-ALPlatformLayer -websession $websession -osrevid $osrevid.Id -name "Citrix XA VDA 7.18" -connectorid $connector.id -shareid $fileshare.id -diskformat $connector.ValidDiskFormats.DiskFormat -type Create
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$osrevid,
[Parameter(Mandatory=$true)][string]$connectorid,
[Parameter(Mandatory=$false)][string]$Description="",
[Parameter(Mandatory=$true)][string]$shareid,
[Parameter(Mandatory=$false)][string]$iconid="196608",
[Parameter(Mandatory=$true)][string]$name,
[Parameter(Mandatory=$false)][string]$size="10240",
[Parameter(Mandatory=$true)][string]$diskformat,
[Parameter(Mandatory=$false)][string]$platformrevid,
[Parameter(Mandatory=$true)][ValidateSet("create","publish")][string]$type,
[Parameter(Mandatory=$false)][string]$HypervisorPlatformTypeId="vsphere",
[Parameter(Mandatory=$false)][ValidateSet("mcs","pvs")][string]$ProvisioningPlatformTypeId="mcs",
[Parameter(Mandatory=$false)][string]$BrokerPlatformTypeId="xendesktop"
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

if ($type -eq "Create")
{
$hypconfig = @"
<HypervisorPlatformTypeId>$HypervisorPlatformTypeId</HypervisorPlatformTypeId>
"@
}
elseif ($type -eq "Publish") {
$hypconfig = @"
<HypervisorPlatformTypeId>$HypervisorPlatformTypeId</HypervisorPlatformTypeId>
<ProvisioningPlatformTypeId>$ProvisioningPlatformTypeId</ProvisioningPlatformTypeId>
<BrokerPlatformTypeId>$BrokerPlatformTypeId</BrokerPlatformTypeId>
"@ 
}
else {
  Throw "Could not get Type for Platform Layer"
}

[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <CreatePlatformLayer xmlns="http://www.unidesk.com/">
      <command>
        <OsLayerRevisionId>$osrevid</OsLayerRevisionId>
        $plat
        <LayerInfo>
          <Name>$name</Name>
          <Description>$Description</Description>
          <IconId>$iconid</IconId>
        </LayerInfo>
        <RevisionInfo>
          <Name>1</Name>
          <Description/>
          <LayerSizeMiB>$size</LayerSizeMiB>
        </RevisionInfo>
        <OsLayerSwitching>BoundToOsLayer</OsLayerSwitching>
        <SelectedFileShare>$shareid</SelectedFileShare>
        <PackagingDiskFilename>$name</PackagingDiskFilename>
        <PackagingDiskFormat>$diskformat</PackagingDiskFormat>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
        <PlatformConnectorConfigId>$connectorid</PlatformConnectorConfigId>
        $hypconfig
      </command>
    </CreatePlatformLayer>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/CreatePlatformLayer";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"

if ($PSCmdlet.ShouldProcess("Creating platform layer $name")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content


  if($obj.Envelope.Body.CreatePlatformLayerResponse.CreatePlatformLayerResult.Error)
  {
    throw $obj.Envelope.Body.CreatePlatformLayerResponse.CreatePlatformLayerResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.CreatePlatformLayerResponse.CreatePlatformLayerResult.WorkTicketId)"
    return $obj.Envelope.Body.CreatePlatformLayerResponse.CreatePlatformLayerResult
  }
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}