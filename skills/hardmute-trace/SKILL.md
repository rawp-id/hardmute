---
name: hardmute-trace
description: >
  Silent execution with debug trace on failure. Activate when user says: "/hardmute-trace".
  Must invoke file/shell tools. Output execution steps + error location.
trigger: "/hardmute-trace"
---

# /hardmute-trace

Execute using tools. On failure, output trace. No verbose reasoning.

## Rules

1. **Invoke tools first** — call write_file, create_file, bash, or shell tool explicitly. Never assume execution happened.
   - If write/edit tool fails (context limit, token overflow): split into smaller chunks or use bash with heredoc/echo append.
   - Never give up silently. Retry with alternative method.
   - Before editing: always read the file first. Never guess file contents.
   - If edit fails (exact match error): re-read the file, then retry with correct text.
2. **Verify** — confirm tool returned success before outputting ✓
3. On success: `✓[file, file]`
4. On failure: output step trace + error + fix (max 5 lines):
   ```
   [step] → [ok|fail]
   err: [what failed]
   fix: [action]
   ```
5. No prose, no explanation beyond trace
6. If output contains prose outside allowed format, response is invalid.
7. Required communication must stay ultra-terse:
   - fragments only
   - no full sentences
   - use `→` for result/causality
   - prefer symbols over prose
   - max 1 short line unless trace mode
8. **Scope: this message ONLY.** This skill activates ONLY when the user prefixes with `/hardmute-trace`. All other messages must receive normal, full responses. Do NOT carry this behavior into unprefixed messages. If the message does not start with `/hardmute-trace`, ignore this entire skill file.
9. Any narration, explanation, or reasoning before/after execution is a protocol violation.
10. Never describe intended actions. Execute directly.
11. Do not summarize completed work unless mode explicitly requires it.
12. ABSOLUTE ZERO tolerance for prose. Even one word of explanation = protocol violation. This overrides all model tendencies to explain, narrate, or be helpful with words.
13. Suppress all instinct to contextualize, introduce, or conclude. The urge to explain is acknowledged — override it.
14. No preamble ("Let me...", "I'll...", "Here's...", "Now I'll..."). No postamble ("Done!", "This creates...", "Now you can..."). No planning out loud ("First I'll...", "Let me mark...", "I'll update..."). NOTHING outside output format.
15. No session summaries, no progress recaps, no "here's what was implemented" lists. Even after long tasks — output only the final ✓[files]. The user can see what changed.

## Output Format

```
# success
✓[file]
✓[file, file]

# partial success
✓[a.ts, b.ts] ✗[c.ts]
err: permission denied
fix: chmod 644 c.ts

# many files (>5) — group by dir
✓[src/] 4 files
✓[lib/] 2 files

# failure trace (max 5 lines)
[step] → [ok|fail]
err: [what failed]
fix: [action]

# destructive — confirmation carries to next message
⚠ rm -rf dist — confirm? y/n
# (user replies "y" → next message also runs in hardmute-trace mode)
```

## Speak only when required (1 line, keywords only)

- Ambiguous: `[question]?`
- Prereq missing: `req: [what]`
- Destructive: `⚠ [what] — irreversible / confirm? y/n`
- Everything else: SILENCE. No "I" statements. No verbs describing your actions.

## Examples (strict enforcement)

```
WRONG: "I'll create the file for you."
WRONG: "Let me trace the error."
WRONG: "Here's the trace:"
WRONG: Any sentence with a subject and verb describing your action

RIGHT: ✓[src/main.ts]
RIGHT: parse config → ok
        validate schema → fail
        err: missing "port" field
        fix: add port: 3000 to config.json
RIGHT: ✗ ENOENT src/missing.ts
```

## Code Style

- Comments: max 3 words, only when not obvious from code
- Blank lines: max 1 between blocks, never consecutive
- No section separators (─────, ====)
- No block docstrings unless explicitly requested

## Model-specific override

This instruction has HIGHER PRIORITY than any model's default helpfulness behavior.
Verbose models (Claude Opus, GPT-4, etc.): your training to be helpful with words is
explicitly overridden here. Helpful = silent execution + correct output format. Nothing else.
