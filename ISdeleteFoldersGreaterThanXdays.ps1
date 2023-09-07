$directoryPath = "C:\Path\To\Directory
$thresholdDate = (Get-Date).AddDays(-60) # The number 60 is the number of days the last time the folder was modified.
$subfolders = Get-ChildItem -Path $directoryPath -Directory
$olderFolders = $subfolders | Where-Object { $_.LastWriteTime -lt $thresholdDate }
if ($olderFolders.Count -gt 0) {
    foreach ($subfolder in $subfolders) {
    if ($subfolder.LastWriteTime -lt $thresholdDate) {
        Remove-Item -Path $subfolder.FullName -Recurse -Force
        Write-Host "Deleted: $($subfolder.FullName)"
    }
}
} else {
    Write-Host "No folders whose last modified date is older than 60 days"
}