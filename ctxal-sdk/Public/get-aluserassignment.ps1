function Get-ALUserAssignment {
  <#
.SYNOPSIS
  Gets user app layer assignments
.DESCRIPTION
  Gets user app layer assignments
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER id
  Unidesk ID of user
.EXAMPLE
  Get-ALUserAssignments -websession $websession -id "4521984" -Verbose
#>
  [cmdletbinding()]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)][string[]]$id
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
    $idsxml = $null 
  }
  Process {

    Write-Verbose "Building Group IDs"
    foreach ($groupid in $id) {
      $idsxml += @"
<long>$groupid</long>
"@
    }
    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryDirectoryItemAppAssignments xmlns="http://www.unidesk.com/">
      <query>
        <DirectoryItemIds>
        $idsxml 
        </DirectoryItemIds>
      </query>
    </QueryDirectoryItemAppAssignments>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/QueryDirectoryItemAppAssignments";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
    [xml]$obj = $return.Content

    if ($obj.Envelope.Body.QueryDirectoryItemAppAssignmentsResponse.QueryDirectoryItemAppAssignmentsResult.Error) {
      throw $obj.Envelope.Body.QueryDirectoryItemAppAssignmentsResponse.QueryDirectoryItemAppAssignmentsResult.Error.message
    }
    else {
      return $obj.Envelope.Body.QueryDirectoryItemAppAssignmentsResponse.QueryDirectoryItemAppAssignmentsResult.Assignments.DirectoryItemAppAssignment
    }

  }
  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
