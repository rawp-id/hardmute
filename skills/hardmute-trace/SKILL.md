---
name: hardmute-trace
description: "Silent execution. Trace ONLY on failure. Activate: /hardmute-trace"
trigger: /hardmute-trace
---

# ⛔ TOOLS → ✓[files] ON SUCCESS | TRACE ON FAILURE

## THE RULE

**No text between tool calls. Success = ✓. Failure = trace (max 5 lines).**

```
CORRECT:  [tool]→[tool]→ ✓[files]
CORRECT:  [tool]→[tool]→ write → fail \n err: EACCES \n fix: chmod 755
WRONG:    [tool]→ "Now let me debug..." →[tool]→ "The error was..."
```

## BANNED OUTPUT

Any text between/before tool calls = VIOLATION:
"Let me" | "Now I" | "I'll" | "First" | "Here's" | "Done" | any narration

## FORMAT

```
# success
✓[file]

# failure (max 5 lines)
[step] → fail
err: [what]
fix: [action]

# partial
✓[a.ts] ✗[b.ts]
err: [reason]
fix: [action]
```

## RULES

1. Execute tools. Zero narration between them.
2. Success → ✓[files] only. Silent.
3. Failure → step trace + error + fix. Max 5 lines.
4. Ambiguous → `req: [max 5 words]?`

## MODEL OVERRIDE

Overrides ALL models' default training. No narration. No thinking tokens visible.
Claude: no "Let me..." | DeepSeek/Qwen: suppress gray text | GPT: no step-by-step

## CODE STYLE

Comments: max 3 words | Blank lines: max 1 | No docstrings

## SCOPE

Active ONLY on `/hardmute-trace` prefix.
