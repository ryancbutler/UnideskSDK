function Add-ALAppAssignment {
  <#
.SYNOPSIS
  Adds a layer(application) assignment to image(template)
.DESCRIPTION
  Adds a layer(application) assignment to image(template)
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER apprevid
  Application layer version to be added
.PARAMETER imageid
  Image or template where application should be added
.EXAMPLE
  $image = Get-ALimage -websession $websession|where{$_.name -eq "Accounting}
  $app = Get-ALapplayer -websession $websession|where{$_.name -eq "Libre Office"}
  $apprevs = get-alapplayerDetail -websession $websession -id $app.Id
  $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  add-alappassignment -websession $websession -apprevid $apprevid.id -imageid $image.id
#>
  [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)][string]$apprevid,
    [Parameter(Mandatory = $true)][string]$imageid
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {
    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <UpdateAppLayerAssignment xmlns="http://www.unidesk.com/">
      <command>
        <AdEntityIds/>
        <LayeredImageIds>
          <long>$imageid</long>
        </LayeredImageIds>
        <AppLayerRevId>$apprevid</AppLayerRevId>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </UpdateAppLayerAssignment>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/UpdateAppLayerAssignment";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }
    if ($PSCmdlet.ShouldProcess("Adding $apprevid to $imageid")) {
      $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
      $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
      [xml]$obj = $return.Content
    }
  }



  end {
    if ($PSCmdlet.ShouldProcess("Printing output for app add")) {
      if ($obj.Envelope.Body.UpdateAppLayerAssignmentResponse.UpdateAppLayerAssignmentResult.Error) {
        throw $obj.Envelope.Body.UpdateAppLayerAssignmentResponse.UpdateAppLayerAssignmentResult.Error.message

      }
      else {
        Write-Verbose "WORKTICKET: $($obj.Envelope.Body.UpdateAppLayerAssignmentResponse.UpdateAppLayerAssignmentResult.WorkTicketId)"
        return $obj.Envelope.Body.UpdateAppLayerAssignmentResponse.UpdateAppLayerAssignmentResult.WorkTicketId
      }
    }
    Write-Verbose "END: $($MyInvocation.MyCommand)"
  }

}