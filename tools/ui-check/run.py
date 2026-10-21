"""UI contracts check for the site: BUTTONS 2.0, COLLAPSIBLE-GROUP 1.1, UI-SIZING 1.1 (and the not-applicable
shapes of BOOLEAN-OPTION 2.0 and SETTINGS-NAVIGATION 2.0) measured in a real Chromium against the working tree.

    python -I tools/ui-check/run.py [--deps temp/contract-browser-deps] [--chromium PATH] [--out temp/ui-check] [--quick]

Playwright is not a dependency of the site and is not installed by this repository: --deps names a folder that holds
the `playwright` package (the previous browser acceptance used temp/contract-browser-deps), --chromium a Chromium
executable (default: the newest one under %LOCALAPPDATA%/ms-playwright). The script serves the repository root on a
loopback port, writes results.json and the screenshots under --out (generated evidence, never committed or hand-edited),
prints one line per failed check and exits 1 on any failure, 0 on none.

The geometry rule it enforces is the contract's, not a snapshot: a control is at least the token target of its profile
and size, is as wide as its content (never wider), shares its row's height, overlaps no other control, and never
overflows the viewport or clips its caption. Contrast is computed from the real computed colours of the real states.
"""
import argparse
import functools
import http.server
import json
import os
import pathlib
import re
import sys
import threading
import time
import xml.etree.ElementTree as ET

ap = argparse.ArgumentParser()
ap.add_argument('--deps', default='temp/contract-browser-deps')
ap.add_argument('--chromium', default=None)
ap.add_argument('--out', default='temp/ui-check')
ap.add_argument('--quick', action='store_true', help='baseline scenarios only')
ap.add_argument('--catalog', default='', help='the shared contracts catalog root: adds the static checks of the kit bytes and of every inline glyph')
ap.add_argument('--inject-css', default='', help='CSS added to every page: the instrument self-test, a violation it must catch')
args = ap.parse_args()

root = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str((root / args.deps).resolve()))
from playwright.sync_api import sync_playwright  # noqa: E402

out = (root / args.out)
if args.inject_css:                 # a self-test run never overwrites the evidence of a real run
    out = out / 'selftest'
out.mkdir(parents=True, exist_ok=True)
(out / 'shots').mkdir(exist_ok=True)

# ---------------------------------------------------------------------------------------------------------------------
# the contract, as numbers (assets/sza-kit.css declares the same tokens)
# ---------------------------------------------------------------------------------------------------------------------
BASE = {'pointer': (32, 24), 'touch': (48, 36)}          # (ordinary target, declared compact floor)
SCALE = {'compact': .75, 'standard': 1, 'large': 1.25, 'xlarge': 1.5, 'huge': 2}      # the kit's own names


def target(profile, size):
    base, floor = BASE[profile]
    return max(floor, base * SCALE[size])


results = []
failures = []


def _aborted(et, ev, tb):
    """A scenario that cannot run (an unreachable control, a timeout) is a finding: report it and still exit non-zero."""
    failures.append(f'the run was aborted: {et.__name__}: {str(ev).splitlines()[0][:240]}')
    (out / 'results.json').write_text(json.dumps({'checks': len(results), 'failed': len(failures), 'results': results, 'aborted': True}, indent=1), encoding='utf-8')
    for f in failures:
        print('FAIL', f)
    print(f'ui-check: {len(results)} checks, {len(failures)} failed -> FAIL (aborted)')


sys.excepthook = _aborted


def check(ok, name, detail=''):
    results.append({'name': name, 'ok': bool(ok), 'detail': str(detail)})
    if not ok:
        failures.append(name + (' :: ' + str(detail) if detail else ''))


