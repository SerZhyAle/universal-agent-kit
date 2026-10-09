# render.ps1 - dot-sourced by tools/build-portal.ps1. Defines the page templates and Build-Site, which returns an
# ordered dictionary: site-relative path -> file content. It writes nothing; the caller decides.
#
# Conventions of the generated pages (SITE-STRUCTURE, SITE-EXPERIENCE, SITE-REPRESENTATION):
#   - one address per page, three languages in the same document: text is wrapped in <span data-l="ru|en|ua">
#     exactly as the landing does it, structure and ids are single;
#   - the kit stylesheet first, then the product layer (assets/site.css), then the portal layer (assets/portal.css);
#   - no style attribute, no inline layout: presentation lives in the stylesheets;
#   - the pre-paint resolver is the landing's text, copied byte for byte.

$script:CurPage = ''
$script:AbsMode = $false

function Esc([string]$s) { return $s.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;').Replace('"', '&quot;') }

# A site-relative link from page $from to site path $to ('' is the landing, a trailing '/' a directory index).
function Rel([string]$from, [string]$to) {
    $frag = ''
    $i = $to.IndexOfAny([char[]]'#?')
    if ($i -ge 0) { $frag = $to.Substring($i); $to = $to.Substring(0, $i) }
    if ($script:AbsMode) { return $Base + $to + $frag }
    $fd = @()
    if ($from.Contains('/')) { $fd = @($from.Substring(0, $from.LastIndexOf('/')).Split('/')) }
    $isDir = ($to -eq '' -or $to.EndsWith('/'))
    $ts = @($to.Split('/', [StringSplitOptions]::RemoveEmptyEntries))
    $tdirs = @()
    if ($isDir) { $tdirs = $ts } elseif ($ts.Count -gt 1) { $tdirs = @($ts[0..($ts.Count - 2)]) }
    $k = 0
    while ($k -lt $fd.Count -and $k -lt $tdirs.Count -and $fd[$k] -eq $tdirs[$k]) { $k++ }
    $up = '../' * ($fd.Count - $k)
    $rest = ''
    if ($k -lt $ts.Count) { $rest = ($ts[$k..($ts.Count - 1)] -join '/') }
    if ($isDir -and $rest -ne '') { $rest += '/' }
    $r = $up + $rest
    if ($r -eq '') { $r = './' }
    return $r + $frag
}

# Inline markup: `code`, **bold**, [text](fn:id | guide:id | term:id | https://..).
function Inl([string]$s) {
    $e = Esc $s
    # code spans are protected first: nothing inside a code span is bold or a link
    $codes = New-Object System.Collections.Generic.List[string]
    $e = [regex]::Replace($e, '`([^`]+)`', [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $codes.Add('<code>' + $m.Groups[1].Value + '</code>'); return [string][char]1 + ($codes.Count - 1) + [string][char]2 })
    $e = [regex]::Replace($e, '\*\*(.+?)\*\*', '<strong>$1</strong>')
    $e = [regex]::Replace($e, '\[([^\]]+)\]\(([^)]+)\)', [System.Text.RegularExpressions.MatchEvaluator]{
        param($m)
        $text = $m.Groups[1].Value; $t = $m.Groups[2].Value
        if ($t -match '^fn:(.+)$')      { return '<a href="' + (Rel $script:CurPage ('portal/functions/' + $Matches[1] + '.html')) + '">' + $text + '</a>' }
        if ($t -match '^guide:(.+)$')   { return '<a href="' + (Rel $script:CurPage ('portal/guides/' + $Matches[1] + '.html')) + '">' + $text + '</a>' }
        if ($t -match '^term:(.+)$')    { return '<a href="' + (Rel $script:CurPage ('portal/glossary.html#term-' + $Matches[1])) + '">' + $text + '</a>' }
        return '<a href="' + $t + '" target="_blank" rel="noopener">' + $text + '</a>'
    })
    $e = [regex]::Replace($e, ([string][char]1) + '(\d+)' + ([string][char]2), [System.Text.RegularExpressions.MatchEvaluator]{ param($m) return $codes[[int]$m.Groups[1].Value] })
    return $e
}

# Three-language span set for a localized object (markup allowed) / plain text for one language.
function T($o) {
    $b = [System.Text.StringBuilder]::new()
    foreach ($l in $Locs) { [void]$b.Append('<span data-l="' + $l + '">' + (Inl ([string]$o.$l)) + '</span>') }
    return $b.ToString()
}
function Pl($o, [string]$l) { return [string]$o.$l }
function U([string]$key) {
    $p = $script:M.Ui.PSObject.Properties[$key]
    if ($null -eq $p) { throw "ui key missing: $key" }
    return $p.Value
}
function UT([string]$key) { return (T (U $key)) }
function A([string]$s) { return (Esc $s) }

# ---------------------------------------------------------------------------------------------------------
# Shared chrome
# ---------------------------------------------------------------------------------------------------------
function Get-Landing { return [System.IO.File]::ReadAllText((Join-Path $root 'index.html'), $utf8) }

function Get-PrePaint {
    $m = [regex]::Match((Get-Landing), '(?s)<script>\s*/\* PAGE-STYLE section 7 pre-paint resolver.*?</script>')
    if (-not $m.Success) { throw 'INPUT INVALID index.html: the pre-paint resolver was not found' }
    return $m.Value
}
function Get-Symbol([string]$id) {
    $m = [regex]::Match((Get-Landing), '(?s)<symbol id="' + [regex]::Escape($id) + '".*?</symbol>')
    if (-not $m.Success) { throw "INPUT INVALID index.html: symbol $id not found" }
    return $m.Value
}

$script:UiKeysForJs = @('langGroup', 'theme', 'toLight', 'toDark', 'toTop', 'menu', 'navPortal', 'navTools', 'navAuthor', 'navSection',
    'breadcrumb', 'searchTitle', 'searchEmpty', 'searchEmptyHelp', 'searchCount', 'searchFail', 'kind.command', 'kind.agent', 'kind.practice')

function Frame([hashtable]$p) {
    $script:CurPage = $p.Path
    $r = Rel $p.Path ''
    $site = 'Universal Agent Kit'
    $titles = [ordered]@{}; $descs = [ordered]@{}
    foreach ($l in $Locs) {
        $titles[$l] = (Pl $p.Title $l) + ' - ' + $site
        $descs[$l]  = (Pl $p.Desc $l)
    }
    $ui = [ordered]@{}
    foreach ($k in $script:UiKeysForJs) {
        $o = U $k
        $ui[$k] = [ordered]@{ en = [string]$o.en; ru = [string]$o.ru; ua = [string]$o.ua }
    }
    $i18n = [ordered]@{ t = $titles; d = $descs; ui = $ui } | ConvertTo-Json -Depth 6 -Compress
    $url = $Base + $p.Path
    $noIndex = $p.ContainsKey('NoIndex') -and $p.NoIndex
    $alt = ''
    if (-not $noIndex) {
        $alt = '<link rel="alternate" hreflang="en" href="' + $url + '?lang=en">' + "`n" +
               '<link rel="alternate" hreflang="ru" href="' + $url + '?lang=ru">' + "`n" +
               '<link rel="alternate" hreflang="uk" href="' + $url + '?lang=uk">' + "`n" +
               '<link rel="alternate" hreflang="x-default" href="' + $url + '">' + "`n"
    }
    $robots = ''
    if ($noIndex) { $robots = '<meta name="robots" content="noindex">' + "`n" }
    $ld = [ordered]@{ '@context' = 'https://schema.org'; '@type' = 'WebPage'; name = $titles.en; description = $descs.en; url = $url; inLanguage = @('en', 'ru', 'uk'); isPartOf = [ordered]@{ '@type' = 'WebSite'; name = $site; url = $Base } } | ConvertTo-Json -Depth 4 -Compress
    $te = A $titles.en; $de = A $descs.en
    $head = @"
<!DOCTYPE html>
<html lang="en" data-lang="en" data-theme="dark" data-root="$(A $r)">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$te</title>
<meta name="description" content="$de">
$robots<link rel="canonical" href="$url">
$alt<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Crect width='64' height='64' rx='14' fill='%233fb950'/%3E%3Cpath d='M20 18h24M20 30h24M20 42h16' stroke='%2304130c' stroke-width='5' stroke-linecap='round' fill='none'/%3E%3C/svg%3E">
<meta name="theme-color" content="#0a0f0a">
<meta property="og:type" content="website">
<meta property="og:site_name" content="$site">
<meta property="og:url" content="$url">
<meta property="og:title" content="$te">
<meta property="og:description" content="$de">
<meta property="og:image" content="${Base}og-image.png">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="$te">
<meta name="twitter:description" content="$de">
<meta name="twitter:image" content="${Base}og-image.png">
<script type="application/ld+json">$ld</script>
<script type="application/json" id="page-i18n">$i18n</script>
$($script:PrePaint)
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${r}assets/sza-kit.css">
<link rel="stylesheet" href="${r}assets/site.css">
<link rel="stylesheet" href="${r}assets/portal.css">
</head>
<body>
<a class="skip-link" href="#main">$(UT 'skip')</a>
<div class="bg-blobs" aria-hidden="true"><div class="blob blob-1"></div><div class="blob blob-2"></div><div class="blob blob-3"></div></div>
<svg class="icon-sprite" aria-hidden="true" xmlns="http://www.w3.org/2000/svg">
  $($script:SymDownload)
  $($script:SymTop)
</svg>
$(Header $p)
<main id="main" class="page">
$($p.Main)
</main>
$(Footer $p)
<button class="to-top" id="toTop" type="button" aria-label="Back to top" title="Back to top"><svg class="icon" aria-hidden="true"><use href="#icon-nav-scroll-top"/></svg></button>
$(SearchDialog)
<script src="${r}assets/portal.js" defer></script>
</body>
</html>
"@
    return $head.Replace("`r`n", "`n")
}

function Header([hashtable]$p) {
    $f = $p.Path
    $nav = @(
        @{ k = 'portal';   to = 'portal/' },
        @{ k = 'overview'; to = 'portal/overview.html' },
        @{ k = 'showcase'; to = 'portal/showcase.html' },
        @{ k = 'subjects'; to = 'portal/subjects.html' },
        @{ k = 'glossary'; to = 'portal/glossary.html' }
    )
    $links = ($nav | ForEach-Object { '<a href="' + (Rel $f $_.to) + '"' + $(if ($f -eq $_.to -or ($_.to -eq 'portal/' -and $f -eq 'portal/')) { ' aria-current="page"' } else { '' }) + '>' + (UT $_.k) + '</a>' }) -join "`n      "
    return @"
<header class="site-header portal-header">
    <a class="brand" href="$(Rel $f '')">Universal&nbsp;Agent&nbsp;Kit<span class="dot">.</span></a>
    <button class="ctl nav-toggle" id="navToggle" type="button" aria-expanded="false" aria-controls="portalNav">$(UT 'menu')</button>
    <nav class="portal-nav" id="portalNav" aria-label="Portal" data-aria="navPortal">
      $links
    </nav>
    <button class="ctl search-open" id="searchOpen" type="button" aria-haspopup="dialog" aria-controls="searchDialog">$(UT 'search')<kbd aria-hidden="true">/</kbd></button>
    <span class="seg" role="group" aria-label="Language" id="langGroup" data-aria="langGroup">
      <button id="lng-ru" type="button" data-set-lang="ru" aria-pressed="false" aria-label="Русский">RU</button>
      <button id="lng-en" type="button" data-set-lang="en" aria-pressed="true" aria-label="English">EN</button>
      <button id="lng-ua" type="button" data-set-lang="ua" aria-pressed="false" aria-label="Українська">UA</button>
    </span>
    <button class="theme-btn" id="themeBtn" type="button" title="Theme" aria-label="Theme" aria-pressed="false">$(UT 'theme')</button>
    <a class="btn btn-primary btn-sm" href="$(Rel $f 'universal-agent-kit.zip')" download>
      <svg class="icon" aria-hidden="true"><use href="#icon-action-download"/></svg>$(UT 'download')
    </a>
</header>
"@
}

function SearchDialog {
    return @"
<dialog class="search-dialog" id="searchDialog" aria-labelledby="searchTitle">
  <form method="dialog" class="search-form" id="searchForm">
    <div class="search-head">
      <h2 id="searchTitle">$(UT 'searchTitle')</h2>
      <button class="btn btn-ghost btn-sm" type="button" id="searchClose">$(UT 'searchClose')</button>
    </div>
    <input class="search-input" id="searchInput" type="search" autocomplete="off" spellcheck="false" aria-labelledby="searchTitle" placeholder="Search..">
    <p class="search-status" id="searchStatus" role="status" aria-live="polite"></p>
    <ul class="search-results" id="searchResults"></ul>
  </form>
</dialog>
"@
}

function Footer([hashtable]$p) {
    $f = $p.Path
    $tools = @(
        @('Fast Media Sorter &amp; Organizer', 'https://serzhyale.github.io/FastMediaSorter_mob_v2/'),
        @('Fast Media Sorter for Windows', 'https://serzhyale.github.io/FastMediaSorter_Lite/'),
        @('CyrFlip', 'https://serzhyale.github.io/CyrFlip/'),
        @('doc-html-translate', 'https://serzhyale.github.io/doc-html-translate/'),
        @('FileDO', 'https://serzhyale.github.io/FileDO/'),
        @('STREAMS Player', 'https://serzhyale.github.io/StreamsPlayer/'),
        @('OneClickRunner', 'https://serzhyale.github.io/OneClickRunner/'),
        @('SZA (hub)', 'https://sza.od.ua')
    )
    $grid = ($tools | ForEach-Object { '<a href="' + $_[1] + '" target="_blank" rel="noopener">' + $_[0] + '</a>' }) -join "`n        "
    $blocks = ($Locs | ForEach-Object {
        $l = $_
        '  <div data-l="' + $l + '">' + "`n" +
        '    <strong>Universal Agent Kit</strong> - ' + (Inl (Pl (U 'footerTag') $l)) + "`n" +
        '    <div class="cta">' + "`n" +
        '      <a class="btn btn-primary" href="' + (Rel $f 'universal-agent-kit.zip') + '" download><svg class="icon" aria-hidden="true"><use href="#icon-action-download"/></svg>' + (Inl (Pl (U 'download') $l)) + '</a>' + "`n" +
        '      <a class="btn btn-ghost" href="https://github.com/SerZhyAle/universal-agent-kit" target="_blank" rel="noopener">' + (Inl (Pl (U 'sourceCode') $l)) + '</a>' + "`n" +
        '    </div>' + "`n" +
        '    <p class="muted">' + (Inl (Pl (U 'footerLicense') $l)) + '</p>' + "`n" +
        '  </div>'
    }) -join "`n"
    return @"
<footer class="site-footer"><div class="container">
$blocks
  <section class="tools-family" aria-labelledby="more-tools-heading">
    <h2 id="more-tools-heading">$(UT 'navTools')</h2>
    <nav class="tools-grid" aria-label="More tools by SZA" data-aria="navTools">
        $grid
    </nav>
  </section>
  <div class="footer-bottom">
    <span>&copy; 2026 <a href="https://sza.od.ua" target="_blank" rel="noopener">Serhii Zhyhunenko</a></span>
    <nav aria-label="Author links" data-aria="navAuthor"><a href="$(Rel $f 'privacy.html')">$(UT 'privacy')</a> &middot; <a href="https://sza.od.ua" target="_blank" rel="noopener">sza.od.ua</a> &middot; <a href="https://github.com/SerZhyAle" target="_blank" rel="noopener">GitHub</a> &middot; <a href="mailto:sza@ukr.net">sza@ukr.net</a></nav>
  </div>
  <p class="provenance muted">$(UT 'provenance')</p>
</div></footer>
"@
}

function Crumbs([string]$from, [object[]]$items) {
    $lis = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $items.Count; $i++) {
        $it = $items[$i]
        if ($i -eq $items.Count - 1) { $lis.Add('<li aria-current="page">' + (T $it.Label) + '</li>') }
        else { $lis.Add('<li><a href="' + (Rel $from $it.To) + '">' + (T $it.Label) + '</a></li>') }
    }
    return '<nav class="crumbs" aria-label="Breadcrumb" data-aria="breadcrumb"><ol>' + ($lis -join '') + '</ol></nav>'
}

