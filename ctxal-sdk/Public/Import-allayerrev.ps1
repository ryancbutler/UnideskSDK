function Import-ALLayerRev
{
<#
.SYNOPSIS
  Imports existing layers from share into ELM
.DESCRIPTION
  Imports existing layers from share into ELM
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER sharepath
  Share UNC Path type
.PARAMETER id
  ID(s) of revision layers to export
.PARAMETER username
  Share username
.PARAMETER sharepw
  Share password
.EXAMPLE
  Import-ALlayerrevs -websession $websession -sharepath "\\myserver\path\layers" -id @(12042,225252,2412412)
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$sharepath,
[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$True)]$id,
[Parameter(Mandatory=$false)]$username,
[Parameter(Mandatory=$false)]$sharepw
)
Begin {
Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
Test-ALWebsession -WebSession $websession
$idsxml = $null 
}


Process {
if(!$id)
{
  Write-Verbose "NOTHING TO DO"
  return $false
}

Write-Verbose "Building XML"
foreach ($revid in $id)
{
$idsxml += @"
<anyType xsi:type="xsd:string">$revid</anyType>
"@
}

}

end{
if(!$id)
{
  Write-Verbose "NOTHING TO DO"
  return $false
}

if ($username)
{
Write-Verbose "Using Credentials"
test-alremotefileshare -websession $websession -sharepath $sharepath -username $username -sharepw $sharepw
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <ImportLayerRevisions xmlns="http://www.unidesk.com/">
      <command>
        <Share>
          <ShareId xsi:nil="true"/>
          <SharePath>$sharepath</SharePath>
          <Username>$username</Username>
          <Password>$sharepw</Password>
        </Share>
        <ImportIds>
          $idsxml
        </ImportIds>
      </command>
    </ImportLayerRevisions>
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
    <ImportLayerRevisions xmlns="http://www.unidesk.com/">
      <command>
        <Share>
          <ShareId xsi:nil="true"/>
          <SharePath>$sharepath</SharePath>
        </Share>
        <ImportIds>
          $idsxml
        </ImportIds>
      </command>
    </ImportLayerRevisions>
  </s:Body>
</s:Envelope>
"@ 
}


$headers = @{
SOAPAction = "http://www.unidesk.com/ImportLayerRevisions";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

if($obj.Envelope.Body.ImportLayerRevisionsResponse.ImportLayerRevisionsResult.Error)
{
    throw $obj.Envelope.Body.ImportLayerRevisionsResponse.ImportLayerRevisionsResult.Error.message
}
else {
    return $obj.Envelope.Body.ImportLayerRevisionsResponse.ImportLayerRevisionsResult.WorkTicketId

}

Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
