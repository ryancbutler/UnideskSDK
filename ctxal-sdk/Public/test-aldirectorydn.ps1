function test-aldirectorydn
{
<#
.SYNOPSIS
  Test Directory Junction DN path
.DESCRIPTION
  Test Directory Junction DN path
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
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
.EXAMPLE
  test-aldirectorydn -websession $websession -serveraddress "mydc.domain.com" -Verbose -username "admin@domain.com" -adpassword "MYPASSWORD" -basedn DC=domain,DC=com
.EXAMPLE
  test-aldirectorydn -websession $websession -serveraddress "mydc.domain.com" -Verbose -usessl -username "admin@domain.com" -adpassword "MYPASSWORD" -basedn DC=domain,DC=com
#>
[cmdletbinding()]
[OutputType([System.boolean])]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$serveraddress,
[Parameter(Mandatory=$false)][string]$port,
[Parameter(Mandatory=$false)][switch]$usessl,
[Parameter(Mandatory=$true)][string]$username,
[Parameter(Mandatory=$true)][string]$adpassword,
[Parameter(Mandatory=$true)][string]$basedn
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

Write-Verbose "Using SSL"
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <TestDirectoryJunction xmlns="http://www.unidesk.com/">
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
        <RequestedAction>ConnectBindAndQuery</RequestedAction>
      </command>
    </TestDirectoryJunction>
  </s:Body>
</s:Envelope>
"@
}
else {
Write-Verbose "NO SSL"

#sets port if not set in parms
if([string]::IsNullOrWhiteSpace($port))
{
  Write-Verbose "Port set to 389"
  $port=389
}
else {
  Write-Verbose "Using port $port"
}

[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <TestDirectoryJunction xmlns="http://www.unidesk.com/">
      <command>
        <ServerAddress>$serveraddress</ServerAddress>
        <ServerPort>$port</ServerPort>
        <BaseDN>$basedn</BaseDN>
        <UserName>$username</UserName>
        <Password>$adpassword</Password>
        <UseSsl>false</UseSsl>
        <AllowableCertificateErrors/>
        <RequestedAction>ConnectBindAndQuery</RequestedAction>
      </command>
    </TestDirectoryJunction>
  </s:Body>
</s:Envelope>
"@
}
$headers = @{
SOAPAction = "http://www.unidesk.com/TestDirectoryJunction";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

if($obj.Envelope.Body.TestDirectoryJunctionResponse.TestDirectoryJunctionResult.Error)
{
  write-warning $obj.Envelope.Body.TestDirectoryJunctionResponse.TestDirectoryJunctionResult.Error.Message
  write-warning $obj.Envelope.Body.TestDirectoryJunctionResponse.TestDirectoryJunctionResult.Error.Details
  return $false
}
  Write-Verbose "AD DN OK!"
  return $true
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}