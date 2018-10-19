function Stop-ALWorkTicket
{
<#
.SYNOPSIS
  Stops or cancels a running layer operation process
.DESCRIPTION
  Stops or cancels a running layer operation process
.PARAMETER websession
  Existing Webrequest session for ELM  Appliance
.EXAMPLE
  Stop-ALWorkTicket -websession $websession
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
    <CancelWorkTickets xmlns="http://www.unidesk.com/">
      <command>
        <WorkTicketIds>
          <long>$id</long>
        </WorkTicketIds>
        <Force>false</Force>
      </command>
    </CancelWorkTickets>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/CancelWorkTickets";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Remove Work ID $id")) 
{
    Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession|Out-Null
}
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
