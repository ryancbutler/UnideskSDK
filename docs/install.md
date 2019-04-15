# Install and Update

## Install Manually

```powershell
Import-Module ".\ctxal-sdk.psm1"
```

## Install PSGallery

```powershell
Find-Module -name ctxal-sdk
Install-Module -Name ctxal-sdk -Scope CurrentUser
```

## Update PSGallery

```powershell
Find-Module -name ctxal-sdk
Update-Module -Name ctxal-sdk
```
``