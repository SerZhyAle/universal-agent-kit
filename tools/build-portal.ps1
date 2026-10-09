<#
.SYNOPSIS
    Build the portal pages of the site from tools/portal/ - the capability inventory, the page content and
    the glossary - and verify them.

.DESCRIPTION
    The portal (portal/**), privacy.html, 404.html, assets/search-index.json and sitemap.xml are render
    targets of tools/portal/ and POSITIONING.md: never edit them by hand, change the source and run this.

    Modes:
      (default)   validate the sources, render every target, write the files that changed.
      -Validate   validate the sources only, write nothing.
      -Check      render in memory and compare with the files on disk; write nothing. Exit 1 on drift.

    Validation (SITE-STRUCTURE 12, 13; SITE-REPRESENTATION 3, 6, 7, 8, 9): every capability of the inventory has
    exactly one function page and the page has a capability; every payload file of kit/ (and merge-prompt.txt)
    is a source of a capability or is listed as excluded with a reason; every localized field exists in RU, EN
    and UA; every link, related function, glossary term and command name resolves; the house text style holds.

    Exits 0 when every source is valid (and, with -Check, nothing drifted). Exits 1 on a validation error or on
    drift. Exits 2 when an input cannot be read.

.PARAMETER Validate
    Validate the sources and stop.

.PARAMETER Check
    Compare the rendered output with the files on disk instead of writing.

.PARAMETER OutDir
    Render into this directory instead of the repository root (a preview).

.PARAMETER Accept
    Record that the page of each listed capability id (comma separated, or 'all') was re-read against the current text
    of its kit sources. tools/portal/reviewed.json holds one digest per capability; validation fails for a capability whose
    sources changed after its page was last accepted, so a change in kit/ cannot leave a stale page unnoticed.
#>
[CmdletBinding()]
param(
    [switch]$Validate,
    [switch]$Check,
    [string]$OutDir,
    [string]$Accept
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

$root  = Split-Path -Parent $PSScriptRoot
$src   = Join-Path $PSScriptRoot 'portal'
$Base  = 'https://serzhyale.github.io/universal-agent-kit/'
$Locs  = @('ru', 'en', 'ua')
$utf8  = New-Object System.Text.UTF8Encoding($false)
$errors = [System.Collections.Generic.List[string]]::new()

function Fail([string]$msg) { $script:errors.Add($msg) }
function Read-Json([string]$path) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "INPUT MISSING $path" }
    return ([System.IO.File]::ReadAllText($path, $utf8) | ConvertFrom-Json)
}
function Has([object]$o, [string]$name) { return ($null -ne $o) -and ($o.PSObject.Properties.Name -contains $name) }

# ---------------------------------------------------------------------------------------------------------
# Content validation helpers
# ---------------------------------------------------------------------------------------------------------
$cyr = '[Ѐ-ӿ]'
function Test-Style([string]$text, [string]$ctx, [string]$loc) {
    $plain = [regex]::Replace($text, '`[^`]*`', '')
    if ($plain -match '\.\.\.')            { Fail "$ctx : house style - use '..' and never three dots in prose" }
    if ($text  -match '[—–…]') { Fail "$ctx : house style - a plain hyphen, never an em dash, en dash or ellipsis character" }
    if ($text  -match '[☀-➿⭐⭕]|[\uD83C-\uD83E][\uDC00-\uDFFF]') { Fail "$ctx : no emoji or dingbats" }
    if ($loc -eq 'en' -and $plain -match $cyr) { Fail "$ctx : Cyrillic text in the English field" }
    if ($loc -eq 'ru' -and $plain -match '[їєіґЇЄІҐ]') { Fail "$ctx : Ukrainian letters in the Russian field" }
    if ($loc -eq 'ua' -and $plain -match '[ыэъёЫЭЪЁ]') { Fail "$ctx : Russian-only letters in the Ukrainian field" }
    if (($loc -eq 'ru' -or $loc -eq 'ua') -and $plain.Trim().Length -gt 0 -and $plain -notmatch $cyr -and $plain -notmatch '^[A-Za-z0-9 ./_-]+$') { Fail "$ctx : no Cyrillic in the $loc field" }
}

# A localized field: an object with a non-empty string for each of ru, en, ua.
function Test-L3([object]$v, [string]$ctx, [int]$max = 0, [switch]$Optional) {
    if ($null -eq $v) { if (-not $Optional) { Fail "$ctx : missing" }; return }
    foreach ($l in $Locs) {
        if (-not (Has $v $l) -or [string]::IsNullOrWhiteSpace([string]$v.$l)) { Fail "$ctx.$l : missing or empty"; continue }
        $t = [string]$v.$l
        if ($max -gt 0 -and $t.Length -gt $max) { Fail "$ctx.$l : $($t.Length) characters, limit $max" }
        Test-Style $t "$ctx.$l" $l
    }
}
function Get-L3([object]$v, [string]$l) { return [string]$v.$l }

$script:CommandNames = @{}
$script:FnIds = @{}
$script:GuideIds = @{}
$script:TermIds = @{}

# Inline markup of the text fields: `code`, **bold**, [text](fn:id | guide:id | term:id | https://..).
function Test-Markup([string]$text, [string]$ctx) {
    foreach ($m in [regex]::Matches($text, '\[([^\]]+)\]\(([^)]+)\)')) {
        $t = $m.Groups[2].Value
        if ($t -match '^fn:(.+)$')        { if (-not $script:FnIds.ContainsKey($Matches[1]))    { Fail "$ctx : link to unknown function '$($Matches[1])'" } }
        elseif ($t -match '^guide:(.+)$') { if (-not $script:GuideIds.ContainsKey($Matches[1])) { Fail "$ctx : link to unknown guide '$($Matches[1])'" } }
        elseif ($t -match '^term:(.+)$')  { if (-not $script:TermIds.ContainsKey($Matches[1]))  { Fail "$ctx : link to unknown glossary term '$($Matches[1])'" } }
        elseif ($t -match '^https://')    { }
        else { Fail "$ctx : link target '$t' is not fn:, guide:, term: or https://" }
    }
    # RP 8: a command named in the interface's own words must exist.
    foreach ($m in [regex]::Matches($text, '`(/[a-z][a-z0-9-]*)(?:\s[^`]*)?`')) {
        if (-not $script:CommandNames.ContainsKey($m.Groups[1].Value)) { Fail "$ctx : command '$($m.Groups[1].Value)' is not in the inventory" }
    }
    if (([regex]::Matches($text, '`')).Count % 2 -ne 0)   { Fail "$ctx : unbalanced backtick" }
    if (([regex]::Matches($text, '\*\*')).Count % 2 -ne 0) { Fail "$ctx : unbalanced ** pair" }
    $outsideCode = [regex]::Replace($text, '`[^`]*`', '')
    if ($outsideCode -match '<[A-Za-z/]')                  { Fail "$ctx : raw HTML is not allowed in a text field (inside a code span it is fine)" }
}
function Test-L3Markup([object]$v, [string]$ctx) {
    if ($null -eq $v) { return }
    foreach ($l in $Locs) { if (Has $v $l) { Test-Markup ([string]$v.$l) "$ctx.$l" } }
}

# ---------------------------------------------------------------------------------------------------------
# Load the sources
# ---------------------------------------------------------------------------------------------------------
function Get-PositioningPillars {
    $text = [System.IO.File]::ReadAllText((Join-Path $root 'POSITIONING.md'), $utf8)
    $m = [regex]::Match($text, '(?s)```json\s*(\{.*?\})\s*```')
    if (-not $m.Success) { throw 'INPUT INVALID POSITIONING.md has no json block' }
    return ($m.Groups[1].Value | ConvertFrom-Json).pillars
}

function Load-Sources {
    $M = [ordered]@{}
    $M.Pillars   = Get-PositioningPillars
    $M.Inventory = Read-Json (Join-Path $src 'inventory.json')
    $M.Sections  = (Read-Json (Join-Path $src 'sections.json')).sections
    $M.Ui        = Read-Json (Join-Path $src 'ui.json')
    $M.Functions = [ordered]@{}
    foreach ($f in Get-ChildItem -LiteralPath (Join-Path $src 'functions') -Filter *.json -File | Sort-Object Name) {
        $M.Functions[[IO.Path]::GetFileNameWithoutExtension($f.Name)] = Read-Json $f.FullName
    }
    $M.Guides = [ordered]@{}
    $gd = Join-Path $src 'guides'
    if (Test-Path -LiteralPath $gd) {
        foreach ($f in Get-ChildItem -LiteralPath $gd -Filter *.json -File | Sort-Object Name) {
            $M.Guides[[IO.Path]::GetFileNameWithoutExtension($f.Name)] = Read-Json $f.FullName
        }
    }
    $M.Terms = [ordered]@{}
    $td = Join-Path $src 'glossary'
    if (Test-Path -LiteralPath $td) {
        foreach ($f in Get-ChildItem -LiteralPath $td -Filter *.json -File | Sort-Object Name) {
            $M.Terms[[IO.Path]::GetFileNameWithoutExtension($f.Name)] = Read-Json $f.FullName
        }
    }
    $M.Privacy = Read-Json (Join-Path $src 'privacy.json')
    return $M
}

# ---------------------------------------------------------------------------------------------------------
# Validate
# ---------------------------------------------------------------------------------------------------------
function Test-Model($M) {
    $perms = @('read-files', 'write-files', 'run-commands', 'subagents', 'web')
    $runtimes = @('claude-code', 'any')
    $kinds = @('command', 'agent', 'practice')

    $secIds = @{}
    foreach ($s in $M.Sections) {
        $secIds[$s.id] = $true
        Test-L3 $s.title "section $($s.id).title" 80
        Test-L3 $s.lead  "section $($s.id).lead" 260
        if ($null -ne $s.pillar -and -not ($M.Pillars | Where-Object { $_.id -eq $s.pillar })) { Fail "section $($s.id): pillar '$($s.pillar)' is not in POSITIONING.md" }
    }
    foreach ($p in $M.Pillars) {
        if (-not ($M.Sections | Where-Object { $_.pillar -eq $p.id })) { Fail "pillar '$($p.id)' has no section" }
    }

    $caps = @{}
    foreach ($c in $M.Inventory.capabilities) {
        if ($caps.ContainsKey($c.id)) { Fail "inventory: duplicate id '$($c.id)'"; continue }
        $caps[$c.id] = $c
        $script:FnIds[$c.id] = $true
        if ($c.kind -notin $kinds)          { Fail "inventory $($c.id): kind '$($c.kind)'" }
        if (-not $secIds.ContainsKey($c.section)) { Fail "inventory $($c.id): section '$($c.section)'" }
        if ($c.runtime -notin $runtimes)    { Fail "inventory $($c.id): runtime '$($c.runtime)'" }
        foreach ($p in @($c.permissions))   { if ($p -notin $perms) { Fail "inventory $($c.id): permission '$p'" } }
        if (@($c.sources).Count -eq 0)      { Fail "inventory $($c.id): no sources" }
        foreach ($s in @($c.sources))       { if (-not (Test-Path -LiteralPath (Join-Path $root $s) -PathType Leaf)) { Fail "inventory $($c.id): source '$s' does not exist" } }
        if ($c.kind -eq 'command') { $script:CommandNames[[string]$c.name] = $c.id }
    }
    # the commands of the kit are the skills of kit/.claude/skills - nothing hidden, nothing invented
    $cmdFiles = Get-ChildItem -LiteralPath (Join-Path $root 'kit/.claude/skills') -Directory | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') } | ForEach-Object { '/' + $_.Name }
    foreach ($n in $cmdFiles) { if (-not $script:CommandNames.ContainsKey($n)) { Fail "kit command $n has no capability in the inventory" } }
    foreach ($n in $script:CommandNames.Keys) { if ($n -notin $cmdFiles) { Fail "inventory command $n has no skill in kit/.claude/skills" } }

    # glossary
    foreach ($id in $M.Terms.Keys) { $script:TermIds[$id] = $true }
    foreach ($id in $M.Guides.Keys) { $script:GuideIds[$id] = $true }

    # coverage manifest (ST 12): every payload file is covered or excluded with a reason
    $covered = @{}
    foreach ($c in $M.Inventory.capabilities) { foreach ($s in @($c.sources)) { $covered[$s] = $true } }
    $excluded = @{}
    foreach ($x in @($M.Inventory.excluded)) {
        $excluded[[string]$x.source] = $true
        if ([string]::IsNullOrWhiteSpace([string]$x.reason)) { Fail "excluded '$($x.source)': no reason" }
    }
    $payload = @(Get-ChildItem -LiteralPath (Join-Path $root 'kit') -Recurse -File -Force | ForEach-Object {
        'kit/' + $_.FullName.Substring((Join-Path $root 'kit').Length + 1).Replace('\', '/') }) + 'merge-prompt.txt'
    foreach ($f in $payload) { if (-not $covered.ContainsKey($f) -and -not $excluded.ContainsKey($f)) { Fail "coverage: payload file '$f' is neither a source of a capability nor excluded" } }

    # function pages
    foreach ($id in $caps.Keys) { if (-not $M.Functions.Contains($id)) { Fail "capability '$id' has no function page (tools/portal/functions/$id.json)" } }
    foreach ($id in $M.Functions.Keys) {
        $f = $M.Functions[$id]; $ctx = "function $id"
        if (-not $caps.ContainsKey($id)) { Fail "$ctx : not in the inventory"; continue }
        if (-not (Has $f 'id') -or $f.id -ne $id) { Fail "$ctx : id field must equal the file name" }
        Test-L3 $f.title   "$ctx.title" 90
        Test-L3 $f.pitch   "$ctx.pitch" 170
        Test-L3 $f.lead    "$ctx.lead" 600
        Test-L3 $f.outcome "$ctx.outcome" 400
        foreach ($k in 'title', 'pitch', 'lead', 'outcome') { if (Has $f $k) { Test-L3Markup $f.$k "$ctx.$k" } }
        if (Has $f 'situation') { Test-L3 $f.situation "$ctx.situation" 400 -Optional; Test-L3Markup $f.situation "$ctx.situation" }
        if (Has $f 'warning')   { Test-L3 $f.warning "$ctx.warning" 400 -Optional;   Test-L3Markup $f.warning "$ctx.warning" }
        if (-not (Has $f 'steps') -or @($f.steps).Count -lt 2) { Fail "$ctx : needs at least 2 steps" }
        else { $i = 0; foreach ($s in @($f.steps)) { $i++; Test-L3 $s "$ctx.steps[$i]" 500; Test-L3Markup $s "$ctx.steps[$i]" } }
        if (Has $f 'tips') { $i = 0; foreach ($s in @($f.tips)) { $i++; Test-L3 $s "$ctx.tips[$i]" 400; Test-L3Markup $s "$ctx.tips[$i]" } }
        if (-not (Has $f 'related') -or @($f.related).Count -lt 1) { Fail "$ctx : needs at least 1 related function" }
        else { foreach ($r in @($f.related)) { if (-not $caps.ContainsKey($r)) { Fail "$ctx : related '$r' is not a capability" } elseif ($r -eq $id) { Fail "$ctx : related to itself" } } }
        if (Has $f 'terms') { foreach ($t in @($f.terms)) { if (-not $script:TermIds.ContainsKey($t)) { Fail "$ctx : term '$t' is not in the glossary" } } }
        if (-not (Has $f 'keywords')) { Fail "$ctx : keywords missing" }
        else {
            foreach ($l in $Locs) {
                if (-not (Has $f.keywords $l) -or @($f.keywords.$l).Count -lt 2) { Fail "$ctx.keywords.$l : at least 2 needed"; continue }
                foreach ($k in @($f.keywords.$l)) { Test-Style ([string]$k) "$ctx.keywords.$l" $l; if (([string]$k).Length -gt 60) { Fail "$ctx.keywords.$l : '$k' is too long" } }
            }
        }
    }

    # guides
    foreach ($id in $M.Guides.Keys) {
        $g = $M.Guides[$id]; $ctx = "guide $id"
        if (-not (Has $g 'id') -or $g.id -ne $id) { Fail "$ctx : id field must equal the file name" }
        Test-L3 $g.title "$ctx.title" 90; Test-L3 $g.pitch "$ctx.pitch" 170; Test-L3 $g.lead "$ctx.lead" 600; Test-L3 $g.outcome "$ctx.outcome" 400
        foreach ($k in 'title', 'pitch', 'lead', 'outcome') { if (Has $g $k) { Test-L3Markup $g.$k "$ctx.$k" } }
        if (-not (Has $g 'steps') -or @($g.steps).Count -lt 3) { Fail "$ctx : needs at least 3 steps" }
        else { $i = 0; foreach ($s in @($g.steps)) { $i++; Test-L3 $s "$ctx.steps[$i]" 600; Test-L3Markup $s "$ctx.steps[$i]" } }
        if (-not (Has $g 'functions') -or @($g.functions).Count -lt 2) { Fail "$ctx : needs at least 2 functions" }
        else { foreach ($r in @($g.functions)) { if (-not $caps.ContainsKey($r)) { Fail "$ctx : function '$r' is not a capability" } } }
        if (Has $g 'terms') { foreach ($t in @($g.terms)) { if (-not $script:TermIds.ContainsKey($t)) { Fail "$ctx : term '$t' is not in the glossary" } } }
        if (-not (Has $g 'keywords')) { Fail "$ctx : keywords missing" }
        else { foreach ($l in $Locs) { if (-not (Has $g.keywords $l) -or @($g.keywords.$l).Count -lt 2) { Fail "$ctx.keywords.$l : at least 2 needed" } else { foreach ($k in @($g.keywords.$l)) { Test-Style ([string]$k) "$ctx.keywords.$l" $l } } } }
    }

    # glossary terms
    foreach ($id in $M.Terms.Keys) {
        $t = $M.Terms[$id]; $ctx = "term $id"
        if (-not (Has $t 'id') -or $t.id -ne $id) { Fail "$ctx : id field must equal the file name" }
        Test-L3 $t.term "$ctx.term" 60; Test-L3 $t.def "$ctx.def" 420; Test-L3Markup $t.def "$ctx.def"
        if (Has $t 'see') { foreach ($s in @($t.see)) { if (-not $script:TermIds.ContainsKey($s)) { Fail "$ctx : see '$s' is not a term" } } }
    }

    # the strings of the chrome
    foreach ($p in $M.Ui.PSObject.Properties) {
        if ($p.Name.StartsWith('$')) { continue }
        Test-L3 $p.Value "ui.$($p.Name)"
    }
}

# ---------------------------------------------------------------------------------------------------------
# Review digests: a page is accepted against the exact text of its kit sources
# ---------------------------------------------------------------------------------------------------------
$ReviewedPath = Join-Path $src 'reviewed.json'
function Get-SourceDigest($cap) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $sb = [System.Text.StringBuilder]::new()
    foreach ($s in @($cap.sources | Sort-Object)) {
        $text = [System.IO.File]::ReadAllText((Join-Path $root $s), $utf8).Replace("`r`n", "`n")
        [void]$sb.Append($s).Append("`n").Append($text).Append("`n--`n")
    }
    $h = $sha.ComputeHash($utf8.GetBytes($sb.ToString()))
    return ([BitConverter]::ToString($h).Replace('-', '').ToLowerInvariant()).Substring(0, 24)
}
function Read-Reviewed {
    $o = [ordered]@{}
    if (Test-Path -LiteralPath $ReviewedPath) {
        foreach ($p in (Read-Json $ReviewedPath).PSObject.Properties) { if (-not $p.Name.StartsWith('$')) { $o[$p.Name] = [string]$p.Value } }
    }
    return $o
}
function Test-Reviewed($M) {
    $rev = Read-Reviewed
    foreach ($c in $M.Inventory.capabilities) {
        if (-not $rev.Contains($c.id)) { Fail "review: '$($c.id)' has no accepted digest - re-read its sources against the page, then run build-portal.ps1 -Accept $($c.id)"; continue }
        if ($rev[$c.id] -ne (Get-SourceDigest $c)) { Fail "review: the sources of '$($c.id)' changed since its page was accepted ($((@($c.sources) -join ', '))) - re-read, fix the page, then run build-portal.ps1 -Accept $($c.id)" }
    }
}
function Save-Accepted($M, [string]$which) {
    $ids = if ($which -eq 'all') { @($M.Inventory.capabilities | ForEach-Object { $_.id }) } else { @($which.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ }) }
    $rev = Read-Reviewed
    foreach ($id in $ids) {
        $c = $M.Inventory.capabilities | Where-Object { $_.id -eq $id } | Select-Object -First 1
        if ($null -eq $c) { throw "no capability '$id' to accept" }
        $rev[$id] = Get-SourceDigest $c
    }
    $out = [ordered]@{ '$comment' = 'One digest per capability: the SHA-256 (24 hex) of its kit sources as the page was last re-read against them. Written only by build-portal.ps1 -Accept, never by hand.' }
    foreach ($k in ($rev.Keys | Sort-Object)) { $out[$k] = $rev[$k] }
    [System.IO.File]::WriteAllText($ReviewedPath, (($out | ConvertTo-Json) + "`n"), $utf8)
    return $ids.Count
}
# ---------------------------------------------------------------------------------------------------------
# Privacy page source (checked here, rendered by render.ps1)
# ---------------------------------------------------------------------------------------------------------
function Test-Privacy($M) {
    $P = $M.Privacy
    if (-not (Has $P 'title')) { Fail 'privacy.json: not written yet'; return }
    Test-L3 $P.title 'privacy.title' 60; Test-L3 $P.desc 'privacy.desc' 300; Test-L3 $P.lead 'privacy.lead' 600
    foreach ($k in 'origin', 'purpose', 'receives', 'key', 'values') { Test-L3 $P.cols.$k "privacy.cols.$k" 40 }
    foreach ($s in @($P.sections)) {
        Test-L3 $s.title "privacy.$($s.id).title" 80
        $i = 0; foreach ($b in @($s.body)) { $i++; Test-L3 $b "privacy.$($s.id).body[$i]" 900; Test-L3Markup $b "privacy.$($s.id).body[$i]" }
    }
    $ids = @($P.sections | ForEach-Object { $_.id })
    foreach ($need in 'origins', 'storage') { if ($need -notin $ids) { Fail "privacy.json: section '$need' is missing" } }
    foreach ($o in @($P.origins)) { Test-L3 $o.purpose "privacy.origin $($o.origin).purpose" 400; Test-L3 $o.receives "privacy.origin $($o.origin).receives" 400 }
    foreach ($o in @($P.storage)) { Test-L3 $o.purpose "privacy.storage $($o.key).purpose" 300 }
}

# ---------------------------------------------------------------------------------------------------------
# Render and write
# ---------------------------------------------------------------------------------------------------------
. (Join-Path $src 'render.ps1')

function Get-LastMod {
    $sm = Join-Path $root 'sitemap.xml'
    if (Test-Path -LiteralPath $sm) {
        $m = [regex]::Match([System.IO.File]::ReadAllText($sm, $utf8), '<lastmod>(\d{4}-\d{2}-\d{2})</lastmod>')
        if ($m.Success) { return $m.Groups[1].Value }
    }
    return [DateTime]::UtcNow.ToString('yyyy-MM-dd')
}

try {
    $M = Load-Sources
    Test-Model $M
    Test-Privacy $M
    if (-not $Accept) { Test-Reviewed $M }
    foreach ($e in $errors) { Write-Host "ERROR $e" }
    if ($errors.Count -gt 0) {
        Write-Host "build-portal: DEFECT - $($errors.Count) validation error(s)"
        exit 1
    }
    if ($Accept) { $n = Save-Accepted $M $Accept; Write-Host "accepted: $n capability page(s) against the current kit sources"; exit 0 }
    Write-Host "validated: $(@($M.Inventory.capabilities).Count) capabilities, $($M.Functions.Count) function pages, $($M.Guides.Count) guides, $($M.Terms.Count) glossary terms"
    if ($Validate) { Write-Host 'build-portal: VALID'; exit 0 }

    $out = Build-Site $M (Get-LastMod)
    $target = if ($OutDir) { $OutDir } else { $root }
    $written = 0; $drift = 0
    foreach ($rel in $out.Keys) {
        $path = Join-Path $target ($rel.Replace('/', [IO.Path]::DirectorySeparatorChar))
        $content = ([string]$out[$rel]).Replace("`r`n", "`n")
        $disk = $null
        if (Test-Path -LiteralPath $path -PathType Leaf) { $disk = [System.IO.File]::ReadAllText($path, $utf8) }
        if ($disk -ceq $content) { continue }
        if ($Check) { Write-Host "DRIFT $rel"; $drift++; continue }
        $dir = Split-Path -Parent $path
        if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        [System.IO.File]::WriteAllText($path, $content, $utf8)
        $written++
    }
    # A published page that the sources no longer generate must be retired with a forwarder, never deleted silently (ST 8, 13).
    $orphans = 0
    $portalDir = Join-Path $target 'portal'
    if (Test-Path -LiteralPath $portalDir) {
        foreach ($f in Get-ChildItem -LiteralPath $portalDir -Recurse -File -Filter *.html) {
            $rel = $f.FullName.Substring($target.Length + 1).Replace('\', '/')
            if (-not $out.Contains($rel)) { Write-Host "ORPHAN $rel is not generated - retire it with a forwarder, then remove it from the tree"; $orphans++ }
        }
    }
    Write-Host "pages:   $($out.Count) targets, $written written, $drift drifted, $orphans orphan(s)"
    if ($drift -gt 0 -or $orphans -gt 0) { Write-Host 'build-portal: DEFECT - the generated files differ from their sources'; exit 1 }
    Write-Host 'build-portal: PASS'
    exit 0
} catch {
    Write-Host "ERROR $($_.Exception.Message)"
    Write-Host $_.ScriptStackTrace
    Write-Host 'build-portal: COULD NOT VERIFY - build process could not complete'
    exit 2
}