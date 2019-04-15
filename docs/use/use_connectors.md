# Connectors

## General

### Get Connector Detail

```powershell
$conn = get-alconnector -websession $websession -type Publish -name "MyconnectorTest7"
get-alconnectordetail -websession $websession -connid $conn.Id -port $conn.ConfigurationSslPort
```

### Remove Connector

```powershell
$conn = get-alconnector -websession $websession -type Publish -name "MyconnectorTest7"
Remove-ALConnector -websession $websession -connid $conn.Id -Confirm:$false
```

### Set Connector Credentials

```powershell
$conn = get-alconnector -websession $websession -type Publish -name "MyconnectorTest7"
$conndetail = get-alconnectordetail -websession $websession -connid $conn.Id -port $conn.ConfigurationSslPort
Set-ALconnectorCred -websession $websession -config $conndetail -connector $conn -username "domain\first.last" -password "Test123
```

## vCenter

### Get vCenter connector(s) information

```powershell
Get-alVcenterConnector -websession $websession
```

### Get vCenter Resource Info

```powershell
$vcenter = Get-alVcenterConnector -websession $websession
$dc = get-alvcenterobject -websession $websession -configid $vcenter.pccId -username $vcenter.pccConfig.userName -vcenter $vcenter.pccConfig.vCenterServer -type datacenter -configid $vcenter.pccId
$folder 
$hostvar = get-alvcenterobject -websession $websession -configid $vcenter.pccId -username $vcenter.pccConfig.userName -vcenter $vcenter.pccConfig.vCenterServer -type Host -dc $dc.value
$datastore = get-alvcenterobject -websession $websession -configid $vcenter.pccId -username $vcenter.pccConfig.userName -vcenter $vcenter.pccConfig.vCenterServer -type Datastore -dc $dc.value
$network = get-alvcenterobject -websession $websession -configid $vcenter.pccId -username $vcenter.pccConfig.userName -vcenter $vcenter.pccConfig.vCenterServer -type network -dc $dc.value
$template = get-alvcenterobject -websession $websession -configid $vcenter.pccId -username $vcenter.pccConfig.userName -vcenter $vcenter.pccConfig.vCenterServer -type vmTemplate -vmfolder $dc.vmFolder
$folder = get-alvcenterobject -websession $websession -configid $vcenter.pccId -username $vcenter.pccConfig.userName -vcenter $vcenter.pccConfig.vCenterServer -type vmfolder -vmfolder $dc.vmFolder
```

### Validate and Set vCenter Password

```powershell
$vcenter = Get-alVcenterConnector -websession $websession
$vcenter.pccConfig|Add-Member -NotePropertyName "password" -NotePropertyValue "mysecretpassword"

Set-alVcenterConnector -websession $websession -config $vcenter
```

### Create vCenter Connector

```powershell
$vcenterpassword = "mysupersecretpassword"
$usernamevc = "domain\username"
$vcentername = "myvcenter.domain.local"
$type = get-alconnectortype -websession $websession -name "Citrix MCS for vSphere"
$dc = get-alvcenterobject -websession $websession -username $usernamevc -vcenter $vcentername -vcenterpass $vcenterpassword -type Datacenter -name "Lab"
$hostvar = get-alvcenterobject -websession $websession -username $usernamevc -vcenter $vcentername -vcenterpass $vcenterpassword -type Host -dc $dc.value -name "myhostname"
$datastore = get-alvcenterobject -websession $websession -username $usernamevc -vcenter $vcentername -vcenterpass $vcenterpassword -type Datastore -dc $dc.value -name "nydatastire"
$network = get-alvcenterobject -websession $websession -username $usernamevc -vcenter $vcentername -vcenterpass $vcenterpassword -type network -dc $dc.value -name "VLAN10"
$template = get-alvcenterobject -websession $websession -username $usernamevc -vcenter $vcentername -vcenterpass $vcenterpassword -type vmTemplate -vmfolder $dc.vmFolder -name "CALTEMP"
$folder = get-alvcenterobject -websession $websession -username $usernamevc -vcenter $vcentername -vcenterpass $vcenterpassword -type vmfolder -vmfolder $dc.vmFolder -name "Unidesk"


$Params = @{
  Name = "MyconnectorTest"
  DC = $dc
  DATASTORE = $datastore
  HOSTSYSTEM = $hostvar
  NETWORK = $network
  FOLDER = $folder
  CONNID = $type.Id
  VMTEMPLATE = $template
  CACHESIZE = "250"
}

new-AlVcenterConnector -websession $websession -username $usernamevc -vcenter $vcentername -vcenterpass $vcenterpassword @params
```