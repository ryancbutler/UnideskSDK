function Set-ALConnectorCreds {
<#
.SYNOPSIS
  Sets Connector Credentials
.DESCRIPTION
  Sets Connector Username and Pass
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.PARAMETER config
  Configuration settings for specific connector (Use get-alconnectordetail)
.PARAMETER connector
  Configurations for specific connector (Use get-alconnector)
.PARAMETER UserName
  Username to be used for Connector
.PARAMETER password
  password to be used for Connector
.EXAMPLE
  Set-ALconnectorCreds -websession $websession -config $ConnectorConfig -connector $connector -username "domain\first.last" -password "Test123
#>
[cmdletbinding()]
Param(
[Parameter(Mandatory=$true)]$websession,
[Parameter(Mandatory=$true)][string]$username,
[Parameter(Mandatory=$true)][string]$password,
[Parameter(Mandatory=$true)][PSCustomObject]$config,
[Parameter(Mandatory=$true)][PSCustomObject]$connector
)
Begin {Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"}

Process{

#do the request
$headers = @{
  "Cookie" = ("UMCSessionCoookie=" + $($websession.token))
  "Accept" = "*/*"
  "Content-Type" = "application/json"
  "Host" = "$($websession.aplip):$($connector.ConfigurationSslPort)"
  "Referer" =  "https://$($websession.aplip):$($connector.ConfigurationSslPort)/ui/"
}
try
{
    $urlv = "https://$($websession.aplip):$($connector.ConfigurationSslPort)/api/Configurations/Verify"
    $url = "https://$($websession.aplip):$($connector.ConfigurationSslPort)/api/Configurations/$($connector.Id)"
    
    Write-host "Old Config:" -ForegroundColor Yellow
    $config | FL
    
    $config.pccConfig.userName = $username
    $config.pccConfig | Add-Member -MemberType NoteProperty -Name password -Value $password
    $configjson = $config |ConvertTo-Json -Depth 100

    Write-host "New Config:" -ForegroundColor Green
    $config | FL
   
    Write-host "Verifying Connector Creds..."
    $verify = Invoke-RestMethod -Method Post -Uri $urlv -WebSession $websession -Headers $headers -Body $configJSON
    Write-host "Changing Connector Creds..."
    $content = Invoke-RestMethod -Method Put -Uri $url -WebSession $websession -Headers $headers -Body $configJSON
    Write-host "Change Successful" -ForegroundColor Green
    
} catch {
  if($_.ErrorDetails.Message)
  {
    $temp = $_.ErrorDetails.Message|ConvertFrom-Json
    if($temp.message)
    {
      Write-error $temp.message
    }
    else {
      Write-error $temp.error.message
      Write-error $temp.error.sqlmessage
      write-error $temp.error.staus
    }
    throw "Process failed!"
  }
  else {
    Write-error $temp.error.message
    Write-error $temp.error.sqlmessage
    write-error $temp.error.staus
  }
} finally {
    
    
}

return $content
}
end{Write-Verbose "END: $($MyInvocation.MyCommand)"}
}
