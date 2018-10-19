function New-ALAppLayer
{
<#
.SYNOPSIS
  Creates a new application layer
.DESCRIPTION
  Creates a new application layer
.PARAMETER websession
  Existing Webrequest session for ELM  Appliance
.PARAMETER version
  Version of the layer
.PARAMETER name
  Name of the layer
.PARAMETER description
  Description of the layer
.PARAMETER revdescription
  Revision description
.PARAMETER OsLayerSwitching
  Allow OS Switching NotBoundToOsLayer=ON BoundToOsLayer=OFF
.PARAMETER connectorid
  ID of Connector to use
.PARAMETER osrevid
  Operating system version ID
.PARAMETER platformrevid
  Platform version ID if needed
.PARAMETER diskformat
  Disk format of the image
.PARAMETER fileshareid
  Fileshare ID to store disk
.PARAMETER size
  Size of layer in GB (default 10240)
.PARAMETER icon
  Icon ID (default 196608)
.EXAMPLE
 $connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
 $fileshare = Get-ALRemoteshare -websession $websession
 $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
 $osrevs = get-aloslayerDetail -websession $websession -id $oss.id
 $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
 new-alapplayer -websession $websession -version "1.0" -name "Accounting APP" -description "Accounting application" -connectorid $connector.id -osrevid $osrevid.Id -diskformat $connector.ValidDiskFormats.DiskFormat -OsLayerSwitching BoundToOsLayer -fileshareid $fileshare.id
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$version,
[Parameter(Mandatory=$true)]$name,
[Parameter(Mandatory=$false)]$description="",
[Parameter(Mandatory=$false)]$revdescription="",
[Parameter(Mandatory=$false)][ValidateSet("NotBoundToOsLayer", "BoundToOsLayer")][string]$OsLayerSwitching="BoundToOsLayer",
[Parameter(Mandatory=$true)]$connectorid,
[Parameter(Mandatory=$true)]$osrevid,
[Parameter(Mandatory=$false)]$platformrevid,
[Parameter(Mandatory=$true)]$diskformat,
[Parameter(Mandatory=$true)]$fileshareid,
[Parameter(Mandatory=$false)]$size="10240",
[Parameter(Mandatory=$false)]$icon="196608"
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
    <CreateApplicationLayer xmlns="http://www.unidesk.com/">
      <command>
        <OsLayerRevisionId>$osrevid</OsLayerRevisionId>
        $plat
        <AppLayerRevisionIds/>
        <LayerInfo>
          <Name>$name</Name>
          <Description>$description</Description>
          <IconId>$icon</IconId>
        </LayerInfo>
        <RevisionInfo>
          <Name>$version</Name>
          <Description>$revdescription</Description>
          <LayerSizeMiB>$size</LayerSizeMiB>
        </RevisionInfo>
        <OsLayerSwitching>$OsLayerSwitching</OsLayerSwitching>
        <SelectedFileShare>$fileshareid</SelectedFileShare>
        <PackagingDiskFilename>$name</PackagingDiskFilename>
        <PackagingDiskFormat>$diskformat</PackagingDiskFormat>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
        <PlatformConnectorConfigId>$connectorid</PlatformConnectorConfigId>
      </command>
    </CreateApplicationLayer>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/CreateApplicationLayer";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Creating app layer $name")) 
{ 
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content

  if($obj.Envelope.Body.CreateApplicationLayerResponse.CreateApplicationLayerResult.Error)
  {
    throw $obj.Envelope.Body.CreateApplicationLayerResponse.CreateApplicationLayerResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.CreateApplicationLayerResponse.CreateApplicationLayerResult.WorkTicketId)"
    return $obj.Envelope.Body.CreateApplicationLayerResponse.CreateApplicationLayerResult
  }
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
