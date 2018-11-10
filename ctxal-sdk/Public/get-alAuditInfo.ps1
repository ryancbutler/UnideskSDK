function Get-ALAuditInfo
{
<#
.SYNOPSIS
  Gets audit information
.DESCRIPTION
  Gets System Settings
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER entitytype
  Type of log to pull
.PARAMETER ID
  ID of entity to pull audit logs
.EXAMPLE
  Get-ALAuditInfo -websession $websession -entitytype OsLayer -id 753664
.EXAMPLE
  Get-ALAuditInfo -websession $websession -entitytype ManagementAppliance
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][ValidateSet("OsLayer","PlatformLayer","AppLayer","Image","ManagementAppliance")][string]$entitytype,
[Parameter(Mandatory=$false)][string]$id
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
  if ($entitytype -eq "ManagementAppliance")
  {
    $id = "32768" #appliance ID
  }

  if([string]::IsNullOrWhiteSpace($id))
  {
    throw "Entity ID for $entitytype audit log required"
  }

}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryAuditLog xmlns="http://www.unidesk.com/">
      <query>
        <Start>0</Start>
        <PageSize>250</PageSize>
        <SortBy>DateLastModified</SortBy>
        <QueryTotalCount>true</QueryTotalCount>
        <EntityType>$entitytype</EntityType>
        <EntityId>$id</EntityId>
      </query>
    </QueryAuditLog>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryAuditLog";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

if($obj.Envelope.Body.QueryAuditLogResponse.QueryAuditLogResult.Error)
  {
    throw $obj.Envelope.Body.QueryAuditLogResponse.QueryAuditLogResult.Error.message
  }
  else {
    return $obj.Envelope.Body.QueryAuditLogResponse.QueryAuditLogResult.items
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}