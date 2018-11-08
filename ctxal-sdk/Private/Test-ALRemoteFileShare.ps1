function Test-ALRemoteFileShare
{
<#
.SYNOPSIS
  Tests remote file share for export import layer processes
.DESCRIPTION
  Tests remote file share for export import layer processes
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER sharepath
  Share UNC Path type
.PARAMETER sharetype
  Share type (Default CIFS)
.PARAMETER username
  Share username
.PARAMETER sharepw
  Share password
.EXAMPLE
  Test-RemoteFileShare -websession $websession -sharepath "\\myserver\path\layers"
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$sharepath,
[Parameter(Mandatory=$false)]$sharetype="Cifs",
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
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <TestRemoteFileShare xmlns="http://www.unidesk.com/">
      <command>
        <ShareId xsi:nil="true"/>
        <SharePath>$sharepath</SharePath>
        <ShareType>$sharetype</ShareType>
        <Username>$username</Username>
        <Password>$sharepw</Password>
        <Timeout xsi:nil="true"/>
        <OnlyCheckCreds>true</OnlyCheckCreds>
      </command>
    </TestRemoteFileShare>
  </s:Body>
</s:Envelope>
"@
}
else {
Write-Verbose "NO Credentials"
[xml]$xml = @"
    <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
      <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <TestRemoteFileShare xmlns="http://www.unidesk.com/">
          <command>
            <ShareId xsi:nil="true"/>
            <SharePath>$sharepath</SharePath>
            <ShareType>$sharetype</ShareType>
            <Timeout xsi:nil="true"/>
            <OnlyCheckCreds>true</OnlyCheckCreds>
          </command>
        </TestRemoteFileShare>
      </s:Body>
    </s:Envelope>
"@   
}


$headers = @{
SOAPAction = "http://www.unidesk.com/TestRemoteFileShare";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

if ($obj.Envelope.Body.TestRemoteFileShareResponse.TestRemoteFileShareResult.Error)
{
  Write-Verbose "Problems connecting to share"
  throw $obj.Envelope.Body.TestRemoteFileShareResponse.TestRemoteFileShareResult.Error.message
  return $false
}
else {
  Write-Verbose "Share connection OK"
  return $true
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}

}
