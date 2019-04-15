# Application Assignments

## Add app layers to an image

```powershell
$image = Get-ALimage -websession $websession|where{$_.name -eq "Accounting"}
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = get-alapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
add-alappassignment -websession $websession -apprevid $apprevid.id -imageid $image.id
```

## Remove app layers from an image

```powershell
$image = Get-ALimage -websession $websession|where{$_.name -eq "Accounting"}
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = Get-ALapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
remove-alappassignment -websession $websession -applayerid $apprevid.LayerId -imageid $image.id
```

## Add user\group to Elastic Layers

```powershell
$users = @('MyGroup1','MyGroup2','Domain Users')
$finduser = $users|get-alldapobject -websession $websession
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = Get-ALapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
$add = $finduser|add-alelappassignment -websession $websession -apprevid $apprevid.Id
```

## Remove user\group from Elastic Layers

```powershell
$users = @('MyGroup1','MyGroup2','Domain Users')
$finduser = $users|get-alldapobject -websession $websession
$app = Get-ALapplayer -websession $websession|where{$_.name -eq "Libre Office"}
$apprevs = Get-ALapplayerDetail -websession $websession -id $app.Id
$apprevid = $apprevs.Revisions.AppLayerRevisionDetail|where{$_.state -eq "Deployable"}|Sort-Object DisplayedVersion -Descending|select -First 1
$finduser|remove-alelappassignment -websession $websession -apprevid $apprevid.Id
```