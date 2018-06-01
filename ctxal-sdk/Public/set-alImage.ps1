function Set-ALImage
{
<#
.SYNOPSIS
  Edits values of a image(template)
.DESCRIPTION
  Edits values of a image(template)
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.PARAMETER id
  ID of image
.PARAMETER name
  Name of the image
.PARAMETER description
  Description of the image
.PARAMETER connectorid
  ID of Connector to use
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
  $fileshare = Get-ALRemoteshare -websession $websession
  $connector = Get-ALconnector -websession $websession -type Create
  $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
  $osrevs = get-aloslayerdetail -websession $websession -id $oss.id
  $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  $plats = Get-ALPlatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
  $platrevs = get-alplatformlayerdetail -websession $websession -id $plats.id
  $platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  $image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting"}
  Set-alimage -websession $websession -name $images.Name -description "My new description" -connectorid $connector.id -osrevid $osrevid.Id -platrevid $platformrevid.id -id $image.Id -ElasticLayerMode Session -diskformat $connector.ValidDiskFormats.DiskFormat
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$id,
[Parameter(Mandatory=$true)]$name,
[Parameter(Mandatory=$false)]$description="",
[Parameter(Mandatory=$true)]$connectorid,
[Parameter(Mandatory=$true)]$osrevid,
[Parameter(Mandatory=$true)]$platrevid,
[Parameter(Mandatory=$false)][ValidateSet("None","Session","Office365","SessionOffice365","Desktop")][string]$ElasticLayerMode="None",
[Parameter(Mandatory=$true)]$diskformat,
[Parameter(Mandatory=$false)]$size="102400",
[Parameter(Mandatory=$false)]$icon="196608"
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {

[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <EditImage xmlns="http://www.unidesk.com/">
      <command>
        <Id>$id</Id>
        <ImageName>$name</ImageName>
        <Description>$description</Description>
        <IconId>$icon</IconId>
        <OsLayerRevId>$osrevid</OsLayerRevId>
        <AppLayerRevIds/>
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
    </EditImage>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/EditImage";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
  if ($PSCmdlet.ShouldProcess("Setting image $name")) { 
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content



  if($obj.Envelope.Body.EditImageResponse.EditImageResult.Error)
  {
    throw $obj.Envelope.Body.EditImageResponse.EditImageResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.EditImageResponse.EditImageResult.WorkTicketId)"
    return $obj.Envelope.Body.EditImageResponse.EditImageResult.ImageSummary
  }
  }
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
