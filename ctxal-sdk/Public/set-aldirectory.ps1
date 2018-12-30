function set-aldirectory
{
<#
.SYNOPSIS
  Sets properties of an existing Directory Junction 
.DESCRIPTION
  Sets properties of an existing Directory Junction 
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER id
  Junction ID
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
.PARAMETER force
  Skip AD tests
.EXAMPLE
  Set-aldirectory -websession $websession -adpassword "MYPASSWORD" -id $directory.id
.EXAMPLE
  Set-aldirectory -websession $websession -adpassword "MYPASSWORD" -id $directory.id -name "MYNEWNAME"
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
[OutputType([System.boolean])]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$id,
[Parameter(Mandatory=$false)][string]$name,
[Parameter(Mandatory=$false)][string]$serveraddress,
[Parameter(Mandatory=$false)][string]$port,
[Parameter(Mandatory=$false)][ValidateSet("Disable", "Enable")][string]$usessl,
[Parameter(Mandatory=$false)][string]$username,
[Parameter(Mandatory=$true)][string]$adpassword,
[Parameter(Mandatory=$false)][switch]$force
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {

Write-Verbose "Getting Directory Junction $id"
$existingdir = get-aldirectorydetail -websession $websession -id $id

#Check for existing params
if([string]::IsNullOrWhiteSpace($ServerAddress))
{
  Write-Verbose "Using existing host value"
  $ServerAddress=$existingdir.Host
}


if([string]::IsNullOrWhiteSpace($username))
{
  write-verbose "Using existing username value"
  $username=$existingdir.UserName
}

if([string]::IsNullOrWhiteSpace($name))
{
  write-verbose "Using existing name value"
  $name=$existingdir.Name
}

#for checking SSL on or off
$sslflag = $false

#sets port if not set in parms
if($usessl -eq "Enable")
{
  Write-Verbose "Enabling SSL"
  $sslflag = $true
  if([string]::IsNullOrWhiteSpace($port))
  {
    Write-Verbose "Port set to 636"
    $port=636
  }

}
elseif ($usessl -eq "Disable") {
  Write-Verbose "Disabling SSL"
  if([string]::IsNullOrWhiteSpace($port))
  {
    Write-Verbose "Port set to 389"
    $port=389
  }
}
elseif ([string]::IsNullOrWhiteSpace($usessl)) {

  if ([string]::IsNullOrWhiteSpace($port))
  {
    $port = $existingdir.Port
  }

  if($existingdir.IsSsl -eq "true")
  {
    $sslflag = $true
  }
  else {
    $sslflag = $false
  }

  
}


if($usessl -eq "Enable" -or $sslflag)
{


  if($force)
  {
    Write-Verbose "Skipping Tests"
  }
  else {
    
    #Test Directory
    if(!(test-aldirectory -websession $websession -serveraddress $serveraddress -usessl:$sslflag -port $port))
    {
      throw "Can't connect to AD server. Use -force to skip tests"
    }
    
    if(!(test-aldirectoryauth -websession $websession -serveraddress $serveraddress -usessl:$sslflag -port $port -username $username -adpassword $adpassword))
    {
      throw "Can't authenticate to AD server. Use -force to skip tests"
    }
    
    
  }



Write-Verbose "Using SSL"
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <EditDirectoryJunction xmlns="http://www.unidesk.com/">
      <command>
        <ServerAddress>$serveraddress</ServerAddress>
        <ServerPort>$port</ServerPort>
        <UserName>$username</UserName>
        <Password>$adpassword</Password>
        <UseSsl>true</UseSsl>
        <AllowableCertificateErrors>
          <CertificateError>CnNoMatch</CertificateError>
          <CertificateError>Chaining</CertificateError>
        </AllowableCertificateErrors>
        <Id>$id</Id>
        <Name>$name</Name>
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
    </EditDirectoryJunction>
  </s:Body>
</s:Envelope>
"@
}
else {

  if($force)
  {
    Write-Verbose "Skipping Tests"
  }
  else {
    
    #Test Directory
    if(!(test-aldirectory -websession $websession -serveraddress $serveraddress -usessl:$sslflag -port $port))
    {
      throw "Can't connect to AD server. Use -force to skip tests"
    }
    
    if(!(test-aldirectoryauth -websession $websession -serveraddress $serveraddress -usessl:$sslflag -port $port -username $username -adpassword $adpassword))
    {
      throw "Can't authenticate to AD server. Use -force to skip tests"
    }
    
  }

Write-Verbose "NO SSL"

#sets port if not set in parms
if([string]::IsNullOrWhiteSpace($port))
{
  write-verbose "Using existing port value"
  $port=$existingdir.Port
}

[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <EditDirectoryJunction xmlns="http://www.unidesk.com/">
      <command>
        <ServerAddress>$serveraddress</ServerAddress>
        <ServerPort>$port</ServerPort>
        <UserName>$username</UserName>
        <Password>$adpassword</Password>
        <UseSsl>false</UseSsl>
        <AllowableCertificateErrors/>
        <Id>$id</Id>
        <Name>$name</Name>
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
    </EditDirectoryJunction>
  </s:Body>
</s:Envelope>
"@
}
$headers = @{
SOAPAction = "http://www.unidesk.com/EditDirectoryJunction";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"

if ($PSCmdlet.ShouldProcess("Sets directory junction config for $name")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content

  #error found
  if($obj.Envelope.Body.EditDirectoryJunctionResponse.EditDirectoryJunctionResult.Error)
  {
    throw $obj.Envelope.Body.EditDirectoryJunctionResponse.EditDirectoryJunctionResult.Error.message
  }

  Write-verbose "Junction edit successful!"
  return $true
  }
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}