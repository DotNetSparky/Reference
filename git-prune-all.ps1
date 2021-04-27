[CmdletBinding()]
Param(
    [int] $Depth = 5
)

$failedCount = 0
$successCount = 0
$failedList = @()

$activity = "Scanning for Repositories"
Write-Progress -Activity $activity -PercentComplete -1

$rootPath = Get-Location
$repos = @(Get-ChildItem -Filter ".git" -Depth $Depth -Directory -Hidden -Recurse | Select-Object -ExpandProperty FullName | Where-Object { (Split-Path $_ -Parent) -ne $rootPath } )

$activity = "Git Object Pruning"
Write-Progress -Activity $activity -PercentComplete 0

$total = $repos.Count
$n = 0
foreach ($i in $repos) {
    $path = Resolve-Path (Split-Path $i -Parent) -Relative
    $name = Split-Path $path -Leaf

    Push-Location $path
    try {

        $gitArgs = @()

        $percent = $n * 100 / $total
        $status = "$n/$($total): ($($name)) $($path)"
        Write-Progress -Activity $activity -Status $status -PercentComplete $percent

        git prune @gitArgs
        if ($?)
        {
            $successCount += 1
        }
        else
        {
            $failedCount += 1
            $failedList += $path
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
if ( $failedCount -gt 0 )
{
    Write-Host "Failed: $failedCount"
    foreach ($i in $failedList) {
        Write-Host "  >> " + $i
    }
    exit 1
}
