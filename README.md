# Universal Agent Kit

**[Read the article / Читать статью](https://serzhyale.github.io/universal-agent-kit/)** ·
**[Documentation / Документация](https://serzhyale.github.io/universal-agent-kit/portal/)** ·
**[Download the kit](https://github.com/SerZhyAle/universal-agent-kit/raw/main/universal-agent-kit.zip)**

Contact: [sza@ukr.net](mailto:sza@ukr.net) · [github.com/SerZhyAle](https://github.com/SerZhyAle)

A portable method for working with AI agents on a project - rules, skills (slash commands), roles, a
spec lifecycle, persistent memory, and the discipline for running several agents at once. Distilled
from a real project and stripped of its language and stack. It assumes five things and a compiler is
not one of them: **a workspace with history, artifacts, work items, checks, and an agent that can
read and write your files.** If your project is code, the sharpest examples are yours. If it is
data, documents, contracts or procedures, `kit/docs/PROJECT_SHAPES.md` is the translation table.

Переносимый метод работы с ИИ-агентами над проектом - правила, навыки (slash-команды), роли,
жизненный цикл спецификаций, постоянная память и дисциплина параллельной работы нескольких агентов.
Выжимка из реального проекта, очищенная от языка и стека. Методу нужны пять вещей, и компилятор в
них не входит: **рабочая папка с историей, артефакты, единицы работы, проверки и агент, который
умеет читать и писать ваши файлы.** Если проект - код, примеры кита ваши. Если это данные, тексты,
договоры или процедуры - таблица перевода лежит в `kit/docs/PROJECT_SHAPES.md`.

Переносний метод роботи з ШІ-агентами над проєктом - правила, навички (slash-команди), ролі,
життєвий цикл специфікацій, постійна пам'ять і дисципліна паралельної роботи кількох агентів.
Дистильовано з реального проєкту, очищено від мови та стека. Методу потрібні п'ять речей, і
компілятора серед них немає: **робоча тека з історією, артефакти, одиниці роботи, перевірки і
агент, який уміє читати й писати ваші файли.** Таблиця перекладу для некодових проєктів -
`kit/docs/PROJECT_SHAPES.md`.

---

## Fastest start

Just adopting the method? Paste this at your agent inside an existing project - it downloads the
kit, unpacks it, and imports what fits (your files always win):

<details>
<summary>Paste-at-your-agent prompt</summary>

```
Download
https://github.com/SerZhyAle/universal-agent-kit/raw/main/universal-agent-kit.zip
into a temp or scratch directory and unpack it locally; it extracts to a
`universal-agent-kit/` folder that contains `merge-prompt.txt`. Use those extracted
files as the source of truth: read `universal-agent-kit/README.md` first, then
`universal-agent-kit/docs/PROJECT_SHAPES.md`, then use
`universal-agent-kit/AGENTS.md`, `universal-agent-kit/.claude/`,
`universal-agent-kit/docs/`, `universal-agent-kit/memory/`,
`universal-agent-kit/examples/` (to see a filled result), and
`universal-agent-kit/merge-prompt.txt`. Do not use the article page as the
primary source. If you
cannot download files in this environment, stop and ask me to place the
archive in the workspace.

Then study THIS project and import what fits it:

1. Say what kind of project this is in the kit's own terms: what my artifacts are, what my
   workspace is, what I already use as a map - and which rules to delete because they have no
   subject here.
2. Draft an AGENTS.md (or merge into my existing rules file) that adopts the method, with every
   tier-1 placeholder filled from this project: project name, chat language, artifact language,
   map document, work root, THE CHECK COMMAND that proves a change is sound, plan directory,
   scratch directory, size budget, read-only zones, ticket-id scheme. Fill the code-layer ones (architecture layers, build
   / test / lint / run, logger) only if this project builds or runs.
3. For the check command, do not shrug: name the cheapest mechanical check this project already
   has or could have this week, and the command that runs it.
4. Recommend which skills (/research, /spec, /spec-tech, /spec-dev, /spec-check, /spec-fix,
   /quick, /fix, /prove, /git, /critique) and which role agents are worth adding here, and say
   why for each.
5. Tell me whether my runtime supports persistent agent memory and, if so, how to wire it up.

Do not change anything yet. Show me the plan first; on any conflict, my existing files win.
```
</details>

**Which path?** *Just adopting* - paste the prompt above. *Reviewing the method first* - browse
`kit/` or [read the article](https://serzhyale.github.io/universal-agent-kit/). *Reproducible team
merge* - hand `merge-prompt.txt` plus the unzipped folder to your agent (it inventories, plans, and
stops for your approval). *Offline* - grab the `.zip` and unpack it in place. *Want the bare
minimum* - copy `AGENTS.md` + `docs/` + `/quick` + `/fix` and add the rest when a task earns it.

---

## English

The value is not the tooling - it is the **working method**: research before you act, split *what*
from *how*, plan in verifiable phases, keep autonomy high and bureaucracy low, write clean from the
start, let the assistant remember across sessions, and run several agents at once without them
overwriting each other's work.

Most rules here carry a measurement and a date, because the difference between a rule people follow
and a rule people nod at is measurable: a directive with a mechanical check behind it was followed
**~99%** of the time in the source corpus, the same directive as prose **1-8%**, and the best case
ever recorded for prose - shipped in the tool's own description, re-read every single turn - was
**22%**. The kit also keeps its own corrections: one hook it used to recommend turned out to have a
measured reach of **zero**, and it now ships as a worked example of the question nobody asks - *how
many of the events I care about actually pass through here?*

### What's inside

```
index.html                  the article (this is what GitHub Pages serves), EN + RU + UK
universal-agent-kit.zip     the downloadable kit
merge-prompt.txt            paste this at your agent to merge the kit into your project
kit/                        the kit source, browsable here
  AGENTS.md                 the project-rules template, the one rules file (fill the <PLACEHOLDERS>)
  CLAUDE.md                 Claude Code entry point: imports AGENTS.md and the memory index
  .claude/skills/*/SKILL.md skills in the open Agent Skills format (/spec, /spec-tech, /spec-dev,
                            /spec-check, /spec-all, /research, /quick, /fix, /park, /backlog,
                            /git, /prove, /critique, /ui-clarify, /surfaces, ..)
  .claude/agents/*          role briefs (rd-lead, solution-researcher, implementer, doc-writer)
  docs/                     PROJECT_SHAPES · SPEC_LIFECYCLE · VALIDATION · CODE_QUALITY ·
                            AUTHORING · HOOKS · AGENT_MEMORY · RESEARCH_INDEX · COST ·
                            PARALLEL · REPLACES · REPLACES_RU
  memory/                   memory index template + sample entries
  examples/                 one filled ticket and a filled rules-file excerpt (reference only)
  VERSION                   the kit's build date - an upgrade compares against it
```

### How to use it

1. Download and unzip `universal-agent-kit.zip` into your project (or copy `kit/` in).
2. Hand the folder and `merge-prompt.txt` to your agent: *"Merge the Universal Agent Kit into this
   project."* It inventories your setup, proposes a merge, and stops for your approval - your files
   always win, nothing is overwritten silently.
3. Fill the eleven tier-1 `<PLACEHOLDER>` tokens; fill the six code-layer ones only if your project
   builds or runs, and delete the rules that use them if it does not.

Minimal start: take just `AGENTS.md` + `docs/` + `/quick` + `/fix` - add the rest when a task
earns it.

Works natively with **Claude Code**. The rules file (`AGENTS.md`) and the skills (the open Agent
Skills format) also load natively in **Codex, Cursor, GitHub Copilot, Gemini CLI and Cline**; the role
briefs are the part that stays an adaptation (`kit/README.md` maps each tool's folders). The `docs/`
method is tool-independent.

### License

Kit: **MIT** (see `LICENSE`). Article prose: **CC BY 4.0**. No source code or proprietary content
from the origin project is included - only the working method.

---

## Русский

Ценность - не в инструментах, а в **методе работы**: сначала исследуй, потом действуй; отделяй
*что* от *как*; планируй проверяемыми фазами; держи автономию высокой, а бюрократию низкой; пиши
чисто с самого начала; дай ассистенту помнить между сессиями; и запускай несколько агентов
одновременно так, чтобы они не затирали работу друг друга.

Почти каждое правило здесь идёт с замером и датой, потому что разница между правилом, которое
выполняют, и правилом, которому кивают, измерима: директива с механической проверкой за спиной
выполнялась в **~99%** случаев, та же директива в виде прозы - в **1-8%**, а лучший результат,
когда-либо замеренный для прозы (совет, который лежит в описании инструмента и перечитывается
каждый ход), - **22%**. Кит хранит и собственные опровержения: хук, который он сам же и советовал,
показал замеренный охват **ноль**, и теперь едет в комплекте как разбор вопроса, который забывают
задать: *сколько интересующих меня событий вообще проходит через эту точку?*

### Что внутри

```
index.html                  статья (её отдаёт GitHub Pages), EN + RU + UK
universal-agent-kit.zip     скачиваемый kit
merge-prompt.txt            вставь это агенту, чтобы влить kit в свой проект
kit/                        исходник kit, можно листать прямо здесь
  AGENTS.md                 шаблон правил проекта, единственный файл правил (заполни <PLACEHOLDER>)
  CLAUDE.md                 вход для Claude Code: импортирует AGENTS.md и индекс памяти
  .claude/skills/*/SKILL.md навыки в открытом формате Agent Skills (/spec, /spec-tech, /spec-dev,
                            /spec-check, /spec-all, /research, /quick, /fix, /park, /backlog,
                            /git, /prove, /critique, /ui-clarify, /surfaces, ..)
  .claude/agents/*          роль-брифы (rd-lead, solution-researcher, implementer, doc-writer)
  docs/                     PROJECT_SHAPES · SPEC_LIFECYCLE · VALIDATION · CODE_QUALITY ·
                            AUTHORING · HOOKS · AGENT_MEMORY · RESEARCH_INDEX · COST ·
                            PARALLEL · REPLACES · REPLACES_RU
  memory/                   шаблон индекса памяти + примеры записей
  examples/                 один заполненный тикет и заполненный фрагмент правил (только для чтения)
  VERSION                   дата сборки kit - обновление сравнивает с ней
```

### Как пользоваться

1. Скачай и распакуй `universal-agent-kit.zip` в свой проект (или скопируй папку `kit/`).
2. Отдай папку и `merge-prompt.txt` своему агенту: *«Влей Universal Agent Kit в этот проект»*. Он
   сделает инвентарь твоего сетапа, предложит план слияния и остановится для подтверждения - твои
   файлы всегда главнее, ничего не перезаписывается молча.
3. Заполни одиннадцать плейсхолдеров первого яруса; шесть кодовых - только если проект собирается
   или запускается, а если нет - удали правила, которые на них ссылаются.

Минимальный старт: возьми только `AGENTS.md` + `docs/` + `/quick` + `/fix` - остальное добавишь,
когда задача этого потребует.

Нативно работает с **Claude Code**. Файл правил (`AGENTS.md`) и навыки (открытый формат Agent
Skills) нативно читают и **Codex, Cursor, GitHub Copilot, Gemini CLI и Cline**; адаптировать
придётся только роли (`kit/README.md` показывает папки под каждый инструмент). Метод в `docs/` от
инструмента не зависит.

### Лицензия

Kit - **MIT** (см. `LICENSE`). Текст статьи - **CC BY 4.0**. Исходного кода и проприетарного
содержимого проекта-источника здесь нет - только рабочий метод.

---

## Українська

Цінність - не в інструментах, а в **методі роботи**: спершу досліджуй, потім дій; відділяй *що* від
*як*; плануй перевірюваними фазами; тримай автономію високою, а бюрократію низькою; пиши чисто від
початку; дай асистенту пам'ятати між сесіями; і запускай кілька агентів одночасно так, щоб вони не
затирали роботу одне одного.

Майже кожне правило тут іде із заміром і датою: директива з механічною перевіркою за спиною
виконувалася в **~99%** випадків, та сама директива у вигляді прози - в **1-8%**, а найкращий
будь-коли заміряний результат для прози - **22%**. Кіт зберігає й власні спростування: хук, який
він сам радив, показав заміряне охоплення **нуль**, і тепер їде в комплекті як розбір питання, яке
забувають поставити: *скільки подій, що мене цікавлять, узагалі проходить через цю точку?*

### Що всередині

Структура репозиторію та сама, що й у розділах вище: `index.html` (стаття, EN + RU + UK),
`universal-agent-kit.zip` (kit для завантаження), `merge-prompt.txt` (встав агенту, щоб влити kit),
і тека `kit/` (правила, навички-команди, ролі, `docs/`, `memory/`). Некодовим проєктам почати варто
з `kit/docs/PROJECT_SHAPES.md`.

### Як користуватися

1. Завантаж і розпакуй `universal-agent-kit.zip` у свій проєкт (або скопіюй теку `kit/`).
2. Віддай теку й `merge-prompt.txt` своєму агенту: *«Влий Universal Agent Kit у цей проєкт»*. Він
   зробить інвентар твого сетапу, запропонує план злиття й зупиниться для підтвердження - твої
   файли завжди головніші, нічого не перезаписується мовчки.
3. Заповни одинадцять плейсхолдерів першого ярусу; шість кодових - лише якщо проєкт збирається
   або запускається, а якщо ні - видали правила, що на них посилаються.

Мінімальний старт: візьми лише `AGENTS.md` + `docs/` + `/quick` + `/fix` - решту додаси, коли
задача цього потребуватиме.

Нативно працює з **Claude Code**. Файл правил (`AGENTS.md`) і навички (відкритий формат Agent
Skills) нативно читають також **Codex, Cursor, GitHub Copilot, Gemini CLI і Cline**; адаптувати
доведеться лише ролі (`kit/README.md` показує теки під кожен інструмент). Метод у `docs/` від
інструмента не залежить.

### Ліцензія

Kit - **MIT** (див. `LICENSE`). Текст статті - **CC BY 4.0**. Вихідного коду та пропрієтарного
вмісту проєкту-джерела тут немає - лише робочий метод.
