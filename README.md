# Universal Agent Kit

**[→ Read the article / Читать статью](https://serzhyale.github.io/universal-agent-kit/)** ·
**[⤓ Download the kit](https://github.com/SerZhyAle/universal-agent-kit/raw/main/universal-agent-kit.zip)**

A portable method for AI-assisted development - rules, skills (slash commands), roles, a spec
lifecycle, and persistent memory. Distilled from a real project and stripped of its language and
stack, so it carries over to most **git-backed repos with a promptable agent**.

Переносимый метод разработки с ИИ-агентами - правила, навыки (slash-команды), роли, жизненный
цикл спецификаций и постоянная память. Выжимка из реального проекта, очищенная от языка и стека,
- ложится в большинство **git-репозиториев с агентом, которым можно управлять через промпты**.

---

## English

The value is not the tooling - it is the **working method**: research before you act, split
*what* from *how*, plan in verifiable phases, keep autonomy high and bureaucracy low, write
clean from the start, and let the assistant remember across sessions.

### What's inside

```
index.html                 the article (this is what GitHub Pages serves), RU + EN
universal-agent-kit.zip     the downloadable kit
merge-prompt.txt            paste this at your agent to merge the kit into your repo
kit/                        the kit source, browsable here
  CLAUDE.md                 project-rules template (fill the <PLACEHOLDERS>)
  .claude/commands/*        slash-command skills (/spec, /spec-tech, /spec-dev, /spec-check,
                            /spec-all, /research, /quick, /fix, /git, /verify, /ui-clarify, ..)
  .claude/agents/*          role briefs (rd-lead, solution-researcher, implementer, doc-writer)
  docs/                     SPEC_LIFECYCLE · CODE_QUALITY · AGENT_MEMORY · RESEARCH_INDEX · VALIDATION
  memory/                   memory index template + one sample entry per type
```

### How to use it

1. Download and unzip `universal-agent-kit.zip` into your repo (or copy `kit/` in).
2. Hand the folder and `merge-prompt.txt` to your coding agent: *"Merge the Universal Agent Kit
   into this repo."* It inventories your setup, proposes a merge, and stops for your approval -
   your files always win, nothing is overwritten silently.
3. Fill the `<PLACEHOLDER>` tokens for your stack (build/test/run commands, source root,
   architecture, plan dir, logger).

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
index.html                 статья (её отдаёт GitHub Pages), RU + EN
universal-agent-kit.zip     скачиваемый kit
merge-prompt.txt            вставь это агенту, чтобы влить kit в свой репозиторий
kit/                        исходник kit, можно листать прямо здесь
  CLAUDE.md                 шаблон правил проекта (заполни <PLACEHOLDER>)
  .claude/commands/*        навыки-команды (/spec, /spec-tech, /spec-dev, /spec-check,
                            /spec-all, /research, /quick, /fix, /git, /verify, /ui-clarify, ..)
  .claude/agents/*          роль-брифы (rd-lead, solution-researcher, implementer, doc-writer)
  docs/                     SPEC_LIFECYCLE · CODE_QUALITY · AGENT_MEMORY · RESEARCH_INDEX · VALIDATION
  memory/                   шаблон индекса памяти + по примеру на каждый тип записи
```

### Как пользоваться

1. Скачай и распакуй `universal-agent-kit.zip` в свой репозиторий (или скопируй папку `kit/`).
2. Отдай папку и `merge-prompt.txt` своему агенту: *«Влей Universal Agent Kit в этот
   репозиторий»*. Он сделает инвентарь твоего сетапа, предложит план слияния и остановится для
   подтверждения - твои файлы всегда главнее, ничего не перезаписывается молча.
3. Заполни `<PLACEHOLDER>` под свой стек (команды сборки/тестов/запуска, корень исходников,
   архитектуру, папку планов, логгер).

Нативно работает с **Claude Code**; для **Cursor / Cline / Windsurf / Codex / Aider** это
адаптация, не drop-in - slash-команды становятся сохранёнными промптами, а роли - системными
промптами (`kit/README.md` указывает файл под каждый инструмент). Метод в `docs/` почти не зависит от инструмента.

### Лицензия

Kit - **MIT** (см. `LICENSE`). Текст статьи - **CC BY 4.0**. Исходного кода и проприетарного
содержимого проекта-источника здесь нет - только рабочий метод.
