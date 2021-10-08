Function Print-SnipeItLabel {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0)]
        [String] $asset_tag,
        [int] $count=1,
        [string]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

                Get-SnipeitValidLabel | Where {$_.startswith($WordToComplete)}
            }
        )]
        [ValidateScript(
            {
                $_ -in (Get-SnipeitValidLabel)
            }
        )]
        $label = "example-label.prn",
        [string]
        $Printer = "ZPR123456789"
    )

    # Getting the Asset
    $asset = Get-SnipeitAsset -asset_tag $asset_tag -ErrorAction SilentlyContinue

    if(-not $asset){
        Write-Error "Asset $asset_tag not found"
        return
    }
    
    # Getting the raw Label
    $raw_label = Get-Content $PSScriptRoot\..\Labels\$label


    # Replacing Lines
    for($i = 0; $i -lt $raw_label.Count; $i++){
        $raw_label[$i] = $raw_label[$i].Replace("{{name}}",$asset.name)
        $raw_label[$i] = $raw_label[$i].Replace("{{ID}}",$asset.id)
        $raw_label[$i] = $raw_label[$i].Replace("{{serial}}",$asset.serial)
        $raw_label[$i] = $raw_label[$i].Replace("{{tag}}",$asset.asset_tag)
        $raw_label[$i] = $raw_label[$i].Replace("{{name}}",$asset.name)
        $raw_label[$i] = $raw_label[$i].Replace("{{company}}",$asset.company.name)
        $raw_label[$i] = $raw_label[$i].Replace("{{model}}",$asset.model.name.Replace("&quot;","`""))
        $raw_label[$i] = $raw_label[$i].Replace("{{purchase_date}}",$asset.purchase_date.formatted)
    }


    
    $tcpConnection = New-Object System.Net.Sockets.TcpClient($Printer, "9100")
    $tcpStream = $tcpConnection.GetStream()
    $reader = New-Object System.IO.StreamReader($tcpStream)
    $writer = New-Object System.IO.StreamWriter($tcpStream)
    $writer.AutoFlush = $true

    if ($tcpConnection.Connected)
    {

        for($y = 0; $y -lt $Count; $y++){

            for($i = 0; $i -lt $raw_label.Count; $i++){

                $writer.WriteLine($raw_label[$i] ) | Out-Null
                #$raw_label[$i]

            }
        }
    
        start-sleep -Milliseconds 500
    }

    $reader.Close()
    $writer.Close()
    $tcpConnection.Close()
}
