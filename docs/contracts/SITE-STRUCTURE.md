# `SITE-STRUCTURE` pointer

- Version: 0.1 (draft; opted in 2026-10-09)
- Role: consumer, site at the **portal** tier (owner decision D2, 2026-10-09)
- Home: `product-site/SITE-STRUCTURE.md` in the shared contracts catalog; its conformance artifact is the
  run-list `SITE-CHECKLIST.md`, read off the rendered site

The site publishes the portal tier's page set: the landing, the privacy page, a portal home that carries a
titled listing for each section, an overview, guides by task, one function page per capability of the kit,
a features showcase, a subject index, a glossary, the local search and the not-found page. Conditional types
whose conditions do not hold (release notes: no dated releases; roadmap; edition or channel page; settings
reference: no settings screen) are owed nothing, and the install-trust page is out of scope for this product.
The pages are generated from `tools/portal/` (the capability inventory, the page content, the glossary) by
`tools/build-portal.ps1`; the inventory is checked against the file tree of `kit/`, so a payload file with no
page and no recorded exclusion fails the build (rule 12). Every page group is published in RU, EN and UA - the
core three, nothing beyond - in one document per page, the language being the `?lang=<ISO>` parameter and the
shared `sza-lang` state, so a missing translation cannot exist (rules 9 to 11). The address scheme is one
permanent address per page (`portal/<page>.html`, `portal/functions/<id>.html`, `portal/guides/<id>.html`,
the root documents) with section anchors never renamed; the addresses outside surfaces hold are listed in
`tools/site-held-addresses.jsonl` and resolved against the page set by `tools/check-site.ps1 -Dimension
held-addresses` (rule 8). Reach, the sitemap, landmarks and the not-found page are held by the same script
(`page-set`). Staying conformant: keep the tier declaration true, publish every new page group in the core
three, leave a forwarder at any moved address, change a capability's page in the same change as the capability,
and close or renew each registry exception before its `until` date.
