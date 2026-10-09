<#
.SYNOPSIS
    Offline gates for the published site: the held addresses, the page width, the page set, the positioning and
    the third-party origins.

.DESCRIPTION
    Every dimension is decidable against the static tree with a near-zero false-positive rate; a rule that needs a
    rendered page (contrast, focus order, reduced motion, the network panel) is not here and is run in a browser.

      held-addresses  SITE-STRUCTURE 8, 11 - docs/site-held-addresses.jsonl: every entry resolves against the page
                      set, is not itself a forwarder, and every address this repository holds in its own surfaces
                      is on the list.
      page-width      SITE-EXPERIENCE 20, 4 - no max-width, min(NNNpx, NNvw), fixed pixel width or centred margin on a
                      page wrapper of the page layer; no style attribute in a published page.
      page-set        SITE-STRUCTURE 1, 2, 3, 9, 10, 15; SITE-EXPERIENCE 15, 16 - the sitemap and the files agree; every
                      page is reached from the landing in at most three steps; every internal link and anchor
                      answers; each page has the skip link first, one main, one h1, labelled navs, ordered headings
                      and the three languages; the not-found page is noindex and builds every address from the base.
      positioning     SITE-REPRESENTATION 1, 2 - every surface that lists what the kit is for lists the pillars of
                      POSITIONING.md in its order, and a short list names the first ones.
      origins         SITE-EXPERIENCE 14 - the hosts the pages load equal the origins privacy.json declares, both
                      ways, and the privacy page names each.
      portal-fresh    the generated portal files equal what tools/build-portal.ps1 renders from their sources.

    Exits 0 when every selected dimension passes, 1 when any fails, 2 when an input cannot be read.

.PARAMETER Dimension
    One of the names above, or all (default).
