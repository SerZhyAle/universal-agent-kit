<#
.SYNOPSIS
    Rebuild universal-agent-kit.zip from kit/ and stamp the kit's update date into the site.

.DESCRIPTION
    The zip and the date on the page are render targets of kit/: this script is the one way to
    produce both, so the download and the date the site shows cannot disagree.

    1. Writes the date to kit/VERSION (one line, yyyy-MM-dd, LF, no BOM), so the zip and every copy
       merged from it can say which kit it came from.
    2. Stages kit/* and merge-prompt.txt under universal-agent-kit/ (the frozen extraction root)
       and zips the stage without the stage folder itself in the entry paths.
    3. Verifies every archive entry byte-for-byte (SHA-256) against its source file.
    4. Stamps the date into index.html (every time.kit-date, JSON-LD dateModified) and sitemap.xml.

    Exits 0 after verifying and stamping a release. Exits 1 when the generated archive differs from its
    source. Exits 2 when a required input cannot be read or a required stamp location is absent; those
    inputs are verified before any release surface is rewritten.

.PARAMETER Date
    The date to stamp, yyyy-MM-dd. Defaults to today in UTC.
#>
[CmdletBinding()]
param(
    [string]$Date = [DateTime]::UtcNow.ToString('yyyy-MM-dd')
)

$ErrorActionPreference = 'Stop'

$root   = Split-Path -Parent $PSScriptRoot
$kit    = Join-Path $root 'kit'
$prompt = Join-Path $root 'merge-prompt.txt'
$zip    = Join-Path $root 'universal-agent-kit.zip'
$stage  = Join-Path $root 'temp/_uak_build'
$anchor = 'universal-agent-kit'

function Get-StampHits([string]$path, [string]$pattern) {
    $text = [System.IO.File]::ReadAllText($path)
    return [regex]::Matches($text, $pattern).Count
}
function Set-Stamp([string]$path, [string]$pattern, [string]$replacement) {
    $text = [System.IO.File]::ReadAllText($path)
    [System.IO.File]::WriteAllText($path, [regex]::Replace($text, $pattern, $replacement), $utf8)
}
$index = Join-Path $root 'index.html'
$sitemap = Join-Path $root 'sitemap.xml'
$timePattern = '(<time class="kit-date" datetime=")\d{4}-\d{2}-\d{2}(">)\d{4}-\d{2}-\d{2}(</time>)'
$ldPattern = '("dateModified": ")\d{4}-\d{2}-\d{2}(")'
$mapPattern = '(<lastmod>)\d{4}-\d{2}-\d{2}(</lastmod>)'

try {
    # --- 1. verify every input before changing a release surface -----------------------------
    if ($Date -notmatch '^\d{4}-\d{2}-\d{2}$') {
        Write-Host "INPUT INVALID date: $Date"
        Write-Host 'build-kit: COULD NOT VERIFY - required release input is invalid'
        exit 2
    }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    $missing = [System.Collections.Generic.List[string]]::new()
    foreach ($input in @(
        @{ Path = $kit; Type = 'Container'; Label = 'kit source directory' },
        @{ Path = $prompt; Type = 'Leaf'; Label = 'merge prompt' },
        @{ Path = $index; Type = 'Leaf'; Label = 'site page' },
        @{ Path = $sitemap; Type = 'Leaf'; Label = 'site map' }
    )) {
        if (-not (Test-Path -LiteralPath $input.Path -PathType $input.Type)) {
            $missing.Add("$($input.Label): $($input.Path)")
        }
    }

    if ($missing.Count -eq 0) {
        $timeHits = Get-StampHits $index $timePattern
        $ldHits = Get-StampHits $index $ldPattern
        $mapHits = Get-StampHits $sitemap $mapPattern
        if ($timeHits -eq 0) { $missing.Add("time.kit-date stamp: $index") }
        if ($ldHits -eq 0) { $missing.Add("dateModified stamp: $index") }
        if ($mapHits -eq 0) { $missing.Add("lastmod stamp: $sitemap") }
    }

    if ($missing.Count -gt 0) {
        foreach ($reason in $missing) { Write-Host "INPUT MISSING $reason" }
        Write-Host 'build-kit: COULD NOT VERIFY - required release input is missing'
        exit 2
    }

    # --- 2. write the kit's own build date, then stage and zip -------------------------------
    [System.IO.File]::WriteAllText((Join-Path $kit 'VERSION'), "$Date`n", $utf8)
    if (Test-Path $stage) { [System.IO.Directory]::Delete($stage, $true) }
    $inner = Join-Path $stage $anchor
    New-Item -ItemType Directory -Path $inner -Force | Out-Null
    Copy-Item -Path (Join-Path $kit '*') -Destination $inner -Recurse -Force
    Copy-Item -Path $prompt -Destination $inner -Force

    if (Test-Path $zip) { Remove-Item -LiteralPath $zip -Force }
    [System.IO.Compression.ZipFile]::CreateFromDirectory($stage, $zip, 'Optimal', $false)

    # --- 3. verify every archive entry against its source ------------------------------------
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $archive = [System.IO.Compression.ZipFile]::OpenRead($zip)
    $entries = 0; $mismatches = 0
    try {
        foreach ($e in $archive.Entries) {
            if ($e.FullName.EndsWith('/')) { continue }
            $entries++
            $rel = $e.FullName.Substring($anchor.Length + 1)
            $src = if ($rel -eq 'merge-prompt.txt') { $prompt } else { Join-Path $kit $rel }
            $s = $e.Open()
            try { $zipHash = [BitConverter]::ToString($sha.ComputeHash($s)) } finally { $s.Dispose() }
            $srcHash = [BitConverter]::ToString($sha.ComputeHash([System.IO.File]::ReadAllBytes($src)))
            if ($zipHash -ne $srcHash) { $mismatches++; Write-Host "MISMATCH $($e.FullName)" }
        }
    } finally {
        $archive.Dispose()
        $sha.Dispose()
    }
    $sourceCount = (Get-ChildItem -Path $kit -Recurse -File -Force).Count + 1
    [System.IO.Directory]::Delete($stage, $true)

    # --- 4. stamp the date --------------------------------------------------------------------
    Set-Stamp $index $timePattern "`${1}$Date`${2}$Date`${3}"
    Set-Stamp $index $ldPattern "`${1}$Date`${2}"
    Set-Stamp $sitemap $mapPattern "`${1}$Date`${2}"

    Write-Host "zip:     $entries entries (sources: $sourceCount), $mismatches mismatch(es)"
    Write-Host "stamped: $Date - kit/VERSION, $timeHits time.kit-date, $ldHits dateModified, $mapHits lastmod"

    if ($mismatches -gt 0 -or $entries -ne $sourceCount) {
        Write-Host 'build-kit: DEFECT - generated archive differs from its source'
        exit 1
    }
    Write-Host 'build-kit: PASS'
} catch {
    Write-Host "ERROR $($_.Exception.Message)"
    Write-Host 'build-kit: COULD NOT VERIFY - build process could not complete'
    exit 2
}
