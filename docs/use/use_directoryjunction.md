# Directory Junction

## New Directory Junction

```powershell
new-aldirectory -websession $websession -serveraddress "mydc.domain.com" -usessl -username "admin@domain.com" -adpassword "MYPASSWORD" -basedn DC=domain,DC=com -name "Mydirectory"
```

## Get ALL Directory Junctions

```powershell
Get-ALDirectory -websession $websession
```

## Get Directory Junction Info

```powershell
get-aldirectorydetail -websession $websession -id $directory.id
```

## Set Directory Junction Info

```powershell
Set-aldirectory -websession $websession -adpassword "MYPASSWORD" -id $directory.id -name "MYNEWNAME"
```

## Delete Directory Junction

```powershell
Remove-ALDirectory -websession $websession -id "4915204"
```

## User Info

```powershell
$dir = Get-ALDirectory -websession $websession|where{$_.name -eq "MyDirectory"}
$userid = Get-ALUserList -websession $websession -junctionid $dir.id -dn "CN=Users,DC=mydomain,DC=com"|Where-Object {$_.loginname -eq "myusername"}
$userdetail = Get-ALUserDetail -websession $websession -junctionid $dir.id -ldapguid $userid.DirectoryId.LdapGuid -dn $userid.DirectoryId.LdapDN -id $userid.DirectoryId.UnideskId
$groups = Get-ALUserGroupMembership -websession $websession -junctionid $dir.id -id $User.DirectoryId.UnideskId -ldapguid $user.FullId.LdapGuid -ldapdn $user.FullId.LdapDN -sid $userdetail.FullId.sid
#build group array for search
$groupids = @()
$groups|%{$groupids += $_.DirectoryId.UnideskId}
#add user to group array
$groupids += $User.DirectoryId.UnideskId
$apps = Get-ALUserAssignment -websession $websession -id $userid.DirectoryId.UnideskId -Verbose
$apps|Select-Object LayerName,CurrentRevision,PendingRevision,AssignedViaDisplayName
```