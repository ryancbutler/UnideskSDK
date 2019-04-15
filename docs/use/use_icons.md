# Icons

## Get icon ids

```powershell
Get-ALicon -websession $websession
```

## Export all icons (save as png)

```powershell
$icons = Get-ALicon -websession $websession

foreach($icon in $icons)
{
    #No authentication needed to grab image
    Invoke-WebRequest -uri $($icon.url) -OutFile ("D:\Temp\icons\" + $($icon.iconid)+".png")
}
```

## Get icon associations

```powershell
Get-ALiconassoc -websession $websession -iconid "196608"
```

## Create new icon

```powershell
$iconfile = "D:\Temp\icons\myiconpic.png"
$temp = new-alicon -WebSession $websession -iconfile $iconfile -Verbose
```

## Remove icon

```powershell
Remove-ALicon -websession $websession -iconid "4259840"
```