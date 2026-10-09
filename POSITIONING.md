# Positioning source - Universal Agent Kit

The one document every external surface of this repository is written from: the landing (`index.html`), the
portal home, overview and showcase, `README.md`, the page descriptions and the Open Graph and social tags. No
surface is written from another surface; where two disagree, this document decides which one is wrong
(`SITE-REPRESENTATION` rules 1 and 2). It is held here, beside the README it governs, and not under `kit/`:
the kit re-expresses the method for an outside reader and does not advertise where the portfolio keeps its
own material.

## What it is

A portable method for working with AI agents on a project, written down as files: a rules file the agent reads
before it starts, skills (slash commands), role agents, a spec lifecycle, persistent memory and the discipline
for running several agents at once. Distilled from a real, mature project and stripped of its language, its
stack and its subject matter, so what is left is the part that transfers. It is not an application: nothing is
installed. The agent reads the files and adds only the parts that fit.

## Who it is for

- People who already work with an AI agent and are tired of explaining the same thing a third time.
- People who want the agent to check, not guess, and to say plainly where it is not sure.
- Solo developers, small teams and owners of a personal project in a local folder.
- Not only programmers: the method rests on files, not on a compiler, so analysis, documentation, contracts
  and procedures fit it, minus the code layer.

## What it promises, and what it does not

It promises a working order: the agent investigates before it changes, separates the what from the how, plans in
phases it can check, keeps context between sessions, and stays out of other agents' way. Done means evidence,
not hope.

It does not promise a smarter agent, and it is not a silver bullet. It stops the agent from shooting itself in
the foot and then forgetting it had a foot. Its sharp edges are stated in the article: ceremony hung on a
one-line edit is invented work, a stale index misleads worse than none, parallel writers silently overwrite each
other, and memory rots when nobody prunes it.

## The pillars

What the kit is for, in the order every surface repeats. A surface that lists what the kit does lists these in
this order; a surface too short for all of them names the first ones, and never one without those before it.

| # | Id | English | Русский | Українська |
| - | --- | --- | --- | --- |
| 1 | `rules` | Rules | Правила | Правила |
| 2 | `skills` | Skills | Навыки | Навички |
| 3 | `agents` | Role agents | Роли | Ролі |
| 4 | `lifecycle` | Spec lifecycle | Жизненный цикл спеки | Життєвий цикл спеки |
| 5 | `memory` | Persistent memory | Постоянная память | Постійна пам'ять |
| 6 | `parallel` | Parallel-agent discipline | Дисциплина параллельной работы агентов | Дисципліна паралельної роботи агентів |

## The surfaces it governs

| Surface | What is written from this document |
| --- | --- |
| `index.html` hero | the lead paragraph, in RU, EN and UA |
| `index.html` head | `description`, `og:description`, `twitter:description`, the JSON-LD description and the per-language description strings the page script swaps in |
| `README.md` | the opening paragraph of the title block, in RU, EN and UA |
| `portal/index.html`, `portal/overview.html`, `portal/showcase.html` | the section order and the pillar list, generated from the block below |
| `privacy.html`, `404.html` | no pillar list; they name the product, not what it is for |

Store-policy exceptions (a listing that must name one function first): none. The kit has no store listing.

## Machine-readable form

`tools/build-portal.ps1` reads the pillars from this block, and `tools/check-site.ps1 -Dimension positioning`
reads the same block to check the surfaces above. `match` is a case-insensitive regular expression that finds
the pillar's name in running text of that language.

```json
{
  "pillars": [
    { "id": "rules",     "en": { "name": "Rules",             "match": "\\brules\\b" },
                         "ru": { "name": "Правила",           "match": "\\bправил[аоуы]?\\b" },
                         "ua": { "name": "Правила",           "match": "\\bправил[аоуи]?\\b" } },
    { "id": "skills",    "en": { "name": "Skills",            "match": "\\bskills\\b" },
                         "ru": { "name": "Навыки",            "match": "\\bнавык\\w*" },
                         "ua": { "name": "Навички",           "match": "\\bнавич\\w*|\\bнавик\\w*" } },
    { "id": "agents",    "en": { "name": "Role agents",       "match": "\\brole agents\\b|\\broles\\b" },
                         "ru": { "name": "Роли",              "match": "\\bрол(?:и|ей|ями|ях)\\b" },
                         "ua": { "name": "Ролі",              "match": "\\bрол(?:і|ей|ями|ях)\\b" } },
    { "id": "lifecycle", "en": { "name": "Spec lifecycle",    "match": "\\bspec lifecycle\\b" },
                         "ru": { "name": "Жизненный цикл спеки", "match": "жизненн\\w+ цикл" },
                         "ua": { "name": "Життєвий цикл спеки",  "match": "життєв\\w+ цикл" } },
    { "id": "memory",    "en": { "name": "Persistent memory", "match": "\\bmemory\\b" },
                         "ru": { "name": "Постоянная память", "match": "\\bпамят\\w*" },
                         "ua": { "name": "Постійна пам'ять",  "match": "\\bпам['’ʼ]ят\\w*" } },
    { "id": "parallel",  "en": { "name": "Parallel-agent discipline", "match": "\\bparallel\\b" },
                         "ru": { "name": "Дисциплина параллельной работы агентов", "match": "параллельн\\w+" },
                         "ua": { "name": "Дисципліна паралельної роботи агентів",  "match": "паралельн\\w+" } }
  ]
}
```
