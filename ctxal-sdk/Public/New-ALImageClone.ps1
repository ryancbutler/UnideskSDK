function New-ALImageClone
{
<#
.SYNOPSIS
  Clones an Image
.DESCRIPTION
  Clones an Image
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER imageid
  id for the image to be cloned
.EXAMPLE
  $image = Get-ALimage -websession $websession | where {$_.name -eq "Windows 10 Accounting"}
  New-ALImageClone -websession $websession -imageid $image.Id -Confirm:$false -OutVariable ALImageClone
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
  <s:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <CloneImage xmlns="http://www.unidesk.com/">
      <command>
        <ImageIdToClone>$imageid</ImageIdToClone>
      </command>
    </CloneImage>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/CloneImage";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Clone Image $imageid")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content

  if($obj.Envelope.Body.CloneImageResponse.CloneImageResult.Error)
  {
    throw $obj.Envelope.Body.CloneImageResponse.CloneImageResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.CloneImageResponse.CloneImageResult.WorkTicketId)"
    return $obj.Envelope.Body.CloneImageResponse.CloneImageResult
  }
}

}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
