# scan all sub-dirs and make a list of all repositories and their origin urls

$activity = "Scanning Repositories"
Write-Progress -Activity $activity -PercentComplete -1

$repos = @()
$rootPath = Get-Location

Get-ChildItem -Filter ".git" -Depth 3 -Directory -Hidden -Recurse | Where-Object { (Split-Path $_.FullName -Parent) -ne $rootPath } | ForEach-Object {
    $path = Resolve-Path (Split-Path $_.FullName -Parent) -Relative
    $name = Split-Path $path -Leaf

    Write-Progress -Activity $activity -Status "$($name): $path" -PercentComplete -1

    Push-Location $path
    try {
        $url = git remote get-url origin
        if ($?) {
            $branch = git branch --show-current
            $i = @{
                Name = $name
                Path = $path
                Url = $url
                Branch = $branch
            }
            $repos += $i
        }
    }
    finally {
        Pop-Location
    }
}

Write-Progress -Activity $activity -Completed

$repos = $repos | Sort-Object -Property Url

Write-Host ""
Write-Host "Found $($repos.Count) repositories"

$repos | Select-Object -Property Url,Name,Path,Branch | Format-Table -AutoSize
$repos | Select-Object -Property Url,Name,Path,Branch | Export-Csv -Delimiter "`t" -Path '.\repositories.txt'

exit 0
