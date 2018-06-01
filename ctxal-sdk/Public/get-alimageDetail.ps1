function Get-ALimageDetail
{
<#
.SYNOPSIS
  Gets additional image(template) detail
.DESCRIPTION
  Gets additional image(template) detail
.PARAMETER websession
  Existing Webrequest session for CAL Appliance
.PARAMETER id
  Image(template) id
.EXAMPLE
  get-alimagedetail -websession $websession -id $image.id
#>
[cmdletbinding()]
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
    <QueryImageDetail xmlns="http://www.unidesk.com/">
      <query>
        <ImageIds>
          <long>$id</long>
        </ImageIds>
      </query>
    </QueryImageDetail>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/QueryImageDetail";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content


if($obj.Envelope.Body.QueryImageDetailResponse.QueryImageDetailResult.Error)
  {
    throw $obj.Envelope.Body.QueryImageDetailResponse.QueryImageDetailResult.Error.message
  }
  else {
    return $obj.Envelope.Body.QueryImageDetailResponse.QueryImageDetailResult.Images.ImageDetail
  }
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
