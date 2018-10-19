function Get-ALImageComp
{
<#
.SYNOPSIS
  Gets image composition details
.DESCRIPTION
  Gets image composition details
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER id
  Image(template) id
.PARAMETER name
  Image name (supports wildcard)
.EXAMPLE
  Gets all images and layer composition
  Get-ALImageComp -websession $websession
.EXAMPLE
  Gets image and layer composition based on ID
  Get-ALImageComp -websession $websession -id 5535
.EXAMPLE
  Gets image and layer composition based on name
  Get-ALImageComp -websession $websession -name "Windows 10"
.EXAMPLE
  Gets image and layer composition based on name (wildcard)
  Get-ALImageComp -websession $websession -name "*10*"
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$false)][string]$id,
[Parameter(Mandatory=$false)][string]$name
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
  
  #get images bases on params
  if( -not ([string]::IsNullOrWhiteSpace($name)) -and ([string]::IsNullOrWhiteSpace($id)))
  {
    $images = Get-ALimage -websession $websession|Where-Object{$_.name -like $name}
  }
  elseif([string]::IsNullOrWhiteSpace($name) -and (-not [string]::IsNullOrWhiteSpace($id)))
  {
    $images = Get-ALimage -websession $websession|Where-Object{$_.id -eq $id}
  }
  elseif((-not [string]::IsNullOrWhiteSpace($name)) -and (-not [string]::IsNullOrWhiteSpace($id)))
  {
    throw "Need to use either ID or Name.  Not both"
    return
  }
  else {
    $images = Get-ALimage -websession $websession
  }
}
Process {
  $returnimage = @()
  foreach ($image in $images)
    {
    $imagedetail =  Get-ALimagedetail -websession $websession -id $image.id
    
    #image detail
    $myimage = [PSCustomObject]@{
    Id = $image.id
    ImageId =  $image.Imageid
    Name = $image.Name
    Type = $image.Type
    Description = $imagedetail.Description
    DateCreated = $image.DateCreated
    DateLastModified = $image.DateLastModified 
    IsPublishable = $image.IsPublishable
    PlatformConnectorId = $image.PlatformConnectorId
    PlatformConnectorName = $image.PlatformConnectorName
    PlatformConnectorConfigId = $image.PlatformConnectorConfigId
    PlatformConnectorConfigName = $image.PlatformConnectorConfigName
    SysprepType = $imagedetail.SysprepType
    ElasticLayerMode = $imagedetail.ElasticLayerMode
    SizeMB = $imagedetail.LayeredImagePartitionSizeMiB
    }

    #Operating System
    $OS = [PSCustomObject]@{
    NAME = $imagedetail.OsRev.name
    ID = $imagedetail.OsRev.Revisions.RevisionResult.Id
    IMAGEID = $imagedetail.OSrev.ImageId
    VersionNAME = $imagedetail.OsRev.Revisions.RevisionResult.Name
    Description = $imagedetail.OsRev.Revisions.RevisionResult.Description
    Status = $imagedetail.OsRev.Revisions.RevisionResult.Status
    }
    $myimage | Add-Member -MemberType NoteProperty -Name OSLayer -Value $OS
    
    #Platform
    $PL = [PSCustomObject]@{
    NAME = $imagedetail.PlatformLayer.name
    ID = $imagedetail.PlatformLayer.Revisions.RevisionResult.Id
    IMAGEID = $imagedetail.PlatformLayer.ImageId
    VersionvNAME = $imagedetail.PlatformLayer.Revisions.RevisionResult.Name
    Description = $imagedetail.PlatformLayer.Revisions.RevisionResult.Description
    Status = $imagedetail.PlatformLayer.Revisions.RevisionResult.Status
    }
    $myimage | Add-Member -MemberType NoteProperty -Name PlatformLayer -Value $PL
    
    #apps
    $apps = @()
    foreach ($app in $imagedetail.AppLayers.ApplicationLayerResult)
    {
        $appobj = [PSCustomObject]@{
        NAME = $app.name
        ID = $app.Revisions.RevisionResult.Id
        ImageId = $app.ImageId
        Priority = $app.Priority
        VersionNAME = $app.Revisions.RevisionResult.Name
        Description = $app.Revisions.RevisionResult.Description
        Status = $app.Revisions.RevisionResult.Status
        }
        $apps += $appobj
        
    }
    $myimage | Add-Member -MemberType NoteProperty -Name AppLayer -Value $apps
    $returnimage += $myimage
  }
  
}
end{
  return $returnimage
  Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
