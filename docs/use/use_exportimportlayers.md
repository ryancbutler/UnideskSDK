# Export and Import Layers

Gets "Exportable" Layers

```powershell
$mypath = "\\mynas\layershare\"
Get-ALExportableRev -websession $websession -sharepath $mypath
```

Gets "Exportable" layers including ones that are already present

```powershell
$mypath = "\\mynas\layershare\"
Get-ALExportableRev -websession $websession -sharepath $mypath -showall
```

Gets "Importable" Layers

```powershell
$mypath = "\\mynas\layershare\"
Get-ALimportableRev -websession $websession -sharepath $mypath
```

Gets "Importable" layers including ones that are already present

```powershell
$mypath = "\\mynas\layershare\"
Get-ALimportableRev -websession $websession -sharepath $mypath -showall
```

## Export Layers

Exports all "exportable" layers to fileshare

```powershell
$mypath = "\\mynas\layershare\"
Get-ALExportableRev -websession $websession -sharepath $mypath|Export-ALlayerrev -websession $websession -sharepath $mypath
```

Exports all "exportable" layers to fileshare with authenication. (Press CTRL key to select more than one layer)

```powershell
$mypath = "\\mynas\layershare\"
$myusername = "mydomain@domain.com"
$sharepw = "mysupersecret"
Get-ALExportableRev -websession $websession -sharepath $mypath -username $myusername -sharepw $sharepw|Export-ALlayerrev -websession $websession -sharepath $mypath -username $myusername -sharepw $sharepw
```

Allows user to select which layers to export. (Press CTRL key to select more than one layer)

```powershell
$mypath = "\\mynas\layershare\"
Get-ALExportableRev -websession $websession -sharepath $mypath|Out-gridview -PassThru|Export-ALlayerrev -websession $websession -sharepath $mypath
```

## Import Layers

Imports all "importable" layers to fileshare

```powershell
$mypath = "\\mynas\layershare\"
Get-ALImportableRev -websession $websession -sharepath $mypath|Import-ALlayerrev -websession $websession -sharepath $mypath
```

Imports all "importable" layers to fileshare with authenication. (Press CTRL key to select more than one layer)

```powershell
$mypath = "\\mynas\layershare\"
$myusername = "mydomain@domain.com"
$sharepw = "mysupersecret"
Get-ALImportableRev -websession $websession -sharepath $mypath -username $myusername -sharepw $sharepw|Import-ALlayerrev -websession $websession -sharepath $mypath -username $myusername -sharepw $sharepw
```

Allows user to select which layers to import. (Press CTRL key to select more than one layer)

```powershell
$mypath = "\\mynas\layershare\"
Get-ALImportableRev -websession $websession -sharepath $mypath|Out-gridview -PassThru|Import-ALlayerrev -websession $websession -sharepath $mypath
```