function Get-ALiconassoc {
  <#
.SYNOPSIS
  Gets items associated with icon
.DESCRIPTION
  Gets items associated with icon
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER iconid
  Icon ID
.EXAMPLE
  Get-ALicon -websession $websession
#>
  [cmdletbinding()]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)][string]$iconid
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {
    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <GetItemsAssociatedWithIcon xmlns="http://www.unidesk.com/">
      <query>
        <IconId>$iconid</IconId>
      </query>
    </GetItemsAssociatedWithIcon>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/GetItemsAssociatedWithIcon";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
    [xml]$obj = $return.Content


    return $obj.Envelope.Body.GetItemsAssociatedWithIconResponse.GetItemsAssociatedWithIconResult.Items.ItemsAssociatedWithIconDto
  }


  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
