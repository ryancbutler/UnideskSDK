function new-AlVcenterConnector {
<#
.SYNOPSIS
  Creates vCenter Connector configuration
.DESCRIPTION
  Creates vCenter Connector configuration
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER name
  Name of the new connector
.PARAMETER dc
  vCenter Datacenter id
.PARAMETER datastore
  vCenter Datastore id
.PARAMETER hostsystem
  vCenter ESXI hostname id
.PARAMETER network
  vCenter network id
.PARAMETER folder
  vCenter folder id
.PARAMETER connid
  ELM platform connection id
.PARAMETER vcenterpass
  vCenter password to authenticate
.PARAMETER username
  vCenter username to authenticate
.PARAMETER vcenter
  vCenter hostname
.PARAMETER vmtemplate
  vCenter template id to use
.PARAMETER cachesize
  Cache size for connector (GB)
.EXAMPLE
  $Params = @{
  Name = "MyconnectorTest"
  DC = $dc
  DATASTORE = $datastore
  HOSTSYSTEM = $hostvar
  NETWORK = $network
  FOLDER = $folder
  CONNID = $type.Id
  VMTEMPLATE = $template
  CACHESIZE = "250"
  }

  new-AlVcenterConnector -websession $websession -username $usernamevc -vcenter $vcentername -vcenterpass $vcenterpassword @params
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
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
[Parameter(Mandatory=$false)]$vmtemplate,
[Parameter(Mandatory=$false)]$cachesize="250"
)
Begin {Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"}


Process{
#do the request
$headers = @{
  "Cookie" = ("UMCSessionCoookie=" + $($websession.token))
  "Accept" = "*/*"
  "Content-Type" = "application/json"
  "Host" = "$($websession.aplip):3504"
  "Referer" =  "https://$($websession.aplip):3504/ui/"
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

if ($PSCmdlet.ShouldProcess("Creating new vCenter Connector $name")) {
  try
  {
      $content = Invoke-RestMethod -Method POST -Uri "https://$($websession.aplip):3504/api/Configurations" -Headers $headers -Body ($body|ConvertTo-Json -Depth 100)
  } catch {

    if($_.ErrorDetails.Message)
    {

      $temp = $_.ErrorDetails.Message|ConvertFrom-Json
      if($temp.message)
      {
        Write-error $temp.message
      }
      else {
        Write-error $temp.error.message
        Write-error $temp.error.sqlmessage
        write-error $temp.error.staus
      }
      throw "Process failed!"
    }
    else {
      throw $_
    }
  } finally {
  }

  return $content
}
}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}

}
