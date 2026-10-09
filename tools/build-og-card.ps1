<#
.SYNOPSIS
    Render the campaign's social-card artwork: og-image.png (1200x630) and the repository
    preview (1280x640).

.DESCRIPTION
    One artwork from one generator (campaign specification, phase P3 and criterion 4). The script
    draws the card with System.Drawing (no network, no browser) and writes two PNGs:

      - og-image.png          1200x630, referenced by index.html (og:image, twitter:image) and
                              served from the site's own origin
      - og-image-1280x640.png 1280x640, under 1 MB, uploaded as the repository social preview in
                              the owner's browser (A->O; browser-only, no API)

    The text is the P1 worksheet's derived fields: the category ("AI coding agent rules", picked by
    the owner 2026-10-10) and the pillar order of POSITIONING.md. The fonts are the locally
    installed Segoe UI family; the webfonts the site loads (Outfit) are not assumed present.

    Not under kit/, not in the zip (tools/build-kit.ps1 stages kit/* and merge-prompt.txt only).

.PARAMETER Font
    The display font family. Defaults to "Segoe UI"; falls back per-draw to Arial if absent.

.EXAMPLE
    pwsh -NoProfile -File tools/build-og-card.ps1
#>
[CmdletBinding()]
param(
    [string]$TitleFont = 'Segoe UI Black',
    [string]$BodyFont  = 'Segoe UI'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

$bg     = (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0x0a, 0x0f, 0x0a)))   # the page theme colour
$fg     = (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0xe6, 0xed, 0xe6)))
$muted  = (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0x8b, 0x98, 0x8b)))
$accent = (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0x3f, 0xb9, 0x50)))   # the favicon green
$chipBg = (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0x13, 0x24, 0x17)))

Add-Type -AssemblyName System.Drawing

function New-Font([string]$family, [float]$em, [System.Drawing.FontStyle]$style = [System.Drawing.FontStyle]::Regular) {
    try { return [System.Drawing.Font]::new($family, $em, $style, [System.Drawing.GraphicsUnit]::Pixel) }
    catch { return [System.Drawing.Font]::new('Arial', $em, $style, [System.Drawing.GraphicsUnit]::Pixel) }
}

function Draw-Card([int]$w, [int]$h, [string]$path) {
    # One artwork: sizes scale with the canvas, so the 1200x630 and 1280x640 renders are the same
    # picture at two sizes. $k is the linear scale relative to the 1280-wide reference.
    $k = $w / 1280.0
    $bmp = [System.Drawing.Bitmap]::new($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    try {
        $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
        $g.Clear([System.Drawing.Color]::FromArgb(0x0a, 0x0f, 0x0a))

        $pad = [int](96 * $k)

        # category chip, top left
        $chipText = 'AI CODING AGENT RULES'
        $chipFont = New-Font $BodyFont ([float](26 * $k)) ([System.Drawing.FontStyle]::Bold)
        $chipSize = $g.MeasureString($chipText, $chipFont)
        $chipRect = [System.Drawing.RectangleF]::new($pad, $pad, $chipSize.Width + 44 * $k, $chipSize.Height + 22 * $k)
        $chipPen  = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(0x3f, 0xb9, 0x50), [float](2.5 * $k))
        $g.FillRectangle($chipBg, $chipRect)
        $g.DrawRectangle($chipPen, [System.Drawing.Rectangle]::Round($chipRect))
        $g.DrawString($chipText, $chipFont, $accent, ($chipRect.X + 22 * $k), ($chipRect.Y + 11 * $k))

        # title
        $titleFont = New-Font $TitleFont ([float](104 * $k))
        $g.DrawString('Universal Agent Kit', $titleFont, $fg, $pad, ($h * 0.34))

        # pillars, in POSITIONING.md order
        $pillarsFont = New-Font $BodyFont ([float](38 * $k))
        $g.DrawString('rules  ' + [char]0x00B7 + '  skills  ' + [char]0x00B7 + '  roles  ' + [char]0x00B7 + '  spec lifecycle  ' + [char]0x00B7 + '  memory  ' + [char]0x00B7 + '  parallel',
            $pillarsFont, $accent, $pad, ($h * 0.60))

        # tagline
        $tagFont = New-Font $BodyFont ([float](32 * $k))
        $g.DrawString('A portable, free MIT kit for any project made of files',
            $tagFont, $muted, $pad, ($h * 0.72))

        # bottom row: address and languages
        $urlFont = New-Font $BodyFont ([float](28 * $k))
        $g.DrawString('serzhyale.github.io/universal-agent-kit', $urlFont, $muted, $pad, ($h - $pad - 30 * $k))
        $langFont = New-Font $BodyFont ([float](28 * $k)) ([System.Drawing.FontStyle]::Bold)
        $langText = 'EN  ' + [char]0x00B7 + '  RU  ' + [char]0x00B7 + '  UK'
        $langSize = $g.MeasureString($langText, $langFont)
        $g.DrawString($langText, $langFont, $fg, ($w - $pad - $langSize.Width), ($h - $pad - 30 * $k))

        $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    } finally {
        $g.Dispose(); $bmp.Dispose()
    }
    $bytes = (Get-Item -LiteralPath $path).Length
    Write-Host "build-og-card: WROTE $path (${w}x${h}, $bytes bytes)"
    if ($bytes -ge 1MB) { Write-Host 'build-og-card: FAIL - the render exceeds 1 MB'; exit 1 }
}

Draw-Card 1200 630 (Join-Path $root 'og-image.png')
Draw-Card 1280 640 (Join-Path $root 'og-image-1280x640.png')
Write-Host 'build-og-card: PASS'
exit 0
