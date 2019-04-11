function Set-ALConnectorCred {
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
  Set-ALconnectorCred -websession $websession -config $ConnectorConfig -connector $connector -username "domain\first.last" -password "Test123
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact="High")]
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
    
    write-verbose "Old Config:"
    $config | Format-List
    
    $config.pccConfig.userName = $username
    $config.pccConfig | Add-Member -MemberType NoteProperty -Name password -Value $password
    $configjson = $config |ConvertTo-Json -Depth 100

    write-verbose "New Config:"
    $config | Format-List
   
    write-verbose "Verifying Connector Creds..."
    Invoke-RestMethod -Method Post -Uri $urlv -WebSession $websession -Headers $headers -Body $configJSON
    write-verbose "Changing Connector Creds..."
    if ($PSCmdlet.ShouldProcess("Setting Connector Password")) {
    $content = Invoke-RestMethod -Method Put -Uri $url -WebSession $websession -Headers $headers -Body $configJSON
    write-verbose "Change Successful"
    }

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
