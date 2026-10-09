<#
.SYNOPSIS
    Write one dated promotion-metrics checkpoint for the free-promotion campaign.

.DESCRIPTION
    Read-only GETs through the `gh` CLI (canon PROMOTION.md section 7; the campaign specification's
    phase P0b and criterion 8). Nothing here changes anything on GitHub: every call is a GET or a
    GraphQL query, and the only write is the dated JSON file under
    docs/specifications/SPECIFICATION_FREE_PROMOTION_CAMPAIGN/metrics/.

    Read per run:
      - repository counters: stars, forks, watchers, topics, homepage, licence, description,
        pushed_at (gh api repos/SerZhyAle/universal-agent-kit)
      - traffic/views, traffic/clones, traffic/popular/referrers (14-day windows)
      - GraphQL usesCustomOpenGraphImage

    A value that cannot be read is written "unknown", never estimated. Search Console figures
    (the sitemap report, indexed counts) have no API: they stay "unknown" until the owner adds
    them by hand and marks the file `consoleSource: "owner, by hand"`.

    The script lives outside kit/ and is not shipped in the zip.

.PARAMETER Date
    The checkpoint date, yyyy-MM-dd, used as the file name. Defaults to today, local time - the
    campaign's dated files (the baseline, the spec rows) use the owner's working date.

.OUTPUTS
    docs/specifications/SPECIFICATION_FREE_PROMOTION_CAMPAIGN/metrics/<yyyy-MM-dd>.json
#>
[CmdletBinding()]
param(
    [string]$Date = [DateTime]::Now.ToString('yyyy-MM-dd')
)

$ErrorActionPreference = 'Stop'

$repo = 'SerZhyAle/universal-agent-kit'
$root  = Split-Path -Parent $PSScriptRoot
$dir   = Join-Path $root 'docs/specifications/SPECIFICATION_FREE_PROMOTION_CAMPAIGN/metrics'
$gql   = 'query{repository(owner:"SerZhyAle",name:"universal-agent-kit"){usesCustomOpenGraphImage}}'

if ($Date -notmatch '^\d{4}-\d{2}-\d{2}$') {
    Write-Host "INPUT INVALID date: $Date"
    exit 2
}

# Read one gh endpoint and return its parsed JSON, or $null when it cannot be read.
# The comma keeps an empty JSON array (topics [], referrers []) an array instead of $null.
function Read-Gh([string[]]$ghArgs) {
    try {
        $out = & gh @ghArgs 2>$null
        if ($LASTEXITCODE -ne 0) { return $null }
        $raw = $out -join "`n"
        # ConvertFrom-Json collapses a top-level empty JSON array ("[]") to $null; keep it an array.
        if ($raw.Trim() -eq '[]') { return ,@() }
        $parsed = ConvertFrom-Json -InputObject $raw
        return ,$parsed
    } catch { return $null }
}

function Referrer-Rows($r) {
    if ($null -eq $r) { return ,'unknown' }
    $rows = [System.Collections.Generic.List[string]]::new()
    foreach ($x in @($r)) { $rows.Add("$($x.referrer): $($x.count)/$($x.uniques)") }
    return ,$rows
}

$repository = Read-Gh @('api', "repos/$repo")
$views      = Read-Gh @('api', "repos/$repo/traffic/views")
$clones     = Read-Gh @('api', "repos/$repo/traffic/clones")
$referrers  = Read-Gh @('api', "repos/$repo/traffic/popular/referrers")
$gqlResult  = Read-Gh @('api', 'graphql', '-f', "query=$gql")

# Materialize every field before the JSON object: an empty array (topics [], referrers []) that
# passes through a statement output or a hashtable-literal branch unrolls to $null in PowerShell.
$unknown = 'unknown'
$stars = $unknown;      $forks = $unknown; $watchers = $unknown; $topics = $unknown
$homepage = $unknown;   $licence = $unknown; $desc = $unknown; $pushed = $unknown
if ($null -ne $repository) {
    $stars = $repository.stargazers_count; $forks = $repository.forks_count
    $watchers = $repository.subscribers_count; $topics = @($repository.topics)
    $homepage = $repository.homepage; $licence = $repository.license.spdx_id
    $desc = $repository.description; $pushed = $repository.pushed_at
}
$v = $unknown; $c = $unknown
if ($null -ne $views)  { $v = [ordered]@{ count = $views.count;  uniques = $views.uniques } }
if ($null -ne $clones) { $c = [ordered]@{ count = $clones.count; uniques = $clones.uniques } }
$customOg = $unknown
if ($null -ne $gqlResult) { $customOg = $gqlResult.data.repository.usesCustomOpenGraphImage }

$checkpoint = [ordered]@{
    date          = $Date
    source        = 'tools/promo-metrics.ps1 (read-only gh api GETs; criterion 8)'
    repository    = [ordered]@{
        stars        = $stars
        forks        = $forks
        watchers     = $watchers
        topics       = $topics
        homepage     = $homepage
        licence      = $licence
        description  = $desc
        pushedAt     = $pushed
    }
    traffic14d   = [ordered]@{
        views     = $v
        clones    = $c
        referrers = $referrers
    }
    socialCard   = [ordered]@{
        usesCustomOpenGraphImage = $customOg
    }
    console      = [ordered]@{
        sitemap = 'unknown'   # no API: the owner reads the Search Console report and replaces this by hand
        indexed = 'unknown'   # same
    }
    consoleSource = 'script - console rows are unknown until the owner fills them by hand and changes this value'
}

New-Item -ItemType Directory -Force -Path $dir | Out-Null
$file = Join-Path $dir "$Date.json"
$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($file, ($checkpoint | ConvertTo-Json -Depth 6) + "`n", $utf8)
Write-Host "promo-metrics: WROTE $file"
Write-Host 'promo-metrics: PASS'
exit 0
