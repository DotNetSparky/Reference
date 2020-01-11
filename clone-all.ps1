# store the current dir
$savedir = Get-Location

# Let the person running the script know what's going on.
Write-Host "Cloning all repositories..."

# /d/Projects/reference/microsoft/aspnet/aspnet-docker
if (-not (Test-Path aspnet/aspnet-docker)) { git clone https://github.com/aspnet/aspnet-docker.git aspnet/aspnet-docker/ }
# /d/Projects/reference/microsoft/aspnet/AspNetCore
if (-not (Test-Path aspnet/AspNetCore)) { git clone $a aspnet/AspNetCore }
# /d/Projects/reference/microsoft/aspnet/BuildTools
if (-not (Test-Path aspnet/BuildTools)) { git clone $a aspnet/BuildTools }
# /d/Projects/reference/microsoft/aspnet/CORS
if (-not (Test-Path aspnet/CORS)) { git clone $a aspnet/CORS }
# /d/Projects/reference/microsoft/aspnet/EntityFrameworkCore
if (-not (Test-Path aspnet/EntityFrameworkCore)) { git clone $a aspnet/EntityFrameworkCore }
# /d/Projects/reference/microsoft/aspnet/Extensions
if (-not (Test-Path aspnet/Extensions)) { git clone $a aspnet/Extensions }
# /d/Projects/reference/microsoft/aspnet/HttpAbstractions
if (-not (Test-Path aspnet/HttpAbstractions)) { git clone $a aspnet/HttpAbstractions }
# /d/Projects/reference/microsoft/aspnet/IISIntegration
if (-not (Test-Path aspnet/IISIntegration)) { git clone $a aspnet/IISIntegration }
# /d/Projects/reference/microsoft/aspnet/KestrelHttpServer
if (-not (Test-Path aspnet/KestrelHttpServer)) { git clone $a aspnet/KestrelHttpServer }
# /d/Projects/reference/microsoft/aspnet/MetaPackages
if (-not (Test-Path aspnet/MetaPackages)) { git clone $a aspnet/MetaPackages }
# /d/Projects/reference/microsoft/aspnet/Mvc
if (-not (Test-Path aspnet/Mvc)) { git clone $a aspnet/Mvc }
# /d/Projects/reference/microsoft/aspnet/Razor
if (-not (Test-Path aspnet/Razor)) { git clone $a aspnet/Razor }
# /d/Projects/reference/microsoft/aspnet/Routing
if (-not (Test-Path aspnet/Routing)) { git clone $a aspnet/Routing }
# /d/Projects/reference/microsoft/aspnet/websdk
if (-not (Test-Path aspnet/websdk)) { git clone $a aspnet/websdk }
# /d/Projects/reference/microsoft/aspnet-archived/JsonPatch
if (-not (Test-Path aspnet-archived/JsonPatch)) { git clone $a aspnet-archived/JsonPatch }
# /d/Projects/reference/microsoft/dotnet/arcade
if (-not (Test-Path dotnet/arcade)) { git clone $a dotnet/arcade }
# /d/Projects/reference/microsoft/dotnet/arcade-minimalci-sample
if (-not (Test-Path dotnet/arcade-minimalci-sample)) { git clone $a dotnet/arcade-minimalci-sample }
# /d/Projects/reference/microsoft/dotnet/arcade-services
if (-not (Test-Path dotnet/arcade-services)) { git clone $a dotnet/arcade-services }
# /d/Projects/reference/microsoft/dotnet/buildtools
if (-not (Test-Path dotnet/buildtools)) { git clone $a dotnet/buildtools }
# /d/Projects/reference/microsoft/dotnet/cli
if (-not (Test-Path dotnet/cli)) { git clone $a dotnet/cli }
# /d/Projects/reference/microsoft/dotnet/CliCommandLineParser
if (-not (Test-Path dotnet/CliCommandLineParser)) { git clone $a dotnet/CliCommandLineParser }
# /d/Projects/reference/microsoft/dotnet/core
if (-not (Test-Path dotnet/core)) { git clone $a dotnet/core }
# /d/Projects/reference/microsoft/dotnet/core-sdk
if (-not (Test-Path dotnet/core-sdk)) { git clone $a dotnet/core-sdk }
# /d/Projects/reference/microsoft/dotnet/core-setup
if (-not (Test-Path dotnet/core-setup)) { git clone $a dotnet/core-setup }
# /d/Projects/reference/microsoft/dotnet/coreclr
if (-not (Test-Path dotnet/coreclr)) { git clone $a dotnet/coreclr }
# /d/Projects/reference/microsoft/dotnet/corefx
if (-not (Test-Path dotnet/corefx)) { git clone $a dotnet/corefx }
# /d/Projects/reference/microsoft/dotnet/corefxlab
if (-not (Test-Path dotnet/corefxlab)) { git clone $a dotnet/corefxlab }
# /d/Projects/reference/microsoft/dotnet/docfx
if (-not (Test-Path dotnet/docfx)) { git clone $a dotnet/docfx }
# /d/Projects/reference/microsoft/dotnet/docker-tools
if (-not (Test-Path dotnet/docker-tools)) { git clone $a dotnet/docker-tools }
# /d/Projects/reference/microsoft/dotnet/dotnet-ci
if (-not (Test-Path dotnet/dotnet-ci)) { git clone $a dotnet/dotnet-ci }
# /d/Projects/reference/microsoft/dotnet/dotnet-docker
if (-not (Test-Path dotnet/dotnet-docker)) { git clone $a dotnet/dotnet-docker }
# /d/Projects/reference/microsoft/dotnet/metadata-tools
if (-not (Test-Path dotnet/metadata-tools)) { git clone $a dotnet/metadata-tools }
# /d/Projects/reference/microsoft/dotnet/orleans
if (-not (Test-Path dotnet/orleans)) { git clone $a dotnet/orleans }
# /d/Projects/reference/microsoft/dotnet/orleans-templates
if (-not (Test-Path dotnet/orleans-templates)) { git clone $a dotnet/orleans-templates }
# /d/Projects/reference/microsoft/dotnet/project-system
if (-not (Test-Path dotnet/project-system)) { git clone $a dotnet/project-system }
# /d/Projects/reference/microsoft/dotnet/project-system-tools
if (-not (Test-Path dotnet/project-system-tools)) { git clone $a dotnet/project-system-tools }
# /d/Projects/reference/microsoft/dotnet/ProjFileTools
if (-not (Test-Path dotnet/ProjFileTools)) { git clone $a dotnet/ProjFileTools }
# /d/Projects/reference/microsoft/dotnet/roslyn-analyzers
if (-not (Test-Path dotnet/roslyn-analyzers)) { git clone $a dotnet/roslyn-analyzers }
# /d/Projects/reference/microsoft/dotnet/roslyn-sdk
if (-not (Test-Path dotnet/roslyn-sdk)) { git clone $a dotnet/roslyn-sdk }
# /d/Projects/reference/microsoft/dotnet/roslyn-tools
if (-not (Test-Path dotnet/roslyn-tools)) { git clone $a dotnet/roslyn-tools }
# /d/Projects/reference/microsoft/dotnet/sdk
if (-not (Test-Path dotnet/sdk)) { git clone $a dotnet/sdk }
# /d/Projects/reference/microsoft/dotnet/standard
if (-not (Test-Path dotnet/standard)) { git clone $a dotnet/standard }
# /d/Projects/reference/microsoft/dotnet/templates
if (-not (Test-Path dotnet/templates)) { git clone $a dotnet/templates }
# /d/Projects/reference/microsoft/dotnet/toolset
if (-not (Test-Path dotnet/toolset)) { git clone $a dotnet/toolset }
# /d/Projects/reference/microsoft/dotnet/versions
if (-not (Test-Path dotnet/versions)) { git clone $a dotnet/versions }
# /d/Projects/reference/microsoft/dotnet-architecture/eShopOnWeb
if (-not (Test-Path dotnet-architecture/eShopOnWeb)) { git clone $a dotnet-architecture/eShopOnWeb }
# /d/Projects/reference/microsoft/reference-source
if (-not (Test-Path reference-source)) { git clone $a reference-source }

Set-Location $saveDir

Write-Host "Complete!"

exit 0
