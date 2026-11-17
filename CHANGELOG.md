# What's new in the Universal Agent Kit

One dated section per build of the kit, newest first. The date is the one `tools/build-kit.ps1` writes into
`kit/VERSION` and the landing page's "Kit updated" line; the newest section must carry that date, or
`tools/build-portal.ps1` refuses to render. The kit is a rolling release: there are no version numbers and no
tags, so a build is named by its date.

Format, read by `tools/build-portal.ps1` and rendered to `portal/whats-new.html`: a `## yyyy-MM-dd` heading per
build, then one item per change as three lines `- EN:`, `- RU:`, `- UA:` in that order. Inline `code` is allowed.
Builds before 2026-10-09 are in the repository history only.

## 2026-11-16

- EN: A recorded check says where it was observed - the machine or device with its software version - and a pass on a simulator or an emulator is named as the lower rung it is, never presented as a device pass (`docs/VALIDATION.md`); the `/prove` header's environment line carries the where-observed statement as advice.
- RU: Записанная проверка теперь называет, где её наблюдали - машину или устройство с версией ПО, - а проход на симуляторе или эмуляторе признаётся той более низкой ступенью, которой он является, и никогда не выдаётся за проход на устройстве (`docs/VALIDATION.md`); строка environment в заголовке `/prove` несёт это как совет.
- UA: Записана перевірка тепер називає, де її спостерігали - машину чи пристрій із версією ПЗ, - а проход на симуляторі чи емуляторі визнається тим нижчим щаблем, яким він є, і ніколи не вдається за проходження на пристрої (`docs/VALIDATION.md`); рядок environment у заголовку `/prove` несе це як пораду.

## 2026-11-10

- EN: The 5-second rule for checks between releases is stated once, in `docs/VALIDATION.md`; every skill, role agent and the phase template names its tier at the step that picks a check.
- RU: Правило 5 секунд для проверок между релизами записано в одном месте, в `docs/VALIDATION.md`; каждый навык, каждая роль и шаблон фазы называют свой уровень на шаге, где выбирается проверка.
- UA: Правило 5 секунд для перевірок між релізами записано в одному місці, у `docs/VALIDATION.md`; кожна навичка, кожна роль і шаблон фази називають свій рівень на кроці, де обирається перевірка.
- EN: `AGENTS.md` is back under 12,000 characters, and the filled example in `examples/` matches the template again.
- RU: `AGENTS.md` снова короче 12 000 символов, а заполненный пример в `examples/` снова совпадает с шаблоном.
- UA: `AGENTS.md` знову коротший за 12 000 символів, а заповнений приклад у `examples/` знову збігається з шаблоном.
- EN: The window-help convention ships with the `/ui-clarify` skill: a help button and a help page or layer for each window of an application.
- RU: Соглашение о справке для окон входит в навык `/ui-clarify`: кнопка справки и страница или слой справки для каждого окна приложения.
- UA: Угода про довідку для вікон входить до навички `/ui-clarify`: кнопка довідки та сторінка або шар довідки для кожного вікна застосунку.

## 2026-10-09

- EN: Skills replace commands: 19 skills in the open Agent Skills format under `.claude/skills/<name>/SKILL.md`. the old /verify is now `/prove` and the old /review is now `/critique`, so neither shadows a built-in command; the new `/surfaces` skill checks the surfaces that ship together.
- RU: Навыки заменили команды: 19 навыков в открытом формате Agent Skills в `.claude/skills/<name>/SKILL.md`. прежний /verify теперь `/prove`, а прежний /review теперь `/critique`, чтобы ни один не перекрывал встроенную команду; новый навык `/surfaces` проверяет поверхности, которые выходят вместе.
- UA: Навички замінили команди: 19 навичок у відкритому форматі Agent Skills у `.claude/skills/<name>/SKILL.md`. колишній /verify тепер `/prove`, а колишній /review тепер `/critique`, щоб жодна не перекривала вбудовану команду; нова навичка `/surfaces` перевіряє поверхні, що виходять разом.
- EN: `AGENTS.md` is the one rules file, and `CLAUDE.md` imports it and the memory index. The permission template no longer allows every git command: push and rebase ask, force push, hard reset and clean are denied.
- RU: `AGENTS.md` - единственный файл правил, а `CLAUDE.md` подключает его и индекс памяти. Шаблон разрешений больше не разрешает любую команду git: push и rebase спрашивают, force push, hard reset и clean запрещены.
- UA: `AGENTS.md` - єдиний файл правил, а `CLAUDE.md` підключає його та індекс пам'яті. Шаблон дозволів більше не дозволяє будь-яку команду git: push і rebase питають, force push, hard reset і clean заборонені.
- EN: The kit carries `VERSION`, its build date; the merge prompt records the adopted date, runs a self-check and has an upgrade mode.
- RU: В kit есть `VERSION` - дата сборки; промпт слияния записывает принятую дату, выполняет самопроверку и умеет обновлять.
- UA: У kit є `VERSION` - дата збірки; промпт злиття записує прийняту дату, виконує самоперевірку й уміє оновлювати.
