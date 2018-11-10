function New-ALImage
{
<#
.SYNOPSIS
  Creates new image(template)
.DESCRIPTION
  Creates new image(template)
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER name
  Name of the layer
.PARAMETER description
  Description of the layer
.PARAMETER connectorid
  ID of Connector to use
.PARAMETER appids
  IDs of application versions to add to image
.PARAMETER osrevid
  Operating system layer version ID
.PARAMETER platrevid
  Platform layer version ID
.PARAMETER ElasticLayerMode
  Elastic Layer setting for the image. Options "None","Session","Office365","SessionOffice365","Desktop"
.PARAMETER diskformat
  Disk format of the image
.PARAMETER size
  Size of layer in GB (default 102400)
.PARAMETER icon
  Icon ID (default 196608)
.EXAMPLE
  $connector = Get-ALconnector -websession $websession -type "Publish"|where{$_.name -eq "PVS"}
  $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
  $osrevs = get-aloslayer -websession $websession -id $oss.id
  $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  $plats = get-alplatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
  $platrevs = get-alplatformlayerdetail -websession $websession -id $plats.id
  $platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  $ids = @("1081350","1081349")
  new-alimage -websession $websession -name "Win10TEST55" -description "Accounting" -connectorid $connector.id -osrevid $osrevid.Id -appids $ids -platrevid $platformrevid.id -diskformat $connector.ValidDiskFormats.DiskFormat -elasticlayermode Desktop
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$name,
[Parameter(Mandatory=$false)][string]$description="",
[Parameter(Mandatory=$true)][string]$connectorid,
[Parameter(Mandatory=$true)][string]$appids,
[Parameter(Mandatory=$true)][string]$osrevid,
[Parameter(Mandatory=$true)][string]$platrevid,
[Parameter(Mandatory=$false)][ValidateSet("None","Session","Office365","SessionOffice365","Desktop")][string]$ElasticLayerMode="None",
[Parameter(Mandatory=$true)][string]$diskformat,
[Parameter(Mandatory=$false)][string]$size="102400",
[Parameter(Mandatory=$false)][string]$icon="196608"
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
$temp = $null
$appids|ForEach-Object{
[string]$temp += @"
<long>$_</long>
"@
#Workaround for script analyzer
$temp = $temp
}


[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <CreateImage xmlns="http://www.unidesk.com/">
      <command>
        <ImageName>$name</ImageName>
        <Description>$description</Description>
        <IconId>$icon</IconId>
        <OsLayerRevId>$osrevid</OsLayerRevId>
        <AppLayerRevIds>
        $temp
        </AppLayerRevIds>
        <PlatformConnectorConfigId>$connectorid</PlatformConnectorConfigId>
        <PlatformLayerRevId>$platrevid</PlatformLayerRevId>
        <SysprepType>None</SysprepType>
        <LayeredImageDiskFilename>$name</LayeredImageDiskFilename>
        <LayeredImageDiskFormat>$diskformat</LayeredImageDiskFormat>
        <LayeredImagePartitionSizeMiB>$size</LayeredImagePartitionSizeMiB>
        <ElasticLayerMode>$ElasticLayerMode</ElasticLayerMode>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </CreateImage>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/CreateImage";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  if ($PSCmdlet.ShouldProcess("Creating image $name")) {
  [xml]$obj = $return.Content

  if($obj.Envelope.Body.CreateImageResponse.CreateImageResult.Error)
  {
    throw $obj.Envelope.Body.CreateImageResponse.CreateImageResult.Error.ExceptionMessage

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.CreateImageResponse.CreateImageResult.WorkTicketId)"
    return $obj.Envelope.Body.CreateImageResponse.CreateImageResult.ImageSummary.Id
  }
  }
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
