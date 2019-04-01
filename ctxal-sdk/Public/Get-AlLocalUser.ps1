Function Get-ALLocalUser
{
<#
.SYNOPSIS
  Gets ELM local users
.DESCRIPTION
  Gets ELM local users
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  Get-ALLocalUser -websession $websession
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
    <QueryUsers xmlns="http://www.unidesk.com/">
      <query>
        <Filter>All</Filter>
      </query>
    </QueryUsers>
  </s:Body>
</s:Envelope>
"@

$headers = @{
SOAPAction = "http://www.unidesk.com/QueryUsers";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}

$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content


if($obj.Envelope.Body.QueryUsersResponse.QueryUsersResult.Users.Error)
    {
      throw $obj.Envelope.Body.QueryUsersResponse.QueryUsersResult.Users.Error.message
    }
    else {
      return $obj.Envelope.body.QueryUsersResponse.QueryUsersResult.Users.UserSummary
    }
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}