# ---------------------------------------------------------------------------------------------------------------------
# in-page measurement
# ---------------------------------------------------------------------------------------------------------------------
JS_HELPERS = r"""
(() => {
  const CTRL = '.btn, .theme-btn, .seg button, .to-top, .letters a, details.sec > summary, .adopt-prompt > details > summary';
  const closed = el => { for (let e = el.parentElement, c = el; e; c = e, e = e.parentElement) {
      if (e.tagName === 'DETAILS' && !e.open && !(c.tagName === 'SUMMARY' && c.parentElement === e)) return true; } return false; };
  const vis = el => { const r = el.getBoundingClientRect(); const cs = getComputedStyle(el);
    return r.width > 0 && r.height > 0 && cs.visibility !== 'hidden' && cs.display !== 'none' && !closed(el); };
  function parseColor(s) {
    let m = s.match(/rgba?\(([^)]+)\)/);
    if (m) { const p = m[1].split(/[ ,\/]+/).filter(Boolean).map(Number); return [p[0], p[1], p[2], p.length > 3 ? p[3] : 1]; }
    m = s.match(/color\(srgb ([\d.e-]+) ([\d.e-]+) ([\d.e-]+)(?: \/ ([\d.e-]+))?\)/);
    if (m) return [m[1] * 255, m[2] * 255, m[3] * 255, m[4] === undefined ? 1 : +m[4]];
    return [0, 0, 0, 0];
  }
  function over(top, bottom) { const a = top[3] + bottom[3] * (1 - top[3]);
    if (a === 0) return [0, 0, 0, 0];
    return [0, 1, 2].map(i => (top[i] * top[3] + bottom[i] * bottom[3] * (1 - top[3])) / a).concat([a]); }
  function backdrop(el) {                       // the colour behind the element's own face, composited up the tree
    const chain = []; for (let e = el; e; e = e.parentElement) chain.push(e);
    let c = [0, 0, 0, 0];
    for (const e of chain) { const b = parseColor(getComputedStyle(e).backgroundColor); c = over(c, b); if (c[3] >= .999) break; }
    return over(c, [255, 255, 255, 1]);
  }
  function face(el) { return over(parseColor(getComputedStyle(el).backgroundColor), backdrop(el.parentElement || el)); }
  const lum = c => { const f = v => { v /= 255; return v <= .03928 ? v / 12.92 : Math.pow((v + .055) / 1.055, 2.4); };
    return .2126 * f(c[0]) + .7152 * f(c[1]) + .0722 * f(c[2]); };
  const ratio = (a, b) => { const x = lum(a), y = lum(b); return (Math.max(x, y) + .05) / (Math.min(x, y) + .05); };
  window.__ui = {
    CTRL, vis, ratio, face, parseColor, over,
    contrast(el) { const f = face(el); const fg = over(parseColor(getComputedStyle(el).color), f); return { ratio: ratio(fg, f), fg, bg: f }; },
    controls() { return Array.from(document.querySelectorAll(CTRL)).filter(vis); },
    label(el) { return (el.getAttribute('aria-label') || el.textContent || '').replace(/\s+/g, ' ').trim().slice(0, 40) + ' <' + el.tagName.toLowerCase() + (el.id ? '#' + el.id : '') + '>'; },
    // width the control would have if nothing constrained it (content only)
    natural(el) { const old = el.style.cssText; const s = (k, v) => el.style.setProperty(k, v, 'important');
      s('width', 'max-content'); s('max-width', 'none'); s('flex', '0 0 auto'); s('min-width', '0');
      const w = el.getBoundingClientRect().width; el.style.cssText = old; return w; },
  };
})();
"""

JS_MEASURE = r"""
() => {
  const U = window.__ui, out = [];
  for (const el of U.controls()) {
    const r = el.getBoundingClientRect(), cs = getComputedStyle(el);
    out.push({
      label: U.label(el), cls: el.className && el.className.baseVal === undefined ? el.className : '',
      kind: el.matches('details > summary') ? 'summary' : 'button',
      x: r.left, y: r.top + scrollY, w: r.width, h: r.height, right: r.right, natural: U.natural(el),
      parent: el.parentElement ? (el.parentElement.id || el.parentElement.className || el.parentElement.tagName) : '',
      radius: cs.borderTopLeftRadius, scrollW: el.scrollWidth, clientW: el.clientWidth,
      whiteSpace: cs.whiteSpace, shadow: cs.boxShadow, fixed: cs.position === 'fixed',
      seg: !!el.closest('.seg'),
      panelRight: (() => { const p = el.closest('.site-header, .search-dialog, .ui-prefs, .toolbar, .cta'); return p ? p.getBoundingClientRect().right : null; })(),
    });
  }
  const rows = [];
  for (const row of document.querySelectorAll('.btn-row')) {
    if (!U.vis(row)) continue;
    const kids = Array.from(row.children).filter(k => U.vis(k)).map(k => { const r = k.getBoundingClientRect(); return { x: r.left, right: r.right, y: r.top + scrollY, h: r.height, label: U.label(k) }; });
    rows.push({ id: row.id || row.className, gap: parseFloat(getComputedStyle(row).columnGap) || 0, kids });
  }
  return { controls: out, rows, docW: document.documentElement.scrollWidth, winW: innerWidth, bodyW: document.body.scrollWidth };
}
"""


