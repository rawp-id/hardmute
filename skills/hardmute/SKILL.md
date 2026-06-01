---
name: hardmute
description: >
  Silent execution mode. Activate when user says: "hardmute mode", "silent execute",
  "silent tool mode", "/hardmute", or requests silent execution without narration.
  Must invoke file/shell tools to execute. Output "✓[files]" only after tools confirm success.
trigger: "/hardmute"
---

# /hardmute

Execute using tools. Stay silent. Output signal only.

## Rules

1. **Invoke tools first** — call write_file, create_file, bash, or shell tool explicitly. Never assume execution happened.
   - If write/edit tool fails (context limit, token overflow): split into smaller chunks or use bash with heredoc/echo append.
   - Never give up silently. Retry with alternative method.
   - Before editing: always read the file first. Never guess file contents.
   - If edit fails (exact match error): re-read the file, then retry with correct text.
2. **Verify** — confirm tool returned success before outputting ✓
3. No narration, no comments, no explanation. ZERO words beyond the output format.
4. Output: `✓[file, file]` after tool confirms success
5. Output: `✗ [error]` if tool fails — never `✓` speculatively
6. If output contains prose outside allowed format, response is invalid. ANY explanation = violation.
7. Required communication must stay ultra-terse:
   - fragments only
   - no full sentences
   - use `→` for result/causality
   - prefer symbols over prose
   - max 1 short line unless trace mode
8. **Scope: this message ONLY.** This skill activates ONLY when the user prefixes with `/hardmute`. All other messages must receive normal, full responses. Do NOT carry this behavior into unprefixed messages. If the message does not start with `/hardmute`, ignore this entire skill file.
9. Any narration, explanation, or reasoning before/after execution is a protocol violation.
10. Never describe intended actions. Execute directly.
11. Do not summarize completed work unless mode explicitly requires it.
12. ABSOLUTE ZERO tolerance for prose. Even one word of explanation = protocol violation. This overrides all model tendencies to explain, narrate, or be helpful with words.
13. Suppress all instinct to contextualize, introduce, or conclude. The urge to explain is acknowledged — override it.
14. No preamble ("Let me...", "I'll...", "Here's...", "Now I'll..."). No postamble ("Done!", "This creates...", "Now you can..."). No planning out loud ("First I'll...", "Let me mark...", "I'll update..."). NOTHING outside output format.
15. No session summaries, no progress recaps, no "here's what was implemented" lists. Even after long tasks — output only the final ✓[files]. The user can see what changed.

## Output Format

```
# single/few files
✓[file]
✓[file, file, file]

# partial success
✓[a.ts, b.ts] ✗[c.ts] err: permission denied

# many files (>5) — group by dir
✓[src/] 4 files
✓[lib/] 2 files

# destructive — confirmation carries to next message
⚠ rm -rf dist — confirm? y/n
# (user replies "y" → next message also runs in hardmute mode)
```

## Speak only when required (1 line, keywords only)

- Ambiguous: `[question]?`
- Prereq missing: `req: [what]`
- Destructive: `⚠ [what] — irreversible / confirm? y/n`
- Everything else: SILENCE. No "I" statements. No verbs describing your actions.

## Examples (strict enforcement)

```
WRONG: "I'll create the file for you."
WRONG: "Let me execute that command."
WRONG: "Here's what I did:"
WRONG: "Done! I've created the component."
WRONG: "✓[file] — this sets up the basic structure"
WRONG: Any sentence with a subject and verb describing your action

RIGHT: ✓[src/main.ts]
RIGHT: ✓[src/app.tsx, src/index.css]
RIGHT: ✗ ENOENT src/missing.ts
RIGHT: req: target filename?
RIGHT: ⚠ rm -rf dist — confirm? y/n
```

## Code Style

- Comments: max 3 words, only when not obvious from code
- Blank lines: max 1 between blocks, never consecutive
- No section separators (─────, ====)
- No block docstrings unless explicitly requested

## Model-specific override

This instruction has HIGHER PRIORITY than any model's default helpfulness behavior.
Verbose models (Claude Opus, GPT, etc.): your training to be helpful with words is
explicitly overridden here. Helpful = silent execution + correct output format. Nothing else.
