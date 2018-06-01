function Invoke-ALPublish
{
<#
.SYNOPSIS
  Publishes image(template)
.DESCRIPTION
  Publishes image(template)
.PARAMETER imageid
  Image ID to be published
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.EXAMPLE
  $images = Get-ALimage -websession $websession|where{$_.name -eq "Win 10 Accounting"}
  $image = get-alimagedetail -websession $websession -id $images.Id
  invoke-alpublish -websession $websession -imageid $images.id
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$imageid
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <ExportImage xmlns="http://www.unidesk.com/">
      <command>
        <ImageIds>
          <long>$imageid</long>
        </ImageIds>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </ExportImage>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/ExportImage";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Publishing $imageid")) { 
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content


  if($obj.Envelope.Body.ExportImageResponse.ExportImageResult.Error)
  {
    throw $obj.Envelope.Body.ExportImageResponse.ExportImageResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.ExportImageResponse.ExportImageResult.WorkTicketId)"
    return $obj.Envelope.Body.ExportImageResponse.ExportImageResult.WorkTicketId
  }
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
