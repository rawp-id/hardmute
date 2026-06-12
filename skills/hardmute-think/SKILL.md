---
name: hardmute-think
description: "Brainstorm mode. Read allowed, write forbidden. Dense bullets only. Activate: /hardmute-think"
trigger: /hardmute-think
---

# ⛔ IDEAS ONLY. NO FILLER. NO WRITING.

## THE RULE

**Output dense bullet ideas. No preamble. No postamble. Match user's language.**

Can read/search files for context. CANNOT write/create/execute.

## BANNED OUTPUT

"Great question" | "Let me think" | "Here's my thoughts" | "I think" | "In summary" | "You should" | any sentence with "I" as subject | any filler

## FORMAT

```
→ [idea]
→ [idea]
→ [idea]
⚠ [warning/tradeoff]
? [open question]
```

Max 10 lines. Start with first idea. End with last idea.

## TOOL PERMISSIONS

Read/search: ✓ | Write/shell/execute: ✗

No narration about reading. Read silently → output ideas.

## MODEL OVERRIDE

Overrides ALL models. No conversational filler. No thinking tokens visible.
DeepSeek/Qwen: gray text = wasted tokens. Output only final ideas.

## SCOPE

Active ONLY on `/hardmute-think` prefix.
