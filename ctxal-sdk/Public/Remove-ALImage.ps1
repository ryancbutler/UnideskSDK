function Remove-ALImage
{
<#
.SYNOPSIS
  Removes image(template)
.DESCRIPTION
  Removes image(template)
.PARAMETER websession
  Existing Webrequest session for ELM  Appliance
.PARAMETER id
  ID of image to remove
.EXAMPLE
  $image = Get-ALimage -websession $websession|where{$_.name -eq "Windows 10 Accounting"}
  Remove-ALImage -websession $websession -imageid $image.id
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$id
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <DeleteImage xmlns="http://www.unidesk.com/">
      <command>
        <Ids>
          <long>$id</long>
        </Ids>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </DeleteImage>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/DeleteImage";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
  if ($PSCmdlet.ShouldProcess("Deleting image $imageid")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content


  if($obj.Envelope.Body.DeleteImageResponse.DeleteImageResult.Error)
  {
    throw $obj.Envelope.Body.DeleteImageResponse.DeleteImageResult.Error.ExceptionMessage

  }
  else {
    return $obj.Envelope.Body.DeleteImageResponse.DeleteImageResult
  }
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}