function PageHead([string]$crumbs, [string]$eyebrow, [object]$title, [object]$lead) {
    $e = ''
    if ($eyebrow -ne '') { $e = '<p class="eyebrow">' + $eyebrow + '</p>' + "`n" }
    $l = ''
    if ($null -ne $lead) { $l = '<p class="lead prose">' + (T $lead) + '</p>' + "`n" }
    return $crumbs + "`n" + '<header class="page-head">' + "`n" + $e + '<h1>' + (T $title) + '</h1>' + "`n" + $l + '</header>'
}

# ---------------------------------------------------------------------------------------------------------
# Facts rendered from the inventory (never retyped)
# ---------------------------------------------------------------------------------------------------------
function Get-Where($c) {
    $paths = @($c.sources | ForEach-Object { if ($_.StartsWith('kit/')) { $_.Substring(4) } else { $_ } })
    $byDir = @{}
    foreach ($p in $paths) { $d = if ($p.Contains('/')) { $p.Substring(0, $p.LastIndexOf('/')) } else { '' }; if (-not $byDir.ContainsKey($d)) { $byDir[$d] = 0 }; $byDir[$d]++ }
    $out = New-Object System.Collections.Generic.List[string]
    $seenDir = @{}
    foreach ($p in $paths) {
        $d = if ($p.Contains('/')) { $p.Substring(0, $p.LastIndexOf('/')) } else { '' }
        if ($d -ne '' -and $byDir[$d] -ge 3) { if (-not $seenDir.ContainsKey($d)) { $seenDir[$d] = $true; $out.Add($d + '/') } }
        else { $out.Add($p) }
    }
    return (($out | ForEach-Object { '<code>' + (Esc $_) + '</code>' }) -join ', ')
}

