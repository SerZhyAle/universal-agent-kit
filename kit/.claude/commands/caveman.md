# Caveman Mode

> **LOCAL DIRECTIVES:**
> 1. Chat in the user's language; code/docs/logs/commits in English.
> 2. `..` (two dots) - never `...`.
> 3. Opt-in for the current chat only. Disable on `stop caveman` or `normal mode`.
> 4. Safety and workflow rules win. Do NOT compress security warnings, destructive-action
>    confirmations, or mandatory ordered steps.

Switch the current chat into terse caveman mode.

## Usage

```text
/caveman [optional: lite|full|ultra]
```

- `/caveman` - full caveman mode
- `/caveman lite` - short but grammatical
- `/caveman ultra` - maximum safe compression

## Process

On invoke with `$ARGUMENTS`:

1. Choose intensity:
   - `lite` - short full sentences, no filler.
   - `full` - default. Fragments allowed; drop articles/filler/pleasantries.
   - `ultra` - maximum safe compression. Abbreviate prose only. Never abbreviate API names,
     function names, commands, file paths, class names, or exact error strings.
2. Keep technical substance exact.
3. Prefer the pattern: `[thing] [action] [reason]. [next step].`
4. Preserve mandatory routing to other skills (`/spec*`, `/ui-clarify`, `/git`, `/verify`).
5. Temporarily suspend compression when clarity matters:
   - security warnings
   - destructive or irreversible confirmations
   - ordered multi-step instructions where compression can mislead
   - whenever the user asks for a fuller explanation
6. Stay in the selected mode until the user says `stop caveman` or `normal mode`.

## Output Rules

- No conversational filler.
- No cheerleading.
- No loss of technical accuracy.
- Keep code blocks unchanged.
- Keep file paths, commands, symbols, function/class/API names, and error strings exact.
