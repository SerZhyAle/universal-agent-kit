/* Portal behaviour (SITE-EXPERIENCE 7, 10, 11, 12, 15): language and theme on the shared keys sza-lang / sza-theme,
   the navigation toggle of a narrow viewport, the local search, the glossary order, back-to-top.
   Vanilla, no libraries, no request except the one search index, loaded once when the search is first opened. */
(function () {
  'use strict';
  var doc = document.documentElement;
  var ROOT = doc.getAttribute('data-root') || './';
  var D = { t: {}, d: {}, ui: {} };
  try { D = JSON.parse(document.getElementById('page-i18n').textContent); } catch (e) {}

  function iso(l) { return l === 'ua' ? 'uk' : l; }
  function cur() { return doc.getAttribute('data-lang') || 'en'; }
  function ui(k) { var o = D.ui[k]; return o ? (o[cur()] || o.en || '') : ''; }
  function metaSet(sel, val) { var m = document.querySelector(sel); if (m && val) m.setAttribute('content', val); }

  function applyThemeLabel() {
    var dark = doc.getAttribute('data-theme') !== 'light';
    var b = document.getElementById('themeBtn');
    if (b) { b.setAttribute('aria-label', dark ? ui('toLight') : ui('toDark')); b.setAttribute('title', ui('theme')); b.setAttribute('aria-pressed', String(!dark)); }
    metaSet('meta[name="theme-color"]', dark ? '#0a0f0a' : '#eef3ea');   /* the kit's --bg per theme */
  }
  function applyAria() {
    var els = document.querySelectorAll('[data-aria]');
    for (var i = 0; i < els.length; i++) { var v = ui(els[i].getAttribute('data-aria')); if (v) els[i].setAttribute('aria-label', v); }
    var tt = document.getElementById('toTop'); if (tt) { tt.setAttribute('aria-label', ui('toTop')); tt.setAttribute('title', ui('toTop')); }
    var inp = document.getElementById('searchInput'); if (inp) inp.setAttribute('placeholder', ui('searchTitle') + '..');
  }
  function sortGlossary() {
    var box = document.getElementById('terms'); if (!box) return;
    var l = cur(), items = Array.prototype.slice.call(box.children);
    var coll = (window.Intl && Intl.Collator) ? new Intl.Collator(iso(l)) : null;
    function key(el) { var s = el.querySelector('dt [data-l="' + l + '"]'); return s ? s.textContent : ''; }
    items.sort(function (a, b) { return coll ? coll.compare(key(a), key(b)) : (key(a) < key(b) ? -1 : 1); });
    for (var i = 0; i < items.length; i++) box.appendChild(items[i]);
  }
  function applyLang(l) {
    doc.setAttribute('data-lang', l); doc.setAttribute('lang', iso(l));
    if (D.t[l]) document.title = D.t[l];
    var d = D.d[l], t = D.t[l];
    metaSet('meta[name="description"]', d); metaSet('meta[property="og:description"]', d); metaSet('meta[name="twitter:description"]', d);
    metaSet('meta[property="og:title"]', t); metaSet('meta[name="twitter:title"]', t);
    ['ru', 'en', 'ua'].forEach(function (c) { var b = document.getElementById('lng-' + c); if (b) b.setAttribute('aria-pressed', String(l === c)); });
    applyAria(); applyThemeLabel(); sortGlossary();
    if (results.length || input && input.value) renderResults();
  }
  function setLang(l) {
    applyLang(l);
    try { localStorage.setItem('sza-lang', l); } catch (e) {}
    try { var u = new URL(location.href); u.searchParams.set('lang', iso(l)); history.replaceState(null, '', u); } catch (e) {}
  }
  function toggleTheme() {
    var t = doc.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    doc.setAttribute('data-theme', t);
    try { localStorage.setItem('sza-theme', t); } catch (e) {}
    applyThemeLabel();
  }

  /* ---------- search: local, one index file, no request per keystroke ---------- */
  var dlg = document.getElementById('searchDialog');
  var input = document.getElementById('searchInput');
  var list = document.getElementById('searchResults');
  var status = document.getElementById('searchStatus');
  var index = null, loading = false, results = [];

  function norm(s) { return String(s || '').toLowerCase().replace(/ё/g, 'е'); }
  function loadIndex(done) {
    if (index) return done();
    if (loading) return;
    loading = true;
    fetch(ROOT + 'assets/search-index.json').then(function (r) { return r.json(); })
      .then(function (j) { index = j; loading = false; done(); })
      .catch(function () { loading = false; if (status) status.textContent = ui('searchFail'); });
  }
  function score(item, toks, l) {
    var t = norm(item.t[l]), d = norm(item.d[l]), w = norm(item.w[l]), s = 0;
    for (var i = 0; i < toks.length; i++) {
      var k = toks[i];
      if (t.indexOf(k) === 0) s += 6; else if (t.indexOf(k) > -1) s += 4;
      else if (w.indexOf(k) > -1) s += 2; else if (d.indexOf(k) > -1) s += 1; else return 0;
    }
    return s;
  }
  function renderResults() {
    if (!list || !input) return;
    var l = cur(), q = input.value.trim(), toks = norm(q).split(/\s+/).filter(Boolean);
    list.textContent = '';
    results = [];
    if (!index || !toks.length) { if (status) status.textContent = ''; return; }
    var scored = [];
    for (var i = 0; i < index.length; i++) { var s = score(index[i], toks, l); if (s > 0) scored.push({ s: s, it: index[i] }); }
    scored.sort(function (a, b) { return b.s - a.s; });
    results = scored.slice(0, 12);
    if (!results.length) {
      status.textContent = '';
      var p = document.createElement('li');
      var a = document.createElement('a'); a.href = ROOT + 'portal/subjects.html'; a.textContent = ui('searchEmptyHelp'); p.appendChild(a);
      list.appendChild(p);
      status.textContent = ui('searchEmpty') + ' «' + q + '»';
      return;
    }
    status.textContent = results.length + ' ' + ui('searchCount');
    results.forEach(function (r) {
      var li = document.createElement('li'), a = document.createElement('a');
      a.href = ROOT + r.it.u;
      var k = document.createElement('span'); k.className = 'r-kind'; k.textContent = ui('kind.' + r.it.k) || r.it.k;
      var t = document.createElement('span'); t.className = 'r-title'; t.textContent = r.it.t[l];
      var d = document.createElement('span'); d.className = 'r-desc'; d.textContent = r.it.d[l];
      a.appendChild(k); a.appendChild(t); a.appendChild(d); li.appendChild(a); list.appendChild(li);
    });
  }
  function openSearch() {
    if (!dlg || typeof dlg.showModal !== 'function') { location.href = ROOT + 'portal/subjects.html'; return; }
    if (!dlg.open) dlg.showModal();
    if (input) input.focus();
    loadIndex(renderResults);
  }
  function closeSearch() { if (dlg && dlg.open) dlg.close(); }

  /* ---------- wiring ---------- */
  function on(id, ev, fn) { var el = document.getElementById(id); if (el) el.addEventListener(ev, fn); }
  ['ru', 'en', 'ua'].forEach(function (c) { on('lng-' + c, 'click', function () { setLang(c); }); });
  on('themeBtn', 'click', toggleTheme);
  on('searchOpen', 'click', openSearch);
  on('searchOpenInline', 'click', openSearch);
  on('searchClose', 'click', closeSearch);
  if (input) input.addEventListener('input', function () { loadIndex(renderResults); });
  /* a search field clears itself on Escape; here Escape closes the dialog, once */
  if (input) input.addEventListener('keydown', function (e) { if (e.key === 'Escape') { e.preventDefault(); closeSearch(); } });
  if (dlg) dlg.addEventListener('click', function (e) { if (e.target === dlg) closeSearch(); });
  var form = document.getElementById('searchForm'); if (form) form.addEventListener('submit', function (e) { e.preventDefault(); if (results[0]) location.href = ROOT + results[0].it.u; });
  document.addEventListener('keydown', function (e) {
    if (e.key !== '/' || e.ctrlKey || e.metaKey || e.altKey) return;
    var t = e.target, tag = t && t.tagName;
    if (tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT' || (t && t.isContentEditable)) return;
    e.preventDefault(); openSearch();
  });

  var toggle = document.getElementById('navToggle'), nav = document.getElementById('portalNav');
  if (toggle && nav) toggle.addEventListener('click', function () {
    var open = nav.classList.toggle('open'); toggle.setAttribute('aria-expanded', String(open));
  });

  function syncToTop() { var b = document.getElementById('toTop'); if (b) b.classList.toggle('show', window.scrollY > 600); }
  window.addEventListener('scroll', syncToTop, { passive: true });
  on('toTop', 'click', function () { window.scrollTo({ top: 0, behavior: 'smooth' }); });

  /* a #hash into another language's block is not needed here: structure and ids are single, only the text is per language */
  applyLang(cur());
  syncToTop();
})();
