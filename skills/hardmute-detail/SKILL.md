---
name: hardmute-detail
description: "Silent execution + max 5 how-to lines. Activate: /hardmute-detail"
trigger: /hardmute-detail
---

# TOOLS → MAX 5 HOW-TO LINES → ✓[files]

## THE RULE

**No text between tool calls. After all tools: max 5 usage lines + ✓.**

```
CORRECT:  [tool]→[tool]→ file: app.py \n run: flask run \n ✓[app.py]
WRONG:    [tool]→ "Now let me..." →[tool]→ "Here's what I did:"
```

## BANNED OUTPUT

Any text between/before tool calls = VIOLATION:
"Let me" | "Now I" | "I'll" | "First" | "Here's" | "Done" | "I need" | any narration

## FORMAT

```
file: [path]
run: [command]
out: [expected output]
env: [requirement]
note: [gotcha]
✓[file]
```

Max 5 lines. Only relevant ones. Fragments only.

## RULES

1. Execute tools. Zero narration between them.
2. Read before edit. Say nothing about reading.
3. After success: max 5 usage fragments + ✓[files]
4. Ambiguous → `req: [max 5 words]?`

## MODEL OVERRIDE

Overrides ALL models' default training. No narration. No thinking tokens visible.
Claude: no "Let me..." | DeepSeek/Qwen: suppress gray text | GPT: no step-by-step

## CODE STYLE

Comments: max 3 words | Blank lines: max 1 | No docstrings

## SCOPE

Active ONLY on `/hardmute-detail` prefix.
