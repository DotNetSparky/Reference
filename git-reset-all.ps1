[CmdletBinding()]
Param(
    [int] $Depth = 5,
    [switch] $Hard,
    [switch] $List
)

$skip = @(
    '\\ref\\'
)

$failedCount = 0
$successCount = 0
$failedList = @()

$activity = "Scanning for Repositories"
Write-Progress -Activity $activity -PercentComplete -1

$rootPath = Get-Location
# unlike for fetch, don't restrict to only directories, additional workspaces will have a ".git" file...
$repos = @(
    Get-ChildItem -Filter ".git" -Depth $Depth -Hidden -Recurse `
    | Where-Object {
        # don't include the root (this is the repo that contains these utility scripts)
        # don't include anything underneath a .git folder
        $p = Split-Path $_.FullName -Parent
        $p -ne $rootPath -and $p -notmatch "\\\.git\\"
    } `
    | Select-Object -ExpandProperty FullName
    | Where-Object { $_ -notmatch $skip }
)

if ($List) {
    foreach ($i in $repos) {
        Write-Host $i
    }
    exit 0
}

$activity = "Reset"
if ($Hard) {
    $activity += ' (hard)'
}
else {
    $activity += ' (soft)'
}

Write-Progress -Activity $activity -PercentComplete 0

$total = $repos.Count
$n = 0
foreach ($i in $repos) {
    $path = Resolve-Path (Split-Path $i -Parent) -Relative
    $name = Split-Path $path -Leaf

    Push-Location $path
    try {
        $percent = $n * 100 / $total

        $status = "$n/$($total): ($($name)) $($path)"
        Write-Progress -Activity $activity -Status $status -PercentComplete $percent

        if ($Hard) {
            git reset --hard # 1>$null
        }
        else {
            git reset --soft # 1>$null
        }
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
if ( $retryCount -gt 0 ) { Write-Host "Retries: $retryCount" }
if ( $failedCount -gt 0 )
{
    Write-Host "Failed: $failedCount"
    foreach ($i in $failedList) {
        Write-Host "  >> " + $i
    }
    exit 1
}
