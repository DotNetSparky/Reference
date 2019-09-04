$maxRetries = 5
$failedCount = 0
$retryCount = 0
$successCount = 0

# store the current dir
$rootDir = Get-Location

# Let the person running the script know what's going on.
Write-Host "Fetching latest changes for all repositories..."

# Find all git repositories and update it to the master latest revision
foreach ($i in (Get-ChildItem -Filter ".git" -Directory -Hidden -Recurse))
{
    $path = [System.IO.Path]::GetDirectoryName($i.FullName)
    Write-Host ""
    Write-Host $path

    # We have to go to the .git parent directory to call the pull command
    Set-Location $path

    $n = 0
    while ($n -lt $maxRetries)
    {
        git fetch --all --tags --prune --prune-tags --recurse-submodules
        if ($?)
        {
            $successCount += 1
            break
        }
        $n += 1
        $retryCount += 1
        if ($n -ge $maxRetries) { $failedCount += 1 }
    }

    # lets get back to the CUR_DIR
    Set-Location $rootDir
}

Write-Host "Complete!"
if ( $retryCount -gt 0 ) { Write-Host "Retries: $retryCount" }
if ( $failedCount -gt 0 )
{
    Write-Host "Failed: $failedCount"
    exit 1
}

exit 0
