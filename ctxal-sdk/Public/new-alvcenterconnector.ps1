function new-AlVcenterConnector {
<#
.SYNOPSIS
  Creates Vcenter Connector configuration
.DESCRIPTION
  Creates Vcenter Connector configuration
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  Get-AlVcenterConnector -websession $websession
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$name,
[Parameter(Mandatory=$true)]$dc,
[Parameter(Mandatory=$true)]$datastore,
[Parameter(Mandatory=$true)]$hostsystem,
[Parameter(Mandatory=$true)]$network,
[Parameter(Mandatory=$true)]$folder,
[Parameter(Mandatory=$true)]$connid,
[Parameter(Mandatory=$true)]$vcenterpass,
[Parameter(Mandatory=$true)]$username,
[Parameter(Mandatory=$true)]$vcenter,
[Parameter(Mandatory=$true)]$vmtemplate,
[Parameter(Mandatory=$false)]$cachesize="250"
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

$body = [PSCustomObject]@{
	'pccConfig' = [PSCustomObject]@{
		'dataCenterId' = [PSCustomObject]@{
			'$value' = $dc.value
			'attributes' = [PSCustomObject]@{'type' = 'Datacenter'}
		}
		'dataCenterName' = $dc.name
		'dataStoreId' = [PSCustomObject]@{
			'$value' = $datastore.value
			'attributes' = [PSCustomObject]@{'type' = 'Datastore'}
		}
		'dataStoreName' = $datastore.name
		'hostId' = [PSCustomObject]@{
			'$value' = $hostsystem.value
			'attributes' = [PSCustomObject]@{'type' = 'HostSystem'}
		}
		'hostName' = $hostsystem.Name
		'layerDiskCacheSize' = $cachesize
		'networkId' = [PSCustomObject]@{
			'$value' = $network.value
			'attributes' = [PSCustomObject]@{'type' = 'Network'}
		}
		'networkName' = $network.name
		'password' = $vcenterpass
		'userName' = $username
		'vCenterServer' = $vcenter
		'vmFolderId' = [PSCustomObject]@{
			'$value' = $folder.value
			'attributes' = [PSCustomObject]@{'type' = 'Folder'}
		}
		'vmFolderName' = $folder.name
		'vmTemplateId' = [PSCustomObject]@{
			'$value' = $vmtemplate.value
			'attributes' = [PSCustomObject]@{'type' = 'VirtualMachine'}
		}
		'vmTemplateName' = $vmtemplate.name
	}
	'pccName' = $name
	'pccPlatformConnectorId' = $connid
}

try
{
    $content = Invoke-RestMethod -Method POST -Uri "https://$($websession.aplip):3504/api/Configurations" -Headers $headers -Body ($body|ConvertTo-Json -Depth 100)
} catch {
    throw $_
} finally {
   #enable checks again
   [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
}

return $content
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}

}
