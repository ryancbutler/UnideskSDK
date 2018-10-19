function Get-ALLdapObject
{
<#
.SYNOPSIS
  Locates LDAP user or group object
.DESCRIPTION
  Locates LDAP user or group object
.PARAMETER websession
  Existing Webrequest session for ELM  Appliance
.PARAMETER object
  Group or user to be located
.EXAMPLE
  get-alldapobject -websession $websession -object "myusername"
.EXAMPLE
  $users = @('MyGroup1','MyGroup2','Domain Users')
  $finduser = $users|get-alldapobject -websession $websession
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][string]$object
)

begin {
Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
Test-ALWebsession -WebSession $websession  
$finalobj = @()   
}

process {
[xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
<s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<SearchDirectoryItemPendingOp xmlns="http://www.unidesk.com/">
<query>
    <SearchString>$object</SearchString>
    <Types>User Group Folder</Types>
    <Location>LDAP</Location>
</query>
</SearchDirectoryItemPendingOp>
</s:Body>
</s:Envelope>
"@
$headers = @{
SOAPAction = "http://www.unidesk.com/SearchDirectoryItemPendingOp";
"Content-Type" = "text/xml; charset=utf-8";
UNIDESK_TOKEN = $websession.token;
}

$url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
$return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
[xml]$obj = $return.Content

$taskid = $obj.Envelope.Body.SearchDirectoryItemPendingOpResponse.SearchDirectoryItemPendingOpResult.Id
Write-Verbose "Found ID: $taskid"
do{
    Write-Verbose "Searching LDAP.."
    Start-Sleep -Seconds 1
    $pendobj = get-pendingop -id $taskid -WebSession $websession
} Until ($pendobj.running -eq "False" )

if ($pendobj.OperationResult.Items -ne "")
{
$tempobj = [PSCustomObject]@{
    Name = $pendobj.OperationResult.Items.SearchResult["Item"].Name
    GUID = $pendobj.OperationResult.Items.SearchResult["Item"].FullId.LdapGuid
    DirectoryJunctionId = $pendobj.OperationResult.Items.SearchResult["Item"].FullId.DirectoryJunctionId
    ObjectType = $pendobj.OperationResult.Items.SearchResult["Item"].DirectoryId.type
    UnideskId = $pendobj.OperationResult.Items.SearchResult["Item"].FullId.UnideskId
    DN = $pendobj.OperationResult.Items.SearchResult["Item"].FullId.LdapDN
    SID = $pendobj.OperationResult.Items.SearchResult["Item"].FullId.Sid
    }
$finalobj += $tempobj 
}
else {
    Write-Warning "$object NOT FOUND"
}
}

end {
    if ($tempobj)
    {
    return $finalobj
    }
Write-Verbose "END: $($MyInvocation.MyCommand)"
}


}