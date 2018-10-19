function Remove-ALAppassignment
{
<#
.SYNOPSIS
  Removes a layer(application) assignment to image(template)
.DESCRIPTION
  Removes a layer(application) assignment to image(template)
.PARAMETER websession
  Existing Webrequest session for ELM  Appliance
.PARAMETER apprevid
  Application layer version to be removed
.PARAMETER imageid
  Image or template where application should be removed
.EXAMPLE
  $image = Get-ALimage -websession $websession|where{$_.name -eq "Accounting}
  $app = Get-ALapplayer -websession $websession|where{$_.name -eq "Libre Office"}
  $apprevs = get-alapplayer -websession $websession -id $app.Id
  $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  remove-alappassignment -websession $websession -applayerid $apprevid.LayerId -imageid $image.id
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][string]$applayerid,
[Parameter(Mandatory=$true)][string]$imageid
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <RemoveAppLayerAssignment xmlns="http://www.unidesk.com/">
      <command>
        <AdEntityIds/>
        <LayeredImageIds>
          <long>$imageid</long>
        </LayeredImageIds>
        <AppLayerId>$applayerid</AppLayerId>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </RemoveAppLayerAssignment>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/RemoveAppLayerAssignment";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}

$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"

if ($PSCmdlet.ShouldProcess("Removing $applayerid from $imageid")) {
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content
}
}



end{
  if ($PSCmdlet.ShouldProcess("Return object")) {
    return $obj
  }
    Write-Verbose "END: $($MyInvocation.MyCommand)"
}

}

