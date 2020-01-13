$repos = (Import-Csv -Delimiter "`t" -Path '.\repositories.txt')

if ((-not $repos) -or ($repos.Count -eq 0)) { Exit 1 }
Write-Host "Count: $($repos.Count)"

$maxRetries = 5
$failedCount = 0
$retryCount = 0
$successCount = 0

$activity = "Cloning Repositories"
Write-Progress -Activity $activity -PercentComplete -1

$total = $repos.Count
$n = 0
$repos | ForEach-Object {
    $path = $_.Path
    $name = Split-Path $path -Leaf

    $nRetry = 0
    while ($nRetry -lt $maxRetries)
    {
        $percent = ($n * $maxRetries + $nRetry) * 100 / ($total * $maxRetries)

        $status = "$n/$($total): ($($name)) $($path)"
        if ($nRetry -gt 0) {
            $status += " (attempt $nRetry/$maxRetries)"
        }
        Write-Progress -Activity $activity -Status $status -PercentComplete $percent

        $gitPath = Join-Path $path ".git"
        if (-not (Test-Path $gitPath)) {

            if (-not (Test-Path $path)) {
                New-Item $path -ItemType Directory | Out-Null
            }

            git clone $_.Url $path
            if ($?)
            {
                $successCount += 1
                break
            }
        }
        $nRetry += 1
        $retryCount += 1
        if ($nRetry -ge $maxRetries) { $failedCount += 1 }
    }

    $n += 1
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
