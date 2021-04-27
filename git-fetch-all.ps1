[CmdletBinding()]
Param(
    [int] $Depth = 5,
    [int] $MaxRetries = 5,
    [switch] $Force
)

$failedCount = 0
$retryCount = 0
$successCount = 0
$failedList = @()

$activity = "Scanning for Repositories"
Write-Progress -Activity $activity -PercentComplete -1

$rootPath = Get-Location
$repos = @(Get-ChildItem -Filter ".git" -Depth $Depth -Directory -Hidden -Recurse | Select-Object -ExpandProperty FullName | Where-Object { (Split-Path $_ -Parent) -ne $rootPath } )

$activity = "Fetching Repositories"
Write-Progress -Activity $activity -PercentComplete 0

$total = $repos.Count
$n = 0
foreach ($i in $repos) {
    $path = Resolve-Path (Split-Path $i -Parent) -Relative
    $name = Split-Path $path -Leaf

    Push-Location $path
    try {

        $gitArgs = @(
            "--all"
            "--tags"
            "--prune"
            "--prune-tags"
            "--recurse-submodules"
            "--quiet"
        )
        if ($Force) {
            $gitArgs += "--force"
        }

        $nRetry = 0
        while ($nRetry -lt $maxRetries)
        {
            $percent = ($n * $maxRetries + $nRetry) * 100 / ($total * $maxRetries)

            $status = "$n/$($total): ($($name)) $($path)"
            if ($nRetry -gt 0) {
                $status += " (attempt $nRetry/$maxRetries)"
            }
            Write-Progress -Activity $activity -Status $status -PercentComplete $percent

            git fetch @gitArgs 1>$null
            if ($?)
            {
                $successCount += 1
                break
            }
            $nRetry += 1
            $retryCount += 1
            if ($nRetry -ge $maxRetries) {
                $failedCount += 1
                $failedList += $path
            }
        }
        $n += 1
    }
    finally {
        Pop-Location
    }
}

Write-Progress -Activity $activity -Completed

Clear-Host
Write-Host "Complete!"

Write-Host "Success: $successCount"
if ( $retryCount -gt 0 ) { Write-Host "Retries: $retryCount" }
if ( $failedCount -gt 0 )
{
    Write-Host "Failed: $failedCount"
    foreach ($i in $failedList) {
        Write-Host "  >> " + $i
    }
    exit 1
}
