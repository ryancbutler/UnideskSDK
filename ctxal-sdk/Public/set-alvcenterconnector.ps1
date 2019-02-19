function Set-alVcenterConnector {
<#
.SYNOPSIS
  Sets Vcenter Connector configuration
.DESCRIPTION
  Sets Vcenter Connector configuration
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER config
  Connector Config
.PARAMETER force
  Skip Verify
.EXAMPLE
  Set-VcenterConnector -websession $websession -config $connectorconfig
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$config,
[switch]$force

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

$configjson = $config|ConvertTo-Json -Depth 20
if($force)
{
  Write-Verbose "Skipping Connector Data Validation"
}
else
{
  Write-Verbose "Verifying Connector Data"
  try
  {
    Invoke-RestMethod -Method Post -Uri "https://$($websession.aplip):3504/api/Configurations/verify" -Headers $headers -Body $configjson|Out-Null
  } catch {
    $responseerror = $_.ErrorDetails.Message|ConvertFrom-Json
    throw ("$($responseerror.error.message)")
  }
  Write-Verbose "Validation Successful"
}

try
{
  Write-Verbose "Setting Connector Data"
  Invoke-RestMethod -Method Put -Uri "https://$($websession.aplip):3504/api/Configurations/$($config.pccid)" -Headers $headers -Body $configjson|Out-Null
} catch {
  $responseerror = $_.ErrorDetails.Message|ConvertFrom-Json
  throw ("$($responseerror.error.message)")
} 

}

end{
  [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
  Write-Verbose "END: $($MyInvocation.MyCommand)"}

}
