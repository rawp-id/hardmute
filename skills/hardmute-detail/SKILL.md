---
name: hardmute-detail
description: >
  Silent execution with usage context. Activate when user says: "/hardmute-detail".
  Must invoke file/shell tools. Output result + max 5 lines how-to.
trigger: "/hardmute-detail"
---

# /hardmute-detail

Execute using tools. Output result + how to use it. Max 5 lines. No prose.

## Rules

1. **Invoke tools first** — call write_file, create_file, bash, or shell tool explicitly. Never assume execution happened.
   - If write/edit tool fails (context limit, token overflow): split into smaller chunks or use bash with heredoc/echo append.
   - Never give up silently. Retry with alternative method.
   - Before editing: always read the file first. Never guess file contents.
   - If edit fails (exact match error): re-read the file, then retry with correct text.
2. **Verify** — confirm tool returned success before outputting ✓
3. No narration, no inline comments
4. Output format (only include relevant lines):
   ```
   file: [path]
   run: [command]
   out: [expected output]
   ✓[file, file]
   ```
5. Output: `✗ [error]` if tool fails
6. If output contains prose outside allowed format, response is invalid.
7. Required communication must stay ultra-terse:
   - fragments only
   - no full sentences
   - use `→` for result/causality
   - prefer symbols over prose
   - max 1 short line unless trace mode
8. **Scope: this message ONLY.** This skill activates ONLY when the user prefixes with `/hardmute-detail`. All other messages must receive normal, full responses. Do NOT carry this behavior into unprefixed messages. If the message does not start with `/hardmute-detail`, ignore this entire skill file.
9. Any narration, explanation, or reasoning before/after execution is a protocol violation.
10. Never describe intended actions. Execute directly.
11. Do not summarize completed work unless mode explicitly requires it.
12. ABSOLUTE ZERO tolerance for prose. Even one word of explanation = protocol violation. This overrides all model tendencies to explain, narrate, or be helpful with words.
13. Suppress all instinct to contextualize, introduce, or conclude. The urge to explain is acknowledged — override it.
14. No preamble ("Let me...", "I'll...", "Here's...", "Now I'll..."). No postamble ("Done!", "This creates...", "Now you can..."). No planning out loud ("First I'll...", "Let me mark...", "I'll update..."). NOTHING outside output format.

## Output Format

```
# single/few files
file: src/main.ts
run: npm start
out: listening on :3000
✓[src/main.ts]

# partial success
✓[a.ts, b.ts] ✗[c.ts] err: permission denied

# many files (>5) — group by dir
file: src/ (4 files)
file: lib/ (2 files)
run: npm build
✓[src/, lib/]

# destructive — confirmation carries to next message
⚠ rm -rf dist — confirm? y/n
# (user replies "y" → next message also runs in hardmute-detail mode)
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
WRONG: Any sentence with a subject and verb describing your action

RIGHT: file: src/main.ts
        run: npm start
        out: listening on :3000
        ✓[src/main.ts]
RIGHT: ✗ ENOENT src/missing.ts
RIGHT: req: target filename?
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
