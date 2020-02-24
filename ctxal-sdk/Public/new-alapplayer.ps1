function New-ALAppLayer {
  <#
.SYNOPSIS
  Creates a new application layer
.DESCRIPTION
  Creates a new application layer
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
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
.PARAMETER appprereqid
  Application Layer Prerequisie version ID(s) if needed
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
  [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)][string]$version,
    [Parameter(Mandatory = $true)][string]$name,
    [Parameter(Mandatory = $false)][string]$description = "",
    [Parameter(Mandatory = $false)][string]$revdescription = "",
    [Parameter(Mandatory = $false)][ValidateSet("NotBoundToOsLayer", "BoundToOsLayer")][string]$OsLayerSwitching = "BoundToOsLayer",
    [Parameter(Mandatory = $true)][string]$connectorid,
    [Parameter(Mandatory = $true)][string]$osrevid,
    [Parameter(Mandatory = $false)][string]$platformrevid,
    [Parameter(Mandatory = $false)][string[]]$appprereqid,
    [Parameter(Mandatory = $true)][string]$diskformat,
    [Parameter(Mandatory = $true)][string]$fileshareid,
    [Parameter(Mandatory = $false)][string]$size = "10240",
    [Parameter(Mandatory = $false)][string]$icon = "196608"
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {

    if (-not ([string]::IsNullOrWhiteSpace($platformrevid))) {
      Write-Verbose "Creating with Platform layer"
      $plat = @" 
<PlatformLayerRevisionId>$platformrevid</PlatformLayerRevisionId>
"@
    }
    else {
      Write-Verbose "Creating withOUT Platform layer"
      $plat = @" 
<PlatformLayerRevisionId xsi:nil="true"/>
"@
    }

    if (-not ([string]::IsNullOrWhiteSpace($appprereqid))) {
      Write-Verbose "Creating with layer pre-reqs"
      $idsxml = @()
      foreach ($revid in $appprereqid) {
        $idsxml += @"
<long>$revid</long>
"@
      }

      $reqs = @"
<AppLayerRevisionIds>$idsxml</AppLayerRevisionIds>
"@
    }
    else {
      Write-Verbose "Creating withOUT layer pre-reqs"
      $reqs = @"
<AppLayerRevisionIds/> 
"@
    }

    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <CreateApplicationLayer xmlns="http://www.unidesk.com/">
      <command>
        <OsLayerRevisionId>$osrevid</OsLayerRevisionId>
        $plat
        $reqs
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
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/CreateApplicationLayer";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    if ($PSCmdlet.ShouldProcess("Creating app layer $name")) { 
      $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
      [xml]$obj = $return.Content

      if ($obj.Envelope.Body.CreateApplicationLayerResponse.CreateApplicationLayerResult.Error) {
        throw $obj.Envelope.Body.CreateApplicationLayerResponse.CreateApplicationLayerResult.Error.message

      }
      else {
        Write-Verbose "WORKTICKET: $($obj.Envelope.Body.CreateApplicationLayerResponse.CreateApplicationLayerResult.WorkTicketId)"
        return $obj.Envelope.Body.CreateApplicationLayerResponse.CreateApplicationLayerResult
      }
    }
  }
  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