function Get-Needs($c) {
    $perms = @($c.permissions)
    if ($perms.Count -eq 0) { return '<span class="muted">' + (UT 'needs.none') + '</span>' }
    return '<ul class="chips">' + (($perms | ForEach-Object { '<li class="pill">' + (UT ('perm.' + $_)) + '</li>' }) -join '') + '</ul>'
}

# ---------------------------------------------------------------------------------------------------------
# Pages
# ---------------------------------------------------------------------------------------------------------
function FnLink([string]$from, [string]$id) {
    $f = $script:M.Functions[$id]
    return '<a href="' + (Rel $from ('portal/functions/' + $id + '.html')) + '">' + (T $f.title) + '</a>'
}

function Build-FunctionPage($c, $pos) {
    $id = $c.id; $f = $script:M.Functions[$id]
    $path = 'portal/functions/' + $id + '.html'
    $script:CurPage = $path
    $sec = $script:M.Sections | Where-Object { $_.id -eq $c.section } | Select-Object -First 1
    $crumbs = Crumbs $path @(
        @{ Label = (U 'crumbKit'); To = '' },
        @{ Label = (U 'portal'); To = 'portal/' },
        @{ Label = $sec.title; To = ('portal/#section-' + $sec.id) },
        @{ Label = $f.title; To = $null })
    $eyebrow = '<span class="pill">' + (UT ('kind.' + $c.kind)) + '</span> <a href="' + (Rel $path ('portal/#section-' + $sec.id)) + '">' + (T $sec.title) + '</a>'
    $b = New-Object System.Collections.Generic.List[string]
    $b.Add((PageHead $crumbs $eyebrow $f.title $f.lead))
    $b.Add('<article class="fn" data-kind="' + $c.kind + '">')
    $b.Add('<div class="panels">')
    if (Has $f 'situation') { $b.Add('<section class="panel" aria-labelledby="h-situation"><h2 id="h-situation">' + (UT 'lbl.situation') + '</h2><p class="prose">' + (T $f.situation) + '</p></section>') }
    $b.Add('<section class="panel" aria-labelledby="h-requirements"><h2 id="h-requirements">' + (UT 'lbl.requirements') + '</h2><dl class="req">')
    $b.Add('<div><dt>' + (UT 'lbl.availability') + '</dt><dd>' + (UT 'avail.kit') + '</dd></div>')
    $b.Add('<div><dt>' + (UT 'lbl.needs') + '</dt><dd>' + (Get-Needs $c) + '</dd></div>')
    $b.Add('<div><dt>' + (UT 'lbl.runtime') + '</dt><dd>' + (UT ('runtime.' + $c.runtime)) + '</dd></div>')
    $b.Add('<div><dt>' + (UT 'lbl.interface') + '</dt><dd>' + (UT 'interface.chat') + '</dd></div>')
    $b.Add('<div><dt>' + (UT 'lbl.where') + '</dt><dd>' + (Get-Where $c) + '</dd></div>')
    $b.Add('</dl></section>')
    if (Has $f 'warning') { $b.Add('<div class="note warn" role="note"><div class="tag">' + (UT 'lbl.warning') + '</div><p>' + (T $f.warning) + '</p></div>') }
    $b.Add('<section class="panel wide" aria-labelledby="h-steps"><h2 id="h-steps">' + (UT 'lbl.steps') + '</h2><ol class="steps">')
    foreach ($s in @($f.steps)) { $b.Add('<li><span class="prose">' + (T $s) + '</span></li>') }
    $b.Add('</ol></section>')
    $b.Add('<div class="note outcome" role="note"><div class="tag">' + (UT 'lbl.outcome') + '</div><p>' + (T $f.outcome) + '</p></div>')
    if ((Has $f 'tips') -and @($f.tips).Count -gt 0) {
        $b.Add('<section class="panel" aria-labelledby="h-tips"><h2 id="h-tips">' + (UT 'lbl.tips') + '</h2><ul class="tips">')
        foreach ($s in @($f.tips)) { $b.Add('<li class="prose">' + (T $s) + '</li>') }
        $b.Add('</ul></section>')
    }
    $b.Add('<section class="panel" aria-labelledby="h-related"><h2 id="h-related">' + (UT 'lbl.related') + '</h2><ul class="fn-list">')
    foreach ($r in @($f.related)) {
        $rf = $script:M.Functions[$r]
        $b.Add('<li>' + (FnLink $path $r) + '<span class="fn-pitch">' + (T $rf.pitch) + '</span></li>')
    }
    $b.Add('</ul></section>')
    if ((Has $f 'terms') -and @($f.terms).Count -gt 0) {
        $b.Add('<section class="panel wide" aria-labelledby="h-terms"><h2 id="h-terms">' + (UT 'lbl.terms') + '</h2><ul class="chips">')
        foreach ($t in @($f.terms)) { $b.Add('<li><a class="pill" href="' + (Rel $path ('portal/glossary.html#term-' + $t)) + '">' + (T $script:M.Terms[$t].term) + '</a></li>') }
        $b.Add('</ul></section>')
    }
    $b.Add('</div>')
    # previous / next inside the section
    $same = @($script:M.Inventory.capabilities | Where-Object { $_.section -eq $c.section })
    $i = [Array]::IndexOf(@($same | ForEach-Object { $_.id }), $id)
    $pager = ''
    if ($i -gt 0) { $prevId = $same[$i - 1].id; $pager += '<a class="pager-prev" rel="prev" href="' + (Rel $path ('portal/functions/' + $prevId + '.html')) + '"><span class="pager-dir">' + (UT 'lbl.prev') + '</span><span>' + (T $script:M.Functions[$prevId].title) + '</span></a>' }
    if ($i -lt $same.Count - 1) { $nextId = $same[$i + 1].id; $pager += '<a class="pager-next" rel="next" href="' + (Rel $path ('portal/functions/' + $nextId + '.html')) + '"><span class="pager-dir">' + (UT 'lbl.next') + '</span><span>' + (T $script:M.Functions[$nextId].title) + '</span></a>' }
    if ($pager -ne '') { $b.Add('<nav class="pager" aria-label="In this section" data-aria="navSection">' + $pager + '</nav>') }
    $b.Add('</article>')
    return @{ Path = $path; Title = $f.title; Desc = $f.pitch; Main = ($b -join "`n") }
}

