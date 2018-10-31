function new-ALicon
{
<#
.SYNOPSIS
  Converts and uploads image file to be used as icon
.DESCRIPTION
  Converts and uploads image file to be used as icon
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER iconfile
  Icon filename
.EXAMPLE
  Upload-ALicon -websession $websession -iconfilename "d:\mysweeticon.png"
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(    
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$iconfile
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {

    if (test-path $iconfile)
    {
        Write-Verbose "$iconfile found!.  Converfting to BASE64"
        $base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($iconfile)) 
    }
    else {
        throw "File not found!. Pleae check filename and try again!"
    }

[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <CreateIcon xmlns="http://www.unidesk.com/">
      <command>
        <TheImage>$base64string</TheImage>
        <Reason>
          <Description>Custom icon uploaded.</Description>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </CreateIcon>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/CreateIcon";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"

if ($PSCmdlet.ShouldProcess("Will create new ICON from $iconfile")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content
  return $obj.Envelope.Body.CreateIconResponse.CreateIconResult.IconId
}

}

end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
