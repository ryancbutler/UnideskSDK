function Get-ALRemoteshare
{
<#
.SYNOPSIS
  Gets CIFS share information currently configured 
.DESCRIPTION
  Gets CIFS share information currently configured 
.PARAMETER websession
  Existing Webrequest session for ELM  Appliance
.EXAMPLE
  Get-ALRemoteshare -websession $websession
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryRemoteFileShares xmlns="http://www.unidesk.com/">
      <query/>
    </QueryRemoteFileShares>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryRemoteFileShares";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content


if($obj.Envelope.Body.QueryRemoteFileSharesResponse.QueryRemoteFileSharesResult.Error)
    {
      throw $obj.Envelope.Body.QueryRemoteFileSharesResponse.QueryRemoteFileSharesResult.Error.message
    }
    else {
      return $obj.Envelope.Body.QueryRemoteFileSharesResponse.QueryRemoteFileSharesResult.RemoteShares.RemoteFileShareSummary
    }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}