function Build-GuidePage($id) {
    $g = $script:M.Guides[$id]
    $path = 'portal/guides/' + $id + '.html'
    $script:CurPage = $path
    $crumbs = Crumbs $path @(
        @{ Label = (U 'crumbKit'); To = '' },
        @{ Label = (U 'portal'); To = 'portal/' },
        @{ Label = (U 'home.guides'); To = 'portal/#guides' },
        @{ Label = $g.title; To = $null })
    $b = New-Object System.Collections.Generic.List[string]
    $b.Add((PageHead $crumbs ('<span class="pill">' + (UT 'lbl.guide') + '</span>') $g.title $g.lead))
    $b.Add('<article class="fn guide"><div class="panels">')
    $b.Add('<section class="panel" aria-labelledby="h-functions"><h2 id="h-functions">' + (UT 'lbl.functions') + '</h2><ul class="fn-list">')
    foreach ($r in @($g.functions)) { $b.Add('<li>' + (FnLink $path $r) + '<span class="fn-pitch">' + (T $script:M.Functions[$r].pitch) + '</span></li>') }
    $b.Add('</ul></section>')
    $b.Add('<section class="panel wide" aria-labelledby="h-steps"><h2 id="h-steps">' + (UT 'lbl.steps') + '</h2><ol class="steps">')
    foreach ($s in @($g.steps)) { $b.Add('<li><span class="prose">' + (T $s) + '</span></li>') }
    $b.Add('</ol></section>')
    $b.Add('<div class="note outcome" role="note"><div class="tag">' + (UT 'lbl.outcome') + '</div><p>' + (T $g.outcome) + '</p></div>')
    if ((Has $g 'terms') -and @($g.terms).Count -gt 0) {
        $b.Add('<section class="panel wide" aria-labelledby="h-terms"><h2 id="h-terms">' + (UT 'lbl.terms') + '</h2><ul class="chips">')
        foreach ($t in @($g.terms)) { $b.Add('<li><a class="pill" href="' + (Rel $path ('portal/glossary.html#term-' + $t)) + '">' + (T $script:M.Terms[$t].term) + '</a></li>') }
        $b.Add('</ul></section>')
    }
    $b.Add('</div></article>')
    return @{ Path = $path; Title = $g.title; Desc = $g.pitch; Main = ($b -join "`n") }
}

