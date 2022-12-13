function Invoke-ALPublish {
  <#
.SYNOPSIS
  Publishes image(template)
.DESCRIPTION
  Publishes image(template)
.PARAMETER imageid
  Image ID's to be published
.PARAMETER websession
  Existing Webrequest session for ELM Appliance
.EXAMPLE
  $images = Get-ALimage -websession $websession|where{$_.name -eq "Win 10 Accounting"}
  $image = get-alimagedetail -websession $websession -id $images.Id
  invoke-alpublish -websession $websession -imageid $images.id
#>
  [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param(
    [Parameter(Mandatory = $true)]$websession,
    [Parameter(Mandatory = $true)][array]$imageid,
    [Parameter(Mandatory = $false)][array]$description = ""
  )
  Begin {
    Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
    Test-ALWebsession -WebSession $websession
  }
  Process {
      if ([string]::IsNullOrWhiteSpace($description)) {
        $description = "" 
      }

    [xml]$xml = @"
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <ExportImage xmlns="http://www.unidesk.com/">
      <command>
        <ImageIds>
          <long>$imageid</long>
        </ImageIds>
        <Reason>
          <Description>$description</Description>
          <ReferenceNumber>0</ReferenceNumber>
        </Reason>
      </command>
    </ExportImage>
  </s:Body>
</s:Envelope>
"@
    Write-Verbose $xml
    # If multiple ImageIds are provided loopt trough the $imageid's and merge the xml blocks
    if ((![string]::IsNullOrWhiteSpace($imageid)) -and ($imageid.count -gt 1)) {
      # Remove original ImageIds node to be able to recreate it as a new element
      $ChildNode = "ImageIds"
      ($xml.envelope.body.ExportImage.command.ChildNodes | Where-Object { $ChildNode -contains $_.Name }) | ForEach-Object { [void]$_.ParentNode.RemoveChild($_) }

      # Retrieve NamespaceUri from parent
      $xdNS = $xml.envelope.body.ExportImage.command.NamespaceURI

      # Define Root Element
      $ImageIdsNode = $xml.CreateNode([Xml.XmlNodeType]::Element, $ChildNode, $xdNS);
    
      # Define Element and values for each provided imageid
      for ($i = 0; $i -lt $imageid.Length; $i++) {
    
        $NewElementName = $xml.CreateNode([Xml.XmlNodeType]::Element, "long", $xdNS);
        $NewElementName.InnerText = $imageid[$i]

        # Append the element with their values
        $ImageIdsNode.AppendChild($NewElementName) | Out-Null
      }

      # Merge with origin
      $xml.envelope.body.ExportImage.command.AppendChild($ImageIdsNode) | Out-Null
    }

    $headers = @{
      SOAPAction     = "http://www.unidesk.com/ExportImage";
      "Content-Type" = "text/xml; charset=utf-8";
      UNIDESK_TOKEN  = $websession.token;
    }
    $url = "https://" + $websession.aplip + "/Unidesk.Web/API.asmx"
    if ($PSCmdlet.ShouldProcess("Publishing $imageid")) {
      $return = Invoke-WebRequest -Uri $url -Method Post -Body $xml -Headers $headers -WebSession $websession
      [xml]$obj = $return.Content


      if ($obj.Envelope.Body.ExportImageResponse.ExportImageResult.Error) {
        throw $obj.Envelope.Body.ExportImageResponse.ExportImageResult.Error.message

      }
      else {
        Write-Verbose "WORKTICKET: $($obj.Envelope.Body.ExportImageResponse.ExportImageResult.WorkTicketId)"
        return $obj.Envelope.Body.ExportImageResponse.ExportImageResult.WorkTicketId
      }
    }
  }
  end { Write-Verbose "END: $($MyInvocation.MyCommand)" }
}