#>
[CmdletBinding()]
param(
    [ValidateSet('all', 'held-addresses', 'page-width', 'page-set', 'positioning', 'origins', 'portal-fresh')]
    [string]$Dimension = 'all'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

$root = Split-Path -Parent $PSScriptRoot
$Base = 'https://serzhyale.github.io/universal-agent-kit/'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$errors = [System.Collections.Generic.List[string]]::new()
function Fail([string]$dim, [string]$msg) { $script:errors.Add("[$dim] $msg") }
function Read-Text([string]$rel) {
    $p = Join-Path $root $rel
    if (-not (Test-Path -LiteralPath $p -PathType Leaf)) { throw "INPUT MISSING $rel" }
    return [System.IO.File]::ReadAllText($p, $utf8)
}
function Rel-Of([string]$full) { return $full.Substring($root.Length + 1).Replace('\', '/') }
function Want([string]$d) { return ($Dimension -eq 'all' -or $Dimension -eq $d) }

# The published HTML files: the landing, the privacy and not-found pages, and every page of the portal.
function Get-Pages {
    $list = New-Object System.Collections.Generic.List[string]
    foreach ($f in 'index.html', 'privacy.html', '404.html') { if (Test-Path -LiteralPath (Join-Path $root $f)) { $list.Add($f) } }
    $pd = Join-Path $root 'portal'
    if (Test-Path -LiteralPath $pd) { foreach ($f in Get-ChildItem -LiteralPath $pd -Recurse -File -Filter *.html | Sort-Object FullName) { $list.Add((Rel-Of $f.FullName)) } }
    return $list
}

# Resolve a site address ('https://serzhyale.github.io/universal-agent-kit/..') to a repository file path, or $null.
function Resolve-Address([string]$addr) {
    if (-not $addr.StartsWith($Base)) { return $null }
    $rest = $addr.Substring($Base.Length)
    $i = $rest.IndexOfAny([char[]]'#?'); if ($i -ge 0) { $rest = $rest.Substring(0, $i) }
    if ($rest -eq '' -or $rest.EndsWith('/')) { $rest += 'index.html' }
    return $rest
}

# ---------------------------------------------------------------------------------------------------------
# held-addresses
# ---------------------------------------------------------------------------------------------------------
function Test-HeldAddresses {
    $d = 'held-addresses'
    $path = 'docs/site-held-addresses.jsonl'
    $text = Read-Text $path
    $entries = New-Object System.Collections.Generic.List[object]
    $n = 0
    foreach ($line in ($text -split "`n")) {
        $n++
        $l = $line.Trim()
        if ($l -eq '' -or $l.StartsWith('#')) { continue }
        try { $entries.Add(($l | ConvertFrom-Json)) } catch { Fail $d "line ${n}: not valid JSON"; continue }
    }
    if ($entries.Count -eq 0) { Fail $d "$path has no entry" }
    $seen = @{}
    foreach ($e in $entries) {
        foreach ($k in 'address', 'holder') { if (-not ($e.PSObject.Properties.Name -contains $k) -or [string]::IsNullOrWhiteSpace([string]$e.$k)) { Fail $d "entry without '$k': $($e | ConvertTo-Json -Compress)" } }
        if (-not ($e.PSObject.Properties.Name -contains 'address')) { continue }
        $addr = [string]$e.address
        $key = $addr + '|' + [string]$e.holder
        if ($seen.ContainsKey($key)) { Fail $d "duplicate entry: $key" }; $seen[$key] = $true
        if (-not $addr.StartsWith($Base)) { Fail $d "$addr : not an address of this site"; continue }
        $file = Resolve-Address $addr
        $target = Join-Path $root $file
        if (-not (Test-Path -LiteralPath $target -PathType Leaf)) { Fail $d "$addr : answers nothing - no file '$file' in the page set"; continue }
        if ($file -eq '404.html') { Fail $d "$addr : resolves to the not-found page" }
        if ($file.EndsWith('.html')) {
            $html = Read-Text $file
            if ($html -match '(?i)http-equiv\s*=\s*"refresh"' -or $html -match 'data-forwarder') { Fail $d "$addr : is itself a forwarder ($file)" }
            if ($html -match '(?i)<meta\s+name="robots"\s+content="[^"]*noindex') { Fail $d "$addr : resolves to a noindex page ($file)" }
            $anchor = ''
            if ($addr.Contains('#')) { $anchor = $addr.Substring($addr.IndexOf('#') + 1) }
            if ($e.PSObject.Properties.Name -contains 'anchor' -and $e.anchor) { $anchor = [string]$e.anchor }
            if ($anchor -ne '' -and $html -notmatch ('\sid="' + [regex]::Escape($anchor) + '"')) { Fail $d "$addr : the anchor '#$anchor' does not exist in $file" }
        }
        if ($addr -match '\?lang=([^&#]*)') { if ($Matches[1] -notin 'ru', 'en', 'uk') { Fail $d "$addr : language '$($Matches[1])' is not ru, en or uk" } }
        # A holder inside this repository must really hold the address.
        if ([string]$e.holder -match '^repo:(.+)$') {
            $hf = $Matches[1]
            if (-not (Test-Path -LiteralPath (Join-Path $root $hf))) { Fail $d "$addr : holder file '$hf' does not exist" }
            elseif ((Read-Text $hf) -notmatch [regex]::Escape($addr)) { Fail $d "$addr : '$hf' does not contain it" }
        }
    }
    # The other way: every address of this site written in a listing surface of this repository (README, robots.txt) is on the list.
    $listed = @{}; foreach ($e in $entries) { if ($e.PSObject.Properties.Name -contains 'address') { $listed[[string]$e.address] = $true } }
    foreach ($f in 'README.md', 'robots.txt') {   # the sitemap lists every page of the site itself and is held by page-set, not by this list
        foreach ($m in [regex]::Matches((Read-Text $f), [regex]::Escape($Base) + '[^\s"''<>)`\]]*')) {
            $a = $m.Value.TrimEnd('.', ',', ';')
            if (-not $listed.ContainsKey($a)) { Fail $d "$f holds $a, which is not on the list" }
        }
    }
}

# ---------------------------------------------------------------------------------------------------------
# page-width (and inline presentation)
# ---------------------------------------------------------------------------------------------------------
function Get-CssRules([string]$css) {
    $css = [regex]::Replace($css, '(?s)/\*.*?\*/', '')
    $rules = New-Object System.Collections.Generic.List[object]
    $stack = New-Object System.Collections.Generic.Stack[string]
    $buf = [System.Text.StringBuilder]::new()
    foreach ($ch in $css.ToCharArray()) {
        if ($ch -eq '{') { $stack.Push($buf.ToString().Trim()); [void]$buf.Clear(); continue }
        if ($ch -eq '}') {
            $sel = $stack.Pop()
            $body = $buf.ToString().Trim(); [void]$buf.Clear()
            if (-not $sel.StartsWith('@') -and $body -ne '') { $rules.Add(@{ Selector = $sel; Body = $body }) }
            continue
        }
        [void]$buf.Append($ch)
    }
    return $rules
}
function Test-PageWidth {
    $d = 'page-width'
    # A selector whose subject is one of these is a page wrapper unless it sits inside a card, callout, table, dialog or code block.
    $wrapper = '^(html|body|main|header|footer|section|article|\.container|\.page|\.page-head|\.panels|\.listing|\.hero|\.sections|\.site-header|\.site-footer|\.grid|\.terms)$'
    $inside = '(^|[\s>+~])(\.panel|\.card|\.note|\.term|\.table-wrap|table|pre|\.copybox|dialog|\.search-dialog|\.demo|\.minimum-start|\.ba)\b'
    foreach ($css in 'assets/site.css', 'assets/portal.css') {
        foreach ($r in (Get-CssRules (Read-Text $css))) {
            foreach ($sel in ($r.Selector -split ',')) {
                $s = $sel.Trim()
                if ($s -match $inside) { continue }
                $subject = ($s -split '[\s>+~]+')[-1] -replace '(:[a-z-]+(\([^)]*\))?|\[[^\]]*\])+$', ''
                $subject = ($subject -replace '^[a-z0-9]+(?=\.)', '')   # section.listing -> .listing
                if ($subject -notmatch $wrapper -and ($s -notmatch '^(html|body|main)\b')) { continue }
                $b = $r.Body
                if ($b -match '(?i)(^|;)\s*max-width\s*:\s*(?!none|100%|var\(--wide\))') { Fail $d "$css : '$s' sets a max-width on a page wrapper" }
                if ($b -match '(?i)min\(\s*\d+(\.\d+)?px\s*,\s*\d+(\.\d+)?vw\s*\)') { Fail $d "$css : '$s' caps the width with min(NNNpx, NNvw)" }
                if ($b -match '(?i)(^|;)\s*width\s*:\s*\d+(\.\d+)?px') { Fail $d "$css : '$s' fixes a pixel width on a page wrapper" }
                if ($b -match '(?i)margin(-inline)?\s*:\s*0\s+auto|margin(-left|-inline-start)?\s*:\s*auto') { Fail $d "$css : '$s' centres a page wrapper with an auto margin" }
            }
        }
    }
    foreach ($pg in (Get-Pages)) {
        $html = Read-Text $pg
        if ($html -match '(?is)<style[\s>]') { Fail $d "$pg : an inline <style> element - layout lives in the stylesheets" }
        foreach ($m in [regex]::Matches($html, '(?i)<[a-z][^>]*\sstyle\s*=')) { Fail $d "$pg : a style attribute: $($m.Value.Substring(0, [Math]::Min(80, $m.Value.Length)))" }
    }
}

# ---------------------------------------------------------------------------------------------------------
# page-set
# ---------------------------------------------------------------------------------------------------------
function Get-Links([string]$html) {
    $out = New-Object System.Collections.Generic.List[string]
    foreach ($m in [regex]::Matches($html, '(?is)<a\s[^>]*?href="([^"]*)"')) { $out.Add($m.Groups[1].Value) }
    return $out
}
function Test-PageSet {
    $d = 'page-set'
    $pages = Get-Pages
    $ids = @{}; $htmls = @{}
    foreach ($pg in $pages) {
        $h = Read-Text $pg; $htmls[$pg] = $h
        $set = @{}; foreach ($m in [regex]::Matches($h, '\sid="([^"]+)"')) { $set[$m.Groups[1].Value] = $true }
        $ids[$pg] = $set
    }
    # 1. the sitemap and the page set agree, both ways
    $sm = Read-Text 'sitemap.xml'
    $inMap = @{}
    foreach ($m in [regex]::Matches($sm, '<loc>([^<]+)</loc>')) {
        $f = Resolve-Address $m.Groups[1].Value
        if ($null -eq $f) { Fail $d "sitemap: $($m.Groups[1].Value) is not an address of this site"; continue }
        $inMap[$f] = $true
        if (-not $htmls.ContainsKey($f)) { Fail $d "sitemap lists $f, which is not a published page" }
    }
    foreach ($pg in $pages) { if ($pg -ne '404.html' -and -not $inMap.ContainsKey($pg)) { Fail $d "$pg is published but not in the sitemap" } }
    if ($inMap.ContainsKey('404.html')) { Fail $d 'sitemap lists 404.html' }

    # 2. links answer; reach from the landing in at most three steps
    $edges = @{}
    foreach ($pg in $pages) {
        $dir = if ($pg.Contains('/')) { $pg.Substring(0, $pg.LastIndexOf('/')) } else { '' }
        $targets = New-Object System.Collections.Generic.List[string]
        foreach ($href in (Get-Links $htmls[$pg])) {
            if ($href -match '^(mailto:|tel:|javascript:)') { continue }
            if ($href -match '^https?://') {
                if ($href.StartsWith($Base)) { $f = Resolve-Address $href } else { continue }
                $frag = if ($href.Contains('#')) { $href.Substring($href.IndexOf('#') + 1) } else { '' }
            } else {
                if ($pg -eq '404.html' -and -not $href.StartsWith('#')) { Fail $d "404.html : '$href' is not built from the base URL"; continue }
                $frag = ''; $p = $href
                $i = $p.IndexOf('#'); if ($i -ge 0) { $frag = $p.Substring($i + 1); $p = $p.Substring(0, $i) }
                $i = $p.IndexOf('?'); if ($i -ge 0) { $p = $p.Substring(0, $i) }
                if ($p -eq '') { $f = $pg }
                else {
                    $segs = New-Object System.Collections.Generic.List[string]
                    if ($dir -ne '') { foreach ($s in $dir.Split('/')) { $segs.Add($s) } }
                    foreach ($s in $p.Split('/')) { if ($s -eq '..') { if ($segs.Count -gt 0) { $segs.RemoveAt($segs.Count - 1) } } elseif ($s -ne '.' -and $s -ne '') { $segs.Add($s) } }
                    $f = ($segs -join '/')
                    if ($p.EndsWith('/') -or $p -eq '.' -or $p -eq './') { $f = if ($f -eq '') { 'index.html' } else { $f + '/index.html' } }
                }
            }
            if ($null -eq $f) { continue }
            if (-not (Test-Path -LiteralPath (Join-Path $root $f))) { Fail $d "$pg : link '$href' answers nothing (no file '$f')"; continue }
            if ($f.EndsWith('.html')) {
                if ($frag -ne '' -and -not $ids[$f].ContainsKey($frag) -and $f -ne 'index.html') { Fail $d "$pg : link '$href' - no id '$frag' in $f" }
                if ($frag -ne '' -and $f -eq 'index.html' -and -not $ids[$f].ContainsKey($frag) -and $frag -notmatch '^sec-\d\d-(ru|en|uk)$') { Fail $d "$pg : link '$href' - no id '$frag' in index.html" }
                $targets.Add($f)
            }
        }
        $edges[$pg] = $targets
    }
    $depth = @{ 'index.html' = 0 }
    $queue = New-Object System.Collections.Generic.Queue[string]; $queue.Enqueue('index.html')
    while ($queue.Count -gt 0) {
        $cur = $queue.Dequeue()
        foreach ($t in $edges[$cur]) { if (-not $depth.ContainsKey($t)) { $depth[$t] = $depth[$cur] + 1; $queue.Enqueue($t) } }
    }
    foreach ($pg in $pages) {
        if ($pg -eq '404.html') { continue }
        if (-not $depth.ContainsKey($pg)) { Fail $d "$pg is an orphan - not reached from the landing by links" }
        elseif ($depth[$pg] -gt 3) { Fail $d "$pg is $($depth[$pg]) steps from the landing; the limit is 3" }
    }

    # 3. each page: landmarks, skip link, headings, languages
    foreach ($pg in $pages) {
        $h = $htmls[$pg]
        if ([regex]::Matches($h, '<main[\s>]').Count -ne 1) { Fail $d "$pg : needs exactly one <main>" }
        if ($h -notmatch '<main[^>]*\sid="main"') { Fail $d "$pg : <main> has no id=main for the skip link" }
        if ([regex]::Matches($h, '<h1[\s>]').Count -ne 1) { Fail $d "$pg : needs exactly one <h1>" }
        if ($h -notmatch '<html[^>]*\slang="[a-z]{2}"') { Fail $d "$pg : <html> has no lang attribute" }
        $body = $h.Substring($h.IndexOf('<body'))
        $first = [regex]::Match($body, '<(a|button|input|select|textarea)\b[^>]*>')
        if (-not $first.Success -or $first.Value -notmatch 'class="skip-link"' -or $first.Value -notmatch 'href="#main"') { Fail $d "$pg : the skip link to #main is not the first focusable element" }
        foreach ($m in [regex]::Matches($h, '<nav\b[^>]*>')) { if ($m.Value -notmatch 'aria-label=') { Fail $d "$pg : a <nav> without a label: $($m.Value)" } }
        if ([regex]::Matches($h, '<nav\b').Count -lt 1) { Fail $d "$pg : no <nav> landmark" }
        $prev = 0
        foreach ($m in [regex]::Matches($h, '<h([1-6])[\s>]|role="heading"\s+aria-level="([1-6])"')) {
            $lv = if ($m.Groups[1].Success) { [int]$m.Groups[1].Value } else { [int]$m.Groups[2].Value }
            if ($prev -gt 0 -and $lv -gt $prev + 1) { Fail $d "$pg : heading level jumps from $prev to $lv"; break }
            $prev = $lv
        }
        foreach ($l in 'ru', 'en', 'ua') { if ($h -notmatch ('data-l="' + $l + '"')) { Fail $d "$pg : no $l text" } }
    }
    # 4. the portal pages: anatomy of a function page (SITE-REPRESENTATION 7)
    foreach ($pg in ($pages | Where-Object { $_ -like 'portal/functions/*' })) {
        $h = $htmls[$pg]
        foreach ($need in 'h-requirements', 'h-steps', 'h-related') { if ($h -notmatch ('id="' + $need + '"')) { Fail $d "$pg : missing $need" } }
        if ($h -notmatch 'class="note outcome"') { Fail $d "$pg : missing the outcome callout" }
        if ($h -match '(?s)class="note warn".*id="h-steps"' -eq $false -and $h -match 'class="note warn"') { Fail $d "$pg : the warning must stand before the steps" }
        if ([regex]::Matches($h, '<main').Count -eq 1 -and $h.IndexOf('id="h-steps"') -lt $h.IndexOf('id="h-requirements"')) { Fail $d "$pg : requirements must come before the steps" }
    }
    # 5. the not-found page
    if (Test-Path -LiteralPath (Join-Path $root '404.html')) {
        $h = $htmls['404.html']
        if ($h -notmatch '(?i)<meta\s+name="robots"\s+content="noindex') { Fail $d '404.html : not noindex' }
        foreach ($need in @('portal/', 'search', 'universal-agent-kit.zip')) { if ($h -notmatch [regex]::Escape($need)) { Fail $d "404.html : does not offer $need" } }
        if ($h -notmatch ('href="' + [regex]::Escape($Base) + '"')) { Fail $d '404.html : does not link the landing by its absolute address' }
        if ($h -match '(?i)(href|src)="(?!https?://|mailto:|data:|#)[^"]*"') { Fail $d '404.html : a relative address - it is served at any depth and must build every address from the base' }
    } else { Fail $d '404.html does not exist' }
}

# ---------------------------------------------------------------------------------------------------------
# positioning
# ---------------------------------------------------------------------------------------------------------
function Get-Pillars {
    $m = [regex]::Match((Read-Text 'POSITIONING.md'), '(?s)```json\s*(\{.*?\})\s*```')
    if (-not $m.Success) { throw 'INPUT INVALID POSITIONING.md has no json block' }
    return ($m.Groups[1].Value | ConvertFrom-Json).pillars
}
function Strip-Tags([string]$s) {
    $s = [regex]::Replace($s, '<[^>]+>', ' ')
    $s = [System.Net.WebUtility]::HtmlDecode($s)
    $s = $s.Replace('\''', '''')
    return [regex]::Replace($s, '\s+', ' ').Trim()
}
function Test-Positioning {
    $d = 'positioning'
    $pillars = @(Get-Pillars)
    $texts = New-Object System.Collections.Generic.List[object]
    $idx = Read-Text 'index.html'
    foreach ($pair in @(@('description', '<meta name="description" content="([^"]*)">'), @('og:description', '<meta property="og:description" content="([^"]*)">'), @('twitter:description', '<meta name="twitter:description" content="([^"]*)">'))) {
        $m = [regex]::Match($idx, $pair[1]); if ($m.Success) { $texts.Add(@{ Surface = "index.html $($pair[0])"; Lang = 'en'; Text = (Strip-Tags $m.Groups[1].Value) }) } else { Fail $d "index.html has no $($pair[0])" }
    }
    $ld = [regex]::Match($idx, '"description":\s*"([^"]*)"'); if ($ld.Success) { $texts.Add(@{ Surface = 'index.html JSON-LD description'; Lang = 'en'; Text = $ld.Groups[1].Value }) }
    foreach ($m in [regex]::Matches($idx, "(ru|en|ua):\{\s*title:'(?:[^'\\]|\\.)*',\s*desc:'((?:[^'\\]|\\.)*)'")) { $texts.Add(@{ Surface = "index.html script description ($($m.Groups[1].Value))"; Lang = $m.Groups[1].Value; Text = (Strip-Tags $m.Groups[2].Value) }) }
    $lead = [regex]::Match($idx, '(?s)<section class="hero">.*?<p class="lead">(.*?)</p>')
    if ($lead.Success) { foreach ($m in [regex]::Matches($lead.Groups[1].Value, '(?s)<span data-l="(ru|en|ua)">(.*?)</span>\s*(?=<span data-l|$)')) { $texts.Add(@{ Surface = "index.html hero lead ($($m.Groups[1].Value))"; Lang = $m.Groups[1].Value; Text = (Strip-Tags $m.Groups[2].Value) }) } } else { Fail $d 'index.html: the hero lead was not found' }
    # README: the three-language opening between the contact line and the first rule
    $rd = Read-Text 'README.md'
    $m = [regex]::Match($rd, '(?s)\nContact:[^\n]*\n\n(.*?)\n---')
    if ($m.Success) {
        foreach ($para in ($m.Groups[1].Value -split "\n\n")) {
            $p = ($para -replace '[*`]', '').Trim(); if ($p -eq '') { continue }
            $lang = if ($p -match '[їєіґ]') { 'ua' } elseif ($p -match '[Ѐ-ӿ]') { 'ru' } else { 'en' }
            $texts.Add(@{ Surface = "README.md opening ($lang)"; Lang = $lang; Text = ([regex]::Replace($p, '\s+', ' ')) })
        }
    } else { Fail $d 'README.md: the opening block was not found' }
    foreach ($t in $texts) {
        $found = New-Object System.Collections.Generic.List[object]
        for ($i = 0; $i -lt $pillars.Count; $i++) {
            $re = [string]$pillars[$i].($t.Lang).match
            $mm = [regex]::Match($t.Text, $re, 'IgnoreCase')
            if ($mm.Success) { $found.Add(@{ Index = $i; Pos = $mm.Index; Id = $pillars[$i].id }) }
        }
        if ($found.Count -lt 3) { Fail $d "$($t.Surface): names fewer than three pillars - is it a listing? '$($t.Text.Substring(0, [Math]::Min(60, $t.Text.Length)))'"; continue }
        $byPos = @($found | Sort-Object { $_.Pos })
        for ($k = 0; $k -lt $byPos.Count; $k++) { if ($byPos[$k].Index -ne $k) { Fail $d "$($t.Surface): the pillars are not the first ones in the source's order (found: $((($byPos | ForEach-Object { $_.Id }) -join ', ')))"; break } }
    }
    # the sections of the portal repeat the order of the pillars
    $secs = (Get-Content -Raw -Encoding UTF8 (Join-Path $root 'tools/portal/sections.json') | ConvertFrom-Json).sections
    $order = @($secs | Where-Object { $null -ne $_.pillar } | ForEach-Object { $_.pillar })
    $want = @($pillars | ForEach-Object { $_.id })
    if (($order -join ',') -ne ($want -join ',')) { Fail $d "tools/portal/sections.json: the pillar sections ($($order -join ', ')) are not in the order of POSITIONING.md ($($want -join ', '))" }
}

# ---------------------------------------------------------------------------------------------------------
# origins
# ---------------------------------------------------------------------------------------------------------
function Test-Origins {
    $d = 'origins'
    $loaded = @{}
    $files = New-Object System.Collections.Generic.List[string]
    foreach ($pg in (Get-Pages)) { $files.Add($pg) }
    foreach ($f in 'assets/site.css', 'assets/portal.css', 'assets/portal.js') { $files.Add($f) }
    foreach ($f in $files) {
        $t = Read-Text $f
        $hits = New-Object System.Collections.Generic.List[string]
        if ($f.EndsWith('.html')) {
            foreach ($m in [regex]::Matches($t, '(?is)<link\b[^>]*>')) {
                $tag = $m.Value
                if ($tag -match 'rel="(canonical|alternate)"') { continue }
                $hm = [regex]::Match($tag, 'href="(https?://[^"]+)"'); if ($hm.Success) { $hits.Add($hm.Groups[1].Value) }
            }
            foreach ($m in [regex]::Matches($t, '(?is)<(script|img|iframe|source|video|audio|embed)\b[^>]*\ssrc="(https?://[^"]+)"')) { $hits.Add($m.Groups[2].Value) }
            foreach ($m in [regex]::Matches($t, "(?is)(fetch|XMLHttpRequest|importScripts)\s*\(\s*['""](https?://[^'""]+)")) { $hits.Add($m.Groups[2].Value) }
        } else {
            foreach ($m in [regex]::Matches($t, '(?is)(url\(\s*[''"]?|@import\s+[''"]?|fetch\(\s*[''"])(https?://[^''")\s]+)')) { $hits.Add($m.Groups[2].Value) }
        }
        foreach ($u in $hits) {
            $hostName = ([uri]$u).Host
            if ($hostName -eq 'serzhyale.github.io') { continue }
            $loaded[$hostName] = $true
        }
    }
    $privacy = Get-Content -Raw -Encoding UTF8 (Join-Path $root 'tools/portal/privacy.json') | ConvertFrom-Json
    $declared = @{}; foreach ($o in @($privacy.origins)) { $declared[[string]$o.origin] = $true }
    foreach ($h in $loaded.Keys) { if (-not $declared.ContainsKey($h)) { Fail $d "the pages load from $h, which privacy.json does not declare" } }
    foreach ($h in $declared.Keys) { if (-not $loaded.ContainsKey($h)) { Fail $d "privacy.json declares $h, which no page loads" } }
    if (Test-Path -LiteralPath (Join-Path $root 'privacy.html')) {
        $pv = Read-Text 'privacy.html'
        foreach ($h in $declared.Keys) { if ($pv -notmatch [regex]::Escape($h)) { Fail $d "privacy.html does not name $h" } }
        foreach ($ad in 'doubleclick', 'googlesyndication', 'adservice', 'analytics', 'googletagmanager') { if ($pv -match $ad -and $pv -notmatch ('no ' + $ad)) { } }
    } else { Fail $d 'privacy.html does not exist' }
    $adHosts = @($loaded.Keys | Where-Object { $_ -match 'doubleclick|googlesyndication|adservice|googletagmanager|google-analytics|facebook|hotjar|yandex' })
    foreach ($h in $adHosts) { Fail $d "an advertising or analytics host is loaded: $h" }
}

# ---------------------------------------------------------------------------------------------------------
# portal-fresh
# ---------------------------------------------------------------------------------------------------------
function Test-PortalFresh {
    $out = & pwsh -NoProfile -File (Join-Path $PSScriptRoot 'build-portal.ps1') -Check 2>&1
    if ($LASTEXITCODE -ne 0) { Fail 'portal-fresh' ("build-portal -Check exited $LASTEXITCODE`n" + (($out | Select-Object -Last 8) -join "`n")) }
}

try {
    if (Want 'held-addresses') { Test-HeldAddresses }
    if (Want 'page-width')     { Test-PageWidth }
    if (Want 'page-set')       { Test-PageSet }
    if (Want 'positioning')    { Test-Positioning }
    if (Want 'origins')        { Test-Origins }
    if (Want 'portal-fresh')   { Test-PortalFresh }
    foreach ($e in $errors) { Write-Host "ERROR $e" }
    if ($errors.Count -gt 0) {
        Write-Host "check-site: DEFECT - $($errors.Count) finding(s) in dimension '$Dimension'"
        exit 1
    }
    Write-Host "check-site: PASS - dimension '$Dimension'"
    exit 0
} catch {
    Write-Host "ERROR $($_.Exception.Message)"
    Write-Host 'check-site: COULD NOT VERIFY - an input could not be read'
    exit 2
}
