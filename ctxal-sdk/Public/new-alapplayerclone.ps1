function New-AlApplayerClone {
  <#
.SYNOPSIS
  Clones a Layer
.DESCRIPTION
  Clones a Layer
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER apprevid
  Application revision version id to clone from
.PARAMETER description
  Description of the cloned layer
.PARAMETER name
  Name of the cloned layer
.PARAMETER targetrevversion
  Versionname of the cloned layer revision
.PARAMETER targetrevdescription
  Description for the cloned layer revision
.PARAMETER iconid
  Icon ID
.EXAMPLE
  $layer = Get-ALapplayer -websession $websession | Where-Object {$_.name -like "S2016_APP_JAVA"}
  $apprevs = Get-ALapplayerDetail -websession $websession -id $layer.id
  $apprevid = $apprevs.Revisions.AppLayerRevisionDetail | Sort-Object id | Select-Object -Last 1
  $targetrevversion = $apprevid.DisplayedVersion
  $targetrevdescription = "Cloned revision $($targetrevversion)"
  $name = "$($Layer.name)_Copy"
  $description = $($Layer.name)
  $Iconid = $(Get-ALicon -websession $websession | Where-Object {$(Get-ALiconassoc -iconid $_.iconid -websession $websession -ea 0) | Where-Object {$_.id -match $layer.id}  }).Iconid
#>  
  [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)]$apprevid,
    [Parameter(Mandatory = $true)][string]$name,
    [Parameter(Mandatory = $false)][string]$description = "",
    [Parameter(Mandatory = $false)][string]$iconid = "196608",
    [Parameter(Mandatory = $true)][string]$targetrevversion,
    [Parameter(Mandatory = $false)][string]$targetrevdescription = "Cloned Revision"
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {
    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <CloneLayer xmlns="http://www.unidesk.com/">
      <command>
        <SourceLayerRevisionId>$apprevid</SourceLayerRevisionId>
        <TargetLayerInfo>
          <Name>$name</Name>
          <Description>$description</Description>
          <IconId>$Iconid</IconId>    
        </TargetLayerInfo>
        <TargetRevisionInfo>
          <Name>$targetrevversion</Name>
          <Description>$targetrevdescription</Description>
          <LayerSizeMiB>0</LayerSizeMiB>
        </TargetRevisionInfo>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>  
      </command>
    </CloneLayer>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    $headers = @{
      SOAPAction     = "http://www.unidesk.com/CloneLayer";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    if ($PSCmdlet.ShouldProcess("Creating Clone of $apprevid")) 
    {
      $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
      [xml]$obj = $return.Content

      if ($obj.Envelope.Body.CloneLayerResponse.CloneLayerResult.Error) {
        throw $obj.Envelope.Body.CloneLayerResponse.CloneLayerResult.Error.message
      }
      else {
        Write-Verbose "WORKTICKET: $($obj.Envelope.Body.CloneLayerResponse.CloneLayerResult.WorkTicketId)"
        return $obj.Envelope.Body.CloneLayerResponse.CloneLayerResult
      }
      
      }
    }

  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}
