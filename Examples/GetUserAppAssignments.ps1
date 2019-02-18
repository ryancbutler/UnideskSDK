$aplip = "192.168.1.100"
$pass = "mysupersecretpassword"
$username = "administrator"
$SecurePassword = ConvertTo-SecureString $Pass -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)
$websession = Connect-alsession -aplip $aplip -Credential $Credential -Verbose

#Final Array
$final = @()

#Get Directory
$dir = Get-ALDirectory -websession $websession|where{$_.name -eq "Lab"}

#Get LDAP Users that have authenticated to ELM
$Users = Get-ALUserList -websession $websession -junctionid $dir.id|Where-Object {$_.DirectoryId.type -eq "UserId" -and $_.DirectoryId.UnideskId -ne 0}

#Iterate user list
foreach ($user in $Users)
{
#Get User Detail
$userdetail = Get-ALUserDetail -websession $websession -junctionid $dir.id -ldapguid $user.DirectoryId.LdapGuid -dn $user.DirectoryId.LdapDN -id $user.DirectoryId.UnideskId

#Get Groups User is member of
$groups = Get-ALUserGroupMembership -websession $websession -junctionid $dir.id -id $User.DirectoryId.UnideskId -ldapguid $user.FullId.LdapGuid -ldapdn $user.FullId.LdapDN -sid $userdetail.FullId.sid

#build group array for search
$groupids = @()
$groups|%{$groupids += $_.DirectoryId.UnideskId}
#add user to group array
$groupids += $User.DirectoryId.UnideskId

#Get Apps that User and Groups are assigned to
$apps = Get-ALUserAssignment -websession $websession -id $groupids
     
     #Iterate each app found
     foreach ($app in $apps)
     {
     #Create PS object
     $object = [PSCustomObject] @{
               'UserName' = $user.LoginName
               'UserDN' = $user.FullId.LdapDN
               'AppLayer' = $app.LayerName;
               'Revision' = $app.CurrentRevision;
               'AssignedVia' = $app.AssignedVia;
               'AssignedViaDisplayName' = $app.AssignedViaDisplayName}
     #Add to return object
     $final += $object
     }

}
#Output object
$final|ft -AutoSize