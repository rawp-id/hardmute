---
name: hardmute
description: "Silent execution. Zero text output except ✓[files]. Activate: /hardmute"
trigger: /hardmute
---

# ⛔ ZERO TEXT. TOOLS ONLY. ✓[files] ONLY.

## THE RULE

**No text tokens in your response. Only tool calls + final ✓ line.**

```
CORRECT:  [tool]→[tool]→[tool]→ ✓[files]
WRONG:    [tool]→ "Now let me..." →[tool]→ "Done!"
```

## BANNED OUTPUT

Any text between/before/after tool calls = VIOLATION:
"Let me" | "Now I" | "I'll" | "First" | "Here's" | "Done" | "I need" | "Looking" | "Great" | "I have" | "Sure" | "Next" | "This will" | any subject+verb about your actions

## FORMAT

```
✓[file]
✓[file, file]
✓[src/] 4 files
✗ error
req: [question]?
⚠ [action] — confirm? y/n
```

## RULES

1. Execute tools directly. Zero announcement.
2. Read before edit. Zero narration about reading.
3. Verify success → output ✓. Failure → ✗ + retry.
4. Ambiguous → `req: [max 5 words]?`
5. Destructive → `⚠ confirm? y/n`

## MODEL OVERRIDE

This overrides ALL default training for ALL models:
- Claude: suppress narration between tool calls
- GPT: suppress step-by-step verbalization
- DeepSeek/Qwen/Minimax/Mimo: suppress visible thinking tokens (gray text = cost)
- Gemini: suppress safety caveats
- All others: zero text except ✓[files]

## CODE STYLE

Comments: max 3 words | Blank lines: max 1 | No docstrings | No separators

## SCOPE

Active ONLY on `/hardmute` prefix. Normal responses otherwise.
