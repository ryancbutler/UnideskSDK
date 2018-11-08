function Get-ALExportableRevs
{
<#
.SYNOPSIS
  Gets revisions that can be used to export
.DESCRIPTION
  Gets revisions that can be used to export
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER sharepath
  Share UNC Path type
.PARAMETER username
  Share username
.PARAMETER sharepw
  Share password
.EXAMPLE
  Get-ALExportableRevs -websession $websession -sharepath "\\myserver\path\layers"
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

return $obj
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}


