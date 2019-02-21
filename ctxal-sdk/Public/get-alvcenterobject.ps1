function Get-VcenterObject {
<#
.SYNOPSIS
  Gets Vcenter Connector datacenters
.DESCRIPTION
  Gets Vcenter Connector datacenters
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER configid
  Connector ID
.PARAMETER vcenter
  vCenter Hostname
.PARAMETER username
  Username to authenticate to vcenter
.EXAMPLE
  Get-VcenterObjectDataCenter -websession $websession -configid $vcenter.pccId -username $vcenter.pccConfig.userName -vcenter $vcenter.pccConfig.vCenterServer -Verbose
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$false)][string]$configid,
[Parameter(Mandatory=$true)][string]$vcenter,
[Parameter(Mandatory=$false)][string]$vcenterpass,
[Parameter(Mandatory=$true)][string]$username,
[Parameter(Mandatory=$true)][ValidateSet("Datacenter","Host","Datastore","Network","VMTemplate","VMFolder")][string]$type,
[Parameter(Mandatory=$false)][string]$dc,
[Parameter(Mandatory=$false)][string]$vmfolder
)
Begin {Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"

  if([string]::IsNullOrWhiteSpace($configid) -and [string]::IsNullOrWhiteSpace($vcenterpass))
  {
      throw "If CONFIGID is not used a password must be set"
  }

#Case sensitive for JSON
switch ($type) {
  "datacenter" { $typemod = "Datacenter" }
  "host" { $typemod = "HostSystem"}
  "datastore" { $typemod = "Datastore"}
  "network" { $typemod = "Network"}
  "vmtemplate" {$typemod = "VirtualMachine"}
  "vmfolder" {$typemod = "Folder"}
}

}

Process{

#do the request
$headers = @{
  "Cookie" = ("UMCSessionCoookie=" + $($websession.token))
  "Accept" = "*/*"
  "Content-Type" = "application/json" 
}

if ($typemod -eq "Datacenter")
{
  Write-Verbose "Building Datacenter Body"
  $body = [PSCustomObject]@{
    'configId' = $configid
    'properties' = (
      'name',
      'vmFolder'
    )
    'recursive' = $True
    'type' = 'Datacenter'
    'userName' = $username
    'vCenterServer' = $vcenter
  }

}
elseif($typemod -eq "VirtualMachine")
{
  Write-Verbose "Building VirtualMachine Body"
  $body = [PSCustomObject]@{
    'configId' = $configid
    'vCenterServer' = $vcenter
    'userName' = $username
    'root' = [PSCustomObject]@{
      'attributes' = [PSCustomObject]@{
                      'type' = 'Folder'
                      "xsi:type"= "ManagedObjectReference"
                    }
      '$value' = $vmfolder
    }
    'type' = $typemod
    'properties' = @(
      'name',
      'parent',
      'datastore',
      'network',
      'runtime',
      'config')
    'recursive' = $True
  }
}
elseif($typemod -eq "Folder")
{
  Write-Verbose "Building Folder Body"
  $body = [PSCustomObject]@{
    'configId' = $configid
    'vCenterServer' = $vcenter
    'userName' = $username
    'root' = [PSCustomObject]@{
      'attributes' = [PSCustomObject]@{
                      'type' = 'Folder'
                      "xsi:type"= "ManagedObjectReference"
                    }
      '$value' = $vmfolder
    }
    'type' = $typemod
    'properties' = @('name')
    'recursive' = $True 
  }

}
else {
  Write-Verbose "Building $type Body"
  if([string]::IsNullOrWhiteSpace($dc))
  {
      throw "DC Parameter required"
  }

  $body = [PSCustomObject]@{
    'configId' = $configid
    'vCenterServer' = $vcenter
    'userName' = $username
    'root' = [PSCustomObject]@{
      'attributes' = [PSCustomObject]@{'type' = 'Datacenter'}
      '$value' = $dc
    }
    'type' = $typemod
    'properties' = @('name')
    'recursive' = $True
    
  }
  
}

#If password is used to authenticate against vcenter
if($vcenterpass)
{
  $body.configId = ""
  $body|Add-Member -NotePropertyName "password" -NotePropertyValue $vcenterpass
}

try
{
  $content = Invoke-RestMethod -Method POST -Uri "https://$($websession.aplip):3504/api/VmwareManagedObjects/findByType" -Headers $headers -Body ($body|ConvertTo-Json -Depth 100)
} catch {
    $temp = $_.ErrorDetails.Message|ConvertFrom-Json
    Write-error $temp.error.message
    Write-error $temp.error.sqlmessage
    write-error $temp.error.staus
    throw "Process failed!"
} finally {
   
}

$final = @()
if($typemod -eq "VirtualMachine")
{
  foreach ($return in $content.results)
  {
    $temp  = [pscustomobject]@{
    "Type" = "VirtualMachine"
    "Value" = $return.mobRef.'$value'
    "Name" = $return.name
    }
    $final += $temp
  }
}
else {

  foreach ($return in $content.results)
  {
    $temp  = [pscustomobject]@{
    "Type" = $return.mobRef.attributes.type
    "Value" = $return.mobRef.'$value'
    "Name" = $return.name
    }
    
    if($typemod -eq "Datacenter")
    {
    $temp|Add-Member -NotePropertyName "vmFolder" -NotePropertyValue $return.vmFolder.'$value'
    }
    $final += $temp
  }

}
  
return $final

}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}

}
