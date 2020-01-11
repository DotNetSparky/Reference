# test copy

$repos = (Import-Csv -Delimiter "`t" -Path '.\repositories.txt')

if ((-not $repos) -or ($repos.Count -eq 0)) { Exit 1 }
Write-Host "Count: $($repos.Count)"

$successCount = 0
$failedCount = 0
$retryCount = 0

$activity = "Cloning Repositories"

$total = $repos.Count
$n = 0
foreach ($i in $repos) {
    $n += 1
    $status = "$n/$($total): ($($i.Path)) $($i.Url)"
    $percent = ($n - 1) * 100 / $total

    Write-Progress -Activity $activity -Status $status -PercentComplete $percent

    $gitPath = Join-Path $i.Path ".git"
    if (-not (Test-Path $gitPath)) {

        if (-not (Test-Path $i.Path)) {
            New-Item $i.Path -ItemType Directory | Out-Null
        }

        git clone $i.Url $i.Path
        if ($?) {
            $successCount += 1
        }
        else {
            $failedCount += 1
        }
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
