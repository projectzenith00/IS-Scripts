$ntUSER = $Env:UserName
$applicationItems = @(
                        "Jitsi",
                        "APPServerClient",
                        "CommPeak Softphone"
                        "GoTo"
                      )

foreach($application in $applicationItems)
    {
        $applicationExtension = $application+".exe"
        $applicationExtensionMSI = $application+".exe"
        if (Get-WmiObject  Win32_Process | Where-Object {$_.Name -CLike $applicationExtension  -or $_.Name -CLike $applicationExtensionMSI}) {
            Stop-Process -Name $application -Force
            Wait-Process -Name $application -Timeout 30
            Write-Host "Application:" $application "has been closed"`n
        } else {
             Write-Host $application "is not running in the background"
        }
    }

$directories = @(
                    "C:\Users\$ntUSER\AppData\Local\Temp",
                    "C:\Users\$ntUSER\AppData\Local\commpeak-softphone-updater",
                    "C:\Users\$ntUSER\AppData\Roaming\commpeak-softphone-updater",
                    "C:\Users\$ntUSER\AppData\Local\Jitsi",
                    "C:\Users\$ntUSER\AppData\Roaming\Jitsi",
                    "C:\Users\$ntUSER\AppData\Roaming\2XClient",
                    "C:\Users\$ntUSER\AppData\Roaming\2XDumps",
                    "C:\Users\$ntUSER\AppData\Local\Temp\2XClientSpool"
                    "C:\Users\$ntUSER\AppData\Local\GoTo-test"
                )

foreach ($itemDirectory in $directories)
    {
        $files =  Get-ChildItem -Path $itemDirectory -File -Recurse
        $folders = Get-ChildItem -Path $itemDirectory -Directory -Recurse

        foreach ($file in $files) {
          try {
                $fileContent = [System.IO.File]::ReadAllBytes($file.FullName)
                Remove-Item $file.FullName -Force
                Write-Host "Deleted: $($file.FullName)"
            } catch {
                Write-Host "Skipped: $($file.FullName) - In use or access denied..."
            }
        }

        $folders | Sort-Object FullName -Descending | ForEach-Object {
            try {
                Remove-Item $_.FullName -Recurse -Force
                Write-Host "Deleted: $($_.FullName)"
            } catch {
                Write-Host "Skipped: $($_.FullName) - Either in use, access denied or not found"
            }
        }
    }