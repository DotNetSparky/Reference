# store the current dir
$rootDir = Get-Location

# Let the person running the script know what's going on.
Write-Host "Checkout for all repositories..."

# Find all git repositories and update it to the master latest revision
foreach ($i in (Get-ChildItem -Filter ".git" -Directory -Hidden -Recurse))
{
    $path = [System.IO.Path]::GetDirectoryName($i.FullName)
    Write-Host ""
    Write-Host $path

    # We have to go to the .git parent directory to call the pull command
    Set-Location $path

    git checkout release/2.1

    # lets get back to the CUR_DIR
    Set-Location $rootDir
}

Write-Host "Complete!"

exit 0
