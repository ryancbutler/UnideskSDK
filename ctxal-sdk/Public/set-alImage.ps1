function Set-ALImage {
  <#
.SYNOPSIS
  Edits values of a image(template)
.DESCRIPTION
  Edits values of a image(template)
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
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
.PARAMETER appLayerid
  Application layer ID
.PARAMETER apprevid
  Application layer version ID
.PARAMETER ElasticLayerMode
  Elastic Layer setting for the image. Options "None","Session","Office365","SessionOffice365","Desktop"
.PARAMETER diskformat
  Disk format of the image
.PARAMETER size
  Size of layer in MB
.PARAMETER icon
  Icon ID
.PARAMETER syspreptype
  Syspreptype for the Image. Options "None","Offline"
.EXAMPLE
  $fileshare = Get-ALRemoteshare -websession $websession
  $connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
  $oss = Get-ALOsLayer -websession $websession|where{$_.name -eq "Windows 10 x64"}
  $osrevs = get-aloslayerdetail -websession $websession -id $oss.id
  $osrevid = $osrevs.Revisions.OsLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  $plats = Get-ALPlatformlayer -websession $websession|where{$_.name -eq "Windows 10 VDA"}
  $platrevs = get-alplatformlayerdetail -websession $websession -id $plats.id
  $platformrevid = $platrevs.Revisions.PlatformLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  $image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting"}
  Set-alimage -websession $websession -name $images.Name -description "My new description" -connectorid $connector.id -osrevid $osrevid.Id -platrevid $platformrevid.id -id $image.Id -ElasticLayerMode Session -diskformat $connector.ValidDiskFormats.DiskFormat -syspreptype Offline
  
  ### Edit image with latest revision for a specific app or apps ***
  $apps = @("Winscp","7-zip")
  $applayerids = foreach ($app in $apps){Get-ALapplayer -websession $websession|where{$_.name -eq $app}}
  $apprevs = foreach ($applayerid in $applayerids){get-alapplayerDetail -websession $websession -id $applayerid.Id}
  $apprevid = foreach ($apprev in $apprevs){$apprev.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1}
  Set-alimage -websession $websession -name $images.Name -description "My new description" -connectorid $connector.id -osrevid $osrevid.Id -platrevid $platformrevid.id -id $image.Id -ElasticLayerMode Session -diskformat $connector.ValidDiskFormats.DiskFormat -applayerid $apprevid.LayerId -apprevid $apprevid.Id -syspreptype Offline
#>

  [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)][string]$id,
    [Parameter(Mandatory = $false)][string]$name,
    [Parameter(Mandatory = $false)][string]$description,
    [Parameter(Mandatory = $false)][string]$connectorid,
    [Parameter(Mandatory = $false)][string]$osrevid,
    [Parameter(Mandatory = $false)][string]$platrevid,
    [Parameter(Mandatory = $false)][array]$applayerid,
    [Parameter(Mandatory = $false)][array]$apprevid,
    [Parameter(Mandatory = $false)][ValidateSet("None", "Session", "Office365", "SessionOffice365", "Desktop")][string]$ElasticLayerMode,
    [Parameter(Mandatory = $false)][string]$diskformat,
    [Parameter(Mandatory = $false)][string]$size,
    [Parameter(Mandatory = $false)][string]$icon,
    [Parameter(Mandatory = $false)][ValidateSet("None", "Offline")][string]$syspreptype
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {

    $image = get-alimagedetail -websession $websession -id $id

    #Check for existing params
    if ([string]::IsNullOrWhiteSpace($name)) {
      $name = $image.Name
      Write-Verbose "Using existing name value $name"
    }

    if ([string]::IsNullOrWhiteSpace($description)) {
 
      $description = $image.$description
      if ([string]::IsNullOrWhiteSpace($image.$description)) {
        $description = ""
      }
      else {
        $description = $image.description
      }
      Write-Verbose "Using existing description value $description"
    }

    if ([string]::IsNullOrWhiteSpace($connectorid)) {
      $connectorid = $image.PlatformConnectorConfigId
      Write-Verbose "Using existing PlatformConnectorId value $connectorid"
    }

    if ([string]::IsNullOrWhiteSpace($osrevid)) {
      $osrevid = $image.OsRev.Revisions.RevisionResult.Id
      Write-Verbose "Using existing osrevid value $osrevid"
    }

    if ([string]::IsNullOrWhiteSpace($platrevid)) {
      $platrevid = $image.PlatformLayer.Revisions.RevisionResult.Id
      Write-Verbose "Using existing platrevid value $platrevid"
    }

    if ([string]::IsNullOrWhiteSpace($ElasticLayerMode)) {
      $ElasticLayerMode = $image.ElasticLayerMode
      Write-Verbose "Using existing ElasticLayerMode value $ElasticLayerMode"
    }

    if ([string]::IsNullOrWhiteSpace($diskformat)) {
      $diskformat = $image.LayeredImageDiskFormat
      Write-Verbose "Using existing diskformat value $diskformat"
    }

    if ([string]::IsNullOrWhiteSpace($size)) {
      $size = $image.LayeredImagePartitionSizeMiB
      Write-Verbose "Using existing size value $size"
    }

    if ([string]::IsNullOrWhiteSpace($icon)) {
      $icon = $image.ImageId
      Write-Verbose "Using existing icon value $icon"
    }
    
    if ([string]::IsNullOrWhiteSpace($syspreptype)) {
      $syspreptype = $image.syspreptype
      Write-Verbose "Using existing syspreptype value $syspreptype"
    }

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
        <PlatformConnectorConfigId>$connectorid</PlatformConnectorConfigId>
        <PlatformLayerRevId>$platrevid</PlatformLayerRevId>
        <AppLayerRevIds/>
        <SysprepType>$syspreptype</SysprepType>
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

    # If ApplayerId and AppRevId are provided merge the two xml blocks
    if ((![string]::IsNullOrWhiteSpace($applayerid)) -and (![string]::IsNullOrWhiteSpace($apprevid))) {
      # Remove AppLayerRevIds to be able to recreate as new element
      $DeleteNames = "AppLayerRevIds"
      ($xml.envelope.body.editimage.command.ChildNodes | Where-Object { $DeleteNames -contains $_.Name }) | ForEach-Object { [void]$_.ParentNode.RemoveChild($_) }

      # Retrieve NamespaceUri from parent
      $xdNS = $xml.envelope.body.editimage.command.NamespaceURI

      # Define Root Element
      $AppLayerRevIds = $xml.CreateNode([Xml.XmlNodeType]::Element, "AppLayerRevIds", $xdNS);
    
      # Define Element and values for each provided applayerid
      for ($i = 0; $i -lt $applayerid.Length; $i++) {
    
        $KeyValueOfInt64 = $xml.CreateNode([Xml.XmlNodeType]::Element, "KeyValueOfInt64", $xdNS);
        $ElementName = $xml.CreateNode([Xml.XmlNodeType]::Element, "Name", $xdNS);
        $ElementName.InnerText = $applayerid[$i]
        $ElementValue = $xml.CreateNode([Xml.XmlNodeType]::Element, "Value", $xdNS);
        $ElementValue.InnerText = $apprevid[$i]

        # Append the elements with their values
        $KeyValueOfInt64.AppendChild($ElementName);
        $KeyValueOfInt64.AppendChild($ElementValue);
        $AppLayerRevIds.AppendChild($KeyValueOfInt64);

      }

      # Merge with origin
      $xml.envelope.body.editimage.command.AppendChild($AppLayerRevIds)
    }
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/EditImage";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    if ($PSCmdlet.ShouldProcess("Setting image $name")) {
      $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
      [xml]$obj = $return.Content



      if ($obj.Envelope.Body.EditImageResponse.EditImageResult.Error) {
        throw $obj.Envelope.Body.EditImageResponse.EditImageResult.Error.message

      }
      else {
        Write-Verbose "WORKTICKET: $($obj.Envelope.Body.EditImageResponse.EditImageResult.WorkTicketId)"
        return $obj.Envelope.Body.EditImageResponse.EditImageResult.ImageSummary
      }
    }
  }

  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
