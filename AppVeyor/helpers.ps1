Function Test-Encoding
{
[CmdletBinding()] 
  Param (
  [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)] 
  [string]$Path
  )   
        $contents = new-object byte[] 3
        $stream = [System.IO.File]::OpenRead($path)
        $stream.Read($contents, 0, 3)|out-null
        $stream.Close()
        ($contents[0] -eq 0x66 -and $contents[1] -eq 0x75 -and $contents[2] -eq 0x6E) -or ($contents[0] -eq 0x20 -and $contents[1] -eq 0x66 -and $contents[2] -eq 0x75) -or ($contents[0] -eq 0x24 -and $contents[1] -eq 0x50 -and $contents[2] -eq 0x75) -or ($contents[0] -eq 70 -and $contents[1] -eq 117 -and $contents[2] -eq 110)

}