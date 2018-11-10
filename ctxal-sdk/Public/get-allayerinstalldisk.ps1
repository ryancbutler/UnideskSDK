function Get-ALLayerInstallDisk
{
<#
.SYNOPSIS
  Gets install disk location during finalize process
.DESCRIPTION
  Gets install disk location during finalize process
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER id
  Layer ID to be located
.EXAMPLE
  get-allayerinstalldisk -websession $websession -layerid $apprevid.LayerId
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$id

)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryLayerInstallDisk xmlns="http://www.unidesk.com/">
      <query>
        <LayerId>$id</LayerId>
      </query>
    </QueryLayerInstallDisk>
  </s:Body>
</s:Envelope>
"@
$headers = @{
    SOAPAction = "http://www.unidesk.com/QueryLayerInstallDisk";
    "Content-Type" = "text/xml; charset=utf-8";
    UNIDESK_TOKEN = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
    [xml]$obj = $return.Content
       
    if($obj.Envelope.Body.QueryLayerInstallDiskResponse.QueryLayerInstallDiskResult.Error)
    {
      throw $obj.Envelope.Body.QueryLayerInstallDiskResponse.QueryLayerInstallDiskResult.Error.message
    }
    else {
      return $obj.Envelope.Body.QueryLayerInstallDiskResponse.QueryLayerInstallDiskResult
    }

}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}