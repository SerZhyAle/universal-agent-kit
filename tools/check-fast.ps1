$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    git diff --check
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    git diff --cached --check
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Write-Host 'PASS: tracked working-tree and staged diff whitespace'
} finally { Pop-Location }
