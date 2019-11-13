function Get-ALUserGroupMembership {
  <#
.SYNOPSIS
  Gets group membership of user
.DESCRIPTION
  Gets group membership of user
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER id
  Unidesk ID of user
.PARAMETER junctionid
  Directory Junction ID
.PARAMETER ldapguid
  User LDAP guid
.PARAMETER ldapdn
  User LDAP DN
.PARAMETER sid
  User SID
.EXAMPLE
  Get-ALUserGroupMembership -websession $websession -junctionid $dir.id -id $User.DirectoryId.UnideskId -ldapguid $user.FullId.LdapGuid -ldapdn $user.FullId.LdapDN -sid $userdetail.FullId.sid
#>
  [cmdletbinding()]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)][string]$id,
    [Parameter(Mandatory = $true)][string]$junctionid,
    [Parameter(Mandatory = $true)][string]$ldapguid,
    [Parameter(Mandatory = $true)][string]$ldapdn,
    [Parameter(Mandatory = $true)][string]$sid
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {
    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryDirectoryItemGroupMembership xmlns="http://www.unidesk.com/">
      <query>
        <Id xsi:type="UserId">
          <UnideskId>$id</UnideskId>
          <DirectoryJunctionId>$junctionid</DirectoryJunctionId>
          <LdapGuid>$ldapguid</LdapGuid>
          <LdapDN>$ldapdn</LdapDN>
          <Sid>$sid</Sid>
        </Id>
      </query>
    </QueryDirectoryItemGroupMembership>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/QueryDirectoryItemGroupMembership";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
    [xml]$obj = $return.Content

    if ($obj.Envelope.Body.QueryDirectoryItemGroupMembershipResponse.QueryDirectoryItemGroupMembershipResult.Error) {
      throw $obj.Envelope.Body.QueryDirectoryItemGroupMembershipResponse.QueryDirectoryItemGroupMembershipResult.Error.message
    }
    else {
      return $obj.Envelope.Body.QueryDirectoryItemGroupMembershipResponse.QueryDirectoryItemGroupMembershipResult.Groups.GroupSummary
    }

  }
  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
