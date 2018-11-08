function Get-ALImportableRevs
{
<#
.SYNOPSIS
  Gets revisions that can be used to import
.DESCRIPTION
  Gets revisions that can be used to import
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER sharepath
  Share UNC Path type
.PARAMETER username
  Share username
.PARAMETER sharepw
  Share password
.EXAMPLE
  Get-ALImportableRevs -websession $websession -sharepath "\\myserver\path\layers"
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$sharepath,
[Parameter(Mandatory=$false)]$username,
[Parameter(Mandatory=$false)]$sharepw
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
    <QueryImportableRevisions xmlns="http://www.unidesk.com/">
      <query>
        <Share>
          <ShareId xsi:nil="true"/>
          <SharePath>$sharepath</SharePath>
          <Username>$username</Username>
          <Password>$sharepw</Password>
        </Share>
      </query>
    </QueryImportableRevisions>
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
    <QueryImportableRevisions xmlns="http://www.unidesk.com/">
      <query>
        <Share>
          <ShareId xsi:nil="true"/>
          <SharePath>$sharepath</SharePath>
        </Share>
      </query>
    </QueryImportableRevisions>
  </s:Body>
</s:Envelope>
"@ 
}


$headers = @{
SOAPAction = "http://www.unidesk.com/QueryImportableRevisions";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content
#return $obj
$output = @()
foreach ($oslayer in $obj.Envelope.Body.QueryImportableRevisionsResponse.QueryImportableRevisionsResult.ImportableLayerHierarchy.OsLayers.PortableOsLayer)
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
return $output

}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}


