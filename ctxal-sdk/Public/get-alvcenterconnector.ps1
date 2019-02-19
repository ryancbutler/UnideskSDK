function Get-AlVcenterConnector {
<#
.SYNOPSIS
  Gets Vcenter Connector configuration
.DESCRIPTION
  Gets Vcenter Connector configuration
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  Get-AlVcenterConnector -websession $websession
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession
)
Begin {
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
Add-Type -TypeDefinition $code
}

Process{
#disable checks using new class
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = [SSLHandler]::GetSSLHandler()
#do the request
$headers = @{
  "Cookie" = ("UMCSessionCoookie=" + $($websession.token))
  "Accept" = "*/*"
  "Content-Type" = "application/json" 
}
try
{
    $content = Invoke-RestMethod -Method Get -Uri "https://$($websession.aplip):3504/api/Configurations/" -Headers $headers
} catch {
    # do something
} finally {
   #enable checks again
   [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
}

return $content
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}

}