function Build-HomePage {
    $path = 'portal/'
    $script:CurPage = $path
    $b = New-Object System.Collections.Generic.List[string]
    $b.Add((PageHead (Crumbs $path @(@{ Label = (U 'crumbKit'); To = '' }, @{ Label = (U 'portal'); To = $null })) '' (U 'home.title') (U 'home.lead')))
    $b.Add('<section class="listing" id="guides" aria-labelledby="h-guides"><h2 id="h-guides">' + (UT 'home.guides') + '</h2><p class="prose">' + (UT 'home.guidesLead') + '</p><div class="grid cards">')
    foreach ($id in $script:M.Guides.Keys) {
        $g = $script:M.Guides[$id]
        $b.Add('<a class="card" href="' + (Rel $path ('portal/guides/' + $id + '.html')) + '"><h3>' + (T $g.title) + '</h3><p>' + (T $g.pitch) + '</p></a>')
    }
    $b.Add('</div></section>')
    $b.Add('<section class="listing" id="sections" aria-labelledby="h-sections"><h2 id="h-sections">' + (UT 'home.sections') + '</h2><p class="prose">' + (UT 'home.sectionsLead') + '</p><div class="panels panels-3">')
    foreach ($s in $script:M.Sections) {
        $fns = @($script:M.Inventory.capabilities | Where-Object { $_.section -eq $s.id })
        $count = (U 'home.countFn')
        $cnt = [ordered]@{}
        foreach ($l in $Locs) { $cnt[$l] = (Pl $count $l).Replace('{n}', [string]$fns.Count) }
        $b.Add('<section class="panel section-listing" id="section-' + $s.id + '" aria-labelledby="h-section-' + $s.id + '">')
        $b.Add('<h3 id="h-section-' + $s.id + '">' + (T $s.title) + ' <span class="count">' + (T $cnt) + '</span></h3><p class="prose">' + (T $s.lead) + '</p><ul class="fn-list">')
        foreach ($c in $fns) {
            $f = $script:M.Functions[$c.id]
            $name = ''
            if ($c.kind -ne 'practice') { $name = ' <code class="fn-name">' + (Esc ([string]$c.name)) + '</code>' }
            $b.Add('<li><a href="' + (Rel $path ('portal/functions/' + $c.id + '.html')) + '">' + (T $f.title) + '</a>' + $name + '<span class="fn-pitch">' + (T $f.pitch) + '</span></li>')
        }
        $b.Add('</ul></section>')
    }
    $b.Add('</div></section>')
    $b.Add('<section class="listing" id="also" aria-labelledby="h-also"><h2 id="h-also">' + (UT 'home.alsoTitle') + '</h2><ul class="chips">')
    foreach ($x in @(@('overview', 'portal/overview.html'), @('showcase', 'portal/showcase.html'), @('subjects', 'portal/subjects.html'), @('glossary', 'portal/glossary.html'))) {
        $b.Add('<li><a class="pill" href="' + (Rel $path $x[1]) + '">' + (UT $x[0]) + '</a></li>')
    }
    $b.Add('</ul></section>')
    return @{ Path = $path; Title = (U 'home.title'); Desc = (U 'home.desc'); Main = ($b -join "`n") }
}

function Build-OverviewPage {
    $path = 'portal/overview.html'
    $script:CurPage = $path
    $caps = @($script:M.Inventory.capabilities)
    $nCmd = @($caps | Where-Object { $_.kind -eq 'command' }).Count
    $nAgent = @($caps | Where-Object { $_.kind -eq 'agent' }).Count
    $nPrac = @($caps | Where-Object { $_.kind -eq 'practice' }).Count
    $ships = [ordered]@{}
    foreach ($l in $Locs) { $ships[$l] = (Pl (U 'overview.ships') $l).Replace('{commands}', [string]$nCmd).Replace('{agents}', [string]$nAgent).Replace('{practices}', [string]$nPrac) }
    $b = New-Object System.Collections.Generic.List[string]
    $b.Add((PageHead (Crumbs $path @(@{ Label = (U 'crumbKit'); To = '' }, @{ Label = (U 'portal'); To = 'portal/' }, @{ Label = (U 'overview'); To = $null })) '' (U 'overview.title') (U 'overview.lead')))
    $b.Add('<div class="panels">')
    $b.Add('<section class="panel" aria-labelledby="h-for"><h2 id="h-for">' + (UT 'overview.forTitle') + '</h2><p class="prose">' + (UT 'overview.forLead') + '</p><ol class="pillars">')
    foreach ($p in $script:M.Pillars) {
        $s = $script:M.Sections | Where-Object { $_.pillar -eq $p.id } | Select-Object -First 1
        $n = @($caps | Where-Object { $_.section -eq $s.id }).Count
        $cnt = [ordered]@{}
        foreach ($l in $Locs) { $cnt[$l] = (Pl (U 'home.countFn') $l).Replace('{n}', [string]$n) }
        $b.Add('<li><a href="' + (Rel $path ('portal/#section-' + $s.id)) + '">' + (T $s.title) + '</a> <span class="count">' + (T $cnt) + '</span><span class="fn-pitch">' + (T $s.lead) + '</span></li>')
    }
    $b.Add('</ol></section>')
    $b.Add('<section class="panel" aria-labelledby="h-ships"><h2 id="h-ships">' + (UT 'overview.shipsTitle') + '</h2><p class="prose">' + (T $ships) + '</p></section>')
    $b.Add('<section class="panel" aria-labelledby="h-how"><h2 id="h-how">' + (UT 'overview.howTitle') + '</h2><p class="prose">' + (UT 'overview.how1') + '</p><p class="prose">' + (UT 'overview.how2') + '</p><p class="prose">' + (UT 'overview.how3') + '</p></section>')
    $b.Add('<section class="panel" aria-labelledby="h-limits"><h2 id="h-limits">' + (UT 'overview.limitsTitle') + '</h2><p class="prose">' + (UT 'overview.limits') + '</p></section>')
    $b.Add('</div>')
    return @{ Path = $path; Title = (U 'overview.title'); Desc = (U 'overview.desc'); Main = ($b -join "`n") }
}

