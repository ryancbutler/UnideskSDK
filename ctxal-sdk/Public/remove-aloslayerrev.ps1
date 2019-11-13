function Remove-ALOSLayerRev {
  <#
.SYNOPSIS
  Removes a OS layer version
.DESCRIPTION
  Removes a OS layer version
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER osid
  Base OS layer version id to use
.PARAMETER osrevid
  OS revision version id to use
.EXAMPLE
  $fileshare = Get-ALRemoteshare -websession $websession
  $osid = Get-ALOSlayer -websession $websession | where{$_.name -eq "Windows 10 x64"}
  $osrevid = Get-ALOSlayerDetail -websession $websession -id $osid.Id
  $osrevid = $osrevid.Revisions.OSLayerRevisionDetail | where{$_.candelete -eq $true} | Sort-Object revision -Descending | select -Last 1
  remove-aloslayerrev -websession $websession -osid $osid.Id -osrevid $osrevid.id -fileshareid $fileshare.id
#>  
  [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)]$osid,
    [Parameter(Mandatory = $true)]$osrevid,
    [Parameter(Mandatory = $true)]$fileshareid
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {
    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <DeleteOsLayerRevisions xmlns="http://www.unidesk.com/">
      <command>
        <LayerId>$osid</LayerId>
        <RevisionIds>
          <long>$osrevid</long>
        </RevisionIds>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
        <SelectedFileShare>$fileshareid</SelectedFileShare>
      </command>
    </DeleteOsLayerRevisions>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/DeleteOsLayerRevisions";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    if ($PSCmdlet.ShouldProcess("Removing $osrevid from $osid")) {
      $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
      [xml]$obj = $return.Content

      if ($obj.Envelope.Body.DeleteOsLayerRevisionsResponse.DeleteOsLayerRevisionsResult.Error) {
        throw $obj.Envelope.Body.DeleteOsLayerRevisionsResponse.DeleteOsLayerRevisionsResult.Error.message

      }
      else {
        Write-Verbose "WORKTICKET: $($obj.Envelope.Body.DeleteOsLayerRevisionsResponse.DeleteOsLayerRevisionsResult.WorkTicketId)"
        return $obj.Envelope.Body.DeleteOsLayerRevisionsResponse.DeleteOsLayerRevisionsResult
      }
    }

  }
  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
