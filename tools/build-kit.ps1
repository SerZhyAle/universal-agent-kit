<#
.SYNOPSIS
    Rebuild universal-agent-kit.zip from kit/ and stamp the kit's update date into the site.

.DESCRIPTION
    The zip and the date on the page are render targets of kit/: this script is the one way to
    produce both, so the download and the date the site shows cannot disagree.

    1. Stages kit/* and merge-prompt.txt under universal-agent-kit/ (the frozen extraction root)
       and zips the stage without the stage folder itself in the entry paths.
    2. Verifies every archive entry byte-for-byte (SHA-256) against its source file.
    3. Stamps the date into index.html (every time.kit-date, JSON-LD dateModified) and sitemap.xml.

    Exits 1 on any mismatch or on a stamp target that is missing, so a half-built release is never
    reported as done.

.PARAMETER Date
    The date to stamp, yyyy-MM-dd. Defaults to today in UTC.
#>
[CmdletBinding()]
param(
    [ValidatePattern('^\d{4}-\d{2}-\d{2}$')]
    [string]$Date = [DateTime]::UtcNow.ToString('yyyy-MM-dd')
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root   = Split-Path -Parent $PSScriptRoot
$kit    = Join-Path $root 'kit'
$prompt = Join-Path $root 'merge-prompt.txt'
$zip    = Join-Path $root 'universal-agent-kit.zip'
$stage  = Join-Path $root 'temp/_uak_build'
$anchor = 'universal-agent-kit'

# --- 1. stage and zip -------------------------------------------------------------------------
if (Test-Path $stage) { [System.IO.Directory]::Delete($stage, $true) }
$inner = Join-Path $stage $anchor
New-Item -ItemType Directory -Path $inner -Force | Out-Null
Copy-Item -Path (Join-Path $kit '*') -Destination $inner -Recurse -Force
Copy-Item -Path $prompt -Destination $inner -Force

if (Test-Path $zip) { Remove-Item -LiteralPath $zip -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($stage, $zip, 'Optimal', $false)

# --- 2. verify every entry against its source -------------------------------------------------
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
} finally { $archive.Dispose() }
$sourceCount = (Get-ChildItem -Path $kit -Recurse -File -Force).Count + 1
[System.IO.Directory]::Delete($stage, $true)

# --- 3. stamp the date ------------------------------------------------------------------------
$utf8 = New-Object System.Text.UTF8Encoding($false)
function Set-Stamp([string]$path, [string]$pattern, [string]$replacement, [string]$label) {
    $text = [System.IO.File]::ReadAllText($path)
    $hits = [regex]::Matches($text, $pattern).Count
    if ($hits -eq 0) { Write-Host "STAMP MISSING $label in $path"; return 0 }
    [System.IO.File]::WriteAllText($path, [regex]::Replace($text, $pattern, $replacement), $utf8)
    return $hits
}
$index = Join-Path $root 'index.html'
$timeHits = Set-Stamp $index '(<time class="kit-date" datetime=")\d{4}-\d{2}-\d{2}(">)\d{4}-\d{2}-\d{2}(</time>)' "`${1}$Date`${2}$Date`${3}" 'time.kit-date'
$ldHits   = Set-Stamp $index '("dateModified": ")\d{4}-\d{2}-\d{2}(")' "`${1}$Date`${2}" 'dateModified'
$mapHits  = Set-Stamp (Join-Path $root 'sitemap.xml') '(<lastmod>)\d{4}-\d{2}-\d{2}(</lastmod>)' "`${1}$Date`${2}" 'lastmod'

Write-Host "zip:     $entries entries (sources: $sourceCount), $mismatches mismatch(es)"
Write-Host "stamped: $Date - $timeHits time.kit-date, $ldHits dateModified, $mapHits lastmod"

if ($mismatches -gt 0 -or $entries -ne $sourceCount -or $timeHits -eq 0 -or $ldHits -eq 0 -or $mapHits -eq 0) {
    Write-Host 'FAIL'
    exit 1
}
Write-Host 'PASS'