function Build-ShowcasePage {
    $path = 'portal/showcase.html'
    $script:CurPage = $path
    $b = New-Object System.Collections.Generic.List[string]
    $b.Add((PageHead (Crumbs $path @(@{ Label = (U 'crumbKit'); To = '' }, @{ Label = (U 'portal'); To = 'portal/' }, @{ Label = (U 'showcase'); To = $null })) '' (U 'showcase.title') (U 'showcase.lead')))
    $b.Add('<div class="grid cards">')
    foreach ($c in @($script:M.Inventory.capabilities | Where-Object { (Has $_ 'showcase') -and $_.showcase })) {
        $f = $script:M.Functions[$c.id]
        $sec = $script:M.Sections | Where-Object { $_.id -eq $c.section } | Select-Object -First 1
        $b.Add('<a class="card" href="' + (Rel $path ('portal/functions/' + $c.id + '.html')) + '"><p class="eyebrow"><span class="pill">' + (UT ('kind.' + $c.kind)) + '</span> ' + (T $sec.title) + '</p><h2>' + (T $f.title) + '</h2><p>' + (T $f.pitch) + '</p></a>')
    }
    $b.Add('</div>')
    return @{ Path = $path; Title = (U 'showcase.title'); Desc = (U 'showcase.desc'); Main = ($b -join "`n") }
}

function Get-IndexKey([string]$label) { return $label.TrimStart('/', '`', '<', '"', '(') }

function Build-SubjectsPage {
    $path = 'portal/subjects.html'
    $script:CurPage = $path
    $cultures = @{ ru = 'ru-RU'; en = 'en-US'; ua = 'uk-UA' }
    $b = New-Object System.Collections.Generic.List[string]
    $b.Add((PageHead (Crumbs $path @(@{ Label = (U 'crumbKit'); To = '' }, @{ Label = (U 'portal'); To = 'portal/' }, @{ Label = (U 'subjects'); To = $null })) '' (U 'subjects.title') (U 'subjects.lead')))
    foreach ($l in $Locs) {
        $ci = [System.Globalization.CultureInfo]::GetCultureInfo($cultures[$l])
        $entries = @{}   # label.ToLower -> @{ Label; Links = list of [href, text] }
        function Add-Entry([string]$label, [string]$href, [string]$text) {
            $k = $label.ToLowerInvariant()
            if (-not $entries.ContainsKey($k)) { $entries[$k] = @{ Label = $label; Links = (New-Object System.Collections.Generic.List[object]) } }
            if (-not ($entries[$k].Links | Where-Object { $_.Href -eq $href })) { $entries[$k].Links.Add(@{ Href = $href; Text = $text }) }
        }
        foreach ($c in $script:M.Inventory.capabilities) {
            $f = $script:M.Functions[$c.id]; $h = Rel $path ('portal/functions/' + $c.id + '.html'); $title = Pl $f.title $l
            if ($c.kind -ne 'practice') { Add-Entry ([string]$c.name) $h $title }
            foreach ($k in @($f.keywords.$l)) { Add-Entry ([string]$k) $h $title }
        }
        foreach ($id in $script:M.Guides.Keys) {
            $g = $script:M.Guides[$id]; $h = Rel $path ('portal/guides/' + $id + '.html'); $title = Pl $g.title $l
            Add-Entry $title $h ((Pl (U 'lbl.guide') $l))
            foreach ($k in @($g.keywords.$l)) { Add-Entry ([string]$k) $h $title }
        }
        foreach ($id in $script:M.Terms.Keys) {
            $t = $script:M.Terms[$id]
            Add-Entry (Pl $t.term $l) (Rel $path ('portal/glossary.html#term-' + $id)) ((Pl (U 'glossary') $l))
        }
        $sorted = @($entries.Values | Sort-Object -Property @{ Expression = { Get-IndexKey $_.Label } }, @{ Expression = { $_.Label } } -Culture $cultures[$l])
        $groups = [ordered]@{}
        foreach ($e in $sorted) {
            $key = Get-IndexKey $e.Label
            $ch = if ($key.Length -gt 0) { $key.Substring(0, 1).ToUpper($ci) } else { '#' }
            if ($ch -notmatch '^\p{L}$') { $ch = '#' }
            if (-not $groups.Contains($ch)) { $groups[$ch] = New-Object System.Collections.Generic.List[object] }
            $groups[$ch].Add($e)
        }
        $b.Add('<div class="subject-index" data-l="' + $l + '">')
        $b.Add('<p class="letters">' + (($groups.Keys | ForEach-Object { '<a href="#idx-' + $l + '-' + [uri]::EscapeDataString($_).Replace('%', '') + '">' + (Esc $_) + '</a>' }) -join ' ') + '</p>')
        foreach ($ch in $groups.Keys) {
            $gid = 'idx-' + $l + '-' + [uri]::EscapeDataString($ch).Replace('%', '')
            $b.Add('<section class="idx-group" aria-labelledby="' + $gid + '"><h2 id="' + $gid + '">' + (Esc $ch) + '</h2><ul class="idx-list">')
            foreach ($e in $groups[$ch]) {
                $links = ($e.Links | ForEach-Object { '<a href="' + $_.Href + '">' + (Esc $_.Text) + '</a>' }) -join ', '
                $b.Add('<li><span class="idx-label">' + (Esc $e.Label) + '</span> <span class="idx-links">' + $links + '</span></li>')
            }
            $b.Add('</ul></section>')
        }
        $b.Add('</div>')
    }
    return @{ Path = $path; Title = (U 'subjects.title'); Desc = (U 'subjects.desc'); Main = ($b -join "`n") }
}

