[CmdletBinding()]
Param(
    [switch] $connectivityOnly,
    [switch] $dangling,
    [switch] $full,
    [switch] $progress,
    [switch] $strict
)

$failedCount = 0
$successCount = 0
$failedList = @()

$activity = "Scanning for Repositories"
Write-Progress -Activity $activity -PercentComplete -1

$rootPath = Get-Location
$repos = @(Get-ChildItem -Filter ".git" -Depth 3 -Directory -Hidden -Recurse | Select-Object -ExpandProperty FullName | Where-Object { (Split-Path $_ -Parent) -ne $rootPath } )

$activity = "Git 'fsck'"
Write-Progress -Activity $activity -PercentComplete 0

$total = $repos.Count
$n = 0
foreach ($i in $repos) {
    $path = Resolve-Path (Split-Path $i -Parent) -Relative
    $name = Split-Path $path -Leaf

    Push-Location $path
    try {
        $percent = $n * 100 / $total

        $gitArgs = @()
        if ($dangling) {
            $gitArgs += @('--dangling')
        }
        else {
            $gitArgs += @('--no-dangling')
        }
        if ($progress) {
            $gitArgs += @('--progress')
        }
        else {
            $gitArgs += @('--no-progress')
        }
        if ($full) {
            $gitArgs += @('--full')
        }
        if ($connectivityOnly) {
            $gitArgs += @('--connectivity-only')
        }
        if ($strict) {
            $gitArgs += @('--strict')
        }

        $status = "$n/$($total): ($($name)) $($path)"
        Write-Progress -Activity $activity -Status $status -PercentComplete $percent

        git fsck @gitArgs
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
