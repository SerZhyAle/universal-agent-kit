# Universal Agent Kit

**[→ Read the article / Читать статью](https://serzhyale.github.io/universal-agent-kit/)** ·
**[⤓ Download the kit](https://github.com/SerZhyAle/universal-agent-kit/raw/main/universal-agent-kit.zip)**

A portable method for AI-assisted development - rules, skills (slash commands), roles, a spec
lifecycle, and persistent memory. Distilled from a real project and stripped of its language and
stack, so it carries over to most **git-backed repos with a promptable agent**.

Переносимый метод разработки с ИИ-агентами - правила, навыки (slash-команды), роли, жизненный
цикл спецификаций и постоянная память. Выжимка из реального проекта, очищенная от языка и стека,
- ложится в большинство **git-репозиториев с агентом, которым можно управлять через промпты**.

Переносний метод розробки з ШІ-агентами - правила, навички (slash-команди), ролі, життєвий цикл
специфікацій та постійна пам'ять. Дистильовано з реального проєкту, очищено від мови та стека -
лягає в більшість **git-репозиторіїв з агентом, яким можна керувати через промпти**.

---

## Fastest start

Just adopting the method? Paste this at your coding agent inside an existing repo - it downloads
the kit, unpacks it, and imports what fits (your files always win):

<details>
<summary>Paste-at-your-agent prompt</summary>

```
Download
https://github.com/SerZhyAle/universal-agent-kit/raw/main/universal-agent-kit.zip
into a temp or scratch directory and unpack it locally; it extracts to a
`universal-agent-kit/` folder beside a `merge-prompt.txt`. Use those extracted
files as the source of truth: read `universal-agent-kit/README.md` first, then
use `universal-agent-kit/CLAUDE.md`, `universal-agent-kit/.claude/`,
`universal-agent-kit/docs/`, `universal-agent-kit/memory/`, and
`merge-prompt.txt`. Do not use the article page as the primary source. If you
cannot download files in this environment, stop and ask me to place the
archive in the workspace.

Then study THIS repository and import what fits it:

1. Draft a CLAUDE.md (or my tool's equivalent rules file) that adopts the method, with every
   placeholder filled from this repo: project name, chat language, source root, architecture
   layers, build / test / lint / run commands, logger, plan directory, scratch directory,
   file-size budget, read-only zones, and ticket-id scheme.
2. Recommend which skills (/research, /spec, /spec-tech, /spec-dev, /spec-check, /spec-fix,
   /quick, /fix, /verify, /git, /review) and which role agents are worth adding here, and say
   why for each.
3. Tell me whether my runtime supports persistent agent memory and, if so, how to wire it up.

Do not change anything yet. Show me the plan first; on any conflict, my existing files win.
```
</details>

**Which path?** *Just adopting* - paste the prompt above. *Reviewing the method first* - browse
`kit/` or [read the article](https://serzhyale.github.io/universal-agent-kit/). *Reproducible team
merge* - hand `merge-prompt.txt` plus the unzipped folder to your agent (it inventories, plans, and
stops for your approval). *Offline* - grab the `.zip` and unpack it in place. *Want the bare
minimum* - copy `CLAUDE.md` + `/quick` + `/fix` and add the rest when a task earns it.

---

## English

The value is not the tooling - it is the **working method**: research before you act, split
*what* from *how*, plan in verifiable phases, keep autonomy high and bureaucracy low, write
clean from the start, and let the assistant remember across sessions.

### What's inside

```
index.html                 the article (this is what GitHub Pages serves), EN + RU + UK
universal-agent-kit.zip     the downloadable kit
merge-prompt.txt            paste this at your agent to merge the kit into your repo
kit/                        the kit source, browsable here
  CLAUDE.md                 project-rules template (fill the <PLACEHOLDERS>)
  AGENTS.md                 the same contract for tools that read AGENTS.md (pointer)
  .claude/commands/*        slash-command skills (/spec, /spec-tech, /spec-dev, /spec-check,
                            /spec-all, /research, /quick, /fix, /park, /backlog, /git,
                            /verify, /ui-clarify, ..)
  .claude/agents/*          role briefs (rd-lead, solution-researcher, implementer, doc-writer)
  docs/                     SPEC_LIFECYCLE · CODE_QUALITY · AGENT_MEMORY · RESEARCH_INDEX · VALIDATION · COST · REPLACES · REPLACES_RU
  memory/                   memory index template + one sample entry per type
```

### How to use it

1. Download and unzip `universal-agent-kit.zip` into your repo (or copy `kit/` in).
2. Hand the folder and `merge-prompt.txt` to your coding agent: *"Merge the Universal Agent Kit
   into this repo."* It inventories your setup, proposes a merge, and stops for your approval -
   your files always win, nothing is overwritten silently.
3. Fill the `<PLACEHOLDER>` tokens for your stack (build/test/run commands, source root,
   architecture, plan dir, logger).

Minimal start: take just `CLAUDE.md` + `/quick` + `/fix` - add the rest when a task earns it.

Works natively with **Claude Code**; for **Cursor / Cline / Windsurf / Codex / Aider** it is an
adaptation, not a drop-in - the slash commands become saved prompts and the role briefs become
system prompts (`kit/README.md` maps each tool's file). The `docs/` method is largely tool-independent.

### License

Kit: **MIT** (see `LICENSE`). Article prose: **CC BY 4.0**. No source code or proprietary content
from the origin project is included - only the working method.

---

## Русский

Ценность - не в инструментах, а в **методе работы**: сначала исследуй, потом действуй; отделяй
*что* от *как*; планируй проверяемыми фазами; держи автономию высокой, а бюрократию низкой; пиши
чисто с самого начала; и дай ассистенту помнить между сессиями.

### Что внутри

```
index.html                 статья (её отдаёт GitHub Pages), EN + RU + UK
universal-agent-kit.zip     скачиваемый kit
merge-prompt.txt            вставь это агенту, чтобы влить kit в свой репозиторий
kit/                        исходник kit, можно листать прямо здесь
  CLAUDE.md                 шаблон правил проекта (заполни <PLACEHOLDER>)
  AGENTS.md                 тот же контракт для инструментов, читающих AGENTS.md (указатель)
  .claude/commands/*        навыки-команды (/spec, /spec-tech, /spec-dev, /spec-check,
                            /spec-all, /research, /quick, /fix, /park, /backlog, /git,
                            /verify, /ui-clarify, ..)
  .claude/agents/*          роль-брифы (rd-lead, solution-researcher, implementer, doc-writer)
  docs/                     SPEC_LIFECYCLE · CODE_QUALITY · AGENT_MEMORY · RESEARCH_INDEX · VALIDATION · COST · REPLACES · REPLACES_RU
  memory/                   шаблон индекса памяти + по примеру на каждый тип записи
```

### Как пользоваться

1. Скачай и распакуй `universal-agent-kit.zip` в свой репозиторий (или скопируй папку `kit/`).
2. Отдай папку и `merge-prompt.txt` своему агенту: *«Влей Universal Agent Kit в этот
   репозиторий»*. Он сделает инвентарь твоего сетапа, предложит план слияния и остановится для
   подтверждения - твои файлы всегда главнее, ничего не перезаписывается молча.
3. Заполни `<PLACEHOLDER>` под свой стек (команды сборки/тестов/запуска, корень исходников,
   архитектуру, папку планов, логгер).

Минимальный старт: возьми только `CLAUDE.md` + `/quick` + `/fix` - остальное добавишь, когда
задача этого потребует.

Нативно работает с **Claude Code**; для **Cursor / Cline / Windsurf / Codex / Aider** это
адаптация, не drop-in - slash-команды становятся сохранёнными промптами, а роли - системными
промптами (`kit/README.md` указывает файл под каждый инструмент). Метод в `docs/` почти не зависит от инструмента.

### Лицензия

Kit - **MIT** (см. `LICENSE`). Текст статьи - **CC BY 4.0**. Исходного кода и проприетарного
содержимого проекта-источника здесь нет - только рабочий метод.

---

## Українська

Цінність - не в інструментах, а в **методі роботи**: спершу досліджуй, потім дій; відділяй
*що* від *як*; плануй перевірюваними фазами; тримай автономію високою, а бюрократію низькою; пиши
чисто від початку; і дай асистенту пам'ятати між сесіями.

### Що всередині

Структура репозиторію та сама, що й у розділах вище: `index.html` (стаття, EN + RU + UK),
`universal-agent-kit.zip` (kit для завантаження), `merge-prompt.txt` (встав агенту, щоб влити kit),
і тека `kit/` (правила, навички-команди, ролі, `docs/`, `memory/`).

### Як користуватися

1. Завантаж і розпакуй `universal-agent-kit.zip` у свій репозиторій (або скопіюй теку `kit/`).
2. Віддай теку й `merge-prompt.txt` своєму агенту: *«Влий Universal Agent Kit у цей репозиторій»*.
   Він зробить інвентар твого сетапу, запропонує план злиття й зупиниться для підтвердження -
   твої файли завжди головніші, нічого не перезаписується мовчки.
3. Заповни `<PLACEHOLDER>` під свій стек (команди збірки/тестів/запуску, корінь коду, архітектуру,
   теку планів, логгер).

Мінімальний старт: візьми лише `CLAUDE.md` + `/quick` + `/fix` - решту додаси, коли задача цього
потребуватиме.

Нативно працює з **Claude Code**; для **Cursor / Cline / Windsurf / Codex / Aider** це адаптація,
не drop-in (`kit/README.md` вказує файл під кожен інструмент). Метод у `docs/` майже не залежить
від інструмента.

### Ліцензія

Kit - **MIT** (див. `LICENSE`). Текст статті - **CC BY 4.0**. Вихідного коду та пропрієтарного
вмісту проєкту-джерела тут немає - лише робочий метод.
