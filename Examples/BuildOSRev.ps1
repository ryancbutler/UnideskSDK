# Creates Citrix App Layering OS versions
# Ryan Butler 2018-10-17 @ryan_c_butler
# From: https://github.com/ryancbutler/UnideskSDK

#Operating System Layer Name
$os = "Win10ENT1803"

#Version name format (1810.14)
$versionname = Get-Date -Format "yyMM.d"
$versiondescription = "Created VIA script"

#Windows update script location
$scriptpath = "$PSScriptRoot\UpdateTask.ps1"

#App Layer Info
$aplip = "192.168.5.5" #AL IP
$ALpass = "MYSECRETPASS" #AL Password
$ALusername = "administrator" #AL Username
$connectorname = "vcenter" #vcenter connector name

#vCenter Info
$vcenterUser = "domain\rbutler"
$vcenterpass = "MYSECRETPASS"
$vcenter = "vcenter01.lab.local"

#Local admin password for update VM
$localadminpw = "MYSECRETPASS"
$localadminuser = "administrator"

##### Start Script #####
#Create AL Credential
$SecurePasswordAL = ConvertTo-SecureString $ALPass -AsPlainText -Force
$CredentialAL = New-Object System.Management.Automation.PSCredential ($ALUsername, $SecurePasswordAL)

#Connect to AL and create session
$websession = Connect-alsession -aplip $aplip -Credential $CredentialAL -Verbose

#Create vCenter Credential
$SecurePasswordVCenter = ConvertTo-SecureString $vcenterpass -AsPlainText -Force
$CredentialVCenter = New-Object System.Management.Automation.PSCredential ($vcenterUser, $SecurePasswordVCenter)

#Connects to vCenter
Connect-VIServer -server $vcenter -Credential $CredentialVCenter

#Test WINRM connectivity
function test-wsmanquiet
{
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$computer)

    try{
        Test-WSMan -ComputerName $computer -ErrorAction Stop
    }
    catch
    {
        return $false
    }

    return $true
}

#Starts the timer
$StartDTM = (Get-Date)

#Gets needed AL info for layer creation
$fileshare = Get-ALRemoteshare -websession $websession
$connector = Get-ALconnector -websession $websession -type Create|where-object{$_.name -eq $connectorname}
$oss = Get-ALOsLayer -websession $websession|Where-Object{$_.name -eq $os}
$osrevs = get-aloslayerDetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail|Where-Object{$_.state -eq "Deployable"}|Sort-Object revision -Descending|Select-Object -First 1
$myosrev = new-aloslayerrev -websession $websession -version $versionname -connectorid $connector.Id -osid $oss.id -osrevid $osrevid.id -diskformat $connector.ValidDiskFormats.DiskFormat -shareid $fileshare.id -description $versiondescription -Confirm:$false
write-host $myosrev.WorkTicketId

  #Waiting for new layer to become ready
  do{
    $status = get-alstatus -websession $websession|Where-Object{$_.id -eq $myosrev.WorkTicketId}
    write-host $status.state
    Start-Sleep -Seconds 15
} Until ($status.state -eq "ActionRequired")

#use function to extract VM NAME from status message
$vmuniname = get-alvmname -message $status.WorkItems.WorkItemResult.Status

$ip = $null
#Get VM with powercli and wait for an IP
do{
    $vm = Get-VM $vmuniname
    $ip = $vm.Guest.IPAddress[0]
    $VMNAME = $vm.ExtensionData.Guest.Hostname
    Start-Sleep -Seconds 10
} Until ($ip)

#Create credential for WINRM
$credname = ("$VMNAME\$localadminuser")
$secpasswd = ConvertTo-SecureString $localadminpw -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($credname, $secpasswd)

$timer = [Diagnostics.Stopwatch]::StartNew()
$timeout = 120 #2 minutes
write-host "Checking for WINRM connectivity"
#Tries to connect to WINRM and waits to become available
while (-not (test-wsmanquiet -Computer $ip))
{
    Write-host "Waiting for $ip to become accessible WINRM..."
    if ($timer.Elapsed.TotalSeconds -ge $Timeout)
    {
    throw "Timeout exceeded. Giving up on $ComputerName"
    }

}

#Start WINRM session
$session = New-PSSession -ComputerName $ip -Credential $cred -ErrorAction stop

#Copies script needed for update process
Copy-Item -ToSession $session -path $scriptpath -Destination "C:\Windows\temp\UpdateTask.ps1" -Force

#Scheduled tasks script block
$sbtask = {
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-ExecutionPolicy Bypass -file "C:\Windows\temp\UpdateTask.ps1" -noexit'
$trigger =  New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "PSWindowsUpdate"
}

#Creates scheduled tasks using script block
Invoke-Command -Session $session -ScriptBlock $sbtask

#Enables autologon
Invoke-Command -Session $session -ScriptBlock {Import-Module -Name Autologon -force;Enable-AutoLogon -Username $using:localadminuser -Password (ConvertTo-SecureString -String $using:localadminpw -AsPlainText -Force) -LogonCount "1" } -ErrorAction stop

#Restart to kick off the process
Restart-Computer -Force -ComputerName $ip -Credential $cred

#Waits for VM to power down
$timer = [Diagnostics.Stopwatch]::StartNew()
#Operation timeout
$timeout = 2 #Hours
do{
    
    if ($timer.Elapsed.TotalHours -ge $Timeout)
    {
    throw "Timeout exceeded on shutdown process"
    }

    write-host "Waiting for VM to shutdown...."
    Start-Sleep -Seconds 10
    $vm = Get-VM $vmuniname
}
until ($vm.PowerState -eq "PoweredOff")

write-host "VM powered down"

#Finalize Layer
$OSS = Get-ALOslayer -websession $websession|Where-Object{$_.name -eq $os}
$OSSREVS = Get-ALOsLayerDetail -websession $websession -id $oss.Id
$ossrevid = $OSSREVS.Revisions.OsLayerRevisionDetail|Where-Object{$_.state -eq "Finalizable"}|Sort-Object revision -Descending|Select-Object -First 1
$disklocation = get-allayerinstalldisk -websession $websession -id $ossrevid.LayerId
invoke-allayerfinalize -websession $websession -fileshareid $fileshare.id -LayerRevisionId $ossrevid.Id -uncpath $disklocation.diskuncpath -filename $disklocation.diskname -Confirm:$false

#End timer
$EndDTM = (Get-Date)

#Compare times
$time = ($EndDTM-$StartDTM)
write-host "Finished in $($time.TotalMinutes) minutes" -foreground Green


