Function Set-ALAdminUser
{
<#
.SYNOPSIS
  Sets Administrator User Password
.DESCRIPTION
  Sets Administrator User Password
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER Password
  New Password for the User
.EXAMPLE
  Set-ALAdminUser -websession $websession -Password $PlainPassword -Verbose
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact="High")]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$false)][string]$Password
)

Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}

Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <EditDirectoryItem xmlns="http://www.unidesk.com/">
      <command>
        <DirectoryItem xsi:type="UserChanges">
            <ItemId xsi:type="UserId">
                <UnideskId>294912</UnideskId>
                <DirectoryJunctionId>0</DirectoryJunctionId>
                <LdapGuid />
                <LdapDN />
                <Sid />
            </ItemId>
            <Roles>
                <long>163847</long>
            </Roles>
            <Name>Administrator</Name>
            <Email />
            <LastName>Administrator</LastName>
            <Phone />
            <Address1 />
            <Address2 />
            <Title />
            <City />
            <State />
            <PostalCode />
            <Country />
            <LoginName>Administrator</LoginName>
            <Password>$Password</Password>
            </DirectoryItem>
            <Reason>
                <ReferenceNumber>0</ReferenceNumber>
            </Reason>
      </command>
    </EditDirectoryItem>
  </s:Body>
</s:Envelope>
"@

$headers = @{
SOAPAction = "http://www.unidesk.com/EditDirectoryItem";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}

$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Setting Administrator Password")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content

    if($obj.Envelope.Body.EditDirectoryItemResponse.EditDirectoryItemResult.Error)
    {
      throw $obj.Envelope.Body.EditDirectoryItemResponse.EditDirectoryItemResult.Error.message
    }
    else {
      return $obj.Envelope.Body.EditDirectoryItemResponse.EditDirectoryItemResult.id
    }
    }
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}