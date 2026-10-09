# `SITE-REPRESENTATION` pointer

- Version: 0.1 (draft; opted in 2026-10-09)
- Role: consumer; every rule binds at the declared portal tier
- Home: `product-site/SITE-REPRESENTATION.md` in the shared contracts catalog; its conformance artifact is the
  run-list `SITE-CHECKLIST.md`, read off the rendered site

Every external surface is written from one positioning source, `POSITIONING.md`, which holds the six pillars
in order (rules 1, 2); the landing hero and descriptions, the README opening and the portal home, overview and
showcase repeat that order, and `tools/check-site.ps1 -Dimension positioning` reads each surface and refuses a
pillar out of order. A fact is typed once in its source (rule 3): the kit date is rendered by
`tools/build-kit.ps1`, the counts of commands, agents and practices are counted from
`tools/portal/inventory.json`, what a capability touches and where it works are rendered from the inventory,
and no edition, device, version or channel string is typed in page copy. One public edition exists -
`universal-agent-kit.zip`, displayed as the kit, derived from `kit/` by the build script (rule 4). Each
capability has exactly one function page with the fixed anatomy of rule 7 - the title as a task, a lead,
requirements, steps, the outcome, related functions - drawn by one template; a command is quoted as its file
names it and a command that is not in the inventory is refused (rule 8); availability is rendered from the
inventory (rule 9); the product has no settings screen, so no settings reference is owed (rule 10). The
showcase is drawn from the inventory's shipped records (rule 11). The privacy page, the permission list rendered
on each function page and the download described on both say one thing (rule 12): the site collects nothing,
the kit installs and runs nothing. Staying conformant: change a capability in the inventory and its page in
the same change, keep a function's name owned by exactly one page, and keep the privacy copy and every data
claim agreeing.
