function remove-ALDirectory
{
<#
.SYNOPSIS
  Removes Directory Junction
.DESCRIPTION
  Removes Directory Junction
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER ID
  Directory Junction ID
.EXAMPLE
  Remove-ALDirectory -websession $websession -id "4915204"
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
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
    <DeleteDirectoryJunction xmlns="http://www.unidesk.com/">
      <command>
        <Ids>
          <long>$id</long>
        </Ids>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </DeleteDirectoryJunction>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/DeleteDirectoryJunction";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Removing Directory Junction $id")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content
  
  if($obj.Envelope.Body.DeleteDirectoryJunctionResponse.DeleteDirectoryJunctionResult.WorkTicketId -eq "0")
    {
      throw "Problem deleting AD junction.  Check ID and try again."
    }
    else {
      return $obj.Envelope.Body.DeleteDirectoryJunctionResponse.DeleteDirectoryJunctionResult.WorkTicketId
    }
}

}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
