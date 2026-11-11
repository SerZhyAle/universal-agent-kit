<#
.SYNOPSIS
  Commit every change in the working tree and push it to GitHub.

.DESCRIPTION
  The push of `main` publishes this rolling repository (GitHub Pages serves the root), so the script
  runs the fast whitespace check first and shows what it is about to commit.

  The first step is `git add .`. Taken back out of the index right after it, on purpose: `.claude/` and
  `.sza-profile.json` (local agent state, untracked by decision). Pass -IncludeLocal to keep them staged.

.PARAMETER Message
  Commit message. Default: "Update <UTC timestamp>".

.PARAMETER Preflight
  Run the release pre-flight (tools/check-release.ps1) before committing. Needs -Catalog.

.PARAMETER Catalog
  Catalog root for the pre-flight (see CLAUDE.md, "Gate").

.PARAMETER NoPush
  Commit only.

.PARAMETER Yes
  Do not ask for confirmation.

.EXAMPLE
  pwsh -NoProfile -File deploy.ps1 -Message "Fix the landing text"
#>
[CmdletBinding()]
param(
    [string]$Message,
    [switch]$Preflight,
    [string]$Catalog,
    [switch]$NoPush,
    [switch]$IncludeLocal,
    [switch]$Yes
)

$ErrorActionPreference = 'Stop'
# The script works from the repository root or from tools/: take the first of the two that holds .git.
$root = $PSScriptRoot
if (-not (Test-Path -LiteralPath (Join-Path $root '.git'))) {
    $root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}
$tools = Join-Path $root 'tools'
Set-Location -LiteralPath $root

function Fail([string]$text, [int]$code = 1) {
    Write-Host "deploy: $text" -ForegroundColor Red
    exit $code
}

# Not named "Git": command lookup is case-insensitive and a function beats git.exe, so `& git` in here
# would call this function again until the call depth overflows.
function Invoke-Git {
    & git @args
    if ($LASTEXITCODE -ne 0) { Fail ("git " + ($args -join ' ') + " failed (exit $LASTEXITCODE)") }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Fail 'git is not on PATH' }
if (-not (Test-Path -LiteralPath (Join-Path $root '.git'))) { Fail "not a git repository: $root" }

$branch = (& git rev-parse --abbrev-ref HEAD).Trim()
if ($branch -eq 'HEAD') { Fail 'detached HEAD: check out a branch first' }
Write-Host "deploy: branch $branch, remote $((& git remote get-url origin).Trim())"

# "git add ." stages everything; the local agent state is then taken back out of the index.
function Stage-All {
    Invoke-Git add .
    if (-not $IncludeLocal) {
        foreach ($local in @('.claude', '.sza-profile.json')) {
            if (Test-Path -LiteralPath $local) { Invoke-Git reset --quiet -- $local }
        }
    }
}

# First step: stage everything.
Stage-All

if ($Preflight) {
    if (-not $Catalog) { Fail '-Preflight needs -Catalog <catalog root>' 2 }
    Write-Host 'deploy: release pre-flight (slow, several minutes)..'
    & pwsh -NoProfile -File (Join-Path $tools 'check-release.ps1') -Catalog $Catalog
    if ($LASTEXITCODE -ne 0) { Fail "pre-flight failed (exit $LASTEXITCODE); nothing was committed" }
    # The pre-flight rebuilds the render targets; stage what it regenerated.
    Stage-All
}

& git diff --cached --quiet
$hasStaged = ($LASTEXITCODE -ne 0)

if ($hasStaged) {
    # Fast check covers whitespace in the staged diff.
    $fast = Join-Path $tools 'check-fast.ps1'
    if (Test-Path -LiteralPath $fast) {
        & pwsh -NoProfile -File $fast
        if ($LASTEXITCODE -ne 0) { Fail "check-fast failed (exit $LASTEXITCODE); fix it and run again. Changes stay staged." }
    }

    Write-Host ''
    Write-Host 'deploy: about to commit:' -ForegroundColor Cyan
    Invoke-Git diff --cached --stat

    if (-not $Yes) {
        $what = if ($NoPush) { 'commit' } else { "commit and push to origin/$branch (this publishes the site)" }
        $answer = Read-Host "deploy: $what? [y/N]"
        if ($answer -notmatch '^(y|yes)$') {
            Invoke-Git reset --quiet
            Fail 'cancelled by the owner; the index was reset, the working tree is untouched' 3
        }
    }

    if (-not $Message) { $Message = 'Update ' + (Get-Date).ToUniversalTime().ToString('yyyy-MM-dd HH:mm') + ' UTC' }
    Invoke-Git commit -m $Message
} else {
    Write-Host 'deploy: nothing to commit'
}

if ($NoPush) { Write-Host 'deploy: -NoPush, done'; exit 0 }

# Push whatever is ahead of the remote (also commits made earlier by hand).
& git rev-parse --abbrev-ref --symbolic-full-name '@{u}' *> $null
if ($LASTEXITCODE -ne 0) {
    Invoke-Git push --set-upstream origin $branch
} else {
    $ahead = [int](& git rev-list --count '@{u}..HEAD')
    if ($ahead -eq 0) { Write-Host 'deploy: remote is already up to date'; exit 0 }
    Invoke-Git push
}

Write-Host "deploy: pushed $((& git rev-parse --short HEAD).Trim()) to origin/$branch" -ForegroundColor Green
