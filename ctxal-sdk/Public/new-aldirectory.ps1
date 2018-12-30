function new-aldirectory
{
<#
.SYNOPSIS
  Creates Directory Junction 
.DESCRIPTION
  Creates Directory Junction
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER name
  Junction name
.PARAMETER serveraddress
  AD server to connect
.PARAMETER port
  AD port (uses 389 and 636 by default)
.PARAMETER usessl
  Connect via SSL
.PARAMETER username
  AD username (eg admin@domain.com)
.PARAMETER adpassword
  AD password
.PARAMETER basedn
  Base AD DN
.PARAMETER force
  Skip AD tests
.EXAMPLE
  new-aldirectory -websession $websession -serveraddress "mydc.domain.com" -Verbose -username "admin@domain.com" -adpassword "MYPASSWORD" -basedn DC=domain,DC=com -name "Mydirectory"
.EXAMPLE
  new-aldirectory -websession $websession -serveraddress "mydc.domain.com" -Verbose -usessl -username "admin@domain.com" -adpassword "MYPASSWORD" -basedn DC=domain,DC=com -name "Mydirectory"
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$name,
[Parameter(Mandatory=$true)][string]$serveraddress,
[Parameter(Mandatory=$false)][string]$port,
[Parameter(Mandatory=$false)][switch]$usessl,
[Parameter(Mandatory=$true)][string]$username,
[Parameter(Mandatory=$true)][string]$adpassword,
[Parameter(Mandatory=$true)][string]$basedn,
[Parameter(Mandatory=$false)][switch]$force
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {


if($usessl)
{

#sets port if not set in parms
if([string]::IsNullOrWhiteSpace($port))
{
  Write-Verbose "Port set to 636"
  $port=636
}
else {
  Write-Verbose "Using port $port"
}

if($force)
{
  Write-Verbose "Skipping Tests"
}
else {
  
  #Test Directory
  if(!(test-aldirectory -websession $websession -serveraddress $serveraddress -usessl:$usessl -port $port))
  {
    throw "Can't connect to AD server. Use -force to skip tests"
  }
  
  if(!(test-aldirectoryauth -websession $websession -serveraddress $serveraddress -usessl:$usessl -port $port -username $username -adpassword $adpassword))
  {
    throw "Can't authenticate to AD server. Use -force to skip tests"
  }
  
  if(!(test-aldirectorydn -websession $websession -serveraddress $serveraddress -usessl:$usessl -port $port -username $username -adpassword $adpassword -basedn $basedn))
  {
    throw "Can't find DN. Use -force to skip tests"
  }
  
}



Write-Verbose "Using SSL"
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <CreateDirectoryJunction xmlns="http://www.unidesk.com/">
      <command>
        <ServerAddress>$serveraddress</ServerAddress>
        <ServerPort>$port</ServerPort>
        <BaseDN>$basedn</BaseDN>
        <UserName>$username</UserName>
        <Password>$adpassword</Password>
        <UseSsl>true</UseSsl>
        <AllowableCertificateErrors>
          <CertificateError>CnNoMatch</CertificateError>
          <CertificateError>Chaining</CertificateError>
        </AllowableCertificateErrors>
        <Name>$name</Name>
        <ParentId>0</ParentId>
        <AttributeMap>
          <MemberOfAttr>memberOf</MemberOfAttr>
          <SidAttr>objectSid</SidAttr>
          <UserGuidAttr>objectGUID</UserGuidAttr>
          <UserDisplayNameAttr>cn</UserDisplayNameAttr>
          <UserPrincipalNameAttr>userPrincipalName</UserPrincipalNameAttr>
          <UserFirstNameAttr>givenName</UserFirstNameAttr>
          <UserLastNameAttr>sn</UserLastNameAttr>
          <UserTitleAttr>title</UserTitleAttr>
          <UserLoginNameAttr>sAMAccountName</UserLoginNameAttr>
          <UserEmailAttr>mail</UserEmailAttr>
          <UserPhoneAttr>telephoneNumber</UserPhoneAttr>
          <UserAddress1Attr>streetAddress</UserAddress1Attr>
          <UserAddress2Attr>postOfficeBox</UserAddress2Attr>
          <UserCityAttr>l</UserCityAttr>
          <UserStateAttr>st</UserStateAttr>
          <UserPostalCodeAttr>postalCode</UserPostalCodeAttr>
          <UserCountryAttr>co</UserCountryAttr>
          <UserFilter>(&amp;(objectClass=user)(!(objectClass=computer))(|(cn=*)(|(sn=*)(givenName=*))))</UserFilter>
          <GroupGuidAttr>objectGUID</GroupGuidAttr>
          <GroupDisplayNameAttr>name</GroupDisplayNameAttr>
          <GroupDescriptionAttr>description</GroupDescriptionAttr>
          <GroupMemberAttr>member</GroupMemberAttr>
          <GroupFilter>(&amp;(groupType:1.2.840.113556.1.4.803:=2147483648)(|(|(objectClass=group)(objectClass=groupOfNames))(objectClass=groupOfUniqueNames)))</GroupFilter>
          <ContainerGuidAttr>objectGUID</ContainerGuidAttr>
          <ContainerDisplayNameAttr>name</ContainerDisplayNameAttr>
          <ContainerDescriptionAttr>description</ContainerDescriptionAttr>
          <ContainerFilter>(|(|(|(objectClass=container)(objectClass=organizationalUnit))(objectClass=builtinDomain))(objectClass=domain))</ContainerFilter>
        </AttributeMap>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </CreateDirectoryJunction>
  </s:Body>
</s:Envelope>
"@
}
else {

    #sets port if not set in parms
  if([string]::IsNullOrWhiteSpace($port))
  {
    Write-Verbose "Port set to 389"
    $port=389
  }
  else {
    Write-Verbose "Using port $port"
  }

  if($force)
  {
    Write-Verbose "Skipping Tests"
  }
  else {
    
    #Test Directory
    if(!(test-aldirectory -websession $websession -serveraddress $serveraddress -usessl:$usessl -port $port))
    {
      throw "Can't connect to AD server. Use -force to skip tests"
    }
    
    if(!(test-aldirectoryauth -websession $websession -serveraddress $serveraddress -usessl:$usessl -port $port -username $username -adpassword $adpassword))
    {
      throw "Can't authenticate to AD server. Use -force to skip tests"
    }
    
    if(!(test-aldirectorydn -websession $websession -serveraddress $serveraddress -usessl:$usessl -port $port -username $username -adpassword $adpassword -basedn $basedn))
    {
      throw "Can't find DN. Use -force to skip tests"
    }
    
  }

Write-Verbose "NO SSL"



[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <CreateDirectoryJunction xmlns="http://www.unidesk.com/">
      <command>
        <ServerAddress>$serveraddress</ServerAddress>
        <ServerPort>$port</ServerPort>
        <BaseDN>$basedn</BaseDN>
        <UserName>$username</UserName>
        <Password>$adpassword</Password>
        <UseSsl>false</UseSsl>
        <AllowableCertificateErrors/>
        <Name>$name</Name>
        <ParentId>0</ParentId>
        <AttributeMap>
          <MemberOfAttr>memberOf</MemberOfAttr>
          <SidAttr>objectSid</SidAttr>
          <UserGuidAttr>objectGUID</UserGuidAttr>
          <UserDisplayNameAttr>cn</UserDisplayNameAttr>
          <UserPrincipalNameAttr>userPrincipalName</UserPrincipalNameAttr>
          <UserFirstNameAttr>givenName</UserFirstNameAttr>
          <UserLastNameAttr>sn</UserLastNameAttr>
          <UserTitleAttr>title</UserTitleAttr>
          <UserLoginNameAttr>sAMAccountName</UserLoginNameAttr>
          <UserEmailAttr>mail</UserEmailAttr>
          <UserPhoneAttr>telephoneNumber</UserPhoneAttr>
          <UserAddress1Attr>streetAddress</UserAddress1Attr>
          <UserAddress2Attr>postOfficeBox</UserAddress2Attr>
          <UserCityAttr>l</UserCityAttr>
          <UserStateAttr>st</UserStateAttr>
          <UserPostalCodeAttr>postalCode</UserPostalCodeAttr>
          <UserCountryAttr>co</UserCountryAttr>
          <UserFilter>(&amp;(objectClass=user)(!(objectClass=computer))(|(cn=*)(|(sn=*)(givenName=*))))</UserFilter>
          <GroupGuidAttr>objectGUID</GroupGuidAttr>
          <GroupDisplayNameAttr>name</GroupDisplayNameAttr>
          <GroupDescriptionAttr>description</GroupDescriptionAttr>
          <GroupMemberAttr>member</GroupMemberAttr>
          <GroupFilter>(&amp;(groupType:1.2.840.113556.1.4.803:=2147483648)(|(|(objectClass=group)(objectClass=groupOfNames))(objectClass=groupOfUniqueNames)))</GroupFilter>
          <ContainerGuidAttr>objectGUID</ContainerGuidAttr>
          <ContainerDisplayNameAttr>name</ContainerDisplayNameAttr>
          <ContainerDescriptionAttr>description</ContainerDescriptionAttr>
          <ContainerFilter>(|(|(|(objectClass=container)(objectClass=organizationalUnit))(objectClass=builtinDomain))(objectClass=domain))</ContainerFilter>
        </AttributeMap>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </CreateDirectoryJunction>
  </s:Body>
</s:Envelope>
"@
}
$headers = @{
SOAPAction = "http://www.unidesk.com/CreateDirectoryJunction";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"

if ($PSCmdlet.ShouldProcess("Will create new directory junction $name"))
{
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content

  #error found
  if($obj.Envelope.Body.CreateDirectoryJunctionResponse.CreateDirectoryJunctionResult.Error)
  {
    throw $obj.Envelope.Body.CreateDirectoryJunctionResponse.CreateDirectoryJunctionResult.Error.message
  }

  Write-Verbose "Junction creation successful!"
  return $obj.Envelope.Body.CreateDirectoryJunctionResponse.CreateDirectoryJunctionResult.id
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}