function Get-ALDirectory
{
<#
.SYNOPSIS
  Gets Directory Junctions
.DESCRIPTION
  Gets Directory Junctions
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  Get-ALDirectory -websession $websession
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"  
  Test-ALWebsession -WebSession $websession
  }
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryDirectoryJunctionFolders xmlns="http://www.unidesk.com/">
      <query/>
    </QueryDirectoryJunctionFolders>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryDirectoryJunctionFolders";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}

$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

#return $obj
if($obj.Envelope.Body.QueryDirectoryJunctionFoldersResponse.QueryDirectoryJunctionFoldersResult.Error)
    {
      throw $obj.Envelope.Body.QueryDirectoryJunctionFoldersResponse.QueryDirectoryJunctionFoldersResult.Error.message
    }
    else {
      return $obj.Envelope.Body.QueryDirectoryJunctionFoldersResponse.QueryDirectoryJunctionFoldersResult.DirectoryJunctions.FolderSummary
    }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