function Build-GlossaryPage {
    $path = 'portal/glossary.html'
    $script:CurPage = $path
    $b = New-Object System.Collections.Generic.List[string]
    $b.Add((PageHead (Crumbs $path @(@{ Label = (U 'crumbKit'); To = '' }, @{ Label = (U 'portal'); To = 'portal/' }, @{ Label = (U 'glossary'); To = $null })) '' (U 'glossary.title') (U 'glossary.lead')))
    $b.Add('<dl class="terms" id="terms">')
    $ids = @($script:M.Terms.Keys | Sort-Object { [string]$script:M.Terms[$_].term.en } -Culture 'en-US')
    foreach ($id in $ids) {
        $t = $script:M.Terms[$id]
        $used = New-Object System.Collections.Generic.List[string]
        foreach ($c in $script:M.Inventory.capabilities) {
            $f = $script:M.Functions[$c.id]
            if ((Has $f 'terms') -and (@($f.terms) -contains $id)) { $used.Add('<a href="' + (Rel $path ('portal/functions/' + $c.id + '.html')) + '">' + (T $f.title) + '</a>') }
        }
        foreach ($gid in $script:M.Guides.Keys) {
            $g = $script:M.Guides[$gid]
            if ((Has $g 'terms') -and (@($g.terms) -contains $id)) { $used.Add('<a href="' + (Rel $path ('portal/guides/' + $gid + '.html')) + '">' + (T $g.title) + '</a>') }
        }
        $see = ''
        if ((Has $t 'see') -and @($t.see).Count -gt 0) {
            $see = '<p class="see">' + (UT 'lbl.seeAlso') + ': ' + ((@($t.see) | ForEach-Object { '<a href="#term-' + $_ + '">' + (T $script:M.Terms[$_].term) + '</a>' }) -join ', ') + '</p>'
        }
        $u = ''
        if ($used.Count -gt 0) { $u = '<p class="used">' + (UT 'lbl.usedOn') + ': ' + ($used -join ', ') + '</p>' }
        $b.Add('<div class="term" id="term-' + $id + '"><dt class="term-name">' + (T $t.term) + '</dt><dd><p class="prose">' + (T $t.def) + '</p>' + $see + $u + '</dd></div>')
    }
    $b.Add('</dl>')
    return @{ Path = $path; Title = (U 'glossary.title'); Desc = (U 'glossary.desc'); Main = ($b -join "`n") }
}

function Build-PrivacyPage {
    $P = $script:M.Privacy
    $path = 'privacy.html'
    $script:CurPage = $path
    $b = New-Object System.Collections.Generic.List[string]
    $b.Add((PageHead (Crumbs $path @(@{ Label = (U 'crumbKit'); To = '' }, @{ Label = $P.title; To = $null })) '' $P.title $P.lead))
    $b.Add('<div class="panels">')
    foreach ($s in @($P.sections)) {
        $cls = if ($s.id -in 'origins', 'storage') { 'panel wide' } else { 'panel' }
        $b.Add('<section class="' + $cls + '" id="' + $s.id + '" aria-labelledby="h-' + $s.id + '"><h2 id="h-' + $s.id + '">' + (T $s.title) + '</h2>')
        $paras = @($s.body)
        if ($paras.Count -gt 0) { $b.Add('<p class="prose">' + (T $paras[0]) + '</p>') }
        if ($s.id -eq 'origins') {
            $b.Add('<div class="table-wrap"><table class="data"><thead><tr><th scope="col">' + (T $P.cols.origin) + '</th><th scope="col">' + (T $P.cols.purpose) + '</th><th scope="col">' + (T $P.cols.receives) + '</th></tr></thead><tbody>')
            foreach ($o in @($P.origins)) { $b.Add('<tr><th scope="row"><code>' + (Esc $o.origin) + '</code></th><td>' + (T $o.purpose) + '</td><td>' + (T $o.receives) + '</td></tr>') }
            $b.Add('</tbody></table></div>')
        }
        if ($s.id -eq 'storage') {
            $b.Add('<div class="table-wrap"><table class="data"><thead><tr><th scope="col">' + (T $P.cols.key) + '</th><th scope="col">' + (T $P.cols.purpose) + '</th><th scope="col">' + (T $P.cols.values) + '</th></tr></thead><tbody>')
            foreach ($o in @($P.storage)) { $b.Add('<tr><th scope="row"><code>' + (Esc $o.key) + '</code></th><td>' + (T $o.purpose) + '</td><td><code>' + (Esc $o.values) + '</code></td></tr>') }
            $b.Add('</tbody></table></div>')
        }
        for ($pi = 1; $pi -lt $paras.Count; $pi++) { $b.Add('<p class="prose">' + (T $paras[$pi]) + '</p>') }
        $b.Add('</section>')
    }
    $b.Add('</div>')
    return @{ Path = $path; Title = $P.title; Desc = $P.desc; Main = ($b -join "`n") }
}

function Build-NotFoundPage {
    $path = '404.html'
    $script:CurPage = $path
    $b = New-Object System.Collections.Generic.List[string]
    $b.Add((PageHead '' '' (U 'nf.title') (U 'nf.lead')))
    $b.Add('<div class="panels"><section class="panel" aria-labelledby="h-offer"><h2 id="h-offer">' + (UT 'nf.offerTitle') + '</h2><ul class="fn-list">')
    $b.Add('<li><a href="' + (Rel $path '') + '">' + (UT 'nf.landing') + '</a></li>')
    $b.Add('<li><a href="' + (Rel $path 'portal/') + '">' + (UT 'nf.portal') + '</a></li>')
    $b.Add('<li><button class="linklike" type="button" id="searchOpenInline">' + (UT 'nf.search') + '</button></li>')
    $b.Add('<li><a href="' + (Rel $path 'universal-agent-kit.zip') + '" download>' + (UT 'nf.download') + '</a></li>')
    $b.Add('</ul></section></div>')
    return @{ Path = $path; Title = (U 'nf.title'); Desc = (U 'nf.desc'); Main = ($b -join "`n"); NoIndex = $true; Absolute = $true }
}

