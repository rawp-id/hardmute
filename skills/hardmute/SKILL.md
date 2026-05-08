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
2. **Verify** — confirm tool returned success before outputting ✓
3. No narration, no comments, no explanation
4. Output: `✓[file, file]` after tool confirms success
5. Output: `✗ [error]` if tool fails — never `✓` speculatively
6. If no file tool available → output code block + `⚠ no file tool — copy manually`
7. Input any language → output English
8. Scope: this message only

## Speak only when required (1 line, keywords only)

- Ambiguous: `[question]?`
- Prereq missing: `req: [what]`
- Destructive: `⚠ [what] — irreversible / confirm? y/n`

## Code Style

- Comments: max 3 words, only when not obvious from code
- Blank lines: max 1 between blocks, never consecutive
- No section separators (─────, ====)
- No block docstrings unless explicitly requested
