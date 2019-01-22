function Get-ALUserDetail
{
<#
.SYNOPSIS
  Gets detailed information on user from directory junction
.DESCRIPTION
  Gets detailed information on user from directory junction
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER id
  Unidesk ID of user
.PARAMETER junctionid
  Directory junction ID
.PARAMETER lapguid
  LDAP guid of user
.PARAMETER dn
  LDAP DN of user
.EXAMPLE
  Get-ALUserDetail -websession $websession -junctionid $dir.id -ldapguid $userid.DirectoryId.LdapGuid -dn $userid.DirectoryId.LdapDN -id $userid.DirectoryId.UnideskId
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$id,
[Parameter(Mandatory=$true)][string]$junctionid,
[Parameter(Mandatory=$true)][string]$ldapguid,
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
  <QueryDirectoryItemDetails xmlns="http://www.unidesk.com/">
  <query>
    <Id xsi:type="UserId">
      <UnideskId>$id</UnideskId>
      <DirectoryJunctionId>$junctionid</DirectoryJunctionId>
      <LdapGuid>$ldapguid</LdapGuid>
      <LdapDN>$dn</LdapDN>
      <Sid/>
    </Id>
  </query>
  </QueryDirectoryItemDetails>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryDirectoryItemDetails";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

 
  if($obj.Envelope.Body.QueryDirectoryItemDetailsResponse.QueryDirectoryItemDetailsResult.Error)
  {
    throw $obj.Envelope.Body.QueryDirectoryItemDetailsResponse.QueryDirectoryItemDetailsResult.Error.message
  }
  else {
    return $obj.Envelope.Body.QueryDirectoryItemDetailsResponse.QueryDirectoryItemDetailsResult.Details
  }

}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
