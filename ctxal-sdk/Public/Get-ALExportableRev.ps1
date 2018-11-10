function Get-ALExportableRev
{
<#
.SYNOPSIS
  Gets revisions that can be used to export to share
.DESCRIPTION
  Gets revisions that can be used to export to share
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER sharepath
  Share UNC Path type
.PARAMETER username
  Share username
.PARAMETER sharepw
  Share password
.PARAMETER showall
  Get all layers including non exportable ones
.EXAMPLE
  Get-ALExportableRev -websession $websession -sharepath "\\myserver\path\layers"
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$sharepath,
[Parameter(Mandatory=$false)][string]$username,
[Parameter(Mandatory=$false)][string]$sharepw,
[Parameter(Mandatory=$false)][switch]$showall
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {

if ($username)
{
Write-Verbose "Using Credentials"
test-alremotefileshare -websession $websession -sharepath $sharepath -username $username -sharepw $sharepw
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryExportableRevisions xmlns="http://www.unidesk.com/">
      <query>
        <Share>
          <ShareId xsi:nil="true"/>
          <SharePath>$sharepath</SharePath>
          <Username>$username</Username>
          <Password>$sharepw</Password>
        </Share>
      </query>
    </QueryExportableRevisions>
  </s:Body>
</s:Envelope>
"@
}
else {
Write-Verbose "NO Credentials"
test-alremotefileshare -websession $websession -sharepath $sharepath
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryExportableRevisions xmlns="http://www.unidesk.com/">
      <query>
        <Share>
          <ShareId xsi:nil="true"/>
          <SharePath>$sharepath</SharePath>
        </Share>
      </query>
    </QueryExportableRevisions>
  </s:Body>
</s:Envelope>
"@ 
}


$headers = @{
SOAPAction = "http://www.unidesk.com/QueryExportableRevisions";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

$output = @()
foreach ($oslayer in $obj.Envelope.Body.QueryExportableRevisionsResponse.QueryExportableRevisionsResult.ExportableLayerHierarchy.OsLayers.PortableOsLayer)
{
    write-verbose $oslayer.name
        foreach ($osrev in $oslayer.Revisions.PortableRevision)
        {
        write-verbose "Entering os layer revisions"
        $temp = [PSCustomObject]@{
        "OSLayer" = $oslayer.Name;
        "LayerTYPE" = "OS";
        "BaseName" = $oslayer.Name;
        "RevName" = $osrev.Name;
        "ID" = $osrev.Id.'#text';
        "SizeInMB" = $osrev.LayerSizeInMb;
        "ExistsInDestination" = $osrev.ExistsInDestination;
        }
        $output += $temp
        }
        
        foreach ($applayer in $oslayer.AppLayers.PortableLayer)
        {
            write-verbose "Entering app layer"
            foreach ($applayerrev in $applayer.Revisions.PortableRevision)
            {
            $temp = [PSCustomObject]@{
            "OSLayer" = $oslayer.Name;
            "LayerTYPE" = "APP";
            "BaseName" = $applayer.Name;
            "RevName" = $applayerrev.Name;
            "ID" = $applayerrev.Id.'#text';
            "SizeInMB" = $applayerrev.LayerSizeInMb;
            "ExistsInDestination" = $applayerrev.ExistsInDestination;
            }
            $output += $temp
            }
        }

        foreach ($platlayer in $oslayer.PlatformLayers.PortableLayer)
        {
        write-verbose "Entering platform layer"
            foreach ($platlayerev in $platlayer.Revisions.PortableRevision)
            {
            $temp = [PSCustomObject]@{
            "OSLayer" = $oslayer.Name;
            "LayerTYPE" = "PLATFORM";
            "BaseName" = $platlayer.Name;
            "RevName" = $platlayerev.Name;
            "ID" = $platlayerev.Id.'#text';
            "SizeInMB" = $platlayerev.LayerSizeInMb;
            "ExistsInDestination" = $platlayerev.ExistsInDestination;
            }
            $output += $temp
            }
        }


}

if ($showall)
{
  return $output
}
else {
  return $output|Where-Object{$_.ExistsInDestination -eq $false}
}

}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}


