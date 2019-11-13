# Used with OS update Citrix ELM versions
# Ryan Butler 2018-10-17 @ryan_c_butler
# From: https://github.com/ryancbutler/UnideskSDK

#Modules Needed
Import-Module -name pswindowsupdate
Import-Module -Name Autologon

#Local admin password
$localadminpw = "MYSECRETPASS"
$localadminuser = "administrator"

#### Script Starts Here ####

#wait for Windows update funciton
function Test-WUInstallerStatus {
    while ((Get-WUInstallerStatus).IsBusy) {
        Write-host -Message "Waiting for Windows update to become free..." -ForegroundColor Yellow
        Start-Sleep -Seconds 15
    }
}

#Enable Windows Update Service
write-host "Starting Windows Update Service"
Set-Service wuauserv -StartupType Automatic
Start-Service wuauserv

#Make sure no other Windows update process is running
write-host "Checking Windows Update Process"
Test-WUInstallerStatus

#Get Updates
write-host "Getting Available Updates"
$updates = Get-WUList

#Download and install
if ($updates) {
    Write-Host "Installing Updates"
    Get-WUInstall -AcceptAll -install -IgnoreReboot
}

#Wait for Windows Update to start if needed
Start-Sleep -Seconds 5

#Make sure no other Windows update process is running
Test-WUInstallerStatus

write-host "Checking for reboot"
if (Get-WURebootStatus -silent) {
    #Needs to reboot
    #Enabling autologon
    Enable-AutoLogon -Username $localadminuser -Password (ConvertTo-SecureString -String $localadminpw -AsPlainText -Force) -LogonCount "1"
    Restart-Computer -Force
}
else {
    #WU Reboot not needed

    #Flag to use during seal process checks
    $good = $true

    #First Section of the "Shutdown for Finalize"
    & 'C:\Program Files\Unidesk\Uniservice\Uniservice.exe' -G    
    #If error with above
    if ($? -eq $false) {
        write-host "Issues with seal process.  Rebooting Again"
        #Enable autologon to kick off scheduled task
        Enable-AutoLogon -Username $localadminuser -Password (ConvertTo-SecureString -String $localadminpw -AsPlainText -Force) -LogonCount "1"
        #Set flag
        $good = $false
        #Reboot to initialize task
        Restart-Computer -Force
    }

    #Second Section of the "Shutdown for Finalize"
    & 'C:\Program Files\Unidesk\Uniservice\Uniservice.exe' -L
    #If error with above
    if ($? -eq $false) {
        write-host "Issues with seal process.  Rebooting Again"
        #Enable autologon to kick off scheduled task
        Enable-AutoLogon -Username $localadminuser -Password (ConvertTo-SecureString -String $localadminpw -AsPlainText -Force) -LogonCount "1"
        #Set flag
        $good = $false
        #Reboot to initialize task
        Restart-Computer -Force
    }

    #If checks pass
    if ($good) {
        #Disable windows update services
        write-host "Disabling Windows Update Service"
        Set-Service wuauserv -StartupType Disabled
        Stop-Service wuauserv
        #Remove Scheduled Task
        write-host "Removing Scheduled Task"
        Unregister-ScheduledTask -TaskName "PSWindowsUpdate" -Confirm:$false
        #Remove update script
        remove-item "C:\Windows\temp\UpdateTask.ps1" -force
        #Shutdown system
        & "C:\Windows\System32\Shutdown.exe" /s /t 0 /d p:4:2 /c "Citrix layer finalization"
    }

}

