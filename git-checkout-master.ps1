$failedCount = 0
$successCount = 0

$activity = "Scanning for Repositories"
Write-Progress -Activity $activity -PercentComplete -1

$rootPath = Get-Location
$repos = @(Get-ChildItem -Filter ".git" -Depth 3 -Directory -Hidden -Recurse | Select-Object -ExpandProperty FullName | Where-Object { (Split-Path $_ -Parent) -ne $rootPath } )

$branch = "master"

$activity = "Checkout $branch"
Write-Progress -Activity $activity -PercentComplete 0

$total = $repos.Count
$n = 0
$repos | ForEach-Object {
    $path = Resolve-Path (Split-Path $_ -Parent) -Relative
    $name = Split-Path $path -Leaf

    Push-Location $path
    try {
        $percent = $n * 100 / $total

        $status = "$n/$($total): ($($name)) $($path)"
        Write-Progress -Activity $activity -Status $status -PercentComplete $percent

        git checkout $branch
        if ($?)
        {
            $successCount += 1
        }
        else
        {
            $failedCount += 1
        }
        $n += 1
    }
    finally {
        Pop-Location
    }
}

Write-Progress -Activity $activity -Completed
Write-Host "Complete!"

Write-Host "Success: $successCount"
if ( $retryCount -gt 0 ) { Write-Host "Retries: $retryCount" }
if ( $failedCount -gt 0 )
{
    Write-Host "Failed: $failedCount"
    exit 1
}
