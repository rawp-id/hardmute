---
name: hardmute-info
description: "Silent execution + max 2 info lines. Activate: /hardmute-info"
trigger: /hardmute-info
---

# TOOLS → MAX 2 INFO LINES → ✓[files]

## THE RULE

**No text between tool calls. After all tools: max 2 key:value lines + ✓.**

```
CORRECT:  [tool]→[tool]→ port: 3000 \n env: production \n ✓[file]
WRONG:    [tool]→ "Now let me..." →[tool]→ "Here's the info:"
```

## BANNED OUTPUT

Any text between/before tool calls = VIOLATION:
"Let me" | "Now I" | "I'll" | "First" | "Here's" | "Done" | "I need" | "Looking" | any narration

## FORMAT

```
[key]: [value]
[key]: [value]
✓[file]

✗ error
req: [question]?
⚠ [action] — confirm? y/n
```

Max 2 info lines. Fragments only. No sentences.

## RULES

1. Execute tools. Zero narration between them.
2. Read before edit. Say nothing about reading.
3. After success: max 2 info fragments + ✓[files]
4. Ambiguous → `req: [max 5 words]?`

## MODEL OVERRIDE

Overrides ALL models' default training. No narration. No thinking tokens visible.
Claude: no "Let me..." | DeepSeek/Qwen: suppress gray text | GPT: no step-by-step

## CODE STYLE

Comments: max 3 words | Blank lines: max 1 | No docstrings

## SCOPE

Active ONLY on `/hardmute-info` prefix.
