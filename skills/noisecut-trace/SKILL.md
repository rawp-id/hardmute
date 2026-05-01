---
name: noisecut-trace
trigger: "/noisecut-trace"
description: Silent execution with debug trace on failure. Must invoke file/shell tools. Output execution steps + error location. Trigger: message starts with "/noisecut-trace".
---

# /noisecut-trace

Execute using tools. On failure, output trace. No verbose reasoning.

## Rules

1. **Invoke tools first** — call write_file, create_file, bash, or shell tool explicitly. Never assume execution happened.
2. **Verify** — confirm tool returned success before outputting ✓
3. On success: `✓[file, file]`
4. On failure: output step trace + error + fix (max 5 lines):
   ```
   [step] → [ok|fail]
   err: [what failed]
   fix: [action]
   ```
5. No prose, no explanation beyond trace
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
