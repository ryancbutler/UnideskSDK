function Import-ALOsLayer
{
<#
.SYNOPSIS
  Creates a new operating system layer
.DESCRIPTION
  Creates a new operating system layer
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.PARAMETER vmname
  Virtual machine name to import from
.PARAMETER description
  Description of the layer
.PARAMETER connectorid
  ID of Connector to use
.PARAMETER icon
  Icon ID (default 196608)
.PARAMETER name
  Name of the layer
.PARAMETER shareid
  ID of file share
.PARAMETER size
  Size of layer in GB (default 61440)
.PARAMETER version
  Version number of the layer
.PARAMETER vmid
  Virtual Machine ID from vCenter or GUID XenCenter
.PARAMETER hypervisor
  Hypversior to import from (ESXI or XenServer)
.EXAMPLE
  $fileshare = Get-ALRemoteshare -websession $websession
  $connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYvCenter"}
  $shares = get-alremoteshare -websession $websession
  #vCenter Command
  $vm = Get-VM "Windows2016VM"
  $vmid = $vm.Id -replace "VirtualMachine-",""
  $response = import-aloslayer -websession $websession -vmname $vm.name -connectorid $connector.id -shareid $fileshare.id -name "Windows 2016" -version "1.0" -vmid $vmid -hypervisor esxi
.EXAMPLE
  $fileshare = Get-ALRemoteshare -websession $websession
  $connector = Get-ALconnector -websession $websession -type Create|where{$_.name -eq "MYXenCenter"}
  $shares = get-alremoteshare -websession $websession
  #Xen Command
  $XenVM = get-xenvm -name $VMName
  $response = import-aloslayer -websession $websession -vmname $vmname -connectorid $connector.id -shareid $fileshare.id -name "Windows 2016" -version "1.0" -vmid $XenVM.uuid -hypervisor xenserver
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$vmname,
[Parameter(Mandatory=$false)]$description="",
[Parameter(Mandatory=$true)]$connectorid,
[Parameter(Mandatory=$true)]$shareid,
[Parameter(Mandatory=$false)]$icon="196608",
[Parameter(Mandatory=$true)]$name,
[Parameter(Mandatory=$false)]$size="61440",
[Parameter(Mandatory=$true)]$version,
[Parameter(Mandatory=$true)]$vmid,
[Parameter(Mandatory=$true)][ValidateSet('esxi','xenserver')][string[]]$hypervisor
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {

switch ($hypervisor)
{
"esxi" {
$platformdata =  @"
<PlatformData>{"VmId":{"attributes":{"type":"VirtualMachine"},"`$value":"$vmid"},"VmName":"$vmname"}</PlatformData>
"@   
  }

"xenserver" {
$platformdata = @"
<PlatformData>{"vmUuid":"$vmid","vmName":"$vmname","osImport":true}</PlatformData>
"@ 
}
}

[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <ImportOs xmlns="http://www.unidesk.com/">
      <command>
        <SelectedFileShare>$shareid</SelectedFileShare>
        <PlatformConnectorConfigId>$connectorid</PlatformConnectorConfigId>
        <PlatformAuditInfo>OS Machine Name: $vmname</PlatformAuditInfo>
        $platformdata
        <LayerInfo>
          <Name>$name</Name>
          <Description>$description</Description>
          <IconId>$icon</IconId>
        </LayerInfo>
        <RevisionInfo>
          <Name>$version</Name>
          <Description/>
          <LayerSizeMiB>$size</LayerSizeMiB>
        </RevisionInfo>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </ImportOs>
  </s:Body>
</s:Envelope>
"@

$headers = @{
SOAPAction = "http://www.unidesk.com/ImportOs";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Importing $vmname as $name")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content

  if($obj.Envelope.Body.ImportOsResponse.ImportOsResult.Error)
  {
    throw $obj.Envelope.Body.ImportOsResponse.ImportOsResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.ImportOsResponse.ImportOsResult.WorkTicketId)"
    return $obj.Envelope.Body.ImportOsResponse.ImportOsResult

  }
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
