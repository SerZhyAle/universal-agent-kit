/* The explicit choice of input profile and interface size (UI-SIZING section 2 rules 1-4). The pre-paint resolver of
   every page has already written data-ui-profile (pointer or touch) and, for any size but the ordinary one,
   data-ui-size (compact, large, xlarge) before first paint; the kit's stylesheet reads them. This file only reflects
   them in the footer control and lets the visitor change either one on purpose. Nothing here listens to a pointer,
   touch or resize event, so a target is never resized by the input that is using it. The choice is kept in the one
   local value uak-ui (privacy.html lists it). Vanilla, no libraries, no request. */
(function () {
  'use strict';
  var doc = document.documentElement;
  var INPUTS = ['auto', 'pointer', 'touch'];
  var SIZES = ['compact', 'standard', 'large', 'xlarge'];

  function fine() { return !!(window.matchMedia && window.matchMedia('(pointer: fine)').matches); }
  function choice() { var c = doc.getAttribute('data-ui-choice'); return INPUTS.indexOf(c) > -1 ? c : 'auto'; }
  function size() { var s = doc.getAttribute('data-ui-size'); return SIZES.indexOf(s) > -1 ? s : 'standard'; }

  function reflect() {
    var c = choice(), s = size(), i, els;
    els = document.querySelectorAll('[data-ui-input]');
    for (i = 0; i < els.length; i++) els[i].setAttribute('aria-pressed', String(els[i].getAttribute('data-ui-input') === c));
    els = document.querySelectorAll('[data-ui-size-set]');
    for (i = 0; i < els.length; i++) els[i].setAttribute('aria-pressed', String(els[i].getAttribute('data-ui-size-set') === s));
  }

  function save() {
    try {
      if (choice() === 'auto' && size() === 'standard') localStorage.removeItem('uak-ui');
      else localStorage.setItem('uak-ui', JSON.stringify({ input: choice(), size: size() }));
    } catch (e) {}
  }

  /* the control that was pressed keeps its place under the pointer while everything around it changes size */
  function keepAnchor(el, change) {
    var before = el.getBoundingClientRect().top;
    change();
    var shift = el.getBoundingClientRect().top - before;
    if (shift) window.scrollBy({ top: shift, left: 0, behavior: 'instant' });
  }

  function apply(btn, attr, value) {
    keepAnchor(btn, function () {
      if (attr === 'input') {
        doc.setAttribute('data-ui-choice', value);
        doc.setAttribute('data-ui-profile', value === 'auto' ? (fine() ? 'pointer' : 'touch') : value);
      } else if (value === 'standard') {
        doc.removeAttribute('data-ui-size');
      } else {
        doc.setAttribute('data-ui-size', value);
      }
    });
    reflect();
    save();
  }

  document.addEventListener('click', function (e) {
    var t = e.target && e.target.closest ? e.target.closest('[data-ui-input],[data-ui-size-set]') : null;
    if (!t) return;
    if (t.hasAttribute('data-ui-input')) apply(t, 'input', t.getAttribute('data-ui-input'));
    else apply(t, 'size', t.getAttribute('data-ui-size-set'));
  });

  reflect();
})();
