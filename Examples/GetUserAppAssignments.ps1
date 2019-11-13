#Returns a list of users with what elastic layers are assigned

$aplip = "192.168.1.100"
$pass = "mysupersecretpassword"
$username = "administrator"
$SecurePassword = ConvertTo-SecureString $Pass -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)
$websession = Connect-alsession -aplip $aplip -Credential $Credential -Verbose
#ELM Directory Name
$DirectoryName = "Lab"

#Final Array
$final = @()

#Get Directory
$dir = Get-ALDirectory -websession $websession | Where-Object { $_.name -eq $DirectoryName }


#Recursive function to find all users
function  Get-LDAPUsers {

  param (
    [Parameter()]
    [string]$ldapdn
  )
  $FULL = Get-ALUserList -websession $websession -dn $ldapdn -junctionid $dir.ID

  foreach ($item in $full) {
    if ($item.type -contains "FolderSummary") {
      Get-LDAPUsers -ldapdn $item.FullId.LdapDN
    }
    elseif ($Item.type -eq "UserSummary") {
      $item 
    }
  }

}

#Call Function
$users = Get-LDAPUsers -ldapdn $dir.LdapDN


#Iterate user list
foreach ($user in $Users) {
  #Get User Detail
  $userdetail = Get-ALUserDetail -websession $websession -junctionid $dir.id -ldapguid $user.DirectoryId.LdapGuid -dn $user.DirectoryId.LdapDN -id $user.DirectoryId.UnideskId

  #Get Groups User is member of
  $groups = Get-ALUserGroupMembership -websession $websession -junctionid $dir.id -id $User.DirectoryId.UnideskId -ldapguid $user.FullId.LdapGuid -ldapdn $user.FullId.LdapDN -sid $userdetail.FullId.sid

  #build group array for search
  $groupids = @()
  $groups | ForEach-Object { $groupids += $_.DirectoryId.UnideskId }
    
  #add user to group array only if it has an ID
  if ($User.DirectoryId.UnideskId -ne 0) {
    $groupids += $User.DirectoryId.UnideskId
  }

  if ($groupids) {
    #Get Apps that User and Groups are assigned to
    $apps = Get-ALUserAssignment -websession $websession -id $groupids
     
    #Iterate each app found
    foreach ($app in $apps) {
      #Create PS object
      $object = [PSCustomObject] @{
        'UserName'               = $user.LoginName
        'UserDN'                 = $user.FullId.LdapDN
        'AppLayer'               = $app.LayerName;
        'Revision'               = $app.CurrentRevision;
        'AssignedVia'            = $app.AssignedVia;
        'AssignedViaDisplayName' = $app.AssignedViaDisplayName
      }
      #Add to return object
      $final += $object
    }

  }
}


#Output object
$final | Format-Table -AutoSize