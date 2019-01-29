function Remove-ALAppLayerRev
{
<#
.SYNOPSIS
  Removes a app layer version
.DESCRIPTION
  Removes a app layer version
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER appid
  Base application layer version id to use
.PARAMETER apprevid
  Application revision version id to use
.EXAMPLE
  $fileshare = Get-ALRemoteshare -websession $websession
  $appid = Get-ALapplayer -websession $websession | where{$_.name -eq "7-Zip"}
  $apprevid = get-alapplayerDetail -websession $websession -id $appid.Id
  $apprevid = $apprevid.Revisions.AppLayerRevisionDetail | where{$_.candelete -eq $true} | Sort-Object revision -Descending | select -First 1
  remove-alapplayerrev -websession $websession -appid $appid.Id -apprevid $apprevid.id -fileshareid $fileshare.id
#>  
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)]$appid,
[Parameter(Mandatory=$true)]$apprevid,
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
		<DeleteAppLayerRevisions xmlns="http://www.unidesk.com/">
		    <command>
				<LayerId>$appid</LayerId>
				<RevisionIds>
					<long>$apprevid</long>
				</RevisionIds>
				<Reason>
					<ReferenceNumber>0</ReferenceNumber>
				</Reason>
				<SelectedFileShare>$fileshareid</SelectedFileShare>
			</command>
		</DeleteAppLayerRevisions>
	</s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/DeleteAppLayerRevisions";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
if ($PSCmdlet.ShouldProcess("Removing $apprevid from $appid")) {
  $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
  [xml]$obj = $return.Content

  if($obj.Envelope.Body.DeleteAppLayerRevisionsResponse.DeleteAppLayerRevisionsResult.Error)
  {
    throw $obj.Envelope.Body.DeleteAppLayerRevisionsResponse.DeleteAppLayerRevisionsResult.Error.message

  }
  else {
    Write-Verbose "WORKTICKET: $($obj.Envelope.Body.DeleteAppLayerRevisionsResponse.DeleteAppLayerRevisionsResult.WorkTicketId)"
    return $obj.Envelope.Body.DeleteAppLayerRevisionsResponse.DeleteAppLayerRevisionsResult
  }
}

}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
