[CmdletBinding()]
Param(
    [int] $Depth = 5,
    [switch] $Aggressive,

    [switch] $FullRepack
)

if (-not $Path) {
    $Path = $PSScriptRoot
}

$failedCount = 0
$successCount = 0
$failedList = @()

$activity = "Scanning for Repositories"
Write-Progress -Activity $activity -PercentComplete -1

$rootPath = Get-Location
$repos = @(Get-ChildItem -Filter ".git" -Depth $Depth -Directory -Hidden -Recurse | Select-Object -ExpandProperty FullName | Where-Object { (Split-Path $_ -Parent) -ne $rootPath } )

$activity = "Git Garbage Collection"
Write-Progress -Activity $activity -PercentComplete 0

$gcArgs = @()
if ($Aggressive) {
    $gcArgs += "--aggressive"
}

$reflogExpireArgs = @(
    '--expire=1.month.ago'
)

$total = $repos.Count
$n = 0
foreach ($i in $repos) {
    $path = Resolve-Path (Split-Path $i -Parent) -Relative
    $name = Split-Path $path -Leaf

    Push-Location $path
    try {

        $percent = $n * 100 / $total
        $status = "$($n+1)/$($total): ($($name)) $($path)"
        Write-Progress -Activity $activity -Status $status -PercentComplete $percent

        $ok = $true

        if ($FullRepack) {
            if ($ok) {
                Write-Progress -Activity $activity -Status $status -CurrentOperation 'git remote prunt origin' -PercentComplete ((($n * 5 * 100) + 0) / ($total * 5))
                git remote prune origin
                $ok = $?
            }
            if ($ok) {
                Write-Progress -Activity $activity -Status $status -CurrentOperation 'git repack' -PercentComplete ((($n * 5 * 100) + 1) / ($total * 5))
                git repack
                $ok = $?
            }
            if ($ok) {
                Write-Progress -Activity $activity -Status $status -CurrentOperation 'git prune-packed' -PercentComplete ((($n * 5 * 100) + 2) / ($total * 5))
                git prune-packed
                $ok = $?
            }
            if ($ok) {
                Write-Progress -Activity $activity -Status $status -CurrentOperation 'git reflog expire' -PercentComplete ((($n * 5 * 100) + 3) / ($total * 5))
                git reflog expire @reflogExpireArgs
                $ok = $?
            }
        }

        if ($ok) {
            Write-Progress -Activity $activity -Status $status -CurrentOperation 'git gc' -PercentComplete ((($n * 5 * 100) + 4) / ($total * 5))
            git gc @gcArgs
            $ok = $?
        }

        if ($ok)
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
