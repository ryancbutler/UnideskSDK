function Remove-ALPlatformLayerRev
{
<#
.SYNOPSIS
  Removes a platform layer version
.DESCRIPTION
  Removes a platform layer version
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER platformid
  Base platform layer version id to use
.PARAMETER platformrevid
  Platform revision version id to use
.EXAMPLE
  $fileshare = Get-ALRemoteshare -websession $websession
  $platformid = Get-ALPlatformlayer -websession $websession | where{$_.name -eq "Windows 10 VDA"}
  $platformrevid = Get-ALPlatformlayerDetail -websession $websession -id $platformid.Id
  $platformrevid = $platformrevid.Revisions.PlatformLayerRevisionDetail | where{$_.candelete -eq $true} | Sort-Object revision -Descending | select -First 1
  remove-alplatformlayerrev -websession $websession -platformid $platformid.Id -platformrevid $platformrevid.id -fileshareid $fileshare.id
#>  
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$platformid,
[Parameter(Mandatory=$true)]$platformrevid,
[Parameter(Mandatory=$true)]$fileshareid
)
Begin {
  Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
  Test-ALWebsession -WebSession $websession
}
Process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		<DeletePlatformLayerRevisions xmlns="http://www.unidesk.com/">
		    <command>
				<LayerId>$platformid</LayerId>
				<RevisionIds>
					<long>$platformrevid</long>
				</RevisionIds>
				<Reason>
					<ReferenceNumber>0</ReferenceNumber>
				</Reason>
				<SelectedFileShare>$fileshareid</SelectedFileShare>
			</command>
		</DeletePlatformLayerRevisions>
	</s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/DeletePlatformLayerRevisions";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Removing $platformrevid from $platformid")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content

  if($obj.Envelope.Body.DeletePlatformLayerRevisionsResponse.DeletePlatformLayerRevisionsResult.Error)
  {
    throw $obj.Envelope.Body.DeletePlatformLayerRevisionsResponse.DeletePlatformLayerRevisionsResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.DeletePlatformLayerRevisionsResponse.DeletePlatformLayerRevisionsResult.WorkTicketId)"
    return $obj.Envelope.Body.DeletePlatformLayerRevisionsResponse.DeletePlatformLayerRevisionsResult
  }
}

}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
