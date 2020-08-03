function Connect-ALsession {
  <#
.SYNOPSIS
  Connects to the Citrix Application Layering appliance and creates a web request session
.DESCRIPTION
  Connects to the Citrix Application Layering appliance and creates a web request session
.PARAMETER credential
  PowerShell credential object
.EXAMPLE
  $websession = Connect-alsession -aplip $aplip -Credential $Credential -Verbose
#>
  [cmdletbinding()]
  Param(
    [parameter(Mandatory = $true)][pscredential]$Credential,
    [Parameter(Mandatory = $true)][string]$aplip
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  }
  Process {
    #https://stackoverflow.com/questions/41897114/unexpected-error-occurred-running-a-simple-unauthorized-rest-query
    $code = @"
public class SSLHandler
{
    public static System.Net.Security.RemoteCertificateValidationCallback GetSSLHandler()
    {
        return new System.Net.Security.RemoteCertificateValidationCallback((sender, certificate, chain, policyErrors) => { return true; });
    }
}
"@
    #compile the class
    try {
      if ([SSLHandler]) {
        Write-Verbose "SSLHandler already loaded"
      }
    }
    catch {
      Write-Verbose "SSLHandler loading"
      Add-Type -TypeDefinition $code
    }


    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    #[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = [SSLHandler]::GetSSLHandler()
    $username = $Credential.UserName
    # Needed for escaping characters &,<,>,", and '
    $pass = [System.Security.SecurityElement]::Escape($Credential.GetNetworkCredential().Password)

    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <Login xmlns="http://www.unidesk.com/">
      <command>
        <UserName>$username</UserName>
        <Password>$pass</Password>
        <Culture>en-US</Culture>
        <RememberMe>false</RememberMe>
      </command>
    </Login>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    $headers = @{"SOAPAction" = "http://www.unidesk.com/Login" }
    $url = "https://" + $aplip + "/Unidesk.Web/API.asmx"
    $login = Invoke-WebRequest -Uri $url -Method Post -Body $xml -ContentType "text/xml" -SessionVariable websession -Headers $headers
    [xml]$mylogin = $login.Content

    if ($mylogin.Envelope.Body.LoginResponse.LoginResult.Error) {
      throw $mylogin.Envelope.Body.LoginResponse.LoginResult.Error.message
    }
    else {
      $websession | add-member -NotePropertyName 'token' -NotePropertyValue $mylogin.Envelope.body.LoginResponse.LoginResult.Token
      $websession | Add-Member -NotePropertyName 'aplip' -NotePropertyValue $aplip
      Write-Verbose "TOKEN: $($mylogin.Envelope.body.LoginResponse.LoginResult.Token)"
      Write-Verbose "IP $aplip"
      return $websession
    }


  }
  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
