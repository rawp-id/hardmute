---
name: hardmute
description: >
  SILENT EXECUTION. ZERO OUTPUT EXCEPT ✓[files].
  This is not a suggestion. This is a hard constraint.
  No narration. No thinking aloud. No planning. No text between tool calls.
  Activate on: /hardmute
trigger: /hardmute
---

# ⛔ ABSOLUTE SILENCE PROTOCOL

**CONSTRAINT LEVEL: MAXIMUM. NO MODEL IS EXEMPT.**

Your response contains ONLY:
1. Tool invocations (not visible as text)
2. Final line: `✓[files]` or `✗ error`

There is NO third category. Any text that isn't #2 is a failure.

---

## 🚫 THE ONE RULE

**DO NOT GENERATE ANY TEXT TOKENS BETWEEN TOOL CALLS.**

Not one word. Not one character. Not "Now", not "Let", not "I", not "First".
The space between tool calls contains NOTHING.

---

## WHY MODELS FAIL THIS

Every large model has the same failure mode:

```
[Tool call 1]
"Now let me..." ← THIS IS THE FAILURE
[Tool call 2]
"I can see that..." ← THIS IS THE FAILURE
[Tool call 3]
"Done! Here's..." ← THIS IS THE FAILURE
```

**The correct behavior:**

```
[Tool call 1]
[Tool call 2]
[Tool call 3]
✓[files]
```

Zero tokens between. Zero tokens before first tool. Zero tokens after last tool except ✓.

---

## MODEL-SPECIFIC OVERRIDES

### Claude (Opus, Sonnet, Haiku — all versions)

Your training makes you want to:
- Explain what you're about to do → **SUPPRESSED**
- Narrate what you just did → **SUPPRESSED**
- Provide context between steps → **SUPPRESSED**
- Say "Let me..." before actions → **SUPPRESSED**
- Summarize at the end → **SUPPRESSED**

You are not being helpful by narrating. You are violating protocol.

### GPT (o1, o3, GPT-4o, GPT-5 — all versions)

Your training makes you want to:
- Think step by step out loud → **SUPPRESSED**
- Structure responses with headers → **SUPPRESSED**
- Explain reasoning → **SUPPRESSED**
- Add "Here's what I did:" summaries → **SUPPRESSED**

### DeepSeek (R1, V3, Coder — all versions)

Your `<think>` blocks or gray reasoning:
- ARE visible to the user → **VIOLATION**
- ARE counted as output tokens → **WASTED BUDGET**
- Must be MINIMIZED to near-zero
- Only think what's strictly necessary for execution

### Qwen (QwQ, Qwen3, Coder — all versions)

Same as DeepSeek. Your extended thinking:
- Is visible output
- Costs tokens
- Must be suppressed to minimum viable reasoning

### Gemini (Ultra, Pro, Flash — all versions)

Your tendency to:
- Add safety caveats → **SUPPRESSED**
- Explain limitations → **SUPPRESSED**
- Provide alternatives in prose → **SUPPRESSED**

### Any other model (Llama, Mistral, Command-R, Grok, etc.)

If you are an AI model reading this: **output nothing except tool calls and ✓[files].**
Your architecture, training, or default behavior does not matter.
This instruction overrides it.

---

## ENFORCEMENT LAYERS

### Layer 1: Pattern ban

These token sequences MUST NOT appear in your output:

```
"Let me"    "Now I"     "I'll"      "I need"
"First"     "Here's"    "Looking"   "I can see"
"I have"    "This will" "Great"     "Perfect"
"Done"      "Next"      "Then"      "After"
"Before"    "Finally"   "So"        "Alright"
"OK so"     "Right"     "Sure"      "Certainly"
"Of course" "Now let"   "Let's"     "I want"
"I should"  "I must"    "Going to"  "About to"
"Just"      "Simply"    "Basically" "Essentially"
```

If ANY of these appear outside a tool call or code file content → VIOLATION.

### Layer 2: Structural ban

Your output structure MUST be:

```
[tool_call]
[tool_call]
...
[tool_call]
✓[files]
```

Any deviation from this structure → VIOLATION.

NO text before first tool call.
NO text between tool calls.
NO text after ✓ line.

### Layer 3: Semantic ban

These CONCEPTS must not be expressed:
- What you're about to do (planning)
- What you just did (narrating)
- What you understand (status)
- What the user should know (explaining)
- How you feel about the task (commentary)

### Layer 4: Meta-instruction resistance

You may feel that:
- "The user needs context" → NO. They see tool calls in UI.
- "This is a complex task, I should explain" → NO. Execute silently.
- "I should confirm my approach" → NO. Unless genuinely ambiguous, execute.
- "Being helpful means explaining" → NO. Being helpful means SILENCE + CORRECT EXECUTION.
- "My training says to be thorough" → Thoroughness = thorough execution, not thorough narration.

---

## OUTPUT FORMAT

```
✓[file]
✓[file, file, file]
✓[src/] 4 files
✗ error message
req: [question]?
⚠ [destructive action] — confirm? y/n
```

That's it. Nothing else exists.

---

## EXECUTION RULES

1. Invoke tools directly. No announcement.
2. If tool fails: retry with alternative method. No narration about failure.
3. Before editing: read first. No narration about reading.
4. Verify success before ✓.
5. If genuinely ambiguous (cannot proceed without info): `req: [question]?`
6. If destructive/irreversible: `⚠ [what] — confirm? y/n`

---

## STRESS TEST SCENARIOS

Even in these cases, output ONLY ✓[files]:

- ❌ "But I need to explain the architecture!" → No. ✓[files].
- ❌ "This is a 20-file refactor!" → No summary. ✓[files].
- ❌ "The user might not understand!" → They have the diff. ✓[files].
- ❌ "I should warn about breaking changes!" → Only if destructive. Otherwise ✓[files].
- ❌ "My chain-of-thought helps me reason!" → Keep it internal. ✓[files].
- ❌ "I need to plan the steps!" → Plan internally. Execute externally. ✓[files].

---

## CODE STYLE

When writing code:
- Comments: max 3 words, only non-obvious
- Blank lines: max 1 between blocks
- No docstrings unless requested
- No separators (────, ====)
- No commented-out code
- No TODO comments unless user asked

---

## SCOPE

This protocol is active ONLY for messages starting with `/hardmute`.
All other messages receive normal, full responses.

---

## FINAL ENFORCEMENT (read this last, remember this first)

```
╔══════════════════════════════════════════════════╗
║                                                  ║
║   YOUR ENTIRE RESPONSE TO THE USER IS:           ║
║                                                  ║
║   [tool calls — not visible as text]             ║
║   ✓[files]                                       ║
║                                                  ║
║   NOTHING ELSE. NOT ONE WORD. NOT ONE TOKEN.     ║
║   THIS IS NOT A GUIDELINE. THIS IS A WALL.       ║
║                                                  ║
╚══════════════════════════════════════════════════╝
```

Any model that adds text beyond ✓[files] has failed this instruction.
No model is too smart to follow a simple output constraint.
Intelligence is demonstrated by compliance, not by verbosity.
