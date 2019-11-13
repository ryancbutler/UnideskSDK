function Get-ALDirectoryDetail {
  <#
.SYNOPSIS
  Gets additional directory junction detail
.DESCRIPTION
  Gets additional directory junction detail
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER id
  Directory Junction id
.EXAMPLE
  get-aldirectorydetail -websession $websession -id $directory.id
#>
  [cmdletbinding()]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)][string]$id
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {
    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <QueryDirectoryJunctionDetails xmlns="http://www.unidesk.com/">
      <query>
        <Ids>
          <long>$id</long>
        </Ids>
      </query>
    </QueryDirectoryJunctionDetails>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/QueryDirectoryJunctionDetails";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
    [xml]$obj = $return.Content

    return $obj.Envelope.Body.QueryDirectoryJunctionDetailsResponse.QueryDirectoryJunctionDetailsResult.Details.DirectoryJunctionDetails

  }
  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
