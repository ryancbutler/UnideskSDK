# Creates and updates Citrix ELM App Layers
# Ryan Butler 2018-10-17 @ryan_c_butler
# From: https://github.com/ryancbutler/UnideskSDK

#App Layer Info
$aplip = "192.168.5.5" #AL IP
$ALpass = "MYSECRETPASS" #AL Password
$ALusername = "administrator" #AL Username
$os = "Win10ENT1803" #OS Layer name to use to create layers
$connectorname = "myvcenter" #vcenter connector name
$appnames = @("notepadplusplus", "firefox", "putty.install") #Chocolatey packages to install 

#vCenter Info
$vcenterUser = "domain\rbutler"
$vcenterpass = "MYSECRETPASS"
$vcenter = "vcenter.domain.com"

#Local admin password
$localadminpw = "MYSECRETPASS"
$localadminuser = "administrator"

##### Start Script #####
#Create AL Credential
$SecurePasswordAL = ConvertTo-SecureString $ALPass -AsPlainText -Force
$CredentialAL = New-Object System.Management.Automation.PSCredential ($ALUsername, $SecurePassword)

#Connect to AL and create session
$websession = Connect-alsession -aplip $aplip -Credential $CredentialAL -Verbose

#Create vCenter Credential
$SecurePasswordVCenter = ConvertTo-SecureString $vcenterpass -AsPlainText -Force
$CredentialVCenter = New-Object System.Management.Automation.PSCredential ($vcenterUser, $SecurePasswordVCenter)

#Connects to vCenter
Connect-VIServer -server $vcenter -Credential $CredentialVCenter

#Test WINRM connectivity
function test-wsmanquiet {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory = $true)]$computer)

    try {
        Test-WSMan -ComputerName $computer -ErrorAction Stop
    }
    catch {
        return $false
    }

    return $true
}

#Starts the timer
$StartDTM = (Get-Date)

#Gets needed AL info for layer creation
$connector = Get-ALconnector -websession $websession -type Create | where-object { $_.name -eq $connectorname }
$oss = Get-ALOsLayer -websession $websession | Where-Object { $_.name -eq $os }
$osrevs = get-aloslayerDetail -websession $websession -id $oss.id
$osrevid = $osrevs.Revisions.OsLayerRevisionDetail | Where-Object { $_.state -eq "Deployable" } | Sort-Object revision -Descending | Select-Object -First 1

#Empty results array
$results = @()

