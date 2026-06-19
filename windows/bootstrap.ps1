param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function New-DotfilesSymlink {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Target,
        [Parameter(Mandatory = $true)][string]$Name
    )

    $targetDir = Split-Path -Parent $Target
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    }

    if (Test-Path $Target) {
        $existing = Get-Item $Target
        if ($existing.LinkType -eq "SymbolicLink") {
            if ($Force) {
                Remove-Item -LiteralPath $Target -Force
            } else {
                Write-Host "$Name link already exists: $Target"
                return
            }
        } elseif (-not $Force) {
            $backup = "$Target.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
            Move-Item -LiteralPath $Target -Destination $backup
            Write-Host "Backed up existing $Name to $backup"
        } else {
            Remove-Item -LiteralPath $Target -Force
        }
    }

    try {
        New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    } catch {
        Write-Host "Failed to create $Name symlink." -ForegroundColor Red
        Write-Host "Enable Windows Developer Mode or rerun PowerShell as Administrator, then run this script again."
        throw
    }

    Write-Host "Linked ${Name}:"
    Write-Host "  $Target -> $Source"
}

$sourceProfile = Join-Path $repoRoot "windows\Microsoft.PowerShell_profile.ps1"
New-DotfilesSymlink -Source $sourceProfile -Target $PROFILE -Name "PowerShell profile"

$configDir = Join-Path $HOME ".config"
$starshipSource = Join-Path $repoRoot "mac\starship\.config\starship.toml"
$starshipTarget = Join-Path $configDir "starship.toml"

if (Test-Path $starshipSource) {
    New-DotfilesSymlink -Source $starshipSource -Target $starshipTarget -Name "starship config"
}