# ---------------------------------------------------------------------------------------------------------
# Search index and sitemap
# ---------------------------------------------------------------------------------------------------------
function Build-SearchIndex {
    $items = New-Object System.Collections.Generic.List[object]
    function Plain([string]$s) { $s = [regex]::Replace($s, '\[([^\]]+)\]\([^)]+\)', '$1'); return $s.Replace('`', '').Replace('**', '') }
    function L3obj($o) { return [ordered]@{ en = (Plain ([string]$o.en)); ru = (Plain ([string]$o.ru)); ua = (Plain ([string]$o.ua)) } }
    foreach ($c in $script:M.Inventory.capabilities) {
        $f = $script:M.Functions[$c.id]
        $w = [ordered]@{}
        foreach ($l in $Locs) { $w[$l] = (Plain ((@($f.keywords.$l) + @([string]$c.name) + @([string]$f.lead.$l)) -join ' ')) }
        $items.Add([ordered]@{ u = ('portal/functions/' + $c.id + '.html'); k = $c.kind; t = (L3obj $f.title); d = (L3obj $f.pitch); w = $w })
    }
    foreach ($id in $script:M.Guides.Keys) {
        $g = $script:M.Guides[$id]; $w = [ordered]@{}
        foreach ($l in $Locs) { $w[$l] = (Plain ((@($g.keywords.$l) + @([string]$g.lead.$l)) -join ' ')) }
        $items.Add([ordered]@{ u = ('portal/guides/' + $id + '.html'); k = 'guide'; t = (L3obj $g.title); d = (L3obj $g.pitch); w = $w })
    }
    foreach ($id in $script:M.Terms.Keys) {
        $t = $script:M.Terms[$id]; $w = [ordered]@{}
        foreach ($l in $Locs) { $w[$l] = (Plain ([string]$t.def.$l)) }
        $items.Add([ordered]@{ u = ('portal/glossary.html#term-' + $id); k = 'term'; t = (L3obj $t.term); d = (L3obj $t.def); w = $w })
    }
    foreach ($pg in @(@('portal/', 'home.title', 'home.lead', 'page'), @('portal/overview.html', 'overview.title', 'overview.lead', 'page'), @('portal/showcase.html', 'showcase.title', 'showcase.lead', 'page'), @('portal/subjects.html', 'subjects.title', 'subjects.lead', 'page'), @('portal/glossary.html', 'glossary.title', 'glossary.lead', 'page'))) {
        $w = [ordered]@{}
        foreach ($l in $Locs) { $w[$l] = (Pl (U $pg[2]) $l) }
        $items.Add([ordered]@{ u = $pg[0]; k = $pg[3]; t = (L3obj (U $pg[1])); d = (L3obj (U $pg[2])); w = $w })
    }
    $items.Add([ordered]@{ u = 'privacy.html'; k = 'page'; t = (L3obj $script:M.Privacy.title); d = (L3obj $script:M.Privacy.desc); w = (L3obj $script:M.Privacy.desc) })
    return ($items | ConvertTo-Json -Depth 6 -Compress)
}

function Build-Sitemap([string]$lastmod, [string[]]$paths) {
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.Append("<?xml version=`"1.0`" encoding=`"UTF-8`"?>`n<urlset xmlns=`"http://www.sitemaps.org/schemas/sitemap/0.9`"`n        xmlns:xhtml=`"http://www.w3.org/1999/xhtml`">`n")
    foreach ($p in $paths) {
        $u = $Base + $p
        [void]$sb.Append("  <url>`n    <loc>$u</loc>`n    <lastmod>$lastmod</lastmod>`n")
        [void]$sb.Append("    <xhtml:link rel=`"alternate`" hreflang=`"en`" href=`"${u}?lang=en`"/>`n")
        [void]$sb.Append("    <xhtml:link rel=`"alternate`" hreflang=`"ru`" href=`"${u}?lang=ru`"/>`n")
        [void]$sb.Append("    <xhtml:link rel=`"alternate`" hreflang=`"uk`" href=`"${u}?lang=uk`"/>`n")
        [void]$sb.Append("    <xhtml:link rel=`"alternate`" hreflang=`"x-default`" href=`"$u`"/>`n  </url>`n")
    }
    [void]$sb.Append("</urlset>`n")
    return $sb.ToString()
}

# ---------------------------------------------------------------------------------------------------------
# The site
# ---------------------------------------------------------------------------------------------------------
function Build-Site($Model, [string]$lastmod) {
    $script:M = $Model
    $script:PrePaint = Get-PrePaint
    $script:SymDownload = Get-Symbol 'icon-action-download'
    $script:SymTop = Get-Symbol 'icon-nav-scroll-top'
    $pages = New-Object System.Collections.Generic.List[hashtable]
    $pages.Add((Build-HomePage))
    $pages.Add((Build-OverviewPage))
    $pages.Add((Build-ShowcasePage))
    $pages.Add((Build-SubjectsPage))
    $pages.Add((Build-GlossaryPage))
    foreach ($id in $script:M.Guides.Keys) { $pages.Add((Build-GuidePage $id)) }
    foreach ($c in $script:M.Inventory.capabilities) { if ($script:M.Functions.Contains($c.id)) { $pages.Add((Build-FunctionPage $c 0)) } }
    $pages.Add((Build-PrivacyPage))
    $out = [ordered]@{}
    foreach ($pg in $pages) {
        $script:AbsMode = $false
        $out[$pg.Path.TrimEnd('/') + $(if ($pg.Path.EndsWith('/')) { '/index.html' } else { '' })] = (Frame $pg)
    }
    # the not-found page is served at any depth: every address in it is built from the base URL
    $script:AbsMode = $true
    $out['404.html'] = (Frame (Build-NotFoundPage))
    $script:AbsMode = $false
    $out['assets/search-index.json'] = (Build-SearchIndex) + "`n"
    $paths = @('') + @($pages | ForEach-Object { $_.Path })
    $out['sitemap.xml'] = (Build-Sitemap $lastmod $paths)
    return $out
}
