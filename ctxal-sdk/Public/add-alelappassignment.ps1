function Add-ALELAppassignment
{
<#
.SYNOPSIS
  Adds a user account or group to an applications elastic layer assignment
.DESCRIPTION
  Adds a user account or group to an applications elastic layer assignment
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER apprevid
  Application version layer ID
.PARAMETER user
  LDAP located user object
.EXAMPLE
  $user = get-alldapobject -websession $websession -object "myusername"
  add-alelappassignment -websession $websession -apprevid $apprevid.Id -user $user
.EXAMPLE
  $users = @('MyGroup1','MyGroup2','Domain Users')
  $finduser = $users|get-alldapobject -websession $websession
  $app = Get-ALapplayerDetail -websession $websession|where{$_.name -eq "Libre Office"}
  $apprevs = Get-ALapplayerDetail -websession $websession -id $app.Id
  $apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object revision -Descending|select -First 1
  $add = $finduser|add-alelappassignment -websession $websession -apprevid $apprevid.Id
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$apprevid,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]$user
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
        <AdEntityIds>
          <DirectoryId xsi:type="$($user.objecttype)">
            <UnideskId>$($user.UnideskId)</UnideskId>
            <DirectoryJunctionId>$($user.DirectoryJunctionId)</DirectoryJunctionId>
            <LdapGuid>$($user.GUID)</LdapGuid>
            <LdapDN>$($user.DN)</LdapDN>
            <Sid/>
          </DirectoryId>
        </AdEntityIds>
        <LayeredImageIds/>
        <AppLayerRevId>$apprevid</AppLayerRevId>
        <Reason>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </UpdateAppLayerAssignment>
  </s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/UpdateAppLayerAssignment";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}
if ($PSCmdlet.ShouldProcess("Adding $apprevid to $($user.DN)")) {
$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content
}
}



end{
if ($PSCmdlet.ShouldProcess("Output for application add"))
{
  if($obj.Envelope.Body.UpdateAppLayerAssignmentResponse.UpdateAppLayerAssignmentResult.Error)
  {
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