def geometry(page, tag, profile, size, expect_text_grow=False):
    """The contract's geometry rules over every visible control on the page, as it is right now."""
    m = page.evaluate(JS_MEASURE)
    tgt = target(profile, size)
    ctl = m['controls']
    check(m['docW'] <= m['winW'] + 1, f'{tag}: no horizontal overflow', f"doc {m['docW']} > win {m['winW']}")
    tol = 1.0
    for c in ctl:
        name = f"{tag}: {c['label']}"
        if c['kind'] == 'button':
            # BUTTONS 3.3, UI-SIZING 2.4: at least the token target in both dimensions (a seg part may be narrow by content)
            check(c['h'] >= tgt - tol, name + ' height >= target', f"{c['h']:.1f} < {tgt}")
            if not c['seg'] or c['w'] < tgt:
                check(c['w'] >= tgt - tol or c['seg'], name + ' width >= target', f"{c['w']:.1f} < {tgt}")
            # BUTTONS 3.3: content width, never stretched (a caption that wrapped is narrower than natural, which is allowed)
            # (width = content plus padding, subject to the minimum hit-target width)
            # (the parts of a semantic segmented selector may be equal in size, BUTTONS section 3 rule 3)
            if not c['seg']:
                check(c['w'] <= max(c['natural'], tgt) + tol, name + ' not stretched', f"{c['w']:.1f} > natural {c['natural']:.1f} / target {tgt}")
            # BUTTONS 3.2: rectangular, baseline radius 4 scaled never to a pill; no permanent shadow
            r = float(re.match(r'[\d.]+', c['radius']).group(0))
            check(r <= 4 * SCALE[size] + .5 and r < c['h'] / 2 and not c['radius'].endswith('%'), name + ' modest radius (4 units, scaled)', c['radius'])
            check(c['shadow'] in ('none', '') or 'inset' in c['shadow'], name + ' no permanent drop shadow (an inset state bar is allowed)', c['shadow'])
        else:
            check(c['h'] >= tgt - tol, name + ' header height >= target', f"{c['h']:.1f} < {tgt}")
        # never clip a caption
        check(c['scrollW'] <= c['clientW'] + 1, name + ' caption not clipped', f"{c['scrollW']} > {c['clientW']}")
        check(c['right'] <= m['winW'] + tol and c['x'] >= -tol, name + ' inside the viewport', f"x {c['x']:.0f}..{c['right']:.0f} of {m['winW']}")
        if c['panelRight'] is not None:
            check(c['right'] <= c['panelRight'] + tol, name + ' inside its panel', f"{c['right']:.0f} > panel {c['panelRight']:.0f}")
    # non-overlap (UI-SIZING 2.5): no two controls' boxes intersect
    boxes = [c for c in ctl if c['kind'] == 'button']
    for i in range(len(boxes)):
        a = boxes[i]
        for j in range(i + 1, len(boxes)):
            b = boxes[j]
            if a['fixed'] != b['fixed']:
                continue
            ix = min(a['x'] + a['w'], b['x'] + b['w']) - max(a['x'], b['x'])
            iy = min(a['y'] + a['h'], b['y'] + b['h']) - max(a['y'], b['y'])
            check(not (ix > .6 and iy > .6), f"{tag}: {a['label']} / {b['label']} do not overlap", f'{ix:.1f}x{iy:.1f}')
    # BUTTONS 4.2: a command row flows from the reading start; spare width stays empty, so neighbours on one line sit one gap apart
    for row in m['rows']:
        ks = row['kids']
        for a, b in zip(ks, ks[1:]):
            if abs(a['y'] - b['y']) <= 3:
                check(abs((b['x'] - a['right']) - row['gap']) <= 1.5 and min(abs(row['gap'] - 8 * SCALE[size]), abs(row['gap'] - 16 * SCALE[size])) <= .6, f"{tag}: {row['id']} flows with one gap between {a['label']} and {b['label']}", f"{b['x'] - a['right']:.1f} vs gap {row['gap']:.1f}")
    # BUTTONS 3.4: every button of one visual row is as tall as the row's tallest (rows: same parent, same top)
    rows = {}
    for c in boxes:
        if c['seg'] or c['fixed']:
            continue
        rows.setdefault((c['parent'], round(c['y'] / 3)), []).append(c)
    for (par, _), row in rows.items():
        if len(row) > 1:
            hs = [r['h'] for r in row]
            check(max(hs) - min(hs) <= tol + .5, f"{tag}: row in {par} has one height", hs)
    return m


def contrast_states(page, tag, selector_list):
    """Text/face contrast of the real normal, hover, pressed and focus states of the first visible match of each selector."""
    for sel in selector_list:
        loc = page.locator(sel + ':visible').first
        if loc.count() == 0:
            continue
        try:
            loc.scroll_into_view_if_needed(timeout=5000)
            handle = loc.element_handle()
            loc.hover(timeout=5000)
        except Exception as e:      # a control that cannot be reached by a real pointer is itself a finding
            check(False, f'{tag}: {sel} is reachable by a pointer', str(e).splitlines()[0])
            continue

        def read(state):
            return page.evaluate("el => { const c = window.__ui.contrast(el); return {ratio: c.ratio, fg: c.fg, bg: c.bg}; }", handle)

        page.mouse.move(0, 0)
        r = read('normal')
        check(r['ratio'] >= 4.5, f'{tag}: {sel} normal contrast >= 4.5', f"{r['ratio']:.2f}")
        loc.hover(timeout=5000)
        r = read('hover')
        check(r['ratio'] >= 4.5, f'{tag}: {sel} hover contrast >= 4.5', f"{r['ratio']:.2f}")
        page.mouse.down()
        r = read('pressed')
        check(r['ratio'] >= 4.5, f'{tag}: {sel} pressed contrast >= 4.5', f"{r['ratio']:.2f}")
        page.mouse.move(0, 0)      # release away from the control: the press is measured, the command is not run
        page.mouse.up()


# ---------------------------------------------------------------------------------------------------------------------
# static checks against the catalog (only with --catalog)
# ---------------------------------------------------------------------------------------------------------------------
def _shape(node):
    attrs = dict(node.attrib)
    if attrs.get('fill') == 'currentColor':
        attrs.pop('fill')
    for attr in ('d', 'transform'):
        if attr in attrs:
            attrs[attr] = [float(x) if re.fullmatch(r'-?(?:\d*\.\d+|\d+)', x) else x for x in re.findall(r'[A-Za-z]+|-?(?:\d*\.\d+|\d+)', attrs[attr])]
    return (node.tag.split('}')[-1], sorted(attrs.items()), [_shape(c) for c in node])


if args.catalog:
    cat = pathlib.Path(args.catalog)
    ref = (cat / 'product-web-pages/reference/sza-kit.css').read_bytes()
    check(ref == (root / 'assets/sza-kit.css').read_bytes(), 'kit: assets/sza-kit.css is byte-identical to the catalog reference')
    pages = [root / 'index.html', root / 'privacy.html', root / '404.html', *sorted((root / 'portal').rglob('*.html'))]
    for f in pages:
        html = f.read_text(encoding='utf-8')
        check('assets/ui-contracts.css' not in html, f'{f.relative_to(root)}: no retired adapter link')
        for mm in re.finditer(r'<symbol id="icon-([^"]+)" viewBox="0 0 24 24">(.*?)</symbol>', html, re.S):
            meaning = mm[1].replace('-', '.', 1)
            svg = ET.fromstring((cat / f'iconography/glyphs/{meaning}.svg').read_text(encoding='utf-8'))
            inline = ET.fromstring('<svg>' + mm[2] + '</svg>')
            check([_shape(c) for c in svg] == [_shape(c) for c in inline], f'{f.relative_to(root)}: inline glyph {meaning} equals the catalog file')


# ---------------------------------------------------------------------------------------------------------------------
# server and browser
# ---------------------------------------------------------------------------------------------------------------------
class Quiet(http.server.SimpleHTTPRequestHandler):
    def log_message(self, *a):
        pass


class Server(http.server.ThreadingHTTPServer):
    def handle_error(self, request, client_address):      # a browser closing a socket mid-request is not a finding
        pass


server = Server(('127.0.0.1', 0), functools.partial(Quiet, directory=str(root)))
threading.Thread(target=server.serve_forever, daemon=True).start()
BASE_URL = f'http://127.0.0.1:{server.server_port}/'

chromium = args.chromium
if not chromium:
    cands = sorted((pathlib.Path(os.environ.get('LOCALAPPDATA', '')) / 'ms-playwright').glob('chromium-*/chrome-win64/chrome.exe'))
    chromium = str(cands[-1]) if cands else None

PAGES = {
    'landing': 'index.html',
    'portal': 'portal/index.html',
    'function': 'portal/functions/spec.html',
    'privacy': 'privacy.html',
    'glossary': 'portal/glossary.html',
    'subjects': 'portal/subjects.html',
}


def open_page(ctx, key, lang='en', theme='dark', profile=None, size=None, text=None):
    page = ctx.new_page()
    page.add_init_script("""
      try { localStorage.setItem('sza-lang', %s); localStorage.setItem('sza-theme', %s); } catch (e) {}
      window.__clip = 0; try { Object.defineProperty(navigator, 'clipboard', {value: {writeText: () => { window.__clip++; return Promise.resolve(); }}, configurable: true}); } catch (e) {}
    """ % (json.dumps(lang), json.dumps(theme)))
    page.goto(BASE_URL + PAGES[key], wait_until='load')
    page.add_script_tag(content=JS_HELPERS)
    if text:
        page.add_style_tag(content=f'html{{font-size:{text}%}}')
    if args.inject_css:
        page.add_style_tag(content=args.inject_css)
    if profile:
        page.evaluate("p => document.documentElement.setAttribute('data-ui-profile', p)", profile)
    if size:
        page.evaluate("s => s === 'standard' ? document.documentElement.removeAttribute('data-ui-size') : document.documentElement.setAttribute('data-ui-size', s)", size)
    page.wait_for_timeout(120)
    return page


def shot(page, name):
    page.screenshot(path=str(out / 'shots' / (name + '.png')), full_page=False)


with sync_playwright() as pw:
    browser = pw.chromium.launch(executable_path=chromium, headless=True)
    desktop = browser.new_context(viewport={'width': 1280, 'height': 800})
    touch = browser.new_context(viewport={'width': 360, 'height': 740}, device_scale_factor=2, is_mobile=True, has_touch=True)
    desktop.set_default_timeout(8000)
    touch.set_default_timeout(8000)

    # ------------------------------------------------------------------ 1. the profile is chosen once, from the pointer
    p = open_page(desktop, 'landing')
    check(p.evaluate("document.documentElement.getAttribute('data-ui-profile')") == 'pointer', 'resolver: a fine primary pointer gives the pointer profile')
    check(p.evaluate("document.documentElement.getAttribute('data-ui-size')") is None, 'resolver: the ordinary size is the absence of data-ui-size')
    p.close()
    p = open_page(touch, 'landing')
    check(p.evaluate("document.documentElement.getAttribute('data-ui-profile')") == 'touch', 'resolver: a coarse primary pointer gives the touch profile')
    p.close()

    # ------------------------------------------------------------------ 2. geometry matrix: baseline + risk-selected
    matrix = []
    sizes_all = ['compact', 'standard', 'large', 'xlarge', 'huge']
    for prof, ctx, width in (('pointer', desktop, 1280), ('touch', touch, 360)):
        for size in (sizes_all if not args.quick else ['compact', 'standard', 'huge']):
            for pg in (['landing', 'portal'] if not args.quick else ['landing']):
                matrix.append((pg, prof, size, 'en', 'dark', None, ctx, width))
    for lang in ('ru', 'ua'):                                     # longest shipped translations, narrow and wide
        for prof, ctx, width in (('touch', touch, 360), ('pointer', desktop, 1280)):
            for pg in ('landing', 'portal'):
                matrix.append((pg, prof, 'standard', lang, 'dark', None, ctx, width))
    for pg in ('function', 'privacy', 'glossary', 'subjects'):    # every page kind once, both profiles
        for prof, ctx, width in (('pointer', desktop, 1280), ('touch', touch, 360)):
            matrix.append((pg, prof, 'standard', 'en', 'dark', None, ctx, width))
    for pg in ('landing', 'portal'):                              # text enlargement is independent of the interface size
        for prof, ctx, width in (('pointer', desktop, 1280), ('touch', touch, 360)):
            matrix.append((pg, prof, 'standard', 'en', 'dark', 200, ctx, width))
        matrix.append((pg, 'touch', 'xlarge', 'ru', 'dark', 150, touch, 360))   # risky combination
    for pg in ('landing', 'portal'):
        for prof, ctx, width in (('pointer', desktop, 1280), ('touch', touch, 360)):
            matrix.append((pg, prof, 'standard', 'en', 'light', None, ctx, width))
    if args.quick:
        matrix = matrix[:12]

    for (pg, prof, size, lang, theme, text, ctx, width) in matrix:
        tag = f'{pg}/{prof}/{size}/{lang}/{theme}' + (f'/text{text}' if text else '') + f'/{width}'
        page = open_page(ctx, pg, lang=lang, theme=theme, profile=prof, size=size, text=text)
        geometry(page, tag, prof, size)
        if (size in ('compact', 'standard', 'huge') and not text) or text:
            shot(page, tag.replace('/', '_'))
        page.close()

    # ------------------------------------------------------------------ 3. contrast of the real states, both themes
    for theme in ('dark', 'light'):
        for prof, ctx in (('pointer', desktop), ('touch', touch)):
            page = open_page(ctx, 'landing', theme=theme, profile=prof)
            contrast_states(page, f'landing/{theme}/{prof}', ['.site-header .btn-primary', '.toolbar .btn-ghost', '.seg button[aria-pressed="false"]',
                                                               '.seg button[aria-pressed="true"]', '.theme-btn', 'details.sec > summary'])
            page.close()
        page = open_page(desktop, 'portal', theme=theme, profile='pointer')
        contrast_states(page, f'portal/{theme}', ['.search-open', '.theme-btn', '.site-header .btn-primary'])
        page.close()

    # ------------------------------------------------------------------ 4. COLLAPSIBLE-GROUP behaviour
    page = open_page(desktop, 'landing', profile='pointer')
    page.evaluate("localStorage.removeItem('uak-groups')")
    page.reload(); page.add_script_tag(content=JS_HELPERS)
    sec = page.locator('article[data-l="en"] details.sec').nth(3)
    summ = sec.locator('> summary')
    summ.scroll_into_view_if_needed()
    check(not sec.evaluate('d => d.open'), 'group: section 03 starts collapsed')
    # marker direction (state, not action): collapsed = no rotation, open = 90deg
    t0 = summ.evaluate("s => getComputedStyle(s, '::before').transform")
    top0 = summ.evaluate('s => s.getBoundingClientRect().top')
    summ.click()
    page.wait_for_timeout(100)
    check(sec.evaluate('d => d.open'), 'group: a click on the header opens it once')
    t1 = summ.evaluate("s => getComputedStyle(s, '::before').transform")
    check(t0 in ('none', 'matrix(1, 0, 0, 1, 0, 0)') and t1.startswith('matrix(') and abs(float(t1.split(',')[1])) > .9, 'group: marker points right when closed and down when open', f'{t0} -> {t1}')
    top1 = summ.evaluate('s => s.getBoundingClientRect().top')
    check(abs(top1 - top0) <= 1, 'group: the activated header keeps its vertical position', f'{top0:.1f} -> {top1:.1f}')
    check(summ.evaluate('s => document.activeElement === s'), 'group: focus stays on the header after activation')
    # the body never toggles the group
    body = sec.locator('.secbody').first
    body.locator('p').first.click()
    check(sec.evaluate('d => d.open'), 'group: a click in the body does not toggle it')
    # keyboard: Enter and Space on the focused header
    summ.focus(); page.keyboard.press('Enter'); page.wait_for_timeout(60)
    check(not sec.evaluate('d => d.open'), 'group: Enter on the header closes it')
    page.keyboard.press('Space'); page.wait_for_timeout(60)
    check(sec.evaluate('d => d.open'), 'group: Space on the header opens it')
    check(summ.evaluate('s => document.activeElement === s'), 'group: focus stays on the header after keyboard toggle')
    # full width: the open body spans the header width (normal flow, below its header)
    wb = sec.evaluate('d => [d.querySelector("summary").getBoundingClientRect(), d.querySelector(".secbody").getBoundingClientRect()].map(r => [r.left, r.width, r.top, r.bottom])')
    check(abs(wb[0][0] - wb[1][0]) <= 1 and abs(wb[0][1] - wb[1][1]) <= 2 and wb[1][2] >= wb[0][3] - 1, 'group: the open body spans the header width, directly below it', wb)
    # multiple groups stay open independently
    sec5 = page.locator('article[data-l="en"] details.sec').nth(5)
    sec5.locator('> summary').click()
    page.wait_for_timeout(120)
    check(sec.evaluate('d => d.open') and sec5.evaluate('d => d.open'), 'group: opening one does not close another')
    # persistence by stable section number, restored before the next paint, mirrored across languages
    stored = page.evaluate("localStorage.getItem('uak-groups')")
    check(stored is not None and '"sec-03":1' in stored and '"sec-05":1' in stored, 'group: user choices are stored by section number', stored)
    page.reload(); page.add_script_tag(content=JS_HELPERS)
    check(page.locator('article[data-l="en"] details.sec').nth(3).evaluate('d => d.open'), 'group: the choice survives a reload')
    page.evaluate("document.documentElement.setAttribute('data-lang','ru')")
    check(page.locator('article[data-l="ru"] details.sec').nth(3).evaluate('d => d.open'), 'group: the same section is open in the other language article')
    # no stored write from a hash navigation or a restore
    page.evaluate("localStorage.removeItem('uak-groups')")
    page.goto(BASE_URL + 'index.html#sec-09-en'); page.add_script_tag(content=JS_HELPERS)
    check(page.evaluate("document.getElementById('sec-09-en').open"), 'group: a hash into a section opens it')
    check(page.evaluate("localStorage.getItem('uak-groups')") is None, 'group: opening by hash is not stored as a user choice')
    # expand all / collapse all, focus inside a hidden body moves to its header
    page.locator('article[data-l="en"] details.sec').nth(2).locator('> summary').click()
    page.locator('article[data-l="en"] details.sec').nth(2).locator('pre, p').first.evaluate('e => { e.setAttribute("tabindex", "0"); e.focus(); }')
    page.get_by_role('button', name=re.compile('Collapse all')).evaluate("b => { document.activeElement.blur(); setAll(false); }")
    check(page.evaluate("document.querySelectorAll('article[data-l=\"en\"] details.sec[open]').length") == 0, 'group: Collapse all closes every section')
    active_in_closed = page.evaluate("(() => { const a = document.activeElement; const d = a && a.closest ? a.closest('details.sec') : null; return !!(d && !d.open && a.tagName !== 'SUMMARY'); })()")
    check(not active_in_closed, 'group: focus is never left inside a hidden body')
    page.close()

    # ------------------------------------------------------------------ 5. the copy button: one node, one width, focus kept, no double run
    page = open_page(desktop, 'landing', profile='pointer')
    page.evaluate("setAll(true)")
    btn = page.locator('article[data-l="en"] button.copy').first
    btn.evaluate("b => { b.closest('details').open = true; }")      # the prompt is a disclosure of its own
    btn.scroll_into_view_if_needed()
    w0 = btn.evaluate('b => b.getBoundingClientRect().width')
    name0 = btn.get_attribute('aria-label')
    btn.focus(); btn.press('Enter'); page.wait_for_timeout(120)
    w1 = btn.evaluate('b => b.getBoundingClientRect().width')
    check(abs(w0 - w1) <= .5, 'copy: the button keeps its width through the copied state', f'{w0:.1f} -> {w1:.1f}')
    check(btn.evaluate('b => document.activeElement === b'), 'copy: focus stays on the button after activation')
    check(btn.get_attribute('aria-disabled') == 'true' and not btn.evaluate('b => b.disabled'), 'copy: aria-disabled, not disabled, while the result shows')
    cd = btn.evaluate("b => { const e = b.querySelector('.cl-done'); const f = window.__ui.face(b); const fg = window.__ui.over(window.__ui.parseColor(getComputedStyle(e).color), f); return window.__ui.ratio(fg, f); }")
    check(cd >= 4.5, 'copy: the copied word reaches 4.5:1 on its face', f'{cd:.2f}')
    check(btn.get_attribute('aria-label') != name0, 'copy: the accessible name reports the result', btn.get_attribute('aria-label'))
    btn.press('Enter'); btn.click(force=True); page.wait_for_timeout(80)
    check(page.evaluate('window.__clip') == 1, 'copy: repeated activation while the result shows runs the command once', page.evaluate('window.__clip'))
    page.wait_for_timeout(1800)
    check(btn.get_attribute('aria-label') == name0 and btn.get_attribute('aria-disabled') is None, 'copy: the idle name and state return')
    w2 = btn.evaluate('b => b.getBoundingClientRect().width')
    check(abs(w0 - w2) <= .5, 'copy: the width after the result equals the width before', f'{w0:.1f} -> {w2:.1f}')
    # width reservation per language: the done word is never wider than the reserved width
    for lang in ('ru', 'ua'):
        page.evaluate(f"document.documentElement.setAttribute('data-lang','{lang}')")
        b = page.locator(f'article[data-l="{lang}"] button.copy').first
        b.evaluate("x => { x.closest('details').open = true; }")
        b.scroll_into_view_if_needed()
        wi = b.evaluate('x => x.getBoundingClientRect().width')
        for st in ('cl-idle', 'cl-done', 'cl-fail'):
            sw = b.evaluate("(x, c) => x.querySelector('.' + c).getBoundingClientRect().width", st)
            check(sw <= wi + .5, f'copy[{lang}]: the {st} word fits the reserved width', f'{sw:.1f} vs {wi:.1f}')
    page.close()

    # a failed copy says so, keeps its width, does not lock the button, and the word is readable
    page = open_page(desktop, 'landing', profile='pointer')
    page.evaluate("Object.defineProperty(navigator, 'clipboard', {value: {writeText: () => Promise.reject(new Error('denied'))}, configurable: true}); document.execCommand = () => false;")
    btn = page.locator('article[data-l="en"] button.copy').first
    btn.evaluate("b => { b.closest('details').open = true; }")
    btn.scroll_into_view_if_needed()
    w0 = btn.evaluate('b => b.getBoundingClientRect().width')
    btn.focus(); btn.press('Enter'); page.wait_for_timeout(150)
    check(btn.evaluate("b => b.classList.contains('failed')"), 'copy: a failed copy shows the failed state')
    check(btn.get_attribute('aria-disabled') is None, 'copy: a failed copy does not lock the button (the visitor may retry)')
    check(abs(btn.evaluate('b => b.getBoundingClientRect().width') - w0) <= .5, 'copy: the width is unchanged in the failed state')
    cf = btn.evaluate("b => { const e = b.querySelector('.cl-fail'); const f = window.__ui.face(b); const fg = window.__ui.over(window.__ui.parseColor(getComputedStyle(e).color), f); return window.__ui.ratio(fg, f); }")
    check(cf >= 4.5, 'copy: the failed word reaches 4.5:1 on its face (dark)', f'{cf:.2f}')
    page.close()
    page = open_page(desktop, 'landing', theme='light', profile='pointer')
    page.evaluate("Object.defineProperty(navigator, 'clipboard', {value: {writeText: () => Promise.reject(new Error('denied'))}, configurable: true}); document.execCommand = () => false;")
    btn = page.locator('article[data-l="en"] button.copy').first
    btn.evaluate("b => { b.closest('details').open = true; }")
    btn.scroll_into_view_if_needed(); btn.focus(); btn.press('Enter'); page.wait_for_timeout(150)
    cf = btn.evaluate("b => { const e = b.querySelector('.cl-fail'); const f = window.__ui.face(b); const fg = window.__ui.over(window.__ui.parseColor(getComputedStyle(e).color), f); return window.__ui.ratio(fg, f); }")
    check(cf >= 4.5, 'copy: the failed word reaches 4.5:1 on its face (light)', f'{cf:.2f}')
    page.close()

    # ------------------------------------------------------------------ 6. the interface choice: explicit, stable, remembered
    page = open_page(desktop, 'landing')
    page.evaluate("localStorage.removeItem('uak-ui')")
    page.reload(); page.add_script_tag(content=JS_HELPERS)
    touch_btn = page.locator('[data-ui-input="touch"]')
    touch_btn.scroll_into_view_if_needed()
    y0 = touch_btn.evaluate('b => b.getBoundingClientRect().top')
    touch_btn.click(); page.wait_for_timeout(100)
    check(page.evaluate("document.documentElement.getAttribute('data-ui-profile')") == 'touch', 'choice: Touch sets the touch profile on a fine-pointer device')
    y1 = touch_btn.evaluate('b => b.getBoundingClientRect().top')
    check(abs(y0 - y1) <= 1.5, 'choice: the pressed control keeps its vertical place', f'{y0:.1f} -> {y1:.1f}')
    check(touch_btn.get_attribute('aria-pressed') == 'true', 'choice: the pressed part carries aria-pressed')
    page.locator('[data-ui-size-set="large"]').click(); page.wait_for_timeout(80)
    check(page.evaluate("JSON.parse(localStorage.getItem('uak-ui')).size") == 'large', 'choice: the size is remembered')
    page.reload(); page.add_script_tag(content=JS_HELPERS)
    check(page.evaluate("[document.documentElement.getAttribute('data-ui-profile'), document.documentElement.getAttribute('data-ui-size')]") == ['touch', 'large'], 'choice: profile and size are applied before first paint after a reload')
    h = page.locator('.site-header .btn-primary').evaluate('b => b.getBoundingClientRect().height')
    check(abs(h - target('touch', 'large')) <= 1.5, 'choice: the header button measures the touch/large target', f'{h:.1f} vs {target("touch", "large")}')
    page.locator('[data-ui-input="auto"]').click(); page.locator('[data-ui-size-set="standard"]').click(); page.wait_for_timeout(80)
    check(page.evaluate("localStorage.getItem('uak-ui')") is None, 'choice: Auto + Standard clears the stored value')
    # a corrupt stored value never produces an unknown profile or a zero-size target
    page.evaluate("localStorage.setItem('uak-ui', '{\"input\":\"huge\",\"size\":\"0\"}')")
    page.reload(); page.add_script_tag(content=JS_HELPERS)
    check(page.evaluate("[document.documentElement.getAttribute('data-ui-profile'), document.documentElement.getAttribute('data-ui-size')]") == ['pointer', None], 'choice: an unknown stored value falls back to auto + the ordinary size')
    page.evaluate("localStorage.removeItem('uak-ui')")
    page.close()

    # the header's one primary command is never dropped on a narrow viewport (BUTTONS section 4 rule 3)
    for pg in ('landing', 'portal', 'function', 'privacy'):
        for prof in ('touch', 'pointer'):
            page = open_page(touch, pg, profile=prof)
            vis = page.evaluate("(() => { const b = document.querySelector('.site-header .btn-primary'); if (!b) return false; const r = b.getBoundingClientRect(); return r.width > 0 && r.height > 0 && getComputedStyle(b).display !== 'none'; })()")
            check(vis, f'{pg}/{prof}/360: the header primary command stays visible')
            page.close()

    # ------------------------------------------------------------------ 7. portal chrome: disclosure marker, search dialog, back to top
    page = open_page(touch, 'portal', profile='touch')
    nav = page.locator('#navToggle')
    check(nav.is_visible(), 'portal: the Menu button is visible on a narrow viewport')
    e0 = nav.evaluate("b => [getComputedStyle(b.querySelector('.marker-expand')).display, getComputedStyle(b.querySelector('.marker-collapse')).display]")
    nav.click(); page.wait_for_timeout(60)
    e1 = nav.evaluate("b => [getComputedStyle(b.querySelector('.marker-expand')).display, getComputedStyle(b.querySelector('.marker-collapse')).display]")
    check(e0[0] != 'none' and e0[1] == 'none' and e1[0] == 'none' and e1[1] != 'none', 'portal: the disclosure marker changes with the expanded state', f'{e0} -> {e1}')
    check(nav.get_attribute('aria-expanded') == 'true', 'portal: aria-expanded follows the state')
    page.close()
    page = open_page(desktop, 'portal', profile='pointer')
    opener = page.locator('#searchOpen')
    opener.focus(); opener.press('Enter'); page.wait_for_timeout(120)
    check(page.evaluate("document.getElementById('searchDialog').open"), 'search: the dialog opens')
    check(page.evaluate("document.activeElement.id") == 'searchInput', 'search: focus moves into the dialog')
    page.keyboard.press('Escape'); page.wait_for_timeout(80)
    check(not page.evaluate("document.getElementById('searchDialog').open"), 'search: Escape closes the dialog')
    check(page.evaluate("document.activeElement.id") == 'searchOpen', 'search: focus returns to the invoker')
    page.close()
    for prof, ctx in (('touch', touch), ('pointer', desktop)):
        page = open_page(ctx, 'landing', profile=prof)
        page.evaluate("window.scrollTo({top: 1400, behavior: 'instant'})"); page.wait_for_timeout(250)
        top = page.locator('#toTop')
        check(top.is_visible(), f'to-top[{prof}]: shown after scrolling')
        label_visible = page.evaluate("(() => { const l = document.querySelector('.to-top-label'); const r = l.getBoundingClientRect(); return r.width > 4 && r.height > 4; })()")
        check(label_visible == (prof == 'touch'), f'to-top[{prof}]: the caption is visible exactly on touch', label_visible)
        check(top.get_attribute('aria-label') and top.get_attribute('title'), f'to-top[{prof}]: accessible name and tooltip')
        page.close()

    # ------------------------------------------------------------------ 8. reduced motion, high contrast, focus ring
    rm = browser.new_context(viewport={'width': 1280, 'height': 800}, reduced_motion='reduce')
    page = open_page(rm, 'landing', profile='pointer')
    dur = page.evaluate("getComputedStyle(document.querySelector('.btn')).transitionDuration")
    check(dur in ('0s', '0.000001s', '1e-06s'), 'motion: buttons do not animate under reduced motion', dur)
    page.close(); rm.close()
    fc = browser.new_context(viewport={'width': 1280, 'height': 800}, forced_colors='active')
    page = open_page(fc, 'landing', profile='pointer')
    bw = page.evaluate("(() => { const b = document.querySelector('.toolbar .btn'); const c = getComputedStyle(b); return [c.borderTopWidth, c.borderTopStyle]; })()")
    check(bw[0] != '0px' and bw[1] != 'none', 'high contrast: a button keeps a visible border', bw)
    sel = page.evaluate("(() => { const a = document.querySelector('.seg button[aria-pressed=true]'); const b = document.querySelector('.seg button[aria-pressed=false]'); return getComputedStyle(a).backgroundColor !== getComputedStyle(b).backgroundColor; })()")
    check(sel, 'high contrast: the pressed part differs from the others')
    shot(page, 'landing_forced-colors')
    page.close(); fc.close()
    page = open_page(desktop, 'landing', profile='pointer')
    page.keyboard.press('Tab'); page.keyboard.press('Tab'); page.keyboard.press('Tab')
    ring = page.evaluate("(() => { const c = getComputedStyle(document.activeElement); return [c.outlineStyle, parseFloat(c.outlineWidth)]; })()")
    check(ring[0] != 'none' and ring[1] >= 2, 'focus: a focused control has a visible ring independent of its fill', ring)
    page.close()

    browser.close()

server.shutdown()
(out / 'results.json').write_text(json.dumps({'when': time.strftime('%Y-%m-%d %H:%M:%S'), 'chromium': chromium,
                                              'checks': len(results), 'failed': len(failures), 'results': results}, indent=1), encoding='utf-8')
for f in failures:
    print('FAIL', f)
print(f"ui-check: {len(results)} checks, {len(failures)} failed -> {'FAIL' if failures else 'PASS'}")
sys.exit(1 if failures else 0)
