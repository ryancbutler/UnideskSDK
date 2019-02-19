function Get-VcenterObjectNetwork {
<#
.SYNOPSIS
  Gets Vcenter Networks
.DESCRIPTION
  Gets Vcenter Networks
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER configid
  Connector ID
.PARAMETER vcenter
  vCenter Hostname
.PARAMETER username
  Username to authenticate to vcenter
.PARAMETER dc
  DC to query
.EXAMPLE
  Get-VcenterObjectDataCenter -websession $websession
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$configid,
[Parameter(Mandatory=$true)][string]$vcenter,
[Parameter(Mandatory=$true)][string]$username,
[Parameter(Mandatory=$true)][string]$dc

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
$username = $username.Replace("\","\\")
$body = @"
{
  "configId": "$configid",
  "vCenterServer": "$vcenter",
  "userName": "$username",
  "root": {
    "attributes": {
      "type": "Datacenter"
    },
    "`$value": "$dc"
  },
  "type": "Network",
  "properties": [
    "name"
  ],
  "recursive": true
}
"@

try
{
    $content = Invoke-RestMethod -Method POST -Uri "https://$($websession.aplip):3504/api/VmwareManagedObjects/findByType" -Headers $headers -Body $body
} catch {
    # do something
} finally {
   #enable checks again
   [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
}

return $content.results
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}

}
