function Get-ALUserList
{
<#
.SYNOPSIS
  Gets list of users and groups for specific LDAP DN
.DESCRIPTION
  Gets list of users and groups for specific LDAP DN
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER junctionid
  Directory junction ID
.PARAMETER dn
  LDAP DN of user location
.EXAMPLE
  Get-ALUserList -websession $websession -junctionid $dir.id -dn "CN=Users,DC=mydomain,DC=com"
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$junctionid,
[Parameter(Mandatory=$true)][string]$dn
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <BrowseContainer xmlns="http://www.unidesk.com/">
      <query>
        <Id xsi:type="FolderId">
          <UnideskId>$junctionid</UnideskId>
          <DirectoryJunctionId>$junctionid</DirectoryJunctionId>
          <LdapGuid/>
          <LdapDN>$dn</LdapDN>
          <Sid/>
        </Id>
        <FilterType>All</FilterType>
      </query>
    </BrowseContainer>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/BrowseContainer";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content
 
  if($obj.Envelope.Body.BrowseContainerResponse.BrowseContainerResult.Error)
  {
    throw $obj.Envelope.Body.BrowseContainerResponse.BrowseContainerResult.Error.message
  }
  else {
    return $obj.Envelope.Body.BrowseContainerResponse.BrowseContainerResult.Items.DirectoryItem
  }

}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