foreach ($appname in $appnames) {

    #Clear starting variables
    $version = 0
    $apprevver = 0
    $newLayer = "N/A"
    $upgrade = "N/A"
    $skiprun = "N/A"
    $ErrorInProcess = $false

    write-host "Proccessing $appname" -foreground green
    #Grabs Package version from Chocolatey
    $web = invoke-restmethod "http://chocolatey.org/api/v2/FindPackagesById()?`$filter=IsLatestVersion&id='$appname'"

    if ($web) {

        #version info
        $latest = $web | Sort-Object id -Descending | Select-Object -First 1
        $version = $latest.properties.Version
        $desc = $latest.properties.Title

        #Checks for existing app layer
        $app = Get-ALapplayer -websession $websession | Where-Object { $_.name -eq $appname }
        if ($app) {

            write-host "$appname layer Found."
            #newlayer flag
            $newLayer = $false

            #Gets layer versions
            $apprevs = get-alapplayerDetail -websession $websession -id $app.Id
            $apprevid = $apprevs.Revisions.AppLayerRevisionDetail | Where-Object { $_.state -eq "Deployable" } | Sort-Object revision -Descending | Select-Object -First 1
            $apprevver = $apprevid.DisplayedVersion
            #Checks app layer revisions against choco version
            if ($apprevid.DisplayedVersion -lt $version ) {
                write-host "AL version at $apprevver. Need to be at $version" -ForegroundColor Green
                #Creates new app layer revision and saves workid
                $workid = new-alapplayerrev -websession $websession -version $version -name $app.Name -connectorid $connector.id -appid $app.Id -apprevid $apprevid.id -osrevid $osrevid.Id -diskformat $connector.ValidDiskFormats.DiskFormat -fileshareid $fileshare.id -Confirm:$false -ErrorAction stop
                write-host "Workid: $($workid.WorkTicketId)"
                #flags
                $upgrade = $true
                $skiprun = $false
            }
            else {
                write-host "Already at or above $version.  Skipping new version..." -ForegroundColor Yellow
                #flags
                $skiprun = $true
                $upgrade = $false
            }

        }
        else {
            $apprevver = 0
            write-host "$appname NOT Found. Creating new Layer"
            #Creates new app layer and saves workid
            $workid = new-alapplayer -websession $websession -version $version -name $appname -description $desc -connectorid $connector.id -osrevid $osrevid.Id -diskformat $connector.ValidDiskFormats.DiskFormat -OsLayerSwitching BoundToOsLayer -fileshareid $fileshare.id -confirm:$false
            write-host "Workid: $($workid.WorkTicketId)"
            #flags
            $upgrade = $false
            $skiprun = $false
            $newLayer = $true
        }
    }
    else {
        Write-Warning "Couldn't locate Package. Check appname $appname"
        #Flags
        $skiprun = $true
        $ErrorInProcess = $true
    }
    #SkipRun if version already found
    if ($skiprun -eq $false) {

        #Waiting for new layer to become ready
        do {
            $status = get-alstatus -websession $websession | Where-Object { $_.id -eq $workid.WorkTicketId }
            write-host $status.state
            Start-Sleep -Seconds 15
        } Until ($status.state -eq "ActionRequired")

        #use function to extract VM NAME from status message
        $vmuniname = get-alvmname -message $status.WorkItems.WorkItemResult.Status

        $ip = $null
        #Get VM with powercli and wait for an IP
        do {
            $vm = Get-VM $vmuniname
            $ip = $vm.Guest.IPAddress[0]
            $VMNAME = $vm.ExtensionData.Guest.Hostname
            Start-Sleep -Seconds 10
        } Until ($ip)

        #Create credential for WINRM
        $credname = ("$VMNAME\$username")
        $secpasswd = ConvertTo-SecureString $pass -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($credname, $secpasswd)

        $timer = [Diagnostics.Stopwatch]::StartNew()
        $timeout = 120
        write-host "Checking for WINRM connectivity"
        #Tries to connect to WINRM and waits to become available
        while (-not (test-wsmanquiet -Computer $ip)) {
            Write-Host "Waiting for $ip to become accessible WINRM..."
            if ($timer.Elapsed.TotalSeconds -ge $Timeout) {
                throw "Timeout exceeded. Giving up on $ComputerName"
            }

        }
        
        #Creates a new WinRM session
        $session = New-PSSession -ComputerName $ip -Credential $cred -ErrorAction stop
        
        #Checks for upgrade flag
        if ($upgrade) {
            #upgrades existing package
            Invoke-Command -Session $session -ScriptBlock { choco upgrade -y $using:appname } -ErrorAction stop
        }
        else {
            #Installs new package
            Invoke-Command -Session $session -ScriptBlock { choco install -y $using:appname } -ErrorAction stop
        }

        #Checks for any error codes in session
        $successrun = Invoke-Command -Session $session -ScriptBlock { $? } -ErrorAction stop

        #Checks flag for successful run
        if ($successrun -eq $false ) {
            Write-Warning "Error with $appname. Removing Layer"
            $ErrorInProcess = $true
            #Stops layering process for app
            Stop-ALWorkTicket -id $workid -websession $websession -confirm:$false
        }
        else {
            #Set Login interactively to clear any runonce (Requires https://www.powershellgallery.com/packages/Autologon)
            Invoke-Command -Session $session -ScriptBlock { Import-Module -Name Autologon -force; Enable-AutoLogon -Username $using:localadminuser -Password (ConvertTo-SecureString -String $using:localadminpw -AsPlainText -Force) -LogonCount "1" } -ErrorAction stop
            #Reboot VM and wait for WINRM
            Restart-Computer -Force -ComputerName $ip -Credential $cred -For WinRM -Wait
            
            #Start WINRM session and seal layer
            $session = New-PSSession -ComputerName $ip -Credential $cred -ErrorAction stop
            write-host "Waiting for interactive processes to clear!"
            Start-Sleep -Seconds 30
            $command = { & 'C:\Program Files\Unidesk\Uniservice\ShutdownForFinalize.cmd' }
            Invoke-Command -Session $session -ScriptBlock $command -ErrorAction stop -verbose
            
            #Checks for any error codes
            $successrun = Invoke-Command -Session $session -ScriptBlock { $? } -ErrorAction stop -verbose

            if ($successrun -eq $false ) {
                Write-Warning "Problem sealing layer. Removing update layer"
                $ErrorInProcess = $true
                #Stops layering process for app
                Stop-ALWorkTicket -id $workid -websession $websession -confirm:$false
            }
            else {
                do {
                    write-host "Waiting for VM to shutdown...."
                    Start-Sleep -Seconds 10
                    $vm = get-vm $vmuniname
                }
                until ($vm.PowerState -eq "PoweredOff")

                write-host "VM powered down"
 
                #Gets layer info to finalize
                $app = Get-ALapplayer -websession $websession | Where-Object { $_.name -eq $appname }
                $apprevs = get-alapplayerDetail -websession $websession -id $app.Id
                $apprevid = $apprevs.Revisions.AppLayerRevisionDetail | Where-Object { $_.state -eq "Finalizable" } | Sort-Object revision -Descending | Select-Object -First 1
                $disklocation = get-allayerinstalldisk -websession $websession -id $apprevid.LayerId
                Write-Host "Finializing Layer"
                #Runs finalization process
                invoke-allayerfinalize -websession $websession -fileshareid $fileshare.id -LayerRevisionId $apprevid.Id -uncpath $disklocation.diskuncpath -filename $disklocation.diskname -Confirm:$false
                $ErrorInProcess = $false
            }
            $ErrorInProcess = $false
        }
    }
    #Process output object
    $temp = @{'AppName'     = $appname;
        'ChocoVersion'      = $version;
        'PreviousALVersion' = $apprevver;
        'CreatedNewLayer'   = $newLayer;
        'CreatedNewVersion' = $upgrade;
        'Skipped'           = $skiprun;
        'ErrorInProcess'    = $ErrorInProcess;
    }
    $object = New-Object –TypeName PSObject –Prop $temp
    $results += $object
}
#End timer
$EndDTM = (Get-Date)

#Compare times
$time = ($EndDTM - $StartDTM)
write-host "Finished in $($time.TotalMinutes) minutes" -foreground Green

#Outputs results
$results | Format-Table -AutoSize
