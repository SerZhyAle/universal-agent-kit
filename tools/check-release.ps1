[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Catalog,
    [string]$Date = [DateTime]::UtcNow.ToString('yyyy-MM-dd')
)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    $sza = ((Get-Content "$HOME/.claude/plugins/installed_plugins.json" -Raw | ConvertFrom-Json).plugins.'sza@sza-unified-rules' |
        Sort-Object lastUpdated -Descending | Select-Object -First 1).installPath
    if (-not $sza -or -not (Test-Path "$sza/tools/check-compliance.ps1")) { throw 'sza compliance gate not found' }
    if (-not (Test-Path -LiteralPath $Catalog -PathType Container)) { throw 'Catalog directory not found' }
    function Run-Gate([string[]]$Arguments) {
        & pwsh -NoProfile @Arguments
        if ($LASTEXITCODE -ne 0) { throw "Release gate failed: $($Arguments -join ' ') (exit $LASTEXITCODE)" }
    }
    Run-Gate -Arguments @('-File', 'tools/build-kit.ps1', '-Date', $Date)
    Run-Gate -Arguments @('-File', 'tools/build-portal.ps1')
    Run-Gate -Arguments @('-File', 'tools/build-portal.ps1', '-Validate')
    Run-Gate -Arguments @('-File', 'tools/build-portal.ps1', '-Check')
    Run-Gate -Arguments @('-File', 'tools/check-site.ps1')
    Run-Gate -Arguments @('-File', "$sza/tools/check-compliance.ps1")
    & python -I tools/ui-check/run.py --catalog $Catalog
    if ($LASTEXITCODE -eq 2) { throw 'Browser gate COULD NOT VERIFY (exit 2); release blocked' }
    if ($LASTEXITCODE -ne 0) { throw "Browser gate failed (exit $LASTEXITCODE)" }
    Write-Host 'PASS: publish pre-flight'
} finally { Pop